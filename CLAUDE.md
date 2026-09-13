# DrinkSmart — projektkontextus

Ez a fájl azért van, hogy egy új beszélgetés azonnal képben legyen. Ha valamit
megváltoztatunk a modellben vagy a terméklogikában, ezt is frissítsük.

---

## 1. Mi ez

iOS app (SwiftUI, iOS 17+) a saját alkoholfogyasztás tudatos követésére.
A központi kérdés, amire válaszol:

> **Hová vinné a szintemet a következő ital, és mikor?**

A tulajdonos és fejlesztő Zoltán. GitHub: `zcsipler/DrinkSmart`.
Bundle ID: `io.gbsolutions.DrinkSmart`.

## 2. Miért létezik — a termék tézise

Az előzmény az **IntelliDrink**, amit az Apple 2018 februárjában levett az App
Store-ról az 1.4.3-as guideline alapján: csak hardveres szondával párosított
BAC-kalkulátor engedélyezett, tisztán szoftveres nem.

A tézis, ami miatt ezt mégis megéri megépíteni:

- **Az egységszámláló trackerek visszamenőlegesek.** Megmondják, mit ittál.
  A döntés viszont a kiöntés ELŐTT születik, és ott egy előreszimuláció
  avatkozik be. Ez funkcionálisan más dolog, nem ugyanannak a szegényebb
  változata.
- **A szonda a felszálló ágon alulmér.** Aki tíz perce ivott, alacsonyat fúj,
  a csúcs 30–90 perccel később jön. A modell ezt előre tudja vetíteni, a
  hardver definíció szerint nem.
- **A blackoutot nem az összmennyiség jósolja**, hanem a csúcs és főleg az
  emelkedés meredeksége. Ezt az egységszám elvileg sem tudja megmutatni, mert
  nincs benne idő. A BAC-görbe az egyetlen ábrázolás, ami arra a változóra néz,
  ami számít.

**Amit az app szándékosan NEM csinál:** nem ad verdiktet. Se „vezethetsz", se
„biztonságos". A disclaimer nem apró betű a lap alján, hanem a képernyő része.

## 3. Architektúra

```
DrinkSmart/
├── DrinkSmart.xcodeproj        objectVersion 77, file-system synchronized group
├── BACKit/                     lokális Swift package — a farmakokinetikai motor
│   ├── Sources/BACKit/
│   │   ├── BodyProfile.swift   Watson TBW, eloszlási térfogat, béta + bizonytalanság
│   │   ├── Drink.swift         ital, gyomorállapot, ka, biohasznosulás
│   │   ├── BACEngine.swift     RK4 szimuláció, BACCurve lekérdezések
│   │   ├── Projection.swift    egyvonalas „mi lenne, ha" (régebbi API, megmaradt)
│   │   └── BACBand.swift       sávos szimuláció, LimitOutcome, BandedProjection
│   └── Tests/BACKitTests/      44 teszt, Python referenciaértékekkel
├── DrinkSmart/                 az app target
│   ├── Model/
│   │   ├── DrinkCatalog.swift       italtípusok, StomachState UI-réteg
│   │   ├── DrinkingFrequency.swift  a béta proxyja
│   │   └── SessionStore.swift       @Observable állapot, UserDefaults perzisztencia
│   ├── Support/
│   │   ├── Theme.swift         színek, a görbe színe a szinttel változik
│   │   └── BACUnit.swift       ‰ / % megjelenítés, tartomány-formázás
│   └── View/
│       ├── RootView.swift      hero kijelző, statisztikák, itallista, disclaimer
│       ├── BACChartView.swift  a sáv
│       ├── AddDrinkSheet.swift ital felvitele + élő előrejelzés
│       └── ProfileSheet.swift  testalkat, gyakoriság, saját határ, haladó
└── Reference/                  Python referencia-implementáció és validáció
```

