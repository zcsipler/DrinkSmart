"""
BAC reference model - Widmark distribution + first-order absorption
with saturable elimination.

This is the numerical reference for the Swift implementation. All
concentrations are in g/L (identical to per mille), because that is the unit
the forensic literature works in. Conversion: 1.0 g/L = 0.1 g/dL = 0.10 % BAC.
"""

from dataclasses import dataclass, field
from typing import List, Literal

ETHANOL_DENSITY = 0.789          # g/mL
BLOOD_WATER_FRACTION = 0.85      # L water per L whole blood (80.6 % w/w * 1.055 g/mL)

Sex = Literal["male", "female"]
StomachState = Literal["empty", "light", "full"]

# First-order absorption rate constants (1/h) by stomach contents.
# Absorption half-life is ~7 minutes on an empty stomach, ~35 minutes on a full one.
KA_BY_STOMACH = {
    "empty": 6.0,
    "light": 2.5,
    "full": 1.2,
}

# Bioavailability after gastric (ADH) first-pass metabolism. Slower absorption
# means a longer gastric residence time, and therefore greater first-pass loss.
BIOAVAILABILITY_BY_STOMACH = {
    "empty": 0.95,
    "light": 0.88,
    "full": 0.80,
}

# Michaelis constant. At this value elimination is effectively zero-order above
# 0.02 g/L but tapers off smoothly near zero - it never goes negative.
KM = 0.02                        # g/L
DEFAULT_BETA = 0.15              # g/L/h, mild-to-moderate drinker average


def watson_tbw(sex: Sex, age: float, height_cm: float, weight_kg: float) -> float:
    """Watson (1980) total body water estimate, in litres.

    Note that the female equation does not include age. That is a property of
    the Watson equations, not an omission here.
    """
    if sex == "male":
        return 2.447 - 0.09516 * age + 0.1074 * height_cm + 0.3362 * weight_kg
    return -2.097 + 0.1069 * height_cm + 0.2466 * weight_kg


@dataclass
class BodyProfile:
    sex: Sex
    age: float
    height_cm: float
    weight_kg: float
    beta: float = DEFAULT_BETA           # elimination rate, g/L/h
    tbw_override: float | None = None    # set when the user has calibrated

    @property
    def total_body_water(self) -> float:
        if self.tbw_override is not None:
            return self.tbw_override
        return watson_tbw(self.sex, self.age, self.height_cm, self.weight_kg)

    @property
    def distribution_volume(self) -> float:
        """Blood-equivalent volume of distribution in litres: C = A / Vd."""
        return self.total_body_water / BLOOD_WATER_FRACTION

    @property
    def widmark_r(self) -> float:
        """Informational Widmark factor, comparable to the classic 0.68 / 0.55."""
        return self.total_body_water / (BLOOD_WATER_FRACTION * self.weight_kg)


@dataclass
class Drink:
    minute: float                        # time of consumption in minutes from t=0
    volume_ml: float
    abv_percent: float
    stomach: StomachState = "light"

    @property
    def grams_ethanol(self) -> float:
        return self.volume_ml * (self.abv_percent / 100.0) * ETHANOL_DENSITY

    @property
    def absorbed_grams(self) -> float:
        return self.grams_ethanol * BIOAVAILABILITY_BY_STOMACH[self.stomach]

    @property
    def ka_per_minute(self) -> float:
        return KA_BY_STOMACH[self.stomach] / 60.0

    @property
    def standard_units(self) -> float:
        """One EU standard unit is 10 g of pure alcohol."""
        return self.grams_ethanol / 10.0


@dataclass
class Sample:
    minute: float
    bac: float                           # g/L
    rate: float                          # g/L/h, signed rate of change


@dataclass
class Simulation:
    samples: List[Sample] = field(default_factory=list)

    @property
    def peak(self) -> Sample:
        return max(self.samples, key=lambda s: s.bac)

    def bac_at(self, minute: float) -> float:
        """Linear interpolation between raster samples."""
        if not self.samples or minute <= self.samples[0].minute:
            return 0.0
        if minute >= self.samples[-1].minute:
            return self.samples[-1].bac
        for a, b in zip(self.samples, self.samples[1:]):
            if a.minute <= minute <= b.minute:
                span = b.minute - a.minute
                w = 0.0 if span == 0 else (minute - a.minute) / span
                return a.bac + w * (b.bac - a.bac)
        return 0.0

    def sober_at(self, threshold: float = 0.01) -> float | None:
        """First time after the peak at which BAC falls below the threshold."""
        peak_minute = self.peak.minute
        for s in self.samples:
            if s.minute >= peak_minute and s.bac < threshold:
                return s.minute
        return None

    def crosses(self, limit: float) -> float | None:
        """First time at which BAC reaches the given limit."""
        for s in self.samples:
            if s.bac >= limit:
                return s.minute
        return None


