# DrinkSmart

iOS app a saját alkoholfogyasztás tudatos követésére. A kérdés, amire válaszol:
**hová vinné a szintemet a következő ital, és mikor.**

Nem vezetési döntéstámogató. A megjelenítés sehol nem ad verdiktet.

## Felépítés

```
DrinkSmart/
├── DrinkSmart.xcodeproj
├── BACKit/                    lokális Swift package — a farmakokinetikai motor
│   ├── Sources/BACKit/        BodyProfile, Drink, BACEngine, BACBand, Projection
│   └── Tests/BACKitTests/     38 teszt a Python referencia értékeivel
├── DrinkSmart/                az app target
│   ├── DrinkSmartApp.swift    ModelContainer CloudKittel, lokális visszaeséssel
│   ├── Localizable.xcstrings  129 kulcs, angol forrás + magyar fordítás
│   ├── Model/
│   │   ├── BACChartModel.swift      a chart bemenete, élő vagy tárolt alkalomból
│   │   ├── DrinkingDay.swift        ivási nap hajnali 5-ös határral
│   │   ├── SessionStore.swift       @Observable, SwiftData-alapú
│   │   └── Persistence/             @Model séma, lezárási szabály, migráció
│   ├── Support/               Theme, BACUnit
│   └── View/                  MainTabView, LiveView, HistoryView, chart, lapok
└── Reference/                 Python referencia + a katalógusgenerátor
```

A motor külön package, mert így `swift test`-tel futtatható az Xcode projekt
megnyitása nélkül, és mert a modell nem függhet a UI-tól.

## Tárolás

Az alkalmak SwiftDatában élnek, iCloud-szinkronra előkészített sémával.

Minden alkalom tárolja a **saját profil-pillanatképét**. Enélkül egy régi este
visszamenőleg megváltozna, amikor a testsúlyod frissül: ugyanaz a három ital
60 kg-nál 0,578 ‰ csúcsot ad, 70 kg-nál 0,507-et. Egy feljegyzés, ami magát
átírja, nem feljegyzés. A **motort** viszont nem fagyasztjuk be — a bemenet van
eltárolva, így egy későbbi modelljavítás a régi alkalmakat is újraszámolja.

Az alkalom határát a `SessionPolicy` dönti el: nyitva marad, amíg van alkohol a
rendszerben, vagy az utolsó ital 3 óránál frissebb. A napok határa hajnali 5,
hogy egy éjfélen átnyúló este egy naphoz tartozzon.

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

A bundle azonosító `dev.zcsipler.drinksmart`. A fejlesztői csapatot a target
Signing beállításainál kell megadni.

Az iCloud-szinkronhoz a target Signing & Capabilities fülén be kell kapcsolni
az **iCloud → CloudKit** és a **Background Modes → Remote notifications**
capabilityt. Enélkül az app fut, csak lokálisan tárol.

## Képernyők

**Live** — az élő alkalom görbéje. Oldalra húzva vagy a fejléc nyilaival
visszalapozhatsz korábbi napokra. Négy állapota van: élő alkalom, rögzített nap,
száraz nap, és olyan nap, amiről nincs adatunk — ez utóbbi kettő szándékosan
külön, mert „nem ittál" és „nem tudjuk" nem ugyanaz.

**Előzmény** — a lezárt alkalmak listája, rákoppintva az akkori görbe.

**Profil** — testalkat, fogyasztási gyakoriság, saját határ, mértékegység.

Ital bárhol felvihető és szerkeszthető, visszamenőlegesen is: a dátumválasztó
napot és időt is kínál, és az ital a saját ivási napjának alkalmához kerül.

## Ami még nincs kész

- Tartományválasztó és aggregált statisztika az Előzmény tabon
- App-szintű teszt target a tárolási logikához
- HealthKit: testadatok beolvasása és a BAC visszaírása
- Helyi értesítések: közeledsz a határhoz / mikorra leszel tiszta
- watchOS-kiegészítő a gyors felvitelhez
- Kalibráció: ha valaha szondával visszamérsz, abból illeszthető a `beta`
