"""
Hungarian.

Hand-written and reviewed. This is the reference translation: its key set
defines what the catalog contains, and every other language file is checked
against it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Ezrelék",
    "Percent": "Százalék",

    # --- DrinkCatalog: drink types ---
    "Beer": "Sör",
    "Wine": "Bor",
    "Sparkling": "Pezsgő",
    "Spirit": "Tömény",
    "Cocktail": "Koktél",
    "Custom": "Egyedi",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Éhgyomor",
    "Moderately full": "Közepesen telt",
    "Full stomach": "Teli has",
    "Empty": "Éhgyomor",
    "Moderate": "Közepes",
    "Full": "Teli",
    "Fast absorption, higher and earlier peak.": "Gyors felszívódás, magasabb és korábbi csúcs.",
    "Moderate absorption.": "Mérsékelt felszívódás.",
    "Slow absorption, lower and later peak.": "Lassú felszívódás, alacsonyabb és későbbi csúcs.",

    # --- DrinkingFrequency ---
    "Rarely": "Ritkán",
    "A few times a month": "Havonta párszor",
    "Several times a week": "Hetente többször",
    "Almost daily": "Szinte naponta",
    "A few occasions a year": "Évente néhány alkalom",
    "Social drinking": "Alkalmi, társasági fogyasztás",
    "Weekly routine": "Heti rendszeresség",
    "Daily or nearly daily": "Napi vagy majdnem napi",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Idő",
    "Level": "Szint",
    "Lower": "Alsó",
    "Upper": "Felső",
    "Lower estimate": "Alsó becslés",
    "Upper estimate": "Felső becslés",
    "Personal limit": "Saját határ",
    "Drink": "Ital",

    # --- BACChartView ---
    "Expected peak around %@": "Várható csúcs %@ körül",
    "Peaked around %@": "Csúcs volt %@ körül",
    "No active session": "Nincs aktív alkalom",
    "Still rising": "Még emelkedik",
    "YOUR LIMIT %@": "SAJÁT HATÁR %@",
    "possible range": "lehetséges tartomány",
    "drag to read values": "húzd a leolvasáshoz",
    "release to go back": "engedd el a visszatéréshez",
    "pour time": "fogyasztási idő",
    "in one go": "egy hajtásra",

    # --- Live screen: the day with nothing on it ---
    "Live": "Élő",
    "Nothing logged today": "Ma még nincs felvitt ital",
    "Add a drink when you have one.": "Vidd fel, amikor iszol valamit.",

    # --- Tabs and history ---
    "History": "Előzmény",
    "No past sessions yet": "Még nincs lezárt alkalom",
    "A session appears here once it has ended — when your level has cleared and a few hours have passed.":
        "Egy alkalom akkor kerül ide, ha lezárult — amikor a szinted kiürült, és eltelt néhány óra.",
    "%@ drinks": "%@ ital",
    "peak": "csúcs",
    "Started": "Kezdés",
    "Lasted": "Tartam",
    "Calculated with your profile at the time": "Az akkori profiloddal számolva",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "becsült szint",
    "estimated range": "becsült tartomány",
    "Elapsed": "Tartam",
    "Drinks": "Italok",
    "Units": "Egység",
    "Expected to clear": "Várhatóan ekkorra ürül ki",
    "Drinks this session": "Az alkalom italai",
    "This is an estimate, not a measurement.": "Ez egy becslés, nem mérés.",
    "Actual values vary considerably between individuals. Never use this to decide whether you can drive.":
        "A tényleges érték egyénenként jelentősen eltérhet. Soha ne használd annak eldöntésére, hogy vezethetsz-e.",
    "Add drink": "Ital hozzáadása",

    # --- Editing an already logged drink ---
    "Edit drink": "Ital szerkesztése",
    "Save changes": "Mentés",
    "With this": "Ezzel",
    "Delete": "Törlés",
    "tap to edit · swipe to delete": "koppints a szerkesztéshez · húzd a törléshez",

    # --- Drinking pace ---
    "How fast": "Milyen tempóban",
    "In one go": "Egy hajtásra",
    "15 min": "15 perc",
    "30 min": "30 perc",
    "1 hr": "1 óra",
    "Counts as a single swallow — the steepest possible rise.":
        "Egyetlen kortynak számít — ez a lehető legmeredekebb emelkedés.",
    "A quick drink. The level climbs fast.":
        "Gyors ital. A szint meredeken emelkedik.",
    "A normal pace.": "Szokásos tempó.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Lassan kortyolva. Ugyanannyi alkohol, sokkal szelídebb emelkedés.",

    # --- AddDrinkSheet ---
    "Cancel": "Mégse",
    "Now": "Most",
    "Projected peak": "Vetített csúcs",
    "Peak at": "Csúcs ekkor",
    "Clears": "Kiürül",
    "This would cross your limit": "Átlépnéd a saját határod",
    "Around %@, for up to %@.": "%@ körül, legfeljebb %@ hosszan.",
    "This might cross your limit": "Átlépheted a saját határod",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "A lassabb lebontás esetén igen, a gyorsabbnál nem. Ez a becslés bizonytalansága.",
    "Type": "Típus",
    "Amount": "Mennyiség",
    "Strength": "Alkoholfok",
    "%@ units": "%@ egység",
    "%@ g alcohol": "%@ g alkohol",
    "Stomach": "Gyomor",
    "When": "Időpont",
    "15 min ago": "15 perce",
    "30 min ago": "30 perce",
    "1 hr ago": "1 órája",
    "Done": "Kész",
    "Set exact time": "Pontos idő megadása",
    "Add": "Hozzáadás",

    # --- ProfileSheet ---
    "Male": "Férfi",
    "Female": "Nő",
    "Sex": "Nem",
    "Weight": "Testsúly",
    "Height": "Magasság",
    "Age": "Életkor",
    "kg": "kg",
    "cm": "cm",
    "yrs": "év",
    "Body": "Testalkat",
    "Total body water comes from the Watson equations, which set the volume alcohol distributes into.":
        "A teljes testvíz a Watson-formulákból jön, ez adja meg az alkohol eloszlási terét.",
    "Total body water comes from the Watson equations, which set the volume alcohol distributes into. "
    "The female equation does not include age, so changing it will not affect the result.":
        "A teljes testvíz a Watson-formulákból jön, ez adja meg az alkohol eloszlási terét. "
        "A női egyenlet nem tartalmazza az életkort, ezért annak állítása nem változtat az eredményen.",
    "Drinking frequency": "Fogyasztás gyakorisága",
    "How often do you drink?": "Milyen gyakran iszol?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's CYP2E1 pathway, "
    "so frequent drinkers clear alcohol faster. It is the weakest point of the model, which is why you can "
    "set under Advanced how much of that uncertainty the app shows you.":
        "Ebből becsüljük a lebontási sebességet. A rendszeres fogyasztás indukálja a máj CYP2E1 útvonalát, "
        "ezért a gyakori fogyasztók gyorsabban bontják le az alkoholt. Ez a modell leggyengébb pontja, "
        "ezért a Haladó beállításokban megadhatod, mennyit mutasson meg az app ebből a bizonytalanságból.",
    "Your limit": "Saját határ",
    "Your own reference number, not a legal limit. The app tells you when a planned drink would take you "
    "past it, and for how long you would stay above.":
        "A te referenciaszámod, nem jogi limit. Az app jelzi, ha egy tervezett ital átvinne rajta — és azt "
        "is, mennyi ideig maradnál fölötte.",
    "Unit": "Mértékegység",
    "Display": "Megjelenítés",
    "Calculated values": "Számított értékek",
    "Total body water": "Teljes testvíz",
    "Distribution volume": "Eloszlási térfogat",
    "Widmark factor": "Widmark-faktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far from that, "
    "it is worth checking the values above.":
        "A Widmark-faktor tipikusan 0,68 körül van férfiaknál és 0,55 körül nőknél. Ha a tiéd messze esik "
        "ettől, érdemes ellenőrizni a fenti adatokat.",
    "Elimination rate": "Lebontási sebesség",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling side of the curve.":
        "Milyen gyorsan üríti a májad a már felszívódott alkoholt — ez a görbe lecsengő szakaszának meredeksége.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the enzyme that breaks it down already runs at full capacity at almost any level. That is why rules of thumb like “one drink an hour” exist at all.":
        "Az alkohol nem százalékosan tűnik el, hanem óránként fix mennyiséggel, mert a lebontó enzim már nagyon alacsony szinten is teljes kapacitáson dolgozik. Innen van, hogy egyáltalán létezik olyan ökölszabály, mint az „óránként egy ital”.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Ezzel a beállítással %@ körülbelül %@ alatt ürül ki. Szinte mindenkinél %@ közé esik ez az "
        "érték óránként.",
    "How to find yours": "Hogyan derítheted ki a sajátodat?",
    "With a breathalyser": "Alkoholszondával",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your last drink, "
    "with nothing in between. Subtract the second reading from the first and divide by the hours between "
    "them.":
        "Fújj kétszer, legalább egy óra különbséggel, a lecsengő ágon — az utolsó ital után legalább két "
        "órával, és közben ne igyál. Vond ki a második mérést az elsőből, és oszd el a köztük eltelt órák "
        "számával.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Például %@, majd két órával később %@: ez %@ óránként.",
    "Without one": "Szonda nélkül",
    "The app tells you when it expects you to clear. If you are reliably back to normal well before that, "
    "your rate is higher than the setting — nudge it up a step and watch for a few sessions. If it takes "
    "longer than predicted, nudge it down.":
        "Az app megmondja, mikorra várja a kiürülést. Ha ennél jóval hamarabb vagy rendben, a lebontásod "
        "gyorsabb a beállítottnál — vidd feljebb egy lépéssel, és figyeld néhány alkalmon át. Ha tovább "
        "tart, vidd lejjebb.",
    "What moves it": "Mi befolyásolja",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It also runs "
    "slightly higher in women on average, and lower on an empty stomach or with liver trouble.":
        "A rendszeres fogyasztás növeli: a munkát végző májenzim a használattól indukálódik. Nőknél "
        "átlagosan valamivel magasabb, éhgyomorra és májbetegség esetén pedig alacsonyabb.",
    "Uncertainty": "Bizonytalanság",
    "At zero every figure is a single number — the app's best estimate. Above zero the same figures are "
    "shown as ranges, and the band on the chart widens to match.":
        "Nullán minden szám egyetlen érték — az app legjobb becslése. Nulla fölött ugyanezek "
        "tartományként jelennek meg, és a grafikon sávja is ennek megfelelően szélesedik.",
    "A single number is easier to learn against: over time you find out what your own 0.6 feels like. "
    "A range is the more literal answer, because the rate really is uncertain. Both are defensible — "
    "this is your call.":
        "Egyetlen számhoz könnyebb tanulni: idővel megtudod, nálad mit jelent a 0,6. A tartomány a szó "
        "szerintibb válasz, mert a lebontási sebesség tényleg bizonytalan. Mindkettő védhető — ez a te "
        "döntésed.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "A fogyasztási gyakoriságod alapján javasolt szórás ± %@ óránként.",
    "Rate": "Sebesség",
    "Range": "Sáv",
    "Advanced": "Haladó beállítások",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a range. "
    "The rate below is not — leave it to the frequency question unless you have a measurement to match "
    "it against.":
        "A bizonytalanság ízlés kérdése: ez dönti el, hogy a számok egy értékként vagy tartományként "
        "jelennek meg. Az alatta lévő sebesség nem az — hagyd a gyakorisági kérdésre, hacsak nincs mért "
        "értéked, amihez igazítanád.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Több személy",
    "History trends": "Előzmény-trendek",
    "Week": "Hét",
    "Month": "Hónap",
    "Year": "Év",
    "Dry days": "Ivásmentes napok",
    "Change": "Változás",
    "before records": "a rögzítés előtt",
    "See further back": "Nézz vissza messzebbre",
    "Weeks, months and years side by side — and every evening older than seven days.": "Hetek, hónapok és évek egymás mellett – és minden hét napnál régebbi este.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Minden, amit eddig felvittél, már el van mentve. A feloldás csak megmutatja.",
    "Coming soon": "Hamarosan",
    "Grams": "Gramm",
    "Grams of alcohol": "Gramm tiszta alkohol",
    "Standard units": "Standard egység",
    "Period": "Időszak",
    "Switch person": "Személyváltás",
    "Add person": "Személy hozzáadása",
    "New person": "Új személy",
    "You": "Te",
    "Name": "Név",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Mind a négy módosítja a görbét, így egyiket sem lehet megtippelni valaki más helyett.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while they are "
    "the selected person.":
        "A saját határ és a finomabb beállítások később a Profil fülön módosíthatók, amíg ő a "
        "kiválasztott személy.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Gyorsfelvitel",
    "Choose a favourite drink": "Válassz kedvenc italt",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Válaszd ki, mit szoktál rendelni, és az Élő képernyőn egy gombnyomással felviheted.",
    "This is your quick-add drink": "Ez a gyorsfelvitel itala",
    "Set as my quick-add drink": "Legyen ez a gyorsfelvitel itala",
    "This is now your usual": "Ez lett a szokásos",
    "Remove favourite": "Kedvenc törlése",
    "Always add this one": "Mindig ezt vigye fel",
    "Logs it straight away, without opening anything.": "Azonnal felviszi, mindenféle felugró nélkül.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full your "
    "stomach is comes from the drink before it, and can be corrected straight after.":
        "Az Élő képernyőn egy koppintás felviszi, a gombon pedig ott a várható csúcs. A gyomor "
        "telítettségét az előző italtól veszi át, és utána azonnal javítható.",
    "Peak %@": "Csúcs %@",
    "%@ added": "%@ felvéve",
    "Save": "Mentés",
    "Undo": "Visszavonás",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Biztonsági mentés",
    "Export a backup": "Mentés exportálása",
    "Import a backup": "Mentés visszatöltése",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it never "
    "changes or removes anything already here.":
        "A mentés minden személyt, alkalmat és italt tartalmaz. A visszatöltés csak a hiányzókat adja "
        "hozzá — a már meglévő adatot nem módosítja és nem törli.",
    "Import this backup?": "Visszatöltöd ezt a mentést?",
    "Import": "Visszatöltés",
    "Everything in this backup is already here.": "A mentés minden eleme már megvan.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Hozzáad %@ alkalmat és %@ italt. A meglévő adatok nem változnak és nem vesznek el.",
    "Import finished": "A visszatöltés kész",
    "Added %@ occasions and %@ drinks.": "Hozzáadva %@ alkalom és %@ ital.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Nyelv",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Megnyitja az appot a Beállításokban, ahol az „Előnyben részesített nyelv” az app saját "
        "nyelvét állítja — a rendszeré marad, ami volt. Az iOS a váltáskor újraindítja az appot.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "A visszatöltés nem sikerült",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Ez a fájl nem a DrinkSmart mentése, vagy megsérült.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Ezt a mentést a DrinkSmart újabb verziója készítette. Frissítsd az appot, és próbáld újra.",
}
