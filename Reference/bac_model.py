"""
BAC referenciamodell - Widmark eloszlas + elsorendu abszorpcio + telitheto eliminacio.

Ez a Swift implementacio numerikus referenciaja. Minden koncentracio g/L egysegben
ertendo (= promille), mert a forenzikus irodalom is ebben dolgozik.
Az atvaltas: 1.0 g/L = 0.1 g/dL = 0.10% BAC.
"""

from dataclasses import dataclass, field
from typing import List, Literal

ETHANOL_DENSITY = 0.789          # g/mL
BLOOD_WATER_FRACTION = 0.85      # L viz / L teljes ver (80.6% w/w * 1.055 g/mL suruseg)

Sex = Literal["male", "female"]
StomachState = Literal["empty", "light", "full"]

# Elsorendu abszorpcios rata-konstansok (1/h) a gyomortartalom fuggvenyeben.
# Ehgyomorra a felszivodasi felezesi ido ~7 perc, teli gyomorra ~35 perc.
KA_BY_STOMACH = {
    "empty": 6.0,
    "light": 2.5,
    "full": 1.2,
}

# Elsofokú (gyomri ADH) metabolizmus miatti biohasznosulas. Lassabb felszivodas
# hosszabb gyomri tartozkodast, es igy nagyobb first-pass vesztesget jelent.
BIOAVAILABILITY_BY_STOMACH = {
    "empty": 0.95,
    "light": 0.88,
    "full": 0.80,
}

# Michaelis-Menten Km. Ilyen kicsi ertek mellett az eliminacio 0.02 g/L felett
# gyakorlatilag nulladrendu, nulla korul viszont simán kifut - nem megy negativba.
KM = 0.02                        # g/L
DEFAULT_BETA = 0.15              # g/L/h, "mild to moderate drinker" atlag


def watson_tbw(sex: Sex, age: float, height_cm: float, weight_kg: float) -> float:
    """Watson (1980) teljes testviz becsles, literben."""
    if sex == "male":
        return 2.447 - 0.09516 * age + 0.1074 * height_cm + 0.3362 * weight_kg
    return -2.097 + 0.1069 * height_cm + 0.2466 * weight_kg


@dataclass
class BodyProfile:
    sex: Sex
    age: float
    height_cm: float
    weight_kg: float
    beta: float = DEFAULT_BETA           # eliminacios rata g/L/h
    tbw_override: float | None = None    # ha a felhasznalo kalibralta magat

    @property
    def total_body_water(self) -> float:
        if self.tbw_override is not None:
            return self.tbw_override
        return watson_tbw(self.sex, self.age, self.height_cm, self.weight_kg)

    @property
    def distribution_volume(self) -> float:
        """Ver-ekvivalens eloszlasi terfogat literben: C = A / Vd."""
        return self.total_body_water / BLOOD_WATER_FRACTION

    @property
    def widmark_r(self) -> float:
        """Tajekoztato Widmark-faktor, a klasszikus 0.68 / 0.55 ertekekkel osszevetheto."""
        return self.total_body_water / (BLOOD_WATER_FRACTION * self.weight_kg)


@dataclass
class Drink:
    minute: float                        # fogyasztas idopontja percben, t=0-hoz kepest
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
        """Magyar/EU standard egyseg = 10 g tiszta alkohol."""
        return self.grams_ethanol / 10.0


@dataclass
class Sample:
    minute: float
    bac: float                           # g/L
    rate: float                          # g/L/h, elojeles valtozasi sebesseg


@dataclass
class Simulation:
    samples: List[Sample] = field(default_factory=list)

    @property
    def peak(self) -> Sample:
        return max(self.samples, key=lambda s: s.bac)

    def bac_at(self, minute: float) -> float:
        """Linearis interpolacio a rasztermintak kozott."""
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
        """Elso idopont a csucs utan, ahol a BAC a kuszob ala esik."""
        peak_minute = self.peak.minute
        for s in self.samples:
            if s.minute >= peak_minute and s.bac < threshold:
                return s.minute
        return None

    def crosses(self, limit: float) -> float | None:
        """Elso idopont, amikor a BAC atlepi a megadott hatart."""
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
    Egy-kompartmentes modell, itaonkent kulon gyomor-kompartmenttel.

        dG_i/dt = -ka_i * G_i
        dC/dt   = (sum_i ka_i * G_i) / Vd - beta * C / (Km + C)

    RK4 integracio, mert a telitheto eliminacios tag miatt az Euler-lepes
    kis BAC-nal erzekelhetoen alulbecsul.
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
        # az aktualis idopontig elfogyasztott italok bekerulnek a gyomorba
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
    A lenyeg: mi tortenik, HA megiszom a kovetkezot.
    Visszaadja a jelenlegi es a vetitett csucsot, es hogy atlepne-e a sajat hatart.
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
