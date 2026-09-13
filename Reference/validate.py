"""Validation: model output against published measurements and the closed form."""

from bac_model import BodyProfile, Drink, simulate, project_next_drink, ETHANOL_DENSITY

male = BodyProfile(sex="male", age=35, height_cm=180, weight_kg=80)
female = BodyProfile(sex="female", age=35, height_cm=167, weight_kg=62)

print("=== 1. Anthropometry ===")
for name, p in [("male 80kg/180cm/35y", male), ("female 62kg/167cm/35y", female)]:
    print(f"{name:24s} TBW={p.total_body_water:5.1f} L   Vd={p.distribution_volume:5.1f} L   r={p.widmark_r:.3f}")
print("  expected classic Widmark r: men ~0.68-0.70, women ~0.55-0.60")

print()
print("=== 2. Controlled dose, empty stomach: 0.6 g/kg ===")
print("   literature: peak ~0.7-0.9 g/L between 30 and 60 minutes")
for name, p in [("male", male), ("female", female)]:
    grams = 0.6 * p.weight_kg
    ml_vodka = grams / (ETHANOL_DENSITY * 0.40)
    d = Drink(minute=0, volume_ml=ml_vodka, abv_percent=40, stomach="empty")
    sim = simulate(p, [d])
    peak = sim.peak
    print(f"  {name:6s} {grams:5.1f} g  -> peak {peak.bac:.3f} g/L @ {peak.minute:.0f} min, "
          f"clears in {sim.sober_at()/60:.1f} h")

print()
print("=== 3. Effect of stomach contents (male, 2x0.5L beer at 5%) ===")
for stomach in ("empty", "light", "full"):
    drinks = [Drink(minute=0, volume_ml=500, abv_percent=5, stomach=stomach),
              Drink(minute=30, volume_ml=500, abv_percent=5, stomach=stomach)]
    sim = simulate(male, drinks)
    print(f"  {stomach:6s} -> peak {sim.peak.bac:.3f} g/L @ {sim.peak.minute:3.0f} min")
print("  expected: a full stomach gives a lower and later peak")

print()
print("=== 4. Slope of the descending limb ===")
sim = simulate(male, [Drink(minute=0, volume_ml=200, abv_percent=40, stomach="empty")])
c180 = sim.bac_at(180)
c240 = sim.bac_at(240)
slope = (c180 - c240)  # drop over one hour
print(f"  BAC(180')={c180:.3f}  BAC(240')={c240:.3f}  slope={slope:.4f} g/L/h")
print(f"  expected: ~{male.beta:.3f} g/L/h (the beta parameter)")

print()
print("=== 5. Comparison with the closed-form Widmark equation ===")
print("   C = A/(r*M) - beta*t ; the model diverges early on because of absorption")
grams = 200 * 0.40 * ETHANOL_DENSITY
for t in (60, 120, 180, 240):
    widmark = grams / (male.widmark_r * male.weight_kg) - male.beta * (t / 60)
    model = sim.bac_at(t)
    print(f"  t={t:3d}'  Widmark={max(widmark,0):.3f}  model={model:.3f}  diff={model-max(widmark,0):+.3f}")

print()
print("=== 6. The main use case: 'what happens if I have the next one?' ===")
consumed = [
    Drink(minute=0, volume_ml=500, abv_percent=5, stomach="full"),
    Drink(minute=45, volume_ml=500, abv_percent=5, stomach="light"),
    Drink(minute=90, volume_ml=200, abv_percent=12, stomach="light"),
]
limit = 1.2  # personal limit in g/L
for label, candidate in [
    ("another beer", Drink(minute=120, volume_ml=500, abv_percent=5, stomach="light")),
    ("one shot",     Drink(minute=120, volume_ml=40, abv_percent=40, stomach="light")),
    ("two shots",    Drink(minute=120, volume_ml=80, abv_percent=40, stomach="light")),
]:
    r = project_next_drink(male, consumed, candidate, limit)
    flag = "CROSSES" if r["exceeds_limit"] else "within"
    print(f"  {label:13s} now={r['current_bac']:.2f}  "
          f"projected peak={r['projected_peak']:.2f} g/L (+{r['minutes_to_peak']:.0f} min)  "
          f"[{flag}]  clears in: {r['sober_at']/60:.1f} h")

print()
print("=== 7. Edge cases ===")
empty = simulate(male, [])
print(f"  no drinks: samples={len(empty.samples)}, peak={empty.peak.bac:.3f}")
tiny = simulate(male, [Drink(minute=0, volume_ml=1, abv_percent=5)])
print(f"  1 mL of beer: peak={tiny.peak.bac:.5f} g/L, never negative: {all(s.bac >= 0 for s in tiny.samples)}")
binge = simulate(male, [Drink(minute=i * 20, volume_ml=40, abv_percent=40, stomach="empty") for i in range(10)])
print(f"  10 shots every 20 min: peak={binge.peak.bac:.2f} g/L @ {binge.peak.minute:.0f} min, "
      f"clears in {binge.sober_at()/60:.1f} h")
max_rate = max(s.rate for s in binge.samples)
print(f"  steepest rise={max_rate:.2f} g/L/h  (the blackout risk indicator)")
