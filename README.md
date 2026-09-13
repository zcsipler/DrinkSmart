# DrinkSmart

iOS app a saját alkoholfogyasztás tudatos követésére. A kérdés, amire válaszol:
**hová vinné a szintemet a következő ital, és mikor.**

Nem vezetési döntéstámogató. A megjelenítés sehol nem ad verdiktet.

## Felépítés

```
DrinkSmart/
├── DrinkSmart.xcodeproj
├── BACKit/                    lokális Swift package — a farmakokinetikai motor
│   ├── Sources/BACKit/
│   └── Tests/BACKitTests/     20 teszt a Python referencia értékeivel
├── DrinkSmart/                az app target
│   ├── DrinkSmartApp.swift
│   ├── Model/
│   │   ├── DrinkCatalog.swift  italtípusok, gyomorállapot megjelenítése
│   │   ├── DrinkingFrequency.swift  a béta proxyja
│   │   └── SessionStore.swift  @Observable állapot, perzisztencia
│   ├── Support/
│   │   ├── Theme.swift         színek — a görbe színe a szinttel változik
│   │   └── BACUnit.swift       ‰ / % megjelenítés, formázás
│   └── View/
│       ├── RootView.swift      hero kijelző, statisztikák, itallista
│       ├── BACChartView.swift  a görbe
│       ├── AddDrinkSheet.swift ital felvitele + élő előrejelzés
│       └── ProfileSheet.swift  testalkat, anyagcsere, saját határ
└── Reference/                  Python referencia-implementáció és validáció
```

A motor külön package, mert így `swift test`-tel futtatható az Xcode projekt
megnyitása nélkül, és mert a modell nem függhet a UI-tól.

## Miért sáv, és nem vonal

A lebontási sebesség (béta) a plauzibilis tartományán belül ennyit mozdít
ugyanazon az alkalmon:

| béta | csúcs | kiürül |
|---|---|---|
| 0,12 | 0,691 ‰ | 9,8 óra |
| 0,15 | 0,616 ‰ | 8,0 óra |
| 0,18 | 0,546 ‰ | 6,7 óra |
| 0,21 | 0,481 ‰ | 5,8 óra |

44 % a csúcsban, négy óra a kiürülésben — nagyobb hatás, mint ±10 kg testsúly.
Egyetlen vonal kirajzolása tehát olyan pontosságot állítana, ami nincs meg.
Ezért a motor három szimulációt futtat (`BACBand`), a nézet sávot rajzol, és
minden szám tartományként jelenik meg: „0,52–0,64 ‰", „19:00–22:00".

Ugyanezért háromállapotú a határátlépés is (`LimitOutcome`): a „nem" és az
„igen" közt van egy `uncertain` eset — a lassú lebontás átvinne, a gyors nem.
Ilyenkor az app „átlépheted"-et mond, nem „átlépnéd"-et.

A bétát a felhasználó **nem** nyers számként adja meg: a profil a fogyasztás
gyakoriságát kérdezi (`DrinkingFrequency`), amiből a középérték és a
bizonytalanság is jön. A nyers csúszkák a haladó beállítások közt maradtak.

## A chart

- **Bizonytalansági sáv** a gyors és a lassú lebontás közti területtel, benne
  a középvonallal. A sáv szélessége maga is információ.
- **Szín a szintet kódolja**: türkiz → borostyán → korall.
- **Csúcs**: ha még előttünk van, „Várható csúcs 14:20 körül" formában.
- **Saját határ** szaggatott vonalként.
- **Italjelölők** az idővonalon, típusnak megfelelő ikonnal.
- **Scrub**: húzással bármelyik időpont tartománya leolvasható.
- **„Még emelkedik" jelzés**, amikor a görbe a felszálló ágon van. Ez az az
  információ, amit egy alkoholszonda elvileg sem tud megadni.

A motor percenkénti mintát ad; a nézet ~220 pontra ritkít, de a csúcsot mindig
megtartja, hogy a sáv teteje ne vágódjon le.

## Ital felvitele

Hat típus (sör, bor, pezsgő, tömény, koktél, egyedi) előre beállított
kiszerelésekkel, plusz térfogat- és alkoholfok-csúszka. A gyomorállapot
három fokozata — éhgyomor / közepesen telt / teli has — a felszívódási
rátát és a first-pass metabolizmust is vezérli, magyarázattal együtt.

A lap tetején végig ott van az élő előrejelzés: hol tartasz most, hová
jutnál, mikor jönne a csúcs, mikorra ürülne ki, és ha átlépnéd a saját
határod, akkor mikor és meddig maradnál fölötte.

## Futtatás

```bash
open DrinkSmart.xcodeproj     # iOS 17+, Swift 6
cd BACKit && swift test       # a motor tesztjei külön is futnak
cd Reference && python3 validate.py
```

A bundle azonosító `io.gbsolutions.DrinkSmart` — a saját csapatodra állítsd át
a target Signing beállításainál.

## Ami még nincs kész

- HealthKit: testadatok beolvasása és a BAC visszaírása
- Helyi értesítések: közeledsz a határhoz / mikorra leszel tiszta
- Korábbi alkalmak és statisztika (itt jön be a SwiftData)
- watchOS-kiegészítő a gyors felvitelhez
- Kalibráció: ha valaha szondával visszamérsz, abból illeszthető a `beta`
# DrinkSmart
