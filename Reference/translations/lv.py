"""
Latvian.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promiles",
    "Percent": "Procenti",

    # --- DrinkCatalog: drink types ---
    "Beer": "Alus",
    "Wine": "Vīns",
    "Sparkling": "Dzirkstošvīns",
    "Spirit": "Stiprais",
    "Cocktail": "Kokteilis",
    "Custom": "Pielāgots",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Tukšs kuņģis",
    "Moderately full": "Vidēji pilns",
    "Full stomach": "Pilns kuņģis",
    "Empty": "Tukšs",
    "Moderate": "Vidēji",
    "Full": "Pilns",
    "Fast absorption, higher and earlier peak.":
        "Ātra uzsūkšanās, augstāks un agrāks maksimums.",
    "Moderate absorption.": "Vidēja uzsūkšanās.",
    "Slow absorption, lower and later peak.": "Lēna uzsūkšanās, zemāks un vēlāks maksimums.",

    # --- DrinkingFrequency ---
    "Rarely": "Reti",
    "A few times a month": "Dažas reizes mēnesī",
    "Several times a week": "Vairākas reizes nedēļā",
    "Almost daily": "Gandrīz katru dienu",
    "A few occasions a year": "Dažas reizes gadā",
    "Social drinking": "Dzeršana kompānijā",
    "Weekly routine": "Iknedēļas ieradums",
    "Daily or nearly daily": "Katru dienu vai gandrīz katru dienu",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Laiks",
    "Level": "Līmenis",
    "Lower": "Zemākais",
    "Upper": "Augstākais",
    "Lower estimate": "Zemākais novērtējums",
    "Upper estimate": "Augstākais novērtējums",
    "Personal limit": "Personīgā robeža",
    "Drink": "Dzēriens",

    # --- BACChartView ---
    "Expected peak around %@": "Gaidāmais maksimums ap %@",
    "Peaked around %@": "Maksimums bija ap %@",
    "No active session": "Nav aktīvas reizes",
    "Still rising": "Vēl kāpj",
    "YOUR LIMIT %@": "TAVA ROBEŽA %@",
    "possible range": "iespējamais diapazons",
    "drag to read values": "velc, lai nolasītu vērtības",
    "release to go back": "atlaid, lai atgrieztos",
    "pour time": "dzeršanas ilgums",
    "in one go": "vienā paņēmienā",

    # --- Live screen: the day with nothing on it ---
    "Live": "Šobrīd",
    "Nothing logged today": "Šodien nekas nav pierakstīts",
    "Add a drink when you have one.": "Pievieno dzērienu, kad to iedzer.",

    # --- Tabs and history ---
    "History": "Vēsture",
    "No past sessions yet": "Vēl nav iepriekšējo reižu",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Reize šeit parādās, kad tā ir beigusies — kad tavs līmenis ir nokrities līdz nullei "
        "un pagājušas dažas stundas.",
    "%@ drinks": "Dzērieni: %@",
    "peak": "maksimums",
    "Started": "Sākums",
    "Lasted": "Ilgums",
    "Calculated with your profile at the time": "Aprēķināts pēc tā brīža profila",

    # --- TodayView ---
    "Profile": "Profils",
    "estimated level": "novērtētais līmenis",
    "estimated range": "novērtētais diapazons",
    "Elapsed": "Pagājis",
    "Drinks": "Dzērieni",
    "Units": "Vienības",
    "Expected to clear": "Izvadīšana paredzēta",
    "Drinks this session": "Šīs reizes dzērieni",
    "This is an estimate, not a measurement.": "Šis ir novērtējums, nevis mērījums.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Faktiskās vērtības dažādiem cilvēkiem ievērojami atšķiras. Nekad neizmanto to, lai "
        "izlemtu, vai drīksti braukt.",
    "Add drink": "Pievienot dzērienu",

    # --- Editing an already logged drink ---
    "Edit drink": "Rediģēt dzērienu",
    "Save changes": "Saglabāt izmaiņas",
    "With this": "Ar šo",
    "Delete": "Dzēst",
    "tap to edit · swipe to delete": "pieskaries, lai rediģētu · pavelc, lai dzēstu",

    # --- Drinking pace ---
    "How fast": "Cik ātri",
    "In one go": "Vienā paņēmienā",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Tiek uzskatīts par vienu malku — visstraujākais iespējamais kāpums.",
    "A quick drink. The level climbs fast.": "Ātri izdzerts. Līmenis strauji kāpj.",
    "A normal pace.": "Parasts temps.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Lēni izbaudīts. Daudz maigāks kāpums pie tāda paša alkohola daudzuma.",

    # --- AddDrinkSheet ---
    "Cancel": "Atcelt",
    "Now": "Tagad",
    "Projected peak": "Prognozētais maksimums",
    "Peak at": "Maksimums plkst.",
    "Clears": "Izvadīts",
    "This would cross your limit": "Šis pārsniegtu tavu robežu",
    "Around %@, for up to %@.": "Aptuveni %@, līdz pat %@.",
    "This might cross your limit": "Šis varētu pārsniegt tavu robežu",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Ar lēnāku vielmaiņu — jā, ar ātrāku — nē. Tāda ir šī novērtējuma nenoteiktība.",
    "Type": "Veids",
    "Amount": "Daudzums",
    "Strength": "Stiprums",
    "%@ units": "Vienības: %@",
    "%@ g alcohol": "%@ g alkohola",
    "Stomach": "Kuņģis",
    "When": "Kad",
    "15 min ago": "Pirms 15 min",
    "30 min ago": "Pirms 30 min",
    "1 hr ago": "Pirms 1 h",
    "Done": "Gatavs",
    "Set exact time": "Norādīt precīzu laiku",
    "Add": "Pievienot",

    # --- ProfileSheet ---
    "Male": "Vīrietis",
    "Female": "Sieviete",
    "Sex": "Dzimums",
    "Weight": "Svars",
    "Height": "Augums",
    "Age": "Vecums",
    "kg": "kg",
    "cm": "cm",
    "yrs": "gadi",
    "Body": "Ķermenis",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Kopējais ķermeņa ūdens tiek aprēķināts pēc Watson vienādojumiem, kas nosaka tilpumu, "
        "kurā alkohols izkliedējas.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Kopējais ķermeņa ūdens tiek aprēķināts pēc Watson vienādojumiem, kas nosaka tilpumu, "
        "kurā alkohols izkliedējas. Sieviešu vienādojumā vecums netiek izmantots, tāpēc tā "
        "maiņa rezultātu neietekmēs.",
    "Drinking frequency": "Dzeršanas biežums",
    "How often do you drink?": "Cik bieži tu dzer?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Šādi mēs novērtējam tavu izvadīšanas ātrumu. Regulāra dzeršana inducē aknu CYP2E1 "
        "ceļu, tāpēc biežiem dzērājiem alkohols tiek izvadīts ātrāk. Tas ir modeļa vājākais "
        "punkts, un tieši tāpēc sadaļā Papildu tu vari norādīt, cik daudz no šīs nenoteiktības "
        "lietotne tev rāda.",
    "Your limit": "Tava robeža",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Tavs paša atskaites skaitlis, nevis likumā noteiktā robeža. Lietotne norāda, kad "
        "plānotais dzēriens to pārsniegtu un cik ilgi tu paliktu virs tās.",
    "Unit": "Mērvienība",
    "Display": "Attēlojums",
    "Calculated values": "Aprēķinātās vērtības",
    "Total body water": "Kopējais ķermeņa ūdens",
    "Distribution volume": "Izkliedes tilpums",
    "Widmark factor": "Widmark faktors",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmark faktors vīriešiem parasti ir ap 0,68, sievietēm — ap 0,55. Ja tavējais no tā "
        "stipri atšķiras, ir vērts pārbaudīt augstāk norādītās vērtības.",
    "Elimination rate": "Izvadīšanas ātrums",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Cik ātri tavas aknas izvada alkoholu pēc tā uzsūkšanās — līknes krītošās daļas "
        "slīpums.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohols tiek izvadīts aptuveni nemainīgā daudzumā stundā, nevis procentuālā daļā, jo "
        "enzīms, kas to noārda, jau gandrīz jebkurā līmenī strādā ar pilnu jaudu. Tieši tāpēc "
        "vispār pastāv īkšķa likumi, piemēram, „viens dzēriens stundā“.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Ar šo iestatījumu %@ izvadīšana aizņem aptuveni %@. Gandrīz visiem tas ir diapazonā "
        "%@ stundā.",
    "How to find yours": "Kā noskaidrot savējo",
    "With a breathalyser": "Ar alkometru",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Izpūt divreiz ar vismaz stundas starplaiku līknes krītošajā daļā — divas vai vairāk "
        "stundas pēc pēdējā dzēriena, neko pa vidu nedzerot. Atņem otro rādījumu no pirmā un "
        "izdali ar stundu skaitu starp tiem.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Piemēram, %@ un %@ divas stundas vēlāk dod %@ stundā.",
    "Without one": "Bez tā",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Lietotne norāda, kad paredz, ka alkohols būs izvadīts. Ja tu regulāri esi atpakaļ "
        "normā krietni ātrāk, tavs ātrums ir lielāks nekā iestatījumā — palielini to par vienu "
        "soli un novēro dažas reizes. Ja tas prasa ilgāk, nekā prognozēts, samazini to.",
    "What moves it": "Kas to ietekmē",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Regulāra dzeršana to paaugstina: aknu enzīmu, kas veic šo darbu, inducē pati "
        "lietošana. Sievietēm tas vidēji ir nedaudz augstāks, bet tukšā dūšā vai ar aknu "
        "problēmām — zemāks.",
    "Uncertainty": "Nenoteiktība",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Pie nulles katrs rādītājs ir viens skaitlis — lietotnes labākais novērtējums. Virs "
        "nulles tie paši rādītāji tiek rādīti kā diapazoni, un josla diagrammā attiecīgi "
        "paplašinās.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Pēc viena skaitļa ir vieglāk mācīties: laika gaitā tu uzzini, kā jūties tieši pie "
        "savām 0,6. Diapazons ir burtiskāka atbilde, jo ātrums tiešām ir nenoteikts. Abi "
        "varianti ir pamatoti — izvēle ir tava.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Izkliede, ko norāda tavs dzeršanas biežums, ir ± %@ stundā.",
    "Rate": "Ātrums",
    "Range": "Diapazons",
    "Advanced": "Papildu",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Nenoteiktība ir gaumes jautājums: tā nosaka, vai rādītāji tiek lasīti kā viens "
        "skaitlis vai kā diapazons. Ātrums zemāk tāds nav — atstāj to biežuma jautājuma ziņā, "
        "ja vien tev nav mērījuma, ar ko to salīdzināt.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Vairākas personas",
    "History trends": "Vēstures tendences",
    "Switch person": "Mainīt personu",
    "Add person": "Pievienot personu",
    "New person": "Jauna persona",
    "You": "Tu",
    "Name": "Vārds",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Visi četri maina līkni, tāpēc nevienu no tiem nevar uzminēt cita cilvēka vietā.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Viņu pašu robežu un smalkākos iestatījumus vēlāk var mainīt cilnē Profils, kamēr viņi "
        "ir izvēlētā persona.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Ātrā pievienošana",
    "Choose a favourite drink": "Izvēlies iecienītāko dzērienu",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Izvēlies dzērienu, ko parasti pasūti, un poga ekrānā Šobrīd to pierakstīs ar vienu "
        "pieskārienu.",
    "This is your quick-add drink": "Šis ir tavs ātrās pievienošanas dzēriens",
    "Set as my quick-add drink": "Iestatīt kā ātrās pievienošanas dzērienu",
    "This is now your usual": "Tagad šis ir tavs ierastais",
    "Remove favourite": "Noņemt iecienītāko",
    "Always add this one": "Vienmēr pievienot šo",
    "Logs it straight away, without opening anything.": "Pieraksta to uzreiz, neko neatverot.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Viens pieskāriens ekrānā Šobrīd pieraksta šo dzērienu, un uz pogas redzams "
        "prognozētais maksimums. Kuņģa pildījums tiek pārņemts no iepriekšējā dzēriena, un to "
        "var izlabot uzreiz pēc tam.",
    "Peak %@": "Maksimums %@",
    "%@ added": "%@ pievienots",
    "Save": "Saglabāt",
    "Undo": "Atsaukt",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Dublējums",
    "Export a backup": "Eksportēt dublējumu",
    "Import a backup": "Importēt dublējumu",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Dublējumā ir visas personas, reizes un dzērieni. Importēšana pievieno trūkstošo — tā "
        "nekad nemaina un nedzēš neko no jau esošā.",
    "Import this backup?": "Importēt šo dublējumu?",
    "Import": "Importēt",
    "Everything in this backup is already here.": "Viss no šī dublējuma jau ir šeit.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Tiks pievienotas reizes: %@. Tiks pievienoti dzērieni: %@. Nekas no jau esošā netiek "
        "mainīts vai dzēsts.",
    "Import finished": "Importēšana pabeigta",
    "Added %@ occasions and %@ drinks.": "Pievienotas reizes: %@. Pievienoti dzērieni: %@.",
    "OK": "Labi",

    # --- LanguageSection: the app's language ---
    "Language": "Valoda",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Atver šo lietotni sadaļā Iestatījumi, kur „Vēlamā valoda“ nosaka pašas lietotnes "
        "valodu — sistēmas valoda paliek nemainīga. Kad to maini, iOS lietotni restartē.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Neizdevās importēt",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Šis fails nav DrinkSmart dublējums vai arī ir bojāts.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Šis dublējums ir izveidots jaunākā DrinkSmart versijā. Atjaunini lietotni un mēģini "
        "vēlreiz.",
}