def simulate(
    profile: BodyProfile,
    drinks: List[Drink],
    horizon_minutes: float = 24 * 60,
    dt: float = 0.25,
    sample_every: float = 1.0,
) -> Simulation:
    """
    One-compartment model with a separate gut compartment per drink.

        dG_i/dt = -ka_i * G_i
        dC/dt   = (sum_i ka_i * G_i) / Vd - beta * C / (Km + C)

    Integrated with RK4, because the saturable elimination term makes a plain
    Euler step noticeably underestimate at low concentrations.
    """
    vd = profile.distribution_volume
    beta_per_minute = profile.beta / 60.0
    ordered = sorted(drinks, key=lambda d: d.minute)

    gut = [0.0] * len(ordered)
    ka = [d.ka_per_minute for d in ordered]
    pending = list(range(len(ordered)))

    def derivatives(gut_state: List[float], c: float) -> tuple[List[float], float]:
        d_gut = [-ka[i] * gut_state[i] for i in range(len(gut_state))]
        influx = sum(ka[i] * gut_state[i] for i in range(len(gut_state))) / vd
        elimination = beta_per_minute * c / (KM + c) if c > 0 else 0.0
        return d_gut, influx - elimination

    c = 0.0
    t = 0.0
    samples: List[Sample] = []
    next_sample = 0.0

    while t <= horizon_minutes + 1e-9:
        # drinks consumed by now enter the stomach
        for i in list(pending):
            if ordered[i].minute <= t + 1e-9:
                gut[i] += ordered[i].absorbed_grams
                pending.remove(i)

        if t >= next_sample - 1e-9:
            _, rate = derivatives(gut, c)
            samples.append(Sample(minute=t, bac=max(c, 0.0), rate=rate * 60.0))
            next_sample += sample_every

        # RK4
        k1_g, k1_c = derivatives(gut, c)
        g2 = [gut[i] + 0.5 * dt * k1_g[i] for i in range(len(gut))]
        k2_g, k2_c = derivatives(g2, c + 0.5 * dt * k1_c)
        g3 = [gut[i] + 0.5 * dt * k2_g[i] for i in range(len(gut))]
        k3_g, k3_c = derivatives(g3, c + 0.5 * dt * k2_c)
        g4 = [gut[i] + dt * k3_g[i] for i in range(len(gut))]
        k4_g, k4_c = derivatives(g4, c + dt * k3_c)

        for i in range(len(gut)):
            gut[i] += dt / 6.0 * (k1_g[i] + 2 * k2_g[i] + 2 * k3_g[i] + k4_g[i])
            gut[i] = max(gut[i], 0.0)
        c += dt / 6.0 * (k1_c + 2 * k2_c + 2 * k3_c + k4_c)
        c = max(c, 0.0)
        t += dt

        if c <= 1e-6 and not pending and all(g <= 1e-9 for g in gut) and t > 1:
            _, rate = derivatives(gut, c)
            samples.append(Sample(minute=t, bac=0.0, rate=0.0))
            break

    return Simulation(samples=samples)


def project_next_drink(
    profile: BodyProfile,
    consumed: List[Drink],
    candidate: Drink,
    limit: float,
) -> dict:
    """
    The point of the whole thing: what happens IF I have the next one.

    Returns the current and projected peak, and whether it would cross the
    user's own limit.
    """
    baseline = simulate(profile, consumed)
    projected = simulate(profile, consumed + [candidate])

    after = [s for s in projected.samples if s.minute >= candidate.minute]
    projected_peak = max(after, key=lambda s: s.bac) if after else projected.peak

    return {
        "current_bac": baseline.bac_at(candidate.minute),
        "projected_peak": projected_peak.bac,
        "projected_peak_minute": projected_peak.minute,
        "minutes_to_peak": projected_peak.minute - candidate.minute,
        "exceeds_limit": projected_peak.bac >= limit,
        "crosses_at": projected.crosses(limit),
        "sober_at": projected.sober_at(),
    }
