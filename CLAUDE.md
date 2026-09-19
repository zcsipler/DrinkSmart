# DrinkSmart — projektkontextus

Ez a fájl azért van, hogy egy új beszélgetés azonnal képben legyen. Ha valamit
megváltoztatunk a modellben vagy a terméklogikában, ezt is frissítsük.

Ha egy új beszélgetés kezdődik, a rövid útvonal: **0.** hogyan dolgozunk,
**2.** miért létezik ez az app, **5.** minden lényeges döntés és az indoklása,
**10.** hol állunk most, **11.** mi jön még.

---

## 0. Munkamódszer — kötelező

**Soha ne commitolj engedély nélkül.** Ha a változtatás kész, mutasd meg a
`git diff --stat` összesítőt és a lényegi részleteket, aztán várj. A commitot
Zoltán hagyja jóvá, és ő is fogalmazhat rajta. Ugyanez a `git push`-ra és
minden más olyan műveletre, ami a repó állapotát kívülről is láthatóvá teszi.

Staging (`git add`) is várjon a jóváhagyásra — az elrontott index ugyanúgy
takarítást igényel.

---

## 1. Mi ez

iOS app (SwiftUI, iOS 17+) a saját alkoholfogyasztás tudatos követésére.
A központi kérdés, amire válaszol:

> **Hová vinné a szintemet a következő ital, és mikor?**