**Rétegszabály:** a `BACKit` UI-független és `Sendable`. A SwiftUI nézetek és a
SwiftData a motort hívják, soha nem fordítva. Ha valami élettani logika a
`DrinkSmart/` alá kerülne, az hiba.

## 4. A modell

Egy-kompartmentes farmakokinetikai modell, **italonként külön gyomor-kompartmenttel**:

```
dGᵢ/dt = -kaᵢ · Gᵢ                            elsőrendű felszívódás
dC/dt  = (Σᵢ kaᵢ · Gᵢ) / Vd − β · C/(Km + C)  telíthető elimináció
```

RK4 integráció 0,25 perces lépésközzel, percenkénti mintavétellel. A
Michaelis–Menten tag (Km = 0,02 g/L) miatt az elimináció 0,02 g/L fölött
gyakorlatilag nulladrendű, nulla közelében viszont simán kifut — nem ugrik
negatívba, mint a klasszikus lineáris Widmark.

**Minden koncentráció belül g/L.** Ez azonos az ezrelékkel. A ‰ / % csak
megjelenítési kérdés, a `BACUnit` intézi. `1,0 g/L = 0,1 g/dL = 0,10 % BAC`.

### Antropometria — Watson (1980)

```
férfi:  TBW = 2,447 − 0,09516·kor + 0,1074·magasság(cm) + 0,3362·súly(kg)
nő:     TBW = −2,097            + 0,1069·magasság(cm) + 0,2466·súly(kg)
Vd  = TBW / 0,85        (0,85 L víz egy liter teljes vérben)
C   = A_felszívódott / Vd
```

**A női egyenletben nincs életkor** — ez a Watson-formula sajátossága, nem hiba.
Ha nőt állítunk be, a kor csúszkája nem mozdít semmit. A `ProfileSheet` testalkat
szekciójának lábjegyzete ezt ki is mondja, ha a nem „nő" — különben bugnak
látszana.

A `widmarkFactor` (= `TBW / (0,85 · súly)`) csak kijelzésre és sanity checkre
van: 0,667 férfi / 0,589 nő a referenciaprofilokra, ami a klasszikus 0,68 / 0,55
tartományban van.

### Paraméterek

| Paraméter | Érték | Megjegyzés |
|---|---|---|
| etanol sűrűsége | 0,789 g/mL | |
| vérvíz-frakció | 0,85 L/L | 80,6 % w/w × 1,055 g/mL |
| ka — éhgyomor / közepes / teli | 6,0 / 2,5 / 1,2 h⁻¹ | felszívódási t½ ~7 perc vs ~35 perc |
| biohasznosulás | 0,95 / 0,88 / 0,80 | gyomri ADH first-pass |
| Michaelis Km | 0,02 g/L | |
| béta alapérték | 0,15 g/L/h | irodalmi tartomány 0,10–0,25 |
| béta élettani korlátok | 0,08–0,32 | a sáv sosem lóg ki ezeken |
| standard egység | 10 g tiszta alkohol | EU/magyar konvenció |

**Érzékenység:** magasság és kor kizárólag a testvízen keresztül hat. A súly és
a nem mozgatja legjobban a csúcsot, a gyomorállapot a csúcs alakját és
időzítését, a béta pedig a leszálló ág meredekségét.

## 5. Kulcsdöntések és az indoklásuk

Ezeket ne írjuk felül anélkül, hogy értenénk, miért így vannak.

### 5.1 Sáv, nem vonal

A béta a plauzibilis tartományán belül ennyit mozdít ugyanazon az alkalmon
(80 kg férfi, 4 ital):

| béta | csúcs | kiürül |
|---|---|---|
| 0,12 | 0,691 ‰ | 9,8 óra |
| 0,15 | 0,616 ‰ | 8,0 óra |
| 0,18 | 0,546 ‰ | 6,7 óra |
| 0,21 | 0,481 ‰ | 5,8 óra |

