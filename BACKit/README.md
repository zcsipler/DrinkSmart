# BACKit

Farmakokinetikai modellréteg egy IntelliDrink-szerű apphoz. Tiszta Swift, UI-független,
`Sendable`, nincs függősége. A SwiftData `@Model` osztályok ezt hívják, nem fordítva.

## A modell

Egy-kompartmentes modell, italonként külön gyomor-kompartmenttel:

```
dGᵢ/dt = -kaᵢ · Gᵢ                        elsőrendű felszívódás
dC/dt  = (Σᵢ kaᵢ · Gᵢ) / Vd − β · C/(Km+C)   telíthető elimináció
```

RK4 integráció 0,25 perces lépésközzel. A Michaelis–Menten tag (Km = 0,02 g/L) miatt
az elimináció 0,02 g/L fölött gyakorlatilag nulladrendű, nulla közelében viszont simán
kifut — nem ugrik negatívba, mint a klasszikus lineáris Widmark.

Minden koncentráció **g/L**, azaz ezrelék. `1,0 g/L = 0,1 g/dL = 0,10 % BAC`.

### Paraméterek és forrásuk

| Paraméter | Érték | Forrás |
|---|---|---|
| Teljes testvíz | Watson (1980) antropometriai egyenletek | a forenzikus irodalom ma ezt részesíti előnyben az eloszlási térfogat közvetlen becslésével szemben |
| Vérvíz-frakció | 0,85 L/L | 80,6 % w/w × 1,055 g/mL vérsűrűség |
| ka (éhgyomor / könnyű / teli) | 6,0 / 2,5 / 1,2 h⁻¹ | felszívódási felezési idő ~7 perc éhgyomorra, ~35 perc teli gyomorra |
| β elimináció | 0,15 g/L/h alapérték | „mild to moderate drinker” átlag; egyéni tartomány 0,10–0,25 |
| Biohasznosulás | 0,95 / 0,88 / 0,80 | gyomri ADH first-pass, lassabb ürülésnél nagyobb veszteség |

A levezetett Widmark-faktor 80 kg / 180 cm / 35 éves férfira **0,667**, 62 kg / 167 cm nőre
**0,589** — mindkettő a klasszikus 0,68 / 0,55 tartományban, ami jó sanity check a levezetésre.

### Validáció

| Ellenőrzés | Eredmény |
|---|---|
| 0,6 g/kg éhgyomorra | csúcs 0,75 g/L @ 36 perc (irodalom: 0,7–0,9 g/L, 30–60 perc) |
| Leszálló ág meredeksége | 0,145 g/L/h a beállított 0,150-nel szemben |
| Tömegmegmaradás | 0,094 % eltérés a bevitt és az eliminált mennyiség közt |
| Gyomortartalom | monoton alacsonyabb és későbbi csúcs |

A `bac_model.py` a numerikus referencia-implementáció. A Swift unit tesztek konkrét
számokat ellenőriznek belőle — ha eltérnek, az algoritmus csúszott el, nem a teszt rossz.

## Használat

```swift
let profile = BodyProfile(sex: .male, age: 35, heightCm: 180, weightKg: 80)
let engine = BACEngine()

let drinks = [
    Drink.beer(500, at: .now.addingTimeInterval(-5400), stomach: .full),
    Drink.wine(150, at: .now.addingTimeInterval(-1800)),
]

let curve = engine.simulate(profile: profile, drinks: drinks)
curve.value(at: .now)        // jelenlegi szint
curve.peak                   // csúcs értéke és időpontja
curve.soberDate()            // mikorra ürül ki
curve.steepestRise           // legmeredekebb emelkedés
```

Swift Charts-hoz a `samples` közvetlenül plottolható, mert `date` abszolút `Date`.

### A lényeg: mi lenne, HA megiszom a következőt

```swift
let candidate = Drink.spirit(40, at: .now)
let p = engine.project(profile: profile, consumed: drinks, candidate: candidate, limit: 1.2)

p.currentBAC        // most itt tartok
p.projectedPeak     // ide jutnék
p.timeToPeak        // ennyi idő múlva
p.exceedsLimit      // átlépném-e a saját határom
p.soberAt           // ekkorra lennék tiszta
```

`largestDrinkWithinLimit(_:)` pedig visszaadja, mekkora ital fér még bele — bináris
keresés a térfogatra.

## Amit érdemes tudni az integráláshoz

**Kalibráció.** Az egyetlen paraméter, aminek az állítása érdemben javít a személyes
pontosságon, a `beta`. Ha lesz szondás visszamérés, abból illeszthető. A `totalBodyWaterOverride`
akkor hasznos, ha a felhasználó testösszetétele erősen eltér az átlagtól (sportoló, magas
izomtömeg) — a Watson-formula ilyenkor alulbecsül.

**Amit a modell nem tud.** Gyógyszerkölcsönhatás, ADH/ALDH genetikai variánsok, májállapot,
női ciklusfázis, kronikus tolerancia. Az egyének közti szórás ugyanarra a bevitelre könnyen
20–30 %. A kimenetet ezért tartományként érdemes megjeleníteni, nem három tizedesjegyű
számként — ez egyszerre pontosabb és App Review-barátabb.

**Emelkedési sebesség.** A `rate` mező és a `steepestRise` azért van benne, mert a memóriakiesés
a felszívódás meredekségével korrelál, nem pusztán a csúcsértékkel. Ha a saját határ mellett
ezt is megjeleníted, az többet mond, mint az önmagában vett szám.

## Fájlok

```
BACKit/
├── Package.swift
├── Sources/BACKit/
│   ├── BodyProfile.swift    testalkat, Watson TBW, eloszlási térfogat
│   ├── Drink.swift          ital, gyomorállapot, biohasznosulás
│   ├── BACEngine.swift      RK4 szimuláció, BACCurve lekérdezések
│   └── Projection.swift     „mi lenne, ha” előrejelzés
└── Tests/BACKitTests/
    └── BACEngineTests.swift 20 teszt, Python referenciaértékekkel
```

A gyökérben a `bac_model.py`, `validate.py`, `fixtures.py` és `check_tests.py` a
referencia-implementáció és a validációs futtatások.
