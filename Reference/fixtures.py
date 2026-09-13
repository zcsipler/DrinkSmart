"""Referencia-ertekek generalasa a Swift unit tesztekhez."""

from bac_model import BodyProfile, Drink, simulate

male = BodyProfile(sex="male", age=35, height_cm=180, weight_kg=80)

print("// --- BodyProfile ---")
print(f"TBW  = {male.total_body_water:.6f}")
print(f"Vd   = {male.distribution_volume:.6f}")
print(f"r    = {male.widmark_r:.6f}")

print()
print("// --- Egy 40 mL feles 40%, ehgyomorra ---")
sim = simulate(male, [Drink(minute=0, volume_ml=40, abv_percent=40, stomach="empty")])
print(f"peak      = {sim.peak.bac:.6f} @ {sim.peak.minute:.0f} perc")
for t in (15, 30, 60, 120, 180):
    print(f"bac({t:3d}') = {sim.bac_at(t):.6f}")
print(f"soberAt   = {sim.sober_at():.0f} perc")

print()
print("// --- Harom ital sorozat (0/45/90 perc) ---")
drinks = [
    Drink(minute=0, volume_ml=500, abv_percent=5, stomach="full"),
    Drink(minute=45, volume_ml=500, abv_percent=5, stomach="light"),
    Drink(minute=90, volume_ml=200, abv_percent=12, stomach="light"),
]
sim3 = simulate(male, drinks)
print(f"peak      = {sim3.peak.bac:.6f} @ {sim3.peak.minute:.0f} perc")
for t in (60, 120, 180, 240):
    print(f"bac({t:3d}') = {sim3.bac_at(t):.6f}")
print(f"soberAt   = {sim3.sober_at():.0f} perc")

print()
print("// --- Tomegmegmaradas ellenorzese ---")
# A csucs alatti terulet * beta + maradek ~ a bevitt mennyiseg / Vd
d = Drink(minute=0, volume_ml=40, abv_percent=40, stomach="empty")
total_in = d.absorbed_grams / male.distribution_volume
auc_eliminated = sum(
    (s.bac / (0.02 + s.bac)) * (male.beta / 60) for s in sim.samples if s.bac > 0
)
print(f"bevitt (g/L-ben)     = {total_in:.6f}")
print(f"eliminalt integral   = {auc_eliminated:.6f}")
print(f"relativ elteres      = {abs(total_in - auc_eliminated) / total_in * 100:.3f} %")

print()
print("// --- Gyomortartalom monotonitas ---")
for stomach in ("empty", "light", "full"):
    s = simulate(male, [Drink(minute=0, volume_ml=500, abv_percent=5, stomach=stomach)])
    print(f"{stomach:6s} peak={s.peak.bac:.6f} @ {s.peak.minute:3.0f} perc")
