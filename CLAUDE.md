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
│   │   ├── BACBand.swift       sávos szimuláció, LimitOutcome, BandedProjection
│   │   └── PourShortening.swift  a megkezdett ital lezárása a következővel
│   └── Tests/BACKitTests/      56 teszt, Python referenciaértékekkel
├── DrinkSmart/                 az app target
│   ├── DrinkSmartApp.swift     ModelContainer, CloudKit visszaeséssel, store létrehozás
│   ├── Localizable.xcstrings   205 kulcs, a 24 hivatalos EU-nyelven
│   ├── Model/
│   │   ├── BACChartModel.swift      a chart bemenete — élő store vagy tárolt alkalom
│   │   ├── DrinkCatalog.swift       italtípusok, StomachState UI-réteg
│   │   ├── DrinkingDay.swift        ivási nap hajnali 5-ös határral
│   │   ├── DrinkingFrequency.swift  a béta proxyja
│   │   ├── HistoryAggregate.swift   alkalmak → napok → periódusok, memóriában
│   │   ├── HistoryWindow.swift      a History képernyő ablaka: hét / hónap / év, oszlopok, mutatók
│   │   ├── HistoryTrend.swift       a teljes időszak két EMA-görbéje: mennyiség / nap, csúcs
│   │   ├── SessionStore.swift       @Observable, SwiftData-alapú, a nyitott alkalom
│   │   └── Persistence/
│   │       ├── Person.swift              @Model, kinek a fogyasztása — test, béta, határ
│   │       ├── PersonMigration.swift     tulajdonos + gazdátlan alkalmak örökbefogadása
│   │       ├── DrinkingSession.swift     @Model, profil-pillanatkép + cache + személy
│   │       ├── DrinkRecord.swift         @Model, a tárolt ital
│   │       ├── SessionPolicy.swift       mikor ér véget egy alkalom
│   │       ├── AppSettings.swift         ami a KÉSZÜLÉKÉ: mértékegység, aktív személy
│   │       ├── LegacyProfileSettings.swift a régi profil-beállítások olvasója
│   │       ├── LegacySessionImport.swift egyszeri import a régi blobból
│   │       └── SessionStore+Preview.swift in-memory store a previewekhez
│   ├── Support/
│   │   ├── Theme.swift         színek, a görbe színe a határhoz viszonyítva változik
│   │   ├── FeatureFlags.swift  egy hely, ami eldönti, mi van bekapcsolva
│   │   ├── BACUnit.swift       ‰ / % megjelenítés, tartomány-formázás
│   │   └── AmountUnit.swift    gramm / standard egység megjelenítés, alapból gramm
│   └── View/
│       ├── MainTabView.swift        History / Live / Profil, Live középen
│       ├── LiveView.swift           élő alkalom, csak a mai nap — három nap-állapot
│       ├── HistoryView.swift        hét / hónap / év, lapozás, chart, alkalom-lista, lakat
│       ├── HistoryChartView.swift   oszlopok egységre, színük a csúcs a határhoz képest
│       ├── HistoryTrendChartView.swift  görgethető, csippenthető trendgörbe, közös zoom
│       ├── HistoryPaywallSheet.swift  mi van a lakat mögött, és hogy az adat már megvan
│       ├── HistoryJumpSheet.swift   ugrás tetszőleges hétre / hónapra / évre a fejlécről
│       ├── SessionRow.swift         egy alkalom sora, lakatolt változattal
│       ├── SessionDetailView.swift  navigációs keret egy múltbeli alkalomhoz
│       ├── SessionContentView.swift a tartalom — LiveView és Detail is ezt használja
│       ├── BACChartView.swift       a sáv, BACChartModel bemenettel
│       ├── DrinkListSection.swift   az itallista, koppintás + húzás
│       ├── DrinkRow.swift           egy sor, kézzel írt swipe-pal
│       ├── AddDrinkSheet.swift      felvitel és szerkesztés + élő előrejelzés
│       ├── PersonSwitcher.swift     ki van kiválasztva + új személy felvitele
│       └── ProfileView.swift        testalkat, gyakoriság, saját határ, haladó
└── Reference/                  Python referencia, katalógusgenerátor, run_tests.sh
```

**Rétegszabály:** a `BACKit` UI-független és `Sendable`. A SwiftUI nézetek és a
SwiftData a motort hívják, soha nem fordítva. Ha valami élettani logika a
`DrinkSmart/` alá kerülne, az hiba.

**A nézetek nem beszélnek SwiftDatával közvetlenül**, egy kivétellel: a
`@Query` a `HistoryView`-ban és a `LiveView`-ban, mert az listázás. Minden írás
a `SessionStore`-on megy át — tizenegy művelet: `refreshFromStore`, `add`,
`update`, `remove`, `project`, `tick`, `activate`, `addPerson`, `archive`,
`importPlan`, `importArchive`.

Alkalmat **kézzel nem lehet lezárni**. Volt egy „End session" gomb, de olyan
kérdésre válaszolt, amit senki nem tesz fel: az alkalom akkor ér véget, amikor
az alkohol kitisztult és eltelt pár óra (`SessionPolicy`) — ez tény az estéről,
nem döntés. Korán megnyomva hamis lezárási időt írt volna, és a következő ital
ugyanazon az estén egy második alkalmat nyitott volna.

A `@Query` mindkét helyen **szűretlen**, és a személyre szűrés memóriában
történik. Nem lustaságból: a `@Query` predikátuma a nézet létrehozásakor
befagy, az aktív személy viszont a nézet alatt változik — ugyanaz a
megfontolás, ami miatt a napra szűrés is memóriában van.

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
másikon. Ez dönti el, melyik alkalomba kerül egy visszamenőlegesen felvitt
ital, és azt is, hogy a Live mit számít „mának".

### 5.7 „Nem ittál" és „nem tudjuk" nem ugyanaz

Egy üres nap, amit rögzítettünk, bizonyíték arra, hogy nem ittál. Egy nap az
`AppSettings.trackingStartedAt` előtt csak annyit jelent, hogy nem tudjuk. Azt
írni rá, hogy „nem ittál", találgatás lenne.

A Live képernyő ma **három** állapotot ismer — `live`, `recorded`, `dry` —,
mert csak a mai napot mutatja (5.11), és a mai nap definíció szerint nem eshet
a rögzítés kezdete elé. A megkülönböztetés maga érvényes, csak nincs hol
látszódnia: az Előzmény tabra tartozik, a tartományválasztóval együtt (12.).
A `trackingStartedAt` addig is karban van tartva.

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

### 5.11 A Live csak a mai nap

Volt benne naplapozás — vízszintes swipe a korábbi napokra, `dayOffset`-tel és
két chevronnal. Kivettük.

**Miért.** A gesztus nem tudott megélni azon a képernyőn. A chart saját
vízszintes húzást használ az értékek leolvasására, a `DrinkRow` pedig a törlés
felfedésére; a lapozás ezért csak a köztük maradó blokkokra került, és ott is
egy `ScrollView`-val versengve. Ami maradt belőle, az egy gesztus, amit
harmadszorra lehetett eltalálni — ez rosszabb, mint ha nem is lenne. Egy első
kör (a lista kivétele a lapozásból, és az irány megfordítása a szokásos
balról-jobbra-a-múltba konvencióra) javított rajta, de nem eleget.

Visszalapozni így az **Előzmény** tabon lehet. Hogy a kettőt érdemes-e
összekötni, és hogyan, az nyitott kérdés — nem elvi döntés, hogy a Live-ból
ne lehessen visszanézni.

**Amit ez maga után vont:** a `MainTabView.liveHomeToken` elveszett (nem maradt
elnavigált állapot, amit vissza kellene hozni), a `DayState` háromállapotú lett
(5.7), és a `DrinkingDay.offset(by:)` / `daysAgo(from:)` egy időre hívó nélkül
maradt — azóta a History ablakai (11.3) használják.

### 5.12 Az italok saját sávot kaptak a görbe alatt

Az italikonok korábban a nulla vonalra annotált `PointMark`-ok voltak, vagyis a
plot **belsejében** ültek, a sáv alján. Két baj volt vele: ránézésre a
görbéhez tartozó adatnak látszottak, és nem tudtak megmutatni semmit az
`5.9`-es fogyasztási tempóból — pedig az adat ott van a modellben.

**A megoldás:** a `chartYScale` tartománya `−lane.span ... yMaximum`. A nulla
alatti rész nem a görbéé, hanem az italoké. Ugyanaz az időtengely — ez a
lényeg, az ikonoknak illeszkedniük kell a görbéhez —, de a görbe területén
kívül. Ezért van explicit `yTicks` a tengelyen: az `.automatic` felcímkézne egy
−0,2 ‰-et, ami értelmetlen leolvasás.

**A görbe fix 200 pt, a sáv lefelé nő.** Egy sűrű este így képernyőbe kerül, nem
olvashatóságba. A `laneLayout` first fit módon sorokba pakolja az italokat.
Soronként 24 pt, legfeljebb hat sor — afölött a chart magasabb, mint amennyire
hasznos, és ami nem fér bele, az az utolsó sorban átfedhet.

**Egy sor egy ivási szál, és az ütközés kérdése az idő, nem a képernyő.** Ami
időben nem folyik egybe, az egy sorba kerül, akármilyen közel van:

- 30 perces sör, utána fél órával egy másik → **egy sor**, sosem voltak
  egyszerre a kézben.
- 30 perces sör, utána 20 perccel egy másik → **egy sor**, mert a második
  felvitele már levágta az elsőt 20 percre (5.13), és a kettő így pont
  egymáshoz ér.
- 30 perces sör közben egy pálinka → **külön sor**, mert a sör közben tényleg
  a kézben volt.

**Az összevetés percre megy, nem másodpercre** (`overlapTolerance`, 60 s). Az
időtartamok egész percek, a képernyőn minden idő percre látszik, tehát egy
másodperces átfedés nem átfedés. Könnyű előállítani: egy 14:55:23-kor kezdett,
egy órásra állított sör 15:55:23-ig tart, a 15:55:10-kor felvitt következő pedig
tizenhárom másodperccel elbukik a teszten — és leesik egy sorral olyan okból,
amit a képernyőre nézve senki nem tudna megnevezni. A `pourCut` (5.13) az új
adatot pontosan egymáshoz igazítja, a tolerancia a korábban felvitt és a kézzel
szerkesztett soroknak kell.

A kétperces lábnyom csak arra van, hogy két azonos pillanatra felvitt ital ne
egymásra rajzolódjon — ezért kell hosszabbnak lennie a toleranciánál, különben
azt sem választaná szét. **Volt egy hibás kör**, amiben a lábnyomot a badge
szélessége adta: az telefonszélességen a látható ablak ~6 %-a, vagyis egy
hatórás estén 20 perc — így egymás alá kerültek olyan italok, amiknek semmi
közük nem volt egymáshoz. A képernyőméret nem dönthet arról, mi volt egyszerre.

**Ennek az ára:** hat feles öt percenként egy sorba kerül, és ott a badge-ek
átfedik egymást. Időrendben állnak, tehát sorozatként olvashatók, de ha ez
zavaró lesz, egy gyenge (a badge felénél ütő) másodlagos feltétel visszahozható.

- **Minden badge a valós idején áll.** Volt egy korábbi kör, amiben a badge-ek
  oldalra csúsztak egymás elől, és egy szaggatott vezérvonal adta vissza az
  igazi időt. A sor jobb: nem kell korrekción keresztül visszaolvasni semmit.
- **Egy sor egy objektum.** A rúd a kezdéstől az utolsó kortyig fut végjellel,
  a badge a kezdésen ül rajta. Aki egyben lehajtja, annak nincs rúdja — nulla
  hosszú rúd láthatatlan, egy csonkká kerekítve pedig olyan időtartamot
  állítana, ami nem volt. A tartam és a pillanat különbsége a rúd megléte.
- **A badge-ek egyformák.** A tempót a rúd mondja el; kétszer elmondani csak
  olyan jelentést aggatna a badge-re, amit nem bír el.

**Az oszlop a teljes chart magasságán átfut**, a görbe mögött és a sorokon
keresztül. Két dolgot csinál egyszerre: a görbén megmutatja, a felszálló ág
melyik szakaszáért felel az ital (enélkül a rúd csak egy hossz lenne,
összevetési alap nélkül), a sávban pedig ez a szemvonal — öt sornál egy alsó
rúd messze kerül az időtengelytől, és az oszlop mondja meg, melyik pillanathoz
tartozik. A kortyolt italnál halvány sáv, az egyben lehajtottnál szaggatott
vonal, mert egy pillanatnak nincs szélessége. Finomabb és halványabb, mint a
szintén szaggatott most-vonal, aminek hangosabbnak kell maradnia.

A jelmagyarázat csak azt a kettőt nevezi meg, ami épp a képernyőn van.

A `LaneLayout` **egyetlen menetben** számol, és a `chart` egy lokális
konstansba kéri le. Nem stílus kérdése: a `chartXSelection` minden húzási
mintánál újraértékeli a `body`-t, és külön computed propertykből a pakolás
markonként többször futna le, frame-enként.

### 5.13 A következő ital lezárja az előzőt — de csak azonos típusnál

A `drinkingMinutes` alapértéke típusonként fix (5.9): a sör 30 perc. Ha 20 perc
múlva új **sört** veszünk fel, akkor az előzőt nem 30 perc alatt ittuk meg,
hanem 20 alatt — a felvitel maga az információ, hiszen nem tartunk két sört a
kézben. Az `Array.pourCut(by:)` ilyenkor lerövidíti a megkezdett italt arra a
pillanatra.

**Típusra érzékeny, és ez a lényege.** Egy feles a sör közben semmit nem mond a
sörről; ha arra is rövidítenénk, kitalálnánk egy meredekebb emelkedést, mint
ami történt. A típus a `Drink.name`, vagyis a sablon azonosítója.

**Nincs alsó korlát.** Ha négy perccel később jön a következő sör, az előző négy
perces lesz. Ez utólagos, tömeges felvitelnél hamis meredekséget ad (négy sör
egymás után begépelve, mind „Most"-tal) — tudatos döntés, hogy a szabály
kivétel nélkül érvényes, és a felvitt időpontok helyessége a felhasználón áll.

**Amit tudni kell róla:**

- **Idempotens.** A levágott ital már nem tart a kérdéses pillanatig, így egy
  második futás nem talál semmit. E nélkül az `AddDrinkSheet` élő előrejelzése
  minden lépésköznél tovább csonkította volna az időtartamot.
- **A `project` ugyanazt a vágást alkalmazza**, mint az `add`. Nem kozmetika:
  e nélkül az Add gomb fölött vetített görbe nem az lenne, amit a gomb
  megnyomása után kapsz.
- **Csak `add`-nál.** Az előző időtartama **nem áll vissza**, ha a megszakító
  italt utólag töröljük vagy átidőzítjük — a 30 perc alapérték volt, és az app
  nem tart nyilván lecserélt alapértékeket. Mindkét soron szerkeszthető az
  időtartam, ez a kiút.
- Csendben történik; az itallistában látszik az új időtartam.

A szabály a `BACKit`-ben van, nem az app rétegben: `[Drink] -> [Drink]`, tiszta
függvény UI nélkül — és így tesztelhető (`PourShorteningTests`, 9 teszt).

### 5.14 A színskála a saját határhoz van kötve, nem abszolút szintekhez

A `Theme.tint(for:limit:)` a `bac / limit` arányt színezi, nem a ‰-értéket.
Öt megállóval, folytonosan: **0** türkiz → **0,55** borostyán → **0,85** korall
→ **1,00 teljes vörös** → **1,50 és fölötte** sötét bíbor.

**Miért nem abszolút.** A régi skála 0,5 ‰-nél váltott borostyánra és 1,3 ‰
fölött korallban állt meg — mindenkinek ugyanott. Ez a színt az ivásról
általában tett állítássá tette, nem erről az emberről szólóvá: aki 0,3 ‰-re
állította a határát, végig türkizben látta az estéjét, aki 1,2 ‰-re, az már jóval
a saját vonala alatt korallban volt.

**A teljes vörös pontosan a határon van.** Ez nem verdikt (2.): a határ a
felhasználó saját száma, amit ő írt be, és az app csak következetes vele — az
5.2-es háromállapotú figyelmeztetés ugyanerre a vonalra hivatkozik. Fölötte
tovább mélyül, hogy a „jóval túl" is látsszon, de a telített vörös pillanata a
határ.

**Amit ez maga után vont:**

- A `tint` minden hívója átad egy határt, és a `BACReadout`-on **kötelező**
  paraméter — nem alapértelmezett, mert egy elfelejtett érték csendben valaki
  más skáláját adná. Az Előzmény az adott alkalom saját határát adja át, nem a
  mait, ugyanazon az alapon, mint a profil-pillanatképnél (5.5).
- A chart sávgradiense a **csúcshoz** igazodik, nem a `yMaximum`-hoz. A
  `yMaximum` konstrukció szerint legalább a határ 1,4-szerese, tehát minden
  gradiens teteje sötét bíbor lett volna, egy csendes estén is.
- A `ProfileView` határcsúszkájának értéke fixen `Theme.alarm`. A saját
  szintjével színezni körkörös volna — a skála a határ törtrésze, tehát egy
  határ mindig pontosan 1,0. Így viszont szó szerint azt mondja: **ez az a
  szám, aminél a kijelző vörösre vált.**
- A charton a határvonal is `Theme.alarm`, nem korall. Ugyanaz a küszöb,
  ugyanaz a szín.

**Aminek tudatában kell lenni:** alacsonyra állított határnál (0,2–0,3 ‰) egy
sör is vörösre viszi a görbét. Ez a skála működése, nem hibája — de ha a határ
alsó vége miatt zavaró lesz, a megállók az egyetlen hangolandó dolog.

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

**Futásidő** (sandbox, ARM Linux — készüléken vélhetően 2–4× gyorsabb, de a
nagyságrend áll). Ezek a számok döntik el, mit szabad gesztus közben hívni:

| Hívás | 1 ital | 5 ital | 8 ital | 7 ital, 17 órás este |
|---|---|---|---|---|
| `simulateBand` | 2,5 ms | 3,8 ms | 6,1 ms | **5,6 ms** |
| `projectBand` (6 szimuláció) | — | 7,3 ms (4 ital + jelölt) | — | **12,0 ms** |
| `BACBand.samples` | — | 0,05 ms | — | — |

**Debug buildben ugyanez 14×**: a `projectBand` 167 ms, a `simulateBand` 73 ms.
Ez nem mellékes, mert fejlesztés közben debug fut a készüléken — egy hívás ott
húsz frame. Az utolsó oszlop a képernyőn is látott este: hét sör 14:55-től
21:24-ig, 13,8 egység, ami reggel 7:47-re ürül ki, vagyis 17 órányi szimuláció
(1074 mintapont).

Referencia-fixture a sávhoz (80 kg férfi, 3 ital, béta 0,12/0,15/0,18):
csúcssáv `0,510401 … 0,624922`, középcsúcs `0,565699` @ 138 perc,
kiürülés `355 … 522` perc.

```bash
./Reference/run_tests.sh                 # 56 teszt, BACKit
cd Reference && python3 validate.py && python3 check_tests.py
```

A `run_tests.sh` Macen egyszerűen `swift test`. A lényege a másik eset: az
asszisztens Linux-sandboxában **nincs toolchain**, ezért a szkript letölt egy
Swift release-t `/tmp`-be, és ugyanazt a suite-ot futtatja. Ettől a „elrontottam
valamit?" kérdés helyben megválaszolható, nem kell visszakérdezni.

Ez **csak a `BACKit`-re igaz**: a csomag a Foundationön kívül semmit nem
importál, így bárhol fordul. Az app target SwiftUI-t és SwiftDatát használ, azt
kizárólag Xcode tudja lefordítani — a nézetek és a perzisztencia ellenőrzése
továbbra is Zoltáné.

A letöltés ~800 MB, munkamenetenként egyszer, nagyjából három perc. Megéri:
utána minden kör végén lefuttatható.

## 7. Lokalizáció

**Forrásnyelv angol, a fordítások String Catalogban.** Az app a 24 hivatalos
EU-nyelvet ismeri. Alapból azt választja, amit az iOS nyelvi beállítása kér; a
felhasználó ettől eltérhet a Profil fül Nyelv sorával, ami a Beállításokban az
app saját „Előnyben részesített nyelv" sorára visz (`LanguageSection`).

- `DrinkSmart/Localizable.xcstrings` — 205 kulcs, 24 nyelven. Generált fájl,
  kézzel nem szerkesztjük.
- `Reference/translations/<kód>.py` — nyelvenként egy modul, mindegyikben egy
  `TRANSLATIONS` szótár az angol forrásszövegtől az adott nyelvig.
- **A magyar a referencia**: azt olvasta végig ember, és az ő kulcskészletéhez
  méri a szkript a többit. A magyar és az angol `translated` állapotban kerül a
  katalógusba, a többi `needs_review`-ban — az Xcode ezt jelöli. Egy nyelvet a
  `make_catalog.py` `REVIEWED` halmazába átemelni annyit tesz, hogy valaki
  vállalja érte a felelősséget.
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
hogy legyen fordítása, minden nyelvnek ugyanazt a kulcskészletet kell vinnie,
és a `%@` specifikátorok számának nyelvenként egyeznie kell.
Új szöveg felvitele: beírod a Swift forrásba angolul, felveszed **minden**
nyelvi modul `TRANSLATIONS` szótárába, és lefuttatod a szkriptet — a hiányzó
kulcsot nyelvenként kiírja.

```bash
cd Reference && python3 make_catalog.py
```

## 8. Konvenciók

- **Commit csak jóváhagyás után** — lásd a 0. fejezetet.
- **A motorhoz érő változtatás után fusson le a tesztsuite**
  (`./Reference/run_tests.sh`), mielőtt a diffet megmutatjuk.
- **A kódban minden angol**: kommentek, docstringek, teszt- és suite-nevek,
  MARK-ok, a Python szkriptek kiírásai. Magyar szöveg csak két helyen van:
  a `Localizable.xcstrings` fordítási értékeiben és ebben a dokumentumban.
  *(Ez a beszélgetés viszont magyarul folyik.)*
- A kommentek a **miértet** magyarázzák, nem a mit. Ami a kódból látszik, azt
  ne írjuk le újra.
- A `BACKit` nem importál SwiftUI-t. Soha.
- A `SessionStore` csak akkor számol újra, ha a bemenet változik — az óra
  ketyegése (`tick()`) csak a `now`-t mozgatja.
- **A csúszkák elengedéskor írnak a store-ba, nem húzás közben.** Mindegyik
  saját kis nézet, ami a húzott értéket lokális `@State`-ben tartja, és az
  `onEditingChanged`-ben commitol. Két oka van, és mindkettő mérhető: egy
  `simulateBand` 2,5–6 ms (ez három RK4-futás, a részletek a 6. pontban), ami
  a 120 Hz-es 8,33 ms-os frame nagy része; és egy `store`-ból olvasott érték
  invalidálja azt, aki olvasta — a `ProfileView`-ba ágyazva ez az egész `Form`
  volt. Ami az értékkel együtt kell hogy mozogjon (a kiürülési idő szövege, a
  sáv), az ezért a draftot birtokló nézetbe költözik, nem marad kívül.
- **A projekció cache-e a `SessionStore`-ban van, nem a nézetben.** A
  `project` megtartja az utolsó választ (`ProjectionKey`, `@ObservationIgnored`
  — egy observed property írása body-értékelés közben azt a nézetet
  invalidálná, amelyik épp kérdezett). Azért ott, mert az `AddDrinkSheet`-ben
  volt egy `@State` cache, amit az `onAppear` töltött fel, és nil-re egy
  közvetlen hívás volt a fallback: az **első** renderben tehát mind a kilenc
  olvasás lefuttatta a 167 ms-os projekciót, a lap 5 másodperc alatt jött fel,
  a cache pedig csak utána érkezett meg. Olyan cache, amit a hívó észrevétlenül
  kikerülhet, rossz helyen van.
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
Live képernyő a mai napra, három nap-állapottal; előzmény-lista és
alkalom-részletek; ital felvitele, szerkesztése és törlése — visszamenőlegesen
is; egyszámos kijelzés opcionális tartománnyal; lebontási sebesség magyarázata
és tippek a saját érték kiderítéséhez; 56 teszt; angol/magyar lokalizáció
154 kulccsal. Több személy (11.5) a `FeatureFlags.multiPerson` mögött: a séma
és a migráció mindenkinél fut, a váltó és a személy-felvitel csak bekapcsolva
látszik — debug buildben a Profil alján, a „Developer" szekcióban.

A CloudKit szinkron kódja megvan, de **ki van kapcsolva**
(`BuildCapabilities.cloudSync = false`), mert az iCloud capability fizetős
fejlesztői tagságot igényel — a részletek és a teendőlista a 11.4-ben.
Kikapcsolva az app pontosan úgy viselkedik, mint a szinkron-munka előtt.

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

A váz megvan: `Support/FeatureFlags.swift`, `flags.multiPerson` alakú
lekérdezéssel, release-ben kikapcsolva, debugban a Profil alján kapcsolható.
StoreKit még nincs mögötte — az `isPurchased` ma mindig hamis, és ez az egyetlen
hely, ahova a jogosultság-lekérdezés majd bekerül. Az első vevő a több profil
(11.5); ami nem flagelendő, az a séma és a migráció, csak a UI.

### 11.3 Sokkal komplexebb Előzmény

Havi / heti / éves bontás, line chartokkal a fogyasztásról. Nem csak
alkalomlista: trendek. Mennyit ittam ebben a hónapban az előzőhöz képest, hány
józan nap volt, hogy alakult a csúcsok alakulása.

Az adat már megvan hozzá: a `DrinkingSession` tárol összesítőt
(`SessionSummary`), és a `DrinkingDay` (5.6) adja a napi bontást. Aggregálásnál
figyelni kell, hogy a cache-elt összesítő a `BACEngine.version`-höz van kötve.

**Megtervezve és az alapja megépítve (2026. szeptember).** A döntések:

- **Egy History képernyő, nem két menüpont.** Szegmens-váltó Nap / Hét /
  Hónap / Év; a drill-down évtől hónapon és héten át a napig megy, a napból a
  mostani alkalom-részletbe (`SessionDetailView`), ami így a hierarchia alja
  marad, hozzányúlás nélkül.
- **Nincs új tárolt entitás.** A `Model/HistoryAggregate.swift` memóriában
  hajtja az alkalmakat napokra (`DayBucket`) és periódusokra
  (`PeriodBucket`), a cache-elt `SessionSummary`-ból. Egy év az néhány száz
  alkalom; egy második @Model CloudKit-kompatibilis, exportált és migrált
  kellene legyen, semmiért. Ebből következik, hogy az export/import (11.4)
  változatlan, és a history egy importált archívumból azonnal előáll.
- **A mennyiség nem vár a motorra, a csúcs igen.** Egység és italszám az
  italokból összeadható; a csúcs csak érvényes cache-ből jön, különben
  `nil` (`HistoryOccasion.peakRange`), és a bucket `peakIsComplete`-je hamis.
  Verzióbump után így az Év nézet nem futtat 365 szimulációt megnyitáskor —
  a cache visszatöltése a store háttérmenete lesz (**hátravan**).
- **„Nem ittál" és „nem tudjuk" itt válik láthatóvá (5.7).** `DayBucket.State`:
  `drank` / `dry` / `unknown`; a `Person.trackingStartedAt` előtti nap
  `unknown`, és nem számít bele az átlag nevezőjébe (`recordedDays`). A
  rögzítés kezdete a tárolt dátum és a **legkorábbi alkalom napja** közül a
  korábbi — egy felvitt este bizonyíték, hogy akkor már rögzítettünk,
  ugyanaz a szabály, mint a `Person.backdateTracking`. Így az ismeretlen
  napok mindig egy összefüggő szakasz az ablak elején; volt egy kör, amiben
  két este közé is esett ismeretlen nap, és a szürke sáv egy oszlopot fedett.
  A tárolt dátumot a `SessionStore.reconcileTrackingStart` is rendbe teszi
  minden `refreshFromStore`-nál (a legkorábbi alkalomra tolja, ha az
  korábbi) — az `add` csak új italra ellenőriz, a migráció, az import és a
  szinkron nem ment át rajta. A dátum *nem* vezethető le pusztán a
  bejegyzésekből: aki telepítés után hat napig nem iszik, annak az a hat
  nap ivásmentes, nem ismeretlen. Szabály: `min(első indítás, legkorábbi
  bejegyzés)`. A szürke sávban felirat: „No data before <dátum>", ha a sáv
  az ablak legalább harmada.
- **A nap a saját dátuma alá kerül, a hét/hónap/év a naptáré.** A hajnali
  5-kor kezdődő ivási nap a `calendarDate`-jével kerül hétbe/hónapba, tehát
  az éjfélen átnyúló este abban a hétben marad, amelyikben kezdődött. A hét
  kezdőnapja a `Calendar`-ból jön (magyarul hétfő).
- **Flag: `Feature.historyTrends`, ingyenes ablakkal.** Az utolsó
  `FeatureFlags.freeHistoryWindowDays` (7) ivási nap — a mai is beleértve —
  ingyenes, ami régebbi, lakat mögé kerül, az alkalom-sorokra is. A nézet
  egy kérdést tesz fel: `flags.canShowHistory(for: DrinkingDay)`. A flag a
  UI-t takarja, az adat mindenkinél íródik (11.5 mintájára): aki fél év után
  fizet, a teljes fél évet látja. A paywall mondja is ki.
- **Tesztek:** `DrinkSmartTests/HistoryAggregateTests.swift`, 15 teszt, két
  suite (aggregátum és ingyenes ablak). Az aggregátor és a `DrinkingDay`
  Foundation-only, ezért egy ideiglenes csomagban Linuxon is lefutottak; az
  app teszt-targetje (12.) továbbra is hiányzik.

**A képernyő megépítve (2026. szeptember), készüléken kipróbálva.**

- **Ablak + finomabb oszlopok, Apple Health-minta.** Szegmens Hét / Hónap /
  Év (`HistoryRange`); a Hét az utolsó hét ivási nap (nem naptári hét), a
  Hónap és az Év naptári egység. Oszlop = nap (Hét, Hónap) vagy hónap (Év).
  Chevronokkal lapozás az `oldestOffset`-ig; szegmensváltás a legújabb
  oldalra ugrik. Nincs külön Nap szegmens: a nap szintje az alkalom-sor a
  chart alatt (`SessionRow`), onnan `SessionDetailView`. **Oszlopról nem
  fúrunk le**: volt (Év-oszlop → hónap, hónap-oszlop → hét, második
  koppintásra), de a képernyő „magától" váltott tőle — a szegmens csak a
  szegmens-váltóról változzon.
- **`HistoryWindow` a modell**, `HistoryAggregate.days` kimenetéből épül:
  oszlopok `drank / dry / unknown / future` állapottal, összegek, változás az
  előző ablakhoz. Volt rajta mozgóátlag-vonal; kivettük, mert a magas
  oszlopok mögé bújt és egy hét hét pontjából nem olvasható ki trend — ha
  egyszer visszajön, az Év nézetbe való, nem a napi bontásba. Az `isWithinFreeWindow` a napokból
  következik, nem állítjuk — így a Hét 0. oldala az egyetlen ingyenes ablak,
  konstrukció szerint.
- **A mennyiség grammban vagy standard egységben, a felhasználó választása
  szerint** (`AmountUnit`, az `AppSettings`-ben a ‰ / % mellett, a Profil
  Display szekciójában). Alapból gramm: egy gramm mindenhol ugyanaz, az
  „egység" országonként más (8 g UK, 10 g HU, 12 g FR). A modell továbbra is
  standard egységben számol (`Drink.standardUnits`), a kettő ×10 — ezért
  nem mutatjuk mindkettőt egymás mellett. Egy helyen érvényes mindenhol:
  History chart, mutató-kártya, Live és alkalom stat-sor.
- **Az oszlop magassága a mennyiség (a tengely felírja, miben), a színe a
  csúcs** a nap saját határához képest (5.14). Koppintásra
  az oszlop fölött megjelenik a pontos érték; a találat a legközelebbi ivós
  oszlopra pattan 16 pont tűréssel, mert a hónap oszlopai pár pont
  szélesek. Az Év hónapcímkéi a locale rövidítéséből
  jönnek, három betűre vágva, ha hosszabb — egy betű nem volt olvasható. Érvényes cache nélkül semleges türkiz; a rögzítés előtti
  napok halvány sávot kapnak, mert az üres az „ivásmentes" jele (5.7).
  Az x-tengely éjfélhez igazított, különben a hét első oszlopát 5 óra levágná.
- **Két chart-kártya egymás alatt: mennyiség, majd csúcs.** A csúcs-chart
  oszlopa a nap legmagasabb szintje (a sáv közepe; a buborék tartományt ír,
  ha a sáv széles, 5.8), rajta a saját határ szaggatott vonala, ahogy a
  Live charton. Nem váltó és nem kettős tengely: a két mérőszám egymás
  alatt egy pillantással összevethető, és a vonal-oszlopok-mögé-bújás
  problémája (mozgóátlag) nem jön elő. Érvénytelen cache-nél a csúcs-oszlop
  hiányzik, nem nulla. A mutató-kártya első sora négy szám:
  mennyiség, italok, „Sober days" (`ivásmentes / rögzített`, alatta a
  rögzítés előtti napok száma, amíg van ilyen — az évben a „4 / 9"
  magyarázat nélkül érthetetlen), és a csúcs. A második sor egyedül a
  változás az előző ablakhoz, alatta halványan, hogy melyikhez („vs. Sep
  8–14"): egy „+239 %" magában vádnak hangzik, viszonyítási alappal
  összehasonlításnak.
- **Lakat:** a mutatók és a két chart együtt homályosodnak, rajta egy gomb a
  `HistoryPaywallSheet`-re; a 7 napnál régebbi alkalom-sor dátuma látszik,
  a csúcsa nem. A lap három dolgot mond: mi van mögötte, hogy az adat már
  megvan, és hogy hogyan nyílik. StoreKit nélkül a gomb debugban a flag
  override-ját állítja, release-ben „Coming soon".
- **A cache háttérben töltődik vissza:** `SessionStore.backfillStaleSummaries`
  a `refreshFromStore` végén, ötösével, `Task.yield`-del.
- Tesztek: `HistoryWindowTests` (11) a `HistoryAggregateTests` (16) mellett;
  Linuxon futtatva egy ideiglenes csomagban, Swift 6 módban, figyelmeztetés
  nélkül.

- **Ugrás tetszőleges időszakra: a fejléc dátuma gomb** (`HistoryJumpSheet`),
  a Naptár app mintájára. A chevronok maradnak a szomszédos oldalra — a
  kettő nem versenyez, más a szándék mögöttük. A lap a szegmenshez illő
  választót ad: Hét → grafikus naptár (a kiválasztott napot tartalmazó
  oldalra ugrik, a koppintás maga a választás), Hónap → év-léptető és 3×4
  hónaprács, Év → évlista; mindegyiken „Today" gomb a visszaútra. Csak a
  rögzített időszak van felkínálva. A dátum → oldal leképezés a
  `HistoryWindow.offset(containing:)`, naptári egységben számolva (Aug 15
  egy hónap-oldallal Sep 14 előtt van, pedig nem telt el harminc nap).
  Külön „ettől eddig" szűrő nincs; ha egyszer kell, a `HistoryRange` kap egy
  `.custom(DateInterval)` esetet, és ugyanez a képernyő szolgálja ki.

**Trend szegmens (negyedik) — megépítve (2026. szeptember), de LEVÉVE a
menüről.** Készüléken kipróbálva nem volt az igazi: a görgethető chart
pattogott (bounce), a bal felső tengelycím („Grams / day") csak húzás
közben látszott és elengedéskor eltűnt, és a görbék furán olvastak. Zoltán
a koncepciót újra akarja gondolni; addig a `HistorySegment.offered` lista
csak a három ablakot adja a pickernek, a kód (`HistoryTrend`,
`HistoryTrendChartView`, a `HistoryView` trend-ága, a tesztek és a kulcsok)
megmarad. Ami alább áll, az a megépített, de rejtett viselkedés.

A teljes rögzített időszak egy görbén, lapozás nélkül,
vízszintes görgetéssel és csippentés-zoommal (`chartScrollableAxes` +
`chartXVisibleDomain`, a csippentés `MagnifyGesture`-rel a látható
tartomány hosszát állítja, a középpont körül, 14 nap és 10 év között). Nem
oszlopok: a hónapok összemosnak, és a zoom értelmét vesztené. A szegmens
külön típus (`HistorySegment`), nem negyedik `HistoryRange`: a range-nek
oldalai, oldalcíme és periódusonként oszlopa van, a trendnek egyik sem —
egy közös enum minden `switch`-ben hagyott volna egy semmit nem jelentő
esetet. Belépéskor a zoom az utolsó negyedév (vagy a teljes időszak, ha
rövidebb), a jobb szélre görgetve. Két kártya, közös zoommal és
görgetéssel (két `@Binding` a `HistoryView` state-jére):

- **Mennyiség:** a napi gramm exponenciális mozgóátlaga (EMA), y = gramm/nap.
  Egyszerű mozgóátlag helyett, mert annál egy nagy este N nap múlva egy
  „lépcsővel" esik ki a görbéből, amikor semmi nem történt; az EMA-nál
  simán lecseng. Szimmetrikus simítás (Gauss, LOESS) helyett, mert az a
  jövő napjait is használná, és a görbe vége utólag mozogna. A felezési idő
  a zoomhoz kötött: < 3 hónap látható → 7 nap, < 2 év → 30 nap, fölötte 90.
  Ivásmentes napon a görbe süllyed, nem zuhan nullára — ezt jelenti a
  szokás. Kitöltött terület, türkiz: itt nincs határ, amihez színezni.
- **Csúcs:** csak az ivós napokra, alkalomról alkalomra lépő EMA, két este
  között vízszintes; a határ szaggatott vonala rajta. Zoltán döntése: a
  csúcs-trend azt mutassa, „amikor iszol, milyen magasra mész" — hogy
  romlik-e vagy javul-e a kontroll —, és ebbe nem számít bele, hány
  ivásmentes nap volt két este között. Ha minden napra átlagolnánk, a
  gyakoriságot és az intenzitást összekevernénk. Ugyanaz a felezési szám,
  csak alkalomban számolva (7 / 30 / 90 alkalom) — egy szám, két görbe, és
  a kártya alatti felirat mondja, melyik miben („Simítás · 7 nap" /
  „Simítás · 7 alkalom"). A lépcső az utolsó estétől máig kitart: a trend
  az, amit a következő estébe viszel. A nyers csúcsok halvány pontok a
  görbe alatt, a határhoz színezve; a görbe függőleges gradienst kap az
  5.14-es öt megállóval, a **mai** határhoz mérve — a kérdés az, hogy a
  múlt hogyan áll a most tartott vonalhoz. Elavult cache-ű nap nincs a
  görbén (nem nulla, nem tudjuk).
- Alkalom-lista ebben a nézetben nincs; a mutató-kártya a teljes időszakra
  (`HistoryFigures`, ugyanaz a típus, amit az ablak is ad), Change sor
  nélkül. A lakat automatikusan érvényes rá, mert kilóg a 7 napból.
- Tesztek: `HistoryTrendTests` (6) — EMA felezési idő és konstans bemenet,
  a mennyiség minden rögzített napra, a csúcs csak ismert csúcsú ivós
  napokra, a rögzítés előtti napok kimaradnak, a zoom-sávok.

**Hátravan:** a Trend szegmens újragondolása és visszatétele a menüre (fent); az Év → hónap, hónap → hét ugrás
visszahozása *látható* vezérlővel (pl. az érték-buborékban egy „Megnyitás"
gomb), nem rejtett gesztussal; hogy a szegmensváltás megtartsa-e az ablak
helyét a nulladik oldalra ugrás helyett; és hogy az ital nélkül maradt
alkalmat (visszavont gyors felvitel, utolsó ital törlése) a `SessionStore`
törölje-e — ma az aggregátor szűri ki (`drinkCount > 0`), az adatbázisban
ott marad.

### 11.4 Adatmentés és készülékváltás

**A követelmény:** ha Zoltán készüléket vált ugyanazzal az Apple ID-val, az
adatok ne vesszenek el. Ez nem opcionális kényelem.

**A döntés megszületett (2026. szeptember): iCloud / CloudKit private database,
saját login és regisztráció nélkül.** Nincs se e-mail/jelszó, se Sign in with
Apple. A kettő nem ugyanaz, és ezt könnyű összekeverni: a Sign in with Apple
*identitás egy saját backendhez* — bejelentkező képernyő, stabil user ID, és egy
szerver, amin az adat áll. A CloudKit *szinkron*: nincs bejelentkező képernyő,
mert a felhasználó már be van jelentkezve, és az adat az ő iCloud-kvótáján ül.

Amiért ez az ág nyert: nincs szerverünk, ami alkoholfogyasztási adatot tárol —
ez ennél az appnál nem mellékes adatvédelmi érv, hanem termékérv is (2., 9.).
Ára, hogy Androidra és webre nem vihető át, és megosztást nem támogat. Ha
egyszer kell web- vagy Android-kliens, akkor jön a Sign in with Apple és egy
saját backend — de az külön fázis, és semmit nem rontunk el azzal, hogy most
CloudKitre építünk.

#### Ami a kódban már megvan

- A séma **CloudKit-kompatibilis** (8.): minden mezőnek van alapértéke vagy
  opcionális, nincs `@Attribute(.unique)`, a kapcsolatok inverzzel mennek.
- `DrinkSmartApp.makeContainer()` — CloudKit ág `.private(cloudKitContainerID)`-vel,
  lokális fallbackkel és debug-assertionnel.
- A kétszeres tulajdonos elleni dedupe: `PersonMigration.resolveOwner` a korábbi
  `createdAt`-ot tartja meg, és a `merge(_:into:)` átviszi a másik alkalmait.
- `SessionStore.observeRemoteChanges()` — feliratkozás a
  `NSPersistentStoreRemoteChange` értesítésre, 500 ms-os debounce-szal. E nélkül
  egy másik készüléken felvitt ital megjelenne a `@Query`-s itallistában, de a
  görbe alatta nem rajzolódna újra, mert a `band`-et csak a `rebuild()` mozgatja.
  A `MainTabView` scenePhase hookja az előtérbe kerülést fedi; ez azt, amikor az
  app már ott van.

#### A kapcsoló

`BuildCapabilities.cloudSync` a `Support/FeatureFlags.swift`-ben, **alapból
`false`**. Ez az egyetlen sor, amit át kell írni.

Szándékosan **nem** `Feature`, és nem debugban kapcsolgatható. A `FeatureFlags`
a végén `isPurchased`-re esik, vagyis azt modellezi, mit *vásárolt* a
felhasználó — a szinkron nem ilyen, azt nem veszi meg senki, azt a target
entitlementje vagy hordozza, vagy nem. Ha `Feature` lenne, a StoreKit
megérkezésekor csendben fizetős funkcióvá válna. Fordítási idejű konstans, mert
futásidejű kapcsoló nem tud entitlementet előállítani, a store pedig egyszer
nyílik meg induláskor, még mielőtt bármilyen kapcsolót ki lehetne olvasni.

#### A blokkoló: fizetős tagság

**Az iCloud capability nem adható hozzá Personal Team alatt.** Az Xcode a
capability-listát a team jogosultságai szerint szűri, tehát nem hibaüzenetet ad,
hanem az iCloud meg sem jelenik a `+ Capability` listában. Kézzel írt
entitlements fájl sem kerüli meg: a provisioning profile nem tartalmazná az
entitlementet, és az aláírás bukna.

Kell hozzá **Apple Developer Program, Individual, 99 USD/év**. Zoltán döntése
(2026. szeptember): **ez várhat, amíg az app élesedik.** Addig `cloudSync =
false`, és az app pontosan úgy viselkedik, mint a szinkron-munka előtt.

#### Teendők, amikor a tagság megvan — sorrendben

1. **Előbb mentés.** Xcode → Window → Devices and Simulators → a készülék →
   DrinkSmart → **Download Container**. A signing team váltása megváltoztatja az
   app aláírását, az iOS pedig nem engedi rátelepíteni a régire ugyanazzal a
   bundle ID-val: az Xcode törli és újratelepíti, **a helyi adatokkal együtt**.
   Ugyanez a menü tud Replace Containert, tehát ez a visszaút.
2. developer.apple.com → Account → a **Program License Agreement** elfogadása.
   Amíg ez függőben van, az Xcode ugyanúgy nem lát capabilityket, mint fizetős
   tagság nélkül.
3. Xcode → Settings → Accounts → **Download Manual Profiles**, és a targeten az
   új team kiválasztása (a „Personal Team" felirat eltűnik mellőle).
4. **+ Capability → iCloud** → CloudKit pipa → konténer:
   `iCloud.dev.zcsipler.drinksmart`. Ha az Xcode mást hoz létre, a
   `DrinkSmartApp.cloudKitContainerID` konstanst kell hozzáigazítani.
5. **+ Capability → Background Modes** → Remote notifications. E nélkül a
   szinkron csak app-indításkor mozdul, push nem érkezik.
6. `BuildCapabilities.cloudSync = true`.
7. Futtatás **előbb a készüléken**, a meglévő adatokkal: itt dől el, hogy a
   meglévő lokális store átáll-e tükrözésre. Siker esetén a `CD_Person` /
   `CD_DrinkingSession` / `CD_DrinkRecord` rekordok megjelennek a CloudKit
   Console Development környezetében. Ha az assertion store-inkompatibilitásra
   hasal el, a kiút az app törlése és újratelepítése, majd Replace Container.
8. Csak ezután a második pont (szimulátor ugyanazzal az Apple ID-val, iCloud
   Drive bekapcsolva). A szimulátorra a push megbízhatatlan, ezért ott
   háttérbe-előtérbe kell tenni az appot.

Ellenőrzés, hogy a 4–5. pont tényleg megtörtént: keletkezett-e `.entitlements`
fájl a projektben.

#### Amibe egyszer már belefutottunk

A `makeContainer()` eredetileg `cloudKitDatabase: .automatic`-kal próbálkozott,
és a `catch` ágban volt egy assertion, ami elvileg jelezte volna, ha nincs
CloudKit. **Nem jelezte.** Az `.automatic` azt jelenti: „tükrözz arra a
konténerre, amit az entitlement megad — *ha* megad egyet"; entitlement nélkül
egyszerűen lokális store-t nyit, és **nem dob hibát**. Így a `catch` soha nem
futott le, az app pedig sikert jelentett, miközben semmit nem szinkronizált.
Egy teljes tesztkör ment el arra, hogy egy olyan buildet vizsgáltunk, amiben
nem is volt CloudKit.

Ezért van a konténer néven megadva (`.private(...)`) és nem `.automatic`-kal: a
hiányzó entitlement, az elgépelt azonosító és a nem birtokolt konténer így mind
dob, vagyis a fallback végre azt csinálja, amire írva lett.

#### Export / import — megépítve

Nem csak az Apple ID váltás miatt: **az iCloud nem biztonsági mentés** (a
felhasználó törölheti az app iCloud-adatát, és nincs kuka), a lokális fallback
ágon futóknak ez az egyetlen átviteli mód, egy elrontott séma-migráció után ez a
visszaút, és adathordozhatóság (GDPR 20. cikk) is. Azért készült el a CloudKit
előtt, mert a tagságtól függetlenül megírható, és mire a szinkron bekapcsol,
addigra védőháló is van meg ellenőrzési eszköz is: két készülékről exportálva a
két fájl összevethető.

Fájlok: `DataArchive` (Codable értéktípusok), `ArchiveExport`, `ArchiveImport`,
`Support/ArchiveDocument.swift` (`FileDocument` az exporthoz),
`View/DataTransferSection.swift` (a Profil alján).

A megvalósítás:

- **JSON, nem store-fájl másolat.** A `.sqlite` viszi a SwiftData/CloudKit
  metaadatokat, és verziók között nem stabil. A fájl fejlécében `schemaVersion`
  és `exportedAt`.
- **Amit exportálunk:** `Person`, `DrinkingSession` (a profil-pillanatképpel) és
  `DrinkRecord` minden tárolt mezője. Ugyanaz az elv, mint 5.5-nél: a bemenet
  megy bele, nem a görbe.
- **Amit nem:** a `cachedPeak*` / `cachedSoberAt` / `cachedEngineVersion` mezők.
  Újraszámolhatók, és a `BACEngine.version`-höz kötöttek — egy másik verziójú
  buildbe importálva hazudnának. Az `AppSettings` sem, az a készüléké.
- **Import: merge `id` alapján, idempotensen.** Ismeretlen id bejön, ismert id
  marad. Készülékváltásnál üres adatbázisba tölt, tehát ott mindegy — de egy
  régi export visszatöltése egy használt appra így nem veszít adatot.
- **Az `isOwner` ütközés a `PersonMigration.merge(_:into:)`-n keresztül.** A
  célkészüléken a migráció már létrehozott egy tulajdonost, mielőtt bármi
  importálna; a fájlban is van egy. Ez ugyanaz a probléma, mint a CloudKit-race,
  tehát ugyanaz a szabály oldja meg — egy szabály, két hívó.
- **`assign(to:)`-on keresztül** kell beírni a `person` kapcsolatot és a
  `personID`-t, különben a `@Query` nem találja meg a behozott alkalmakat.
  Import után egy `refreshFromStore()` elég: a `closeEndedSessions` minden
  nyitott alkalmon végigmegy, tehát egy régi „nyitott" importált este magától
  rendbe jön.
- **A meglévő alkalom egészben marad ki, az italaival együtt.** Italonként
  összefésülni azt igényelné, hogy eldöntsük, melyik oldal nyer egy mindkét
  helyen meglévő, de eltérő időpontú italnál — és erre nincs becsületes szabály,
  mert nem tároljuk, melyik szerkesztés volt később. A kihagyás kiszámítható és
  egy mondatban elmondható, ami egy visszafordíthatatlan műveletnél követelmény.
- **UI:** `DataTransferSection` a `ProfileView` alján, nem a főfolyamatban. Az
  import előbb tervet készít (`ArchiveImport.Plan`), és a megerősítő ablak abból
  mondja meg, mi fog történni — utána ír csak bármit.
- **Fájlformátum `.json`, nem saját UTI.** Egy privát típus rendezettebb lenne a
  megosztó lapon, de Info.plistben kellene deklarálni, és minden más app elől
  elzárná a fájlt — egy mentésnél, aminek pont az a dolga, hogy elhagyja az
  appot, ez rossz csere. A verzió a fájlon belül van (`schemaVersion`), ott, ahol
  ellenőrizni is lehet.

**Hátravan:** tesztek. Ez a kód pontosan az a fajta, amit a 11.8 és a 12. leír —
nem crashel és nem logol, csak rossz emberhez tesz egy alkalmat vagy kihagy
egyet. App-szintű teszt target nélkül nem is futtatható teszt rá.

### 11.5 Több profil — megépítve, flag mögött, tesztek nélkül

Egy estén belül át lehessen váltani másik emberre — pl. a barátnő profiljára —,
és oda is felvinni az italokat, gyorsan, a helyszínen.

Ez a legmélyebb séma-változás a listán. A `DrinkingSession` ma a profilt
*pillanatképként* tárolja (5.5), de nincs fogalma arról, hogy *kié*.

Megbeszélve és megépítve 2026 szeptemberében, a `FeatureFlags.multiPerson`
mögött. Ami itt áll, az működő viselkedés, nem terv — a tesztek kivételével.
Amikor a flag élesedik, az alábbi döntések átköltöznek az 5. fejezetbe.

**A váltás globális, és naponta visszaáll a tulajdonosra.** Mindhárom tab az
aktív személyt mutatja: az Előzmény az ő alkalmait, a Profil az ő testadatait
szerkeszti. Egy mentális modell van, nem kettő, és a vendég testadatai
ugyanott állíthatók, ahol a tieid. A legvalószínűbb hiba az, hogy este átváltasz
és másnap reggel elfelejted — ezért az aktív személy visszaáll a tulajdonosra,
ha a váltás nem a mai ivási napon (5.6) történt. Nem „hideg indítás"
detektálással, hanem a váltás időbélyegéből: a háttérből visszatérés így nem
zavar, egy esti app-kilövés nem veszíti el a kontextust, reggel viszont
magától te vagy.

**A feature flag a UI-t takarja, nem a sémát.** A `Person` entitás és a
migráció a flagtől függetlenül mindig lefut, mindenki a tulajdonoshoz tartozik,
és csak a váltó, a személy-felvitel és a személyenkénti szűrés van
`FeatureFlags.multiPerson` mögött (11.2). Ha a séma is flag alatt lenne, a flag
bekapcsolása egy meglévő installon ugyanúgy migrációt igényelne, a kikapcsolása
pedig elrejtené egy létező személy adatait — vagyis két adatállapotot kellene
karbantartani. Flag nélkül az app pontosan úgy viselkedik, mint korábban, és a
kódban egy ág van, nem kettő.

**Séma.** A `Person` viszi mindazt, ami személyenkénti: a testadatokat, a
gyakoriságot, a saját határt és a `trackingStartedAt`-ot — vagyis a mai
`AppSettings` nagy részét. Az `AppSettings` a `unit`-ra és az aktív személy
azonosítójára fogy le; a régi kulcsot **nem töröljük**, ugyanazon az alapon,
amiért a `LegacySessionImport` sem törli a sajátját (az az egyetlen másolat,
amiből a migráció újrajátszható). A `DrinkingSession` kap egy `person`
kapcsolatot **és** egy denormalizált `personID`-t: a `@Query` a `LiveView`-ban
és a `HistoryView`-ban skalárra tud szűrni, opcionális kapcsolaton keresztül
nem megbízhatóan. A kettő egy helyen íródik.

**Migráció.** `PersonMigration.run(in:)`, a `LegacySessionImport` mintájára:
tulajdonos-`Person` a régi beállításokból (`LegacyProfileSettings`, ami a
`drinksmart.settings.v1` kulcsot olvassa, és soha többé nem írja), majd minden
gazdátlan alkalom hozzá. **Nincs „már lefutott" UserDefaults-kulcs**, és ez
szándékos: a védelem maga az adat — tulajdonos csak akkor jön létre, ha nincs,
és a söprés csak a gazdátlan alkalmakhoz nyúl. Egy marker itt kifejezetten
rossz lenne, mert CloudKit mellett egy régebbi verziójú készülékről érkező
alkalom a marker beállítása **után** is befuthat, és akkor sosem kapna gazdát.
Két lekérdezés induláskor az olcsóbb hiba. CloudKit mellett két készülék az első szinkron
előtt két tulajdonost hozhat létre — ugyanaz a probléma, ami miatt az
`AppSettings` ma nincs SwiftDatában (lásd ott). Olcsó védelem a dedupe-lépés
indításkor: a korábbi `createdAt` nyer, a másik alkalmai átkerülnek hozzá.

**Store.** Egy `SessionStore` marad, `switch(to:)`-szal újrapontozva — a sáv
újraszámolása váltáskor pár ezredmásodperc, cserébe nincs párhuzamos állapot a
memóriában. Négy hely, ahol több emberrel a mai kód csendben rossz adatot
csinálna:

- `fetchOpenSession` és `sessionCovering` — szűrés nélkül a visszamenőleg
  felvitt italod beleeshet a másik ember aznapi alkalmába
- `profileApplicable(at:)` — a „legközelebbi alkalom profilja" fallback (5.5)
  az ő testalkatát fagyasztaná be a te alkalmadba
- `closeSessionIfEnded` — ma csak az aktív nyitott alkalmat zárja; több emberrel
  egyszerre több nyitott alkalom van, és a nem aktívé örökre nyitva maradna, ezért
  a `refreshFromStore` az összesen végigfuttatja a szabályt
- a `LiveView` és a `HistoryView` `@Query`-je, ami közvetlenül listáz

**UI (`PersonSwitcher.swift`).** A váltó egy chip — monogram, név, chevron —,
és **nem a heróban ül, hanem a Live tartalom tetején**, a nap-állapoton kívül.
A hero csak akkor van a képernyőn, ha fut alkalom; a legvalószínűbb pillanat
viszont, amikor valakit fel akarsz venni, pont egy üres nap. Ott ült eddig az
„End session", ami nem átkerült, hanem **megszűnt** (3.). Az Előzmény és a Profil `NavigationStack`-jében ugyanez a chip
a toolbarban van — a Profil mezői a *kiválasztott* ember testadatait írják, és
enélkül semmi nem mondaná meg, kiét. A hozzáadó lap név, nem, testsúly,
magasság, kor: mind a négy testadat alakítja a görbét, ezért egyiket sem
tippeljük meg (4.). A gyakoriság és a határ alapértékkel megy, mert utólag
állítható és nem a görbe alakját szabja. A chip kap személyre szabott színt
(`PersonAccent`, a soron következő szabad szín automatikusan), a görbe **nem**:
az a limithez viszonyított skála (5.14), és két színrendszer egy képernyőn
olvashatatlan.

**Fázisok.** 1. `FeatureFlags` váz ✔ — 2. `Person`, migráció, store-szűrés ✔ —
3. váltó, hozzáadó lap, a kézi lezárás kivezetése ✔ — 4. Előzmény és Profil a
kontextusra kötve ✔ — 5. tesztek: **hátravan**. A 2. fázis pont az a kód, ami a
11.8 és a 12. szerint **adatot tud veszíteni**, és ma nincs rá app-szintű teszt
target.

**Nyitva maradt:** a vendég határa app-alapértelmezés legyen-e vagy a tiéd
másolva (az első a javaslat — a határ személyes döntés, nem háztartási
beállítás), és hogy a személy törlése cascade-del vigye-e az alkalmait, vagy
legyen külön archiválás.

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

### 11.8 Tesztlefedettség a fő számolásra

Zoltán kérése, és a lista legfontosabb pontja: a **Widmark/farmakokinetikai
számolás ne tudjon észrevétlenül elromlani**. Ami ma van, az jó alap — 56 teszt,
konkrét számokkal a Python referenciából —, de nem teljes:

- **Jellemzőalapú (property-based) tesztek** a konkrét értékek mellé:
  a görbe sosem negatív, a tömeg megmarad, több ital monoton magasabb csúcsot ad,
  a sáv alsó vége sosem megy a felső fölé. Ezeket véletlen bemenetek százain
  kell futtatni, nem három fixture-ön.
- **Regressziós lakat a modellre.** Egy tesztfájl, ami a jelenlegi motor
  kimenetét rögzíti több profilra és italsorozatra. Ha bármelyik szám mozdul,
  a teszt elhasal — és akkor vagy szándékos volt (`BACEngine.version` bumpolása),
  vagy elrontottunk valamit. Ez az a védelem, ami ma hiányzik.
- **App-szintű teszt target** a `SessionPolicy`, a `DrinkingDay` és a migráció
  köré. Ez a kód tud **adatot veszíteni**, és ma egyáltalán nincs tesztelve.
- **Határesetek:** nulla hosszú ital, negatív időtartam, éjfélen átnyúló alkalom,
  a bétahatárokra szorított sáv, üres profil.

A `Reference/run_tests.sh` óta ez nem csak elvárás: minden kör végén lefuttatható
(6.).

## 12. Technikai hátralék

Nem termékfunkciók, hanem amit rendbe kell tenni:

- **iCloud capability bekapcsolása Xcode-ban — fizetős Apple Developer Program
  tagságra vár, lásd a 11.4 teendőlistáját.** A kód készen áll, a
  `BuildCapabilities.cloudSync` konstans kapcsolja. Az export / import ettől
  függetlenül **megvan** (11.4), tesztek nélkül.
- **App-szintű teszt target — a tesztek már megvannak, a target nincs.** A
  `DrinkSmartTests/` mappában ott a 18 teszt (`PersonMigrationTests`,
  `SessionRoutingTests`, `ActivePersonTests`, `TestSupport`), de **egyik sem
  fut**, mert nincs mibe fordulniuk. Xcode-ban: File → New → Target → Unit
  Testing Bundle, neve `DrinkSmartTests`, host application a `DrinkSmart`. A
  file-system synchronized group (objectVersion 77) utána magától felveszi a
  meglévő fájlokat. Amíg ez nincs meg, a teszt csak dokumentáció.
  A kód, amit védenek, az, ami **adatot tud veszíteni** — nem crashel és nem
  logol, csak rossz emberhez tesz egy italt vagy elérhetetlenné tesz egy
  alkalmat. A `SessionPolicy` és a `DrinkingDay` ugyanide tartozik.
- A Live és az Előzmény összekötése: kell-e egyáltalán, és ha igen, gesztus
  helyett mivel (5.11)
- Az `AddDrinkSheet` élő előrejelzése minden lépésköznél `projectBand`-et hív
  (egy hosszú estén 12 ms release, 167 ms debug; 6 szimuláció). Itt a
  késleltetés nem járható út, mert pont az élő előreszimuláció a termék tézise
  (2., 5.10) — ezt a motor gyorsításával kell megoldani. A belső ciklus RK4-lépésenként ~7 tömböt allokál (`dGut`, három
  `zip().map`), plusz lépésenként egy `pending.filter` és egy
  `indices.contains`; előre foglalt scratch bufferekkel nagyrészt kiirtható.
  A kimenetnek bitre azonosnak kell maradnia — `BACEngine.version` nem bumpolandó
- HealthKit: testadatok beolvasása, BAC és kalória visszaírása
- Helyi értesítések: közeledsz a határhoz / mikorra leszel tiszta
- watchOS-kiegészítő a gyors felvitelhez
- Ital áthelyezése másik napra szerkesztéssel (most az eredeti alkalomban marad)
- A hero kijelző **tartományos** elrendezésének élő ellenőrzése: 48pt-on egy
  tartomány kétszer olyan széles, a `minimumScaleFactor` 0,5-re megy le
- Az angol locale 12 órás AM/PM időformátuma szélesebb címkéket ad a charton;
  a `strideHours` már ritkít, de élőben ellenőrizni kell
- **A rövid címkék helyét az angol és a magyar szabta meg, de most 24 nyelv
  fér beléjük.** A generálás után kilógónak látszik a litván „Išplėstiniai
  nustatymai" (`Advanced`) és „Atšaukti veiksmą" (`Undo`), a holland „Ongedaan
  maken" (`Undo`), valamint a román „Eliminare completă" (`Clears`) — ez
  utóbbi egy szűk stat-sorban ül. Kettő közül kell választani: vagy rövidebb
  fordítás kell, vagy a sornak kell engednie. Amíg egy nyelv `needs_review`,
  a fordítás szabadon rövidíthető; ha a sor a szűk keresztmetszet, az minden
  nyelvre kihat, tehát a felület a rendes megoldás. Élőben kell végignézni,
  és nem csak ezt a négyet — a generálás csak azt méri, hány karakter, nem
  azt, hova fér

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

**Mit tudok ellenőrizni.** A `BACKit` tesztjeit **le tudom futtatni**:
`./Reference/run_tests.sh` letölt egy Swift toolchaint a sandboxba, és lemegy
mind az 56 teszt (6.). Ezt minden olyan kör végén futtassuk le, ami a motorhoz
ér. Rajta kívül: zárójel- és API-egyezés-ellenőrzés, a Python referencia, a
katalógus-ellenőrző.

**Amit nem tudok:** az **app targetet** nem fordítom — SwiftUI és SwiftData kell
hozzá, az Xcode dolga. A nézetek, a perzisztencia és minden, ami készüléken
látszik, Zoltáné. Ezért érdemes minden körben kis, önmagában értelmes
változást adni.