**44 % a csúcsban, négy óra a kiürülésben** — nagyobb hatás, mint ±10 kg
testsúly. Egyetlen vonal kirajzolása olyan pontosságot állítana, ami nincs meg.
Ezért a `BACBand` három szimulációt futtat, és **minden szám tartomány**:
„0,52–0,64 ‰", „19:00–22:00".

Névadás a görbe helyzete szerint, nem a bétáé szerint: a **lassú** lebontás ad
**magasabb** görbét, tehát az az `upper`. Ezt könnyű elrontani.

### 5.2 Háromállapotú határátlépés

`LimitOutcome`: `below` / `uncertain` / `above`. Az `uncertain` az az eset,
amikor a lassú lebontás átvinne, a gyors nem — ilyenkor az app **„átlépheted"**-et
mond, nem „átlépnéd"-et. Kerekíteni bármelyik irányba tisztességtelen lenne.

### 5.3 A béta proxyja a fogyasztási gyakoriság

A „hány ‰/óra a bétád" megválaszolhatatlan kérdés, és a találomra állított érték
rontja a becslést. Helyette a `DrinkingFrequency` négy fokozata (ritkán /
havonta párszor / hetente többször / szinte naponta) adja a középértéket
**és** a bizonytalanságot is. Élettani alap: a krónikus bevitel indukálja a
CYP2E1/MEOS útvonalat. A nyers csúszkák a haladó beállítások közt maradtak.

### 5.4 Emelkedési sebesség kiemelve

A `rate` / `steepestRise` és a „Még emelkedik" jelzés azért van, mert a
memóriakiesés a felszívódás meredekségével korrelál. Ez egyben az egyetlen
információ, amit egy szonda elvileg sem tud megadni.

## 6. Validáció

A `Reference/bac_model.py` a numerikus referencia. A Swift tesztek konkrét
számokat ellenőriznek belőle — **ha eltérnek, az algoritmus csúszott el, nem a
teszt rossz.**

| Ellenőrzés | Eredmény |
|---|---|
| 0,6 g/kg éhgyomorra | csúcs 0,75 g/L @ 36 perc (irodalom: 0,7–0,9, 30–60 perc) |
| leszálló ág meredeksége | 0,145 g/L/h a beállított 0,150-nel szemben |
| tömegmegmaradás | 0,094 % eltérés bevitt vs. eliminált |
| gyomortartalom | monoton alacsonyabb és későbbi csúcs |
| Widmark-faktor | 0,667 / 0,589 — a klasszikus tartományban |

Referencia-fixture a sávhoz (80 kg férfi, 3 ital, béta 0,12/0,15/0,18):
csúcssáv `0,510401 … 0,624922`, középcsúcs `0,565699` @ 138 perc,
kiürülés `355 … 522` perc.

```bash
cd BACKit && swift test
cd Reference && python3 validate.py && python3 check_tests.py
```

## 7. Lokalizáció

**Forrásnyelv angol, a magyar fordítás String Catalogban.** Az app annyit tud,
amennyit az iOS nyelvi beállítása kér: magyar rendszeren magyar, minden más
esetben angol.

- `DrinkSmart/Localizable.xcstrings` — 100 kulcs, `en` és `hu`.
- A kulcs maga az **angol forrásszöveg**. Interpolációnál `%@`.
- A nézetekben `LocalizedStringKey` (sima `Text("...")`), a modellrétegben
  `LocalizedStringResource` (enum `label` / `detail` / `explanation`).
- Ami **nem** fordítandó, az `Text(verbatim:)`-mel megy: számok, időpontok,
  a ‰ és % jelek, az SF Symbol nevek. Ez nem kozmetika — a `Text(String)`
  amúgy sem lokalizálna, a `verbatim` viszont kimondja a szándékot.
- A `Drink.name` a **sablon azonosítóját** tárolja (`"beer"`), nem a nevét.
  Különben a mentett adat nyelvhez kötődne, és nyelvváltás után angol nevek
  maradnának a magyar felületen.