A tulajdonos és fejlesztő Zoltán. GitHub: `zcsipler/DrinkSmart`.
Bundle ID: `dev.zcsipler.drinksmart`.

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
│   │   ├── BACEngine.swift     RK4 szimuláció, BACCurve lekérdezések, version
│   │   ├── Projection.swift    egyvonalas „mi lenne, ha" (régebbi API, megmaradt)
│   │   └── BACBand.swift       sávos szimuláció, LimitOutcome, BandedProjection
│   └── Tests/BACKitTests/      47 teszt, Python referenciaértékekkel
├── DrinkSmart/                 az app target
│   ├── DrinkSmartApp.swift     ModelContainer, CloudKit visszaeséssel, store létrehozás
│   ├── Localizable.xcstrings   152 kulcs, en + hu
│   ├── Model/
│   │   ├── BACChartModel.swift      a chart bemenete — élő store vagy tárolt alkalom
│   │   ├── DrinkCatalog.swift       italtípusok, StomachState UI-réteg
│   │   ├── DrinkingDay.swift        ivási nap hajnali 5-ös határral
│   │   ├── DrinkingFrequency.swift  a béta proxyja
│   │   ├── SessionStore.swift       @Observable, SwiftData-alapú, a nyitott alkalom
│   │   └── Persistence/
│   │       ├── DrinkingSession.swift     @Model, profil-pillanatkép + cache
│   │       ├── DrinkRecord.swift         @Model, a tárolt ital
│   │       ├── SessionPolicy.swift       mikor ér véget egy alkalom
│   │       ├── AppSettings.swift         ki vagy MOST (UserDefaults)
│   │       ├── LegacySessionImport.swift egyszeri import a régi blobból
│   │       └── SessionStore+Preview.swift in-memory store a previewekhez
│   ├── Support/
│   │   ├── Theme.swift         színek, a görbe színe a szinttel változik
│   │   └── BACUnit.swift       ‰ / % megjelenítés, tartomány-formázás
│   └── View/
│       ├── MainTabView.swift        History / Live / Profil, Live középen
│       ├── LiveView.swift           élő alkalom + naplapozás + négy nap-állapot
│       ├── HistoryView.swift        lezárt alkalmak listája
│       ├── SessionDetailView.swift  navigációs keret egy múltbeli alkalomhoz
│       ├── SessionContentView.swift a tartalom — LiveView és Detail is ezt használja
│       ├── BACChartView.swift       a sáv, BACChartModel bemenettel
│       ├── DrinkListSection.swift   az itallista, koppintás + húzás
│       ├── DrinkRow.swift           egy sor, kézzel írt swipe-pal
│       ├── AddDrinkSheet.swift      felvitel és szerkesztés + élő előrejelzés
│       └── ProfileView.swift        testalkat, gyakoriság, saját határ, haladó
└── Reference/                  Python referencia + a katalógusgenerátor
```

**Rétegszabály:** a `BACKit` UI-független és `Sendable`. A SwiftUI nézetek és a
SwiftData a motort hívják, soha nem fordítva. Ha valami élettani logika a
`DrinkSmart/` alá kerülne, az hiba.

**A nézetek nem beszélnek SwiftDatával közvetlenül**, egy kivétellel: a
`@Query` a `HistoryView`-ban és a `LiveView`-ban, mert az listázás. Minden írás
a `SessionStore`-on megy át — hét művelet: `refreshFromStore`, `add`, `update`,
`remove`, `clearSession`, `project`, `tick`.

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
Ha nőt állítunk be, a kor csúszkája nem mozdít semmit. A `ProfileView` testalkat
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
| béta bizonytalanság alapból | 0 | egy szám, nem tartomány — lásd 5.8 |
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
testsúly. A grafikonon egyetlen vonal kirajzolása olyan pontosságot állítana,
ami nincs meg. Ezért a `BACBand` három szimulációt futtat, és a chart **sávot**
rajzol. A sáv szélessége maga is információ.

A motor mindig a sávot számolja — ez tartja életben az `uncertain` határállapotot
(5.2) és a kiürülés időtartományát („19:00–22:00"). Hogy ebből mit *látunk*
számként, azt az 5.8 dönti el.

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
CYP2E1/MEOS útvonalat.

A nyers béta-csúszka elérhető marad, de a haladó beállítások **legalján**, külön
lenyitva. Egy vezérlő, ami feljebb ül, kérdésnek látszik, amire a felhasználótól
választ várunk — erre viszont nem tud válaszolni. Egyetlen valós indoka van a
kézi állításnak: ha van mért érték (szonda), amihez igazítani lehet.

A lenyitott blokk ezért nem csak egy csúszka. Megmutatja a beállítást órában is
(„1,0 ‰ ennyi idő alatt ürül ki") — az absztrakt 0,15/óra addig semmit nem
jelent —, és három tippet ad a saját érték megtippeléséhez:

1. **Szondával:** két fújás a lecsengő ágon, legalább egy óra különbséggel, az
   utolsó ital után legalább két órával. A két érték különbsége osztva az eltelt
   órákkal — ez maga a béta, definíció szerint.
2. **Szonda nélkül:** az app megmondja, mikorra várja a kiürülést. Ha
   következetesen hamarabb vagy rendben, a béta magasabb a beállítottnál. Ez a
   valódi önkalibrációs hurok, hardver nélkül.
3. **Mi mozgatja:** enzimindukció, nem átlagosan magasabb, éhgyomor és
   májbetegség lefelé.

### 5.4 Emelkedési sebesség kiemelve

A `rate` / `steepestRise` és a „Még emelkedik" jelzés azért van, mert a
memóriakiesés a felszívódás meredekségével korrelál. Ez egyben az egyetlen
információ, amit egy szonda elvileg sem tud megadni.

### 5.5 Alkalmanként befagyasztott profil

Minden `DrinkingSession` tárolja a **saját** profil-pillanatképét, lapítva hat
mezőbe. Ha csak az italokat tárolnánk és mindig az aktuális profillal
számolnánk, egy régi este visszamenőleg megváltozna: ugyanaz a három ital
60 kg-nál 0,578 ‰ csúcsot ad, 70 kg-nál 0,507-et — 14 % eltérés. Egy feljegyzés,
ami magát átírja, nem feljegyzés.

A lezárt alkalom befagy. A nyitott követi az aktuális profilt, amíg le nem
zárul — mert egy este közepén észrevett elgépelést a *most látott* görbén
akarsz javítani. Visszamenőlegesen létrehozott alkalom a **legközelebbi**
alkalom profilját örökli, nem a mait (`profileApplicable`).

A **motort** viszont szándékosan nem fagyasztjuk be: a bemenet van eltárolva,
így egy későbbi modelljavítás a régi alkalmakat is helyesen újraszámolja.

### 5.6 Ivási nap, nem naptári nap

A `DrinkingDay` hajnali 5-kor vált. Egy 22:00–03:00 este így egy naphoz
tartozik; éjféli határral kettévágódna, a csúcs az egyik napon, a lecsengés a
másikon. Ez dönti el a Live lapozását és azt is, melyik alkalomba kerül egy
visszamenőlegesen felvitt ital.

### 5.7 Négy nap-állapot, és a „nem tudjuk" külön

A Live képernyő négy esetet ismer: `live`, `recorded`, `dry`, `untracked`.
Az utolsó kettő **nem ugyanaz**. Egy üres nap, amit rögzítettünk, bizonyíték
arra, hogy nem ittál. Egy nap az `AppSettings.trackingStartedAt` előtt csak
annyit jelent, hogy nem tudjuk. Azt írni rá, hogy „nem ittál", találgatás
lenne, ezért külön ikonja és szövege van.

### 5.8 Egy szám alapból, tartomány ha a user kéri

A motor mindig sávot számol (5.1). Hogy ez számként egy érték vagy tartomány,
azt **kizárólag a `betaUncertainty`** dönti el, és az **alapértéke nulla**. A
`BACReadout` mindig a sávot kapja, és magától egy számot ír ki, ha a sáv
szélessége nulla (`formatRange` összecsukja az egyező végeket). Nincs külön
„egyszámos mód" a kódban.

**Miért nulla az alapérték.** A szám személyes referenciaskála: idővel
megtanulod, nálad mit jelent a 0,6. Tartományhoz nincs fix pont, amihez az emlék
hozzátapadhatna. Ráadásul a béta bizonytalansága nem véletlen zaj, hanem
**személyenként szisztematikus**: ha a valódi bétád 0,18, és az app 0,15-tel
számol, minden számot ugyanabba az irányba, nagyjából ugyanannyival téveszt el.
A következetes torzítás egy referenciaskálához ártalmatlan — észrevétlenül
hozzákalibrálod magad.

**Miért marad meg a csúszka.** A tartomány a szó szerintibb válasz: a sebesség
tényleg bizonytalan. Aki ezt akarja látni, állítsa fel — ettől az app is
komolyabbnak hat. Ez beállítás, nem alapértelmezés.

A szórás a nullás alapbeálláson is látszik ott, ahol **változtat a döntésen**:

- **kiürülés ideje** — négy óra különbség nem kozmetika,
- **a sáv a charton**,
- **a háromállapotú figyelmeztetés** (5.2) — az „átlépheted" a sávból él.

A `DrinkingFrequency` ezért **csak a bétát állítja**, a bizonytalanságot nem — a
javasolt szórást a csúszka mellett szövegként ajánlja fel. A
`Physiology.legacyBetaUncertainty` (0,03) külön konstans: egy régi, még
`betaUncertainty` nélkül írt pillanatkép azt a számot jelentette, és egy tárolt
alkalom nem írhatja át magát (5.5).

### 5.9 Ivási tempó — az emelkedés hitelessége, nem a csúcs pontossága

A `Drink.drinkingMinutes` alatt az alkohol **egyenletes sebességgel** kerül a
gyomorba, nem egyetlen pillanatban. Nulla időtartam bitre azonos a régi
viselkedéssel (0,181691712), így semmi korábban felvitt adat nem mozdul.

**Fontos, hogy miért van:** nem a csúcs miatt. Egy négy sörös este csúcsa
így is, úgy is ~2 %-on belül ugyanaz. Az **emelkedés meredeksége** viszont
0,81 → 0,36 g/L/h között mozog az „egy hajtásra" és a lassú kortyolás között
(−55 %). A blackout ezzel korrelál (5.4), tehát egy olyan görbealakot
állítottunk volna, amit nem modelleztünk.

*(Ezt a számot egyszer elrontottam: egy gyors szkriptben a bolus-esetben mind a
négy sört t=0-ra tettem, és −32 %-os csúcskülönbséget állítottam. Nem volt igaz.
Ha egy szám túl jól jön ki, számoljuk újra.)*

Italtípusonkénti alapértékek — `DrinkCatalog`: tömény 0 perc (egyben lehajtják),
sör 30, bor 25, pezsgő 20, koktél 20, egyedi 15.

### 5.10 Az előrejelzés a megerősítő sávban van, nem a lap tetején

Az `AddDrinkSheet` vetített csúcsa az Add gomb fölött ül. Nem ez alapján
választasz italt — már tudod, hogy sört akarsz —, így a lap tetején csak
lenyomta a típusválasztót a fold alá. A gomb mellett viszont ott van, ahol a
döntés születik, és a határátlépés-figyelmeztetés (5.2) belőle növi ki magát,
amikor van mit mondani.

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

- `DrinkSmart/Localizable.xcstrings` — 152 kulcs, `en` és `hu`.
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

- **Commit csak jóváhagyás után** — lásd a 0. fejezetet.
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
- A séma **CloudKit-kompatibilis**: minden tárolt mezőnek van alapértéke vagy
  opcionális, nincs `@Attribute(.unique)`, a kapcsolat inverzzel megy. Ezt új
  mező felvitelekor is tartani kell, különben migráció.
- A cache-elt összesítő a `BACEngine.version`-t hordozza. Bumpold, ha a modell
  **számai** változnak — refaktorra ne, mert feleslegesen újraszámol mindent.

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

**Kész:** a motor sávval és ivási tempóval; SwiftData-perzisztencia alkalmanként
befagyasztott profillal; migráció a régi UserDefaults-blobból; három tab;
Live képernyő naplapozással és négy nap-állapottal; előzmény-lista és
alkalom-részletek; ital felvitele, szerkesztése és törlése — visszamenőlegesen
is; egyszámos kijelzés opcionális tartománnyal; lebontási sebesség magyarázata
és tippek a saját érték kiderítéséhez; 47 teszt; angol/magyar lokalizáció
152 kulccsal.

Az app **fordul és fut** szimulátoron, iPhone-ra telepítve van kipróbálva.

Utolsó commit: `d0ef5aa` — „Add drinking pace, and show one number unless you
ask for the range".

## 11. Roadmap

Zoltán tervei, prioritási sorrend nélkül. Egyik sincs elkezdve. Mielőtt
bármelyikbe belevágnánk, kérdezzük meg, tényleg most jön-e — a sorrend
változhat.

### 11.1 Szondás visszatesztelés és kalibráció

A cél nem az, hogy a szondát helyettesítsük, hanem hogy **felhasználjuk**. A
`ProfileView` már leírja a módszert szövegben (5.3): két fújás a lecsengő ágon,
legalább egy óra különbséggel, a különbség osztva az eltelt órákkal adja a bétát.

Amit építeni kell: egy kis kalkulátor — két mért érték + két időpont —, ami
kiszámolja a bétát, és felajánlja, hogy beállítja. Érdemes eltárolni a méréseket
is, hogy több pontból lehessen átlagolni, és hogy a becslés/mérés eltérése
látható legyen.

Ez egyben **App Store-érv** is: az app nem kiváltja a hardvert, hanem pontosabb
lesz tőle. A guideline 1.4.3 pont a szondával párosított appokat engedi (9.).

### 11.2 Feature flagek és in-app payment

Az **alapfunkció a Live** — ez maradjon ingyenes és mindig elérhető. Minden más
funkció kerüljön flag alá, hogy egy későbbi in-app vásárlás mögé lehessen tenni
őket anélkül, hogy a kódot újra kellene szabni.

Tervezési megjegyzés: a flageket ne a nézetekbe szórjuk szét. Egy központi
`FeatureFlags` (vagy `Entitlements`) típus kell, ami a StoreKit-állapotot és a
debug-override-ot egy helyen fogja össze, és a nézetek csak kérdezik.

### 11.3 Sokkal komplexebb Előzmény

Havi / heti / éves bontás, line chartokkal a fogyasztásról. Nem csak
alkalomlista: trendek. Mennyit ittam ebben a hónapban az előzőhöz képest, hány
józan nap volt, hogy alakult a csúcsok alakulása.

Az adat már megvan hozzá: a `DrinkingSession` tárol összesítőt
(`SessionSummary`), és a `DrinkingDay` (5.6) adja a napi bontást. Aggregálásnál
figyelni kell, hogy a cache-elt összesítő a `BACEngine.version`-höz van kötve.

### 11.4 Adatmentés és készülékváltás

**A követelmény:** ha Zoltán készüléket vált ugyanazzal az Apple ID-val, az
adatok ne vesszenek el. Ez nem opcionális kényelem.

A séma már **CloudKit-kompatibilis** (8.), a konténer kódban ott van, csak a
capability nincs bekapcsolva Xcode-ban — addig lokálisra esik vissza.

Nyitott döntés: elég-e az iCloud / Apple ID kötés, vagy kell saját
login/regisztráció is. Az iCloud egyszerűbb és privátabb (nincs szerverünk, ami
alkoholfogyasztási adatot tárol — ez adatvédelmileg komoly érv), viszont
Androidra vagy webre nem vihető át, és nem támogat megosztást. **Ezt még meg
kell beszélni.**

### 11.5 Több profil

Egy estén belül át lehessen váltani másik emberre — pl. a barátnő profiljára —,
és oda is felvinni az italokat.

Ez a legmélyebb séma-változás a listán. A `DrinkingSession` ma a profilt
*pillanatképként* tárolja (5.5), de nincs fogalma arról, hogy *kié*. Kell egy
`Person` entitás, és minden alkalomnak hozzá kell tartoznia. A migrációt úgy
kell megírni, hogy a meglévő alkalmak egy alapértelmezett személyhez kerüljenek.
A `SessionStore` ma egyetlen nyitott alkalmat ismer — több emberrel egyszerre
több nyitott alkalom van.

### 11.6 Józan napok streak

Duolingo-szerű: jól látható helyen, a headerben a józan napok száma, és
gratuláció bizonyos mérföldköveknél.

Vigyázni kell vele: a streak **motiváló**, de egy megszakadt sorozat tud
büntetésként hatni, ami pont ellentétes azzal, amit ez az app akar. Legyen benne
visszafogott — ne piros, ne „elvesztetted", inkább „eddig eljutottál". A számítás
alapja a `DrinkingDay` (5.6) és az `AppSettings.trackingStartedAt`: nem
rögzített nap nem józan nap, csak ismeretlen (5.7).

### 11.7 Tudományos magyarázó képernyő

A kíváncsiaknak: mi alapján és hogyan számol az app — Widmark, Watson,
Michaelis–Menten, a felszívódási állandók. A tartalom nagyrészt már megvan
ebben a dokumentumban (4. fejezet) és a kód kommentjeiben.

Ez is **App Store-érv**: az átláthatóság azt támasztja alá, hogy ez egy
tudatosságnövelő eszköz, nem egy „megvezethetsz-e" kalkulátor.

## 12. Technikai hátralék

Nem termékfunkciók, hanem amit rendbe kell tenni:

- iCloud capability bekapcsolása Xcode-ban (lásd 11.4)
- App-szintű teszt target — a `SessionPolicy`, a `DrinkingDay` és a migráció
  tiszta logika, és ez az a kód, ami adatot tud veszíteni
- Tartományválasztó az Előzmény tabon (a 11.3 előfeltétele)
- HealthKit: testadatok beolvasása, BAC és kalória visszaírása
- Helyi értesítések: közeledsz a határhoz / mikorra leszel tiszta
- watchOS-kiegészítő a gyors felvitelhez
- Ital áthelyezése másik napra szerkesztéssel (most az eredeti alkalomban marad)
- A hero kijelző **tartományos** elrendezésének élő ellenőrzése: 48pt-on egy
  tartomány kétszer olyan széles, a `minimumScaleFactor` 0,5-re megy le
- Az angol locale 12 órás AM/PM időformátuma szélesebb címkéket ad a charton;
  a `strideHours` már ritkít, de élőben ellenőrizni kell

## 13. Megjegyzés a hangnemhez

Zoltán iOS fejlesztő, a technikai mélységet bírja és igényli. A termékdöntéseket
érvekkel vitatja — ha valami rossz UX vagy rossz modellezés, mondjuk ki, és
támasszuk alá számokkal. A „lebontási sebesség csúszka" kritikája tőle jött, és
igaza volt; ebből lett az 5.1–5.3 pont. Ugyanígy a „nem ittál" kontra „nincs
adat" megkülönböztetés (5.7).

Döntés előtt **egyesével** kérdezz, részletesen, valós alternatívákkal — nem
négy kérdést egyszerre. Ha egy kérésnek van rejtett következménye (ütköző
gesztus, elveszett adat, hamis állítás), azt mondd ki, mielőtt megcsinálod.

**A vitát vigyük végig, de ne makacskodjunk.** A tartomány-kontra-egy-szám kérdés
két körben fordult: először kivettem a tartományt mindenhonnan, aztán kiderült,
hogy a kérés nem ez volt — csak az alapérték ne tartomány legyen. Ha a válasz
javítja az előző kört, ismerjük el nyíltan és írjuk át (ebből lett az 5.8).

**Amit nem tudok ellenőrizni:** nincs Swift toolchain a környezetemben, tehát
**nem fordítom le a kódot**. Amit tudok: zárójel- és API-egyezés-ellenőrzés, a
Python referencia, a katalógus-ellenőrző. A fordítás és a futtatás Zoltáné —
szimulátoron és készüléken. Ezért érdemes minden körben kis, önmagában
értelmes változást adni.
