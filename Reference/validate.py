"""Validacio: a modell kimenete vs. publikalt kiserleti ertekek es zart keplet."""

from bac_model import BodyProfile, Drink, simulate, project_next_drink, ETHANOL_DENSITY

male = BodyProfile(sex="male", age=35, height_cm=180, weight_kg=80)
female = BodyProfile(sex="female", age=35, height_cm=167, weight_kg=62)

print("=== 1. Antropometria ===")
for name, p in [("ferfi 80kg/180cm/35e", male), ("no 62kg/167cm/35e", female)]:
    print(f"{name:24s} TBW={p.total_body_water:5.1f} L   Vd={p.distribution_volume:5.1f} L   r={p.widmark_r:.3f}")
print("  elvart klasszikus Widmark r: ferfi ~0.68-0.70, no ~0.55-0.60")

print()
print("=== 2. Kontrollalt dozis, ehgyomorra: 0.6 g/kg ===")
print("   irodalom: csucs ~0.7-0.9 g/L, 30-60 perc kozott")
for name, p in [("ferfi", male), ("no", female)]:
    grams = 0.6 * p.weight_kg
    ml_vodka = grams / (ETHANOL_DENSITY * 0.40)
    d = Drink(minute=0, volume_ml=ml_vodka, abv_percent=40, stomach="empty")
    sim = simulate(p, [d])
    peak = sim.peak
    print(f"  {name:6s} {grams:5.1f} g  -> csucs {peak.bac:.3f} g/L @ {peak.minute:.0f} perc, "
          f"jozan {sim.sober_at()/60:.1f} h")

print()
print("=== 3. Gyomortartalom hatasa (ferfi, 2x0.5L sor 5%) ===")
for stomach in ("empty", "light", "full"):
    drinks = [Drink(minute=0, volume_ml=500, abv_percent=5, stomach=stomach),
              Drink(minute=30, volume_ml=500, abv_percent=5, stomach=stomach)]
    sim = simulate(male, drinks)
    print(f"  {stomach:6s} -> csucs {sim.peak.bac:.3f} g/L @ {sim.peak.minute:3.0f} perc")
print("  elvart: teli gyomorral alacsonyabb es kesobbi csucs")

print()
print("=== 4. Eliminacios meredekseg a leszallo agon ===")
sim = simulate(male, [Drink(minute=0, volume_ml=200, abv_percent=40, stomach="empty")])
c180 = sim.bac_at(180)
c240 = sim.bac_at(240)
slope = (c180 - c240)  # 1 ora alatti esés
print(f"  BAC(180')={c180:.3f}  BAC(240')={c240:.3f}  meredekseg={slope:.4f} g/L/h")
print(f"  elvart: ~{male.beta:.3f} g/L/h (beta parameter)")

print()
print("=== 5. Osszevetes a zart Widmark-keplettel ===")
print("   C = A/(r*M) - beta*t ; a modell ettol a felszivodas miatt ter el korai idoben")
grams = 200 * 0.40 * ETHANOL_DENSITY
for t in (60, 120, 180, 240):
    widmark = grams / (male.widmark_r * male.weight_kg) - male.beta * (t / 60)
    model = sim.bac_at(t)
    print(f"  t={t:3d}'  Widmark={max(widmark,0):.3f}  modell={model:.3f}  elteres={model-max(widmark,0):+.3f}")

print()
print("=== 6. A fo use case: 'mi tortenik, ha megiszom a kovetkezot?' ===")
consumed = [
    Drink(minute=0, volume_ml=500, abv_percent=5, stomach="full"),
    Drink(minute=45, volume_ml=500, abv_percent=5, stomach="light"),
    Drink(minute=90, volume_ml=200, abv_percent=12, stomach="light"),
]
limit = 1.2  # sajat hatar g/L
for label, candidate in [
    ("meg egy sor",  Drink(minute=120, volume_ml=500, abv_percent=5, stomach="light")),
    ("egy feles",    Drink(minute=120, volume_ml=40, abv_percent=40, stomach="light")),
    ("ket feles",    Drink(minute=120, volume_ml=80, abv_percent=40, stomach="light")),
]:
    r = project_next_drink(male, consumed, candidate, limit)
    flag = "ATLEPNE" if r["exceeds_limit"] else "rendben"
    print(f"  {label:12s} most={r['current_bac']:.2f}  "
          f"vetitett csucs={r['projected_peak']:.2f} g/L (+{r['minutes_to_peak']:.0f} perc)  "
          f"[{flag}]  jozan: {r['sober_at']/60:.1f} h")

print()
print("=== 7. Határesetek ===")
empty = simulate(male, [])
print(f"  nulla ital: mintaszam={len(empty.samples)}, csucs={empty.peak.bac:.3f}")
tiny = simulate(male, [Drink(minute=0, volume_ml=1, abv_percent=5)])
print(f"  1 mL sor: csucs={tiny.peak.bac:.5f} g/L, sosem megy negativba: {all(s.bac >= 0 for s in tiny.samples)}")
binge = simulate(male, [Drink(minute=i * 20, volume_ml=40, abv_percent=40, stomach="empty") for i in range(10)])
print(f"  10 feles 20 percenkent: csucs={binge.peak.bac:.2f} g/L @ {binge.peak.minute:.0f} perc, "
      f"jozan {binge.sober_at()/60:.1f} h")
max_rate = max(s.rate for s in binge.samples)
print(f"  max emelkedesi sebesseg={max_rate:.2f} g/L/h  (blackout-kockazat indikatora)")