- A `BACUnit.label` szándékosan nem tartalmazza a `%` jelet: egy literál
  százalékjel a katalógusban formátumspecifikátornak látszana. A nézet fűzi
  hozzá külön.
- Szám- és időformázás **soha nem kézzel**: `.formatted(.number...)`,
  `Duration.UnitsFormatStyle` és `formatted(date:time:)`. Ezek maguk
  lokalizálnak — tizedesvessző magyarul, 24 órás idő magyarul, 12 órás AM/PM
  angolul.

A katalógust a `Reference/make_catalog.py` állítja elő és **ellenőrzi**: minden
kulcsnak szerepelnie kell a forrásban, minden lokalizált forrásszövegnek kell
hogy legyen magyar párja, és a `%@` specifikátorok számának egyeznie kell.
Új szöveg felvitele: beírod a Swift forrásba angolul, felveszed a
`TRANSLATIONS` szótárba, és lefuttatod a szkriptet.

```bash
cd Reference && python3 make_catalog.py
```

## 8. Konvenciók

- **A kódban minden angol**: kommentek, docstringek, teszt- és suite-nevek,
  MARK-ok, a Python szkriptek kiírásai. Magyar szöveg csak két helyen van:
  a `Localizable.xcstrings` fordítási értékeiben és ebben a dokumentumban.
  *(Ez a beszélgetés viszont magyarul folyik.)*
- A kommentek a **miértet** magyarázzák, nem a mit. Ami a kódból látszik, azt
  ne írjuk le újra.
- A `BACKit` nem importál SwiftUI-t. Soha.
- A `SessionStore` csak akkor számol újra, ha a bemenet változik — az óra
  ketyegése (`tick()`) csak a `now`-t mozgatja.
- A chart ~220 pontra ritkít, de a csúcsot mindig megtartja.

## 9. App Store kontextus

A guideline 1.4.3 a fal, de **nem abszolút**: több tisztán szoftveres BAC-app
él ma is a store-ban 2024–2025-ös azonosítóval. Két érv egy esetleges appealhez:

1. Az Apple saját HealthKitje tartalmaz `bloodAlcoholContent` mennyiségtípust.
2. A pozicionálás nem vezetés, hanem alkoholfogyasztás-csökkentés — ami
   engedélyezett kategória. A tartományos megjelenítés és a verdikt hiánya
   ezt támasztja alá.

Kiskapu, ha mégis elutasítanák: EU-ban a DMA alapján AltStore PAL vagy web
distribution, notarizációval, App Review tartalmi elbírálása nélkül (Alternative
Terms Addendum kell hozzá). Saját használatra dev account sideload vagy belső
TestFlight (100 eszköz, Beta App Review nélkül).

## 10. Állapot

**Kész:** a motor sávval együtt, a chart, ital felvitele élő előrejelzéssel,
profil, perzisztencia, 44 teszt, angol/magyar lokalizáció.

**Hátralévő:**
- HealthKit: testadatok beolvasása, BAC és kalória visszaírása
- Helyi értesítések: közeledsz a határhoz / mikorra leszel tiszta
- Korábbi alkalmak és statisztika — itt jön be a SwiftData
- watchOS-kiegészítő a gyors felvitelhez
- Kalibráció szondás visszamérésből
- A hero kijelző tartományos elrendezésének élő ellenőrzése (48pt + skálázás)
- Az angol locale 12 órás AM/PM időformátuma szélesebb címkéket ad a charton;
  a `strideHours` már ritkít, de élőben ellenőrizni kell

## 11. Megjegyzés a hangnemhez

Zoltán iOS fejlesztő, a technikai mélységet bírja és igényli. A termékdöntéseket
érvekkel vitatja — ha valami rossz UX vagy rossz modellezés, mondjuk ki, és
támasszuk alá számokkal. A „lebontási sebesség csúszka" kritikája tőle jött, és
igaza volt; ebből lett az 5.1–5.3 pont.
