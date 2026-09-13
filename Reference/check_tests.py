"""Verifies the assertions made by the Swift tests against the Python reference."""

from bac_model import BodyProfile, Drink, simulate, project_next_drink

p = BodyProfile(sex="male", age=35, height_cm=180, weight_kg=80)
consumed = [
    Drink(minute=0, volume_ml=500, abv_percent=5, stomach="full"),
    Drink(minute=45, volume_ml=500, abv_percent=5, stomach="light"),
]

ok = lambda b: "PASS" if b else "FAIL"

# projectionRaisesPeak
r = project_next_drink(p, consumed, Drink(minute=90, volume_ml=500, abv_percent=5), 1.2)
print(f"{ok(r['projected_peak'] > r['current_bac'])} projectionRaisesPeak  "
      f"now={r['current_bac']:.3f} peak={r['projected_peak']:.3f} dt={r['minutes_to_peak']:.0f}'")

# largerDrinkLargerPeak
s = project_next_drink(p, consumed, Drink(minute=90, volume_ml=40, abv_percent=40), 1.2)
l = project_next_drink(p, consumed, Drink(minute=90, volume_ml=120, abv_percent=40), 1.2)
print(f"{ok(l['projected_peak'] > s['projected_peak'] and l['sober_at'] > s['sober_at'])} largerDrinkLargerPeak  "
      f"small={s['projected_peak']:.3f}/{s['sober_at']:.0f}'  large={l['projected_peak']:.3f}/{l['sober_at']:.0f}'")

# limitDetection (limit 0.5)
d = project_next_drink(p, consumed, Drink(minute=90, volume_ml=200, abv_percent=40, stomach="empty"), 0.5)
print(f"{ok(d['exceeds_limit'] and d['crosses_at'] is not None)} limitDetection  "
      f"peak={d['projected_peak']:.3f} crosses={d['exceeds_limit']} @ {d['crosses_at']}'")

# withinLimit (limit 3.0)
w = project_next_drink(p, consumed, Drink(minute=90, volume_ml=40, abv_percent=40), 3.0)
print(f"{ok(not w['exceeds_limit'] and w['crosses_at'] is None)} withinLimit  peak={w['projected_peak']:.3f}")

# largestDrinkWithinLimit (limit 0.8, 5% beer)
def largest(limit, tol=1.0):
    zero = project_next_drink(p, consumed, Drink(minute=90, volume_ml=0, abv_percent=5), limit)
    if zero["exceeds_limit"]:
        return None
    lo, hi = 0.0, 1000.0
    while hi - lo > tol:
        mid = (lo + hi) / 2
        if project_next_drink(p, consumed, Drink(minute=90, volume_ml=mid, abv_percent=5), limit)["exceeds_limit"]:
            hi = mid
        else:
            lo = mid
    return lo

mv = largest(0.8)
at = project_next_drink(p, consumed, Drink(minute=90, volume_ml=mv, abv_percent=5), 0.8)
over = project_next_drink(p, consumed, Drink(minute=90, volume_ml=mv + 50, abv_percent=5), 0.8)
print(f"{ok(mv and not at['exceeds_limit'] and over['exceeds_limit'])} largestDrinkWithinLimit  "
      f"max={mv:.0f} mL (peak={at['projected_peak']:.3f}), +50mL -> {over['projected_peak']:.3f}")

# alreadyOverLimit (limit 0.3)
heavy = consumed + [Drink(minute=60, volume_ml=300, abv_percent=40, stomach="empty")]
z = project_next_drink(p, heavy, Drink(minute=120, volume_ml=0, abv_percent=5), 0.3)
print(f"{ok(z['exceeds_limit'])} alreadyOverLimit  peak with no drink={z['projected_peak']:.3f} > 0.3")

# orderIndependence
a = Drink(minute=0, volume_ml=500, abv_percent=5)
b = Drink(minute=60, volume_ml=40, abv_percent=40)
f1 = simulate(p, [a, b]).peak.bac
f2 = simulate(p, [b, a]).peak.bac
print(f"{ok(abs(f1 - f2) < 1e-9)} orderIndependence  {f1:.9f} vs {f2:.9f}")

# riseRateReflectsPacing
fast = [Drink(minute=i * 10, volume_ml=40, abv_percent=40, stomach="empty") for i in range(4)]
slow = [Drink(minute=i * 60, volume_ml=40, abv_percent=40, stomach="empty") for i in range(4)]
fr = max(s.rate for s in simulate(p, fast).samples)
sr = max(s.rate for s in simulate(p, slow).samples)
print(f"{ok(fr > sr)} riseRateReflectsPacing  fast={fr:.3f} g/L/h  slow={sr:.3f} g/L/h")

# fasterMetabolism
fastp = BodyProfile(sex="male", age=35, height_cm=180, weight_kg=80, beta=0.22)
dr = [Drink(minute=0, volume_ml=200, abv_percent=40, stomach="empty")]
print(f"{ok(simulate(fastp, dr).sober_at() < simulate(p, dr).sober_at())} fasterMetabolism  "
      f"beta=0.15 -> {simulate(p, dr).sober_at():.0f}'  beta=0.22 -> {simulate(fastp, dr).sober_at():.0f}'")

# sexDifference
fem = BodyProfile(sex="female", age=35, height_cm=167, weight_kg=62)
dd = [Drink(minute=0, volume_ml=100, abv_percent=40, stomach="empty")]
print(f"{ok(simulate(fem, dd).peak.bac > simulate(p, dd).peak.bac)} sexDifference  "
      f"male={simulate(p, dd).peak.bac:.3f}  female={simulate(fem, dd).peak.bac:.3f}")
