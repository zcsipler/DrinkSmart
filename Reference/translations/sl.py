"""
Slovene.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promil",
    "Percent": "Odstotek",

    # --- DrinkCatalog: drink types ---
    "Beer": "Pivo",
    "Wine": "Vino",
    "Sparkling": "Peneče vino",
    "Spirit": "Žgana pijača",
    "Cocktail": "Koktajl",
    "Custom": "Po meri",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Prazen želodec",
    "Moderately full": "Srednje poln želodec",
    "Full stomach": "Poln želodec",
    "Empty": "Prazen",
    "Moderate": "Srednje poln",
    "Full": "Poln",
    "Fast absorption, higher and earlier peak.": "Hitra absorpcija, višji in zgodnejši vrh.",
    "Moderate absorption.": "Srednje hitra absorpcija.",
    "Slow absorption, lower and later peak.": "Počasna absorpcija, nižji in poznejši vrh.",

    # --- DrinkingFrequency ---
    "Rarely": "Redko",
    "A few times a month": "Nekajkrat na mesec",
    "Several times a week": "Večkrat na teden",
    "Almost daily": "Skoraj vsak dan",
    "A few occasions a year": "Nekajkrat na leto",
    "Social drinking": "Družabno pitje",
    "Weekly routine": "Tedenska rutina",
    "Daily or nearly daily": "Vsak dan ali skoraj vsak dan",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Čas",
    "Level": "Raven",
    "Lower": "Spodnja",
    "Upper": "Zgornja",
    "Lower estimate": "Spodnja ocena",
    "Upper estimate": "Zgornja ocena",
    "Personal limit": "Osebna meja",
    "Drink": "Pijača",

    # --- BACChartView ---
    "Expected peak around %@": "Pričakovani vrh okoli %@",
    "Peaked around %@": "Vrh je bil okoli %@",
    "No active session": "Ni aktivnega dogodka",
    "Still rising": "Še narašča",
    "YOUR LIMIT %@": "TVOJA MEJA %@",
    "possible range": "možni razpon",
    "drag to read values": "povleci za odčitavanje vrednosti",
    "release to go back": "spusti za vrnitev",
    "pour time": "čas pitja",
    "in one go": "na dušek",

    # --- Live screen: the day with nothing on it ---
    "Live": "V živo",
    "Nothing logged today": "Danes ni nič zabeleženega",
    "Add a drink when you have one.": "Vsako pijačo dodaj, ko jo piješ.",

    # --- Tabs and history ---
    "History": "Zgodovina",
    "No past sessions yet": "Še ni preteklih dogodkov",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Dogodek se prikaže tukaj, ko se konča — ko se alkohol izloči in mine nekaj ur.",
    "%@ drinks": "Pijače: %@",
    "peak": "vrh",
    "Started": "Začetek",
    "Lasted": "Trajanje",
    "Calculated with your profile at the time": "Izračunano s tvojim takratnim profilom",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "ocenjena raven",
    "estimated range": "ocenjen razpon",
    "Elapsed": "Preteklo",
    "Drinks": "Pijače",
    "Units": "Enote",
    "Expected to clear": "Pričakovano izločanje",
    "Drinks this session": "Pijače na tem dogodku",
    "This is an estimate, not a measurement.": "To je ocena, ne meritev.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Dejanske vrednosti se med posamezniki precej razlikujejo. Tega nikoli ne uporabljaj "
        "za odločitev, ali lahko voziš.",
    "Add drink": "Dodaj pijačo",

    # --- Editing an already logged drink ---
    "Edit drink": "Uredi pijačo",
    "Save changes": "Shrani spremembe",
    "With this": "S to pijačo",
    "Delete": "Izbriši",
    "tap to edit · swipe to delete": "dotakni se za urejanje · povleci za brisanje",

    # --- Drinking pace ---
    "How fast": "Kako hitro",
    "In one go": "Na dušek",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Šteje kot en sam požirek — najstrmejši možni vzpon.",
    "A quick drink. The level climbs fast.": "Hitro popita pijača. Raven hitro naraste.",
    "A normal pace.": "Običajen tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Počasi popita pijača. Precej blažji vzpon ob enaki količini alkohola.",

    # --- AddDrinkSheet ---
    "Cancel": "Prekliči",
    "Now": "Zdaj",
    "Projected peak": "Predvideni vrh",
    "Peak at": "Vrh ob",
    "Clears": "Izloči se",
    "This would cross your limit": "To bi preseglo tvojo mejo",
    "Around %@, for up to %@.": "Okoli %@, za največ %@.",
    "This might cross your limit": "To bi morda preseglo tvojo mejo",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Pri počasnejši presnovi da, pri hitrejši ne. To je negotovost ocene.",
    "Type": "Vrsta",
    "Amount": "Količina",
    "Strength": "Jakost",
    "%@ units": "Enote: %@",
    "%@ g alcohol": "%@ g alkohola",
    "Stomach": "Želodec",
    "When": "Kdaj",
    "15 min ago": "pred 15 min",
    "30 min ago": "pred 30 min",
    "1 hr ago": "pred 1 h",
    "Done": "Končano",
    "Set exact time": "Nastavi točen čas",
    "Add": "Dodaj",

    # --- ProfileSheet ---
    "Male": "Moški",
    "Female": "Ženski",
    "Sex": "Spol",
    "Weight": "Teža",
    "Height": "Višina",
    "Age": "Starost",
    "kg": "kg",
    "cm": "cm",
    "yrs": "let",
    "Body": "Telo",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Skupna telesna voda izhaja iz Watsonovih enačb, ki določajo volumen, v katerega se "
        "alkohol porazdeli.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Skupna telesna voda izhaja iz Watsonovih enačb, ki določajo volumen, v katerega se "
        "alkohol porazdeli. Ženska enačba ne vključuje starosti, zato njena sprememba ne bo "
        "vplivala na rezultat.",
    "Drinking frequency": "Pogostost pitja",
    "How often do you drink?": "Kako pogosto piješ?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Tako ocenimo tvojo hitrost izločanja. Redno pitje inducira jetrno pot CYP2E1, zato "
        "tisti, ki pijejo pogosto, izločajo alkohol hitreje. To je najšibkejša točka modela, "
        "zato lahko pod Napredno nastaviš, koliko te negotovosti ti aplikacija pokaže.",
    "Your limit": "Tvoja meja",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Tvoja lastna referenčna številka, ne zakonska meja. Aplikacija ti pove, kdaj bi te "
        "načrtovana pijača popeljala čeznjo in kako dolgo bi ostal nad njo.",
    "Unit": "Enota",
    "Display": "Prikaz",
    "Calculated values": "Izračunane vrednosti",
    "Total body water": "Skupna telesna voda",
    "Distribution volume": "Volumen porazdelitve",
    "Widmark factor": "Widmarkov faktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmarkov faktor je pri moških običajno okoli 0,68, pri ženskah pa 0,55. Če je tvoj "
        "daleč od tega, je vredno preveriti zgornje vrednosti.",
    "Elimination rate": "Hitrost izločanja",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Kako hitro tvoja jetra izločijo alkohol, ko je ta absorbiran — naklon padajoče strani "
        "krivulje.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol se izloča v približno stalni količini na uro in ne v odstotkih, ker encim, ki "
        "ga razgrajuje, deluje s polno zmogljivostjo pri skoraj vsaki ravni. Prav zato sploh "
        "obstajajo pravila, kot je »ena pijača na uro«.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Pri tej nastavitvi se %@ izloči v približno %@. Skoraj vsi so v razponu %@ na uro.",
    "How to find yours": "Kako ugotoviti svojo hitrost",
    "With a breathalyser": "Z alkotestom",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Dvakrat pihni v alkotest, vsaj uro narazen, na padajoči strani — dve uri ali več po "
        "zadnji pijači in brez pijače vmes. Drugo meritev odštej od prve in rezultat deli s "
        "številom ur med njima.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Na primer %@ in %@ dve uri pozneje pomeni %@ na uro.",
    "Without one": "Brez alkotesta",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Aplikacija ti pove, kdaj pričakuje, da se bo alkohol izločil. Če si zanesljivo spet "
        "normalen precej pred tem, je tvoja hitrost višja od nastavitve — premakni jo za eno "
        "stopnjo navzgor in spremljaj nekaj dogodkov. Če traja dlje od napovedi, jo premakni "
        "navzdol.",
    "What moves it": "Kaj vpliva nanjo",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Redno pitje jo zviša: jetrni encim, ki opravlja to delo, se z uporabo inducira. Pri "
        "ženskah je v povprečju tudi nekoliko višja, nižja pa na prazen želodec ali ob težavah "
        "z jetri.",
    "Uncertainty": "Negotovost",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Pri ničli je vsaka številka ena sama vrednost — najboljša ocena aplikacije. Nad ničlo "
        "so iste številke prikazane kot razponi, temu primerno pa se razširi tudi pas na "
        "grafu.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Ob eni sami številki se je lažje učiti: sčasoma spoznaš, kakšen občutek je pri tvojih "
        "0,6. Razpon je bolj dobesedni odgovor, ker je hitrost res negotova. Oboje je "
        "utemeljeno — odločitev je tvoja.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Razpon, ki ga nakazuje tvoja pogostost pitja, je ± %@ na uro.",
    "Rate": "Hitrost",
    "Range": "Razpon",
    "Advanced": "Napredno",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Negotovost je stvar okusa: določa, ali so številke prikazane kot ena vrednost ali kot "
        "razpon. Spodnja hitrost ni stvar okusa — prepusti jo vprašanju o pogostosti, razen če "
        "imaš meritev, s katero jo lahko primerjaš.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Več oseb",
    "History trends": "Trendi zgodovine",
    "Week": "Teden",
    "Month": "Mesec",
    "Year": "Leto",
    "Sober days": "Dnevi brez alkohola",
    "Change": "Sprememba",
    "before records": "pred začetkom beleženja",
    "See further back": "Poglej dlje nazaj",
    "Weeks, months and years side by side — and every evening older than seven days.": "Tedni, meseci in leta drug ob drugem – in vsak večer, starejši od sedmih dni.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Vse, kar si zabeležil, je že shranjeno. Odklep to le pokaže.",
    "Coming soon": "Kmalu",
    "No data before %@": "Ni podatkov pred %@",
    "vs.": "glede na",
    "Grams": "Grami",
    "Grams of alcohol": "Grami alkohola",
    "Standard units": "Standardne enote",
    "Period": "Obdobje",
    "Switch person": "Zamenjaj osebo",
    "Add person": "Dodaj osebo",
    "New person": "Nova oseba",
    "You": "Ti",
    "Name": "Ime",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Vse štiri vrednosti spremenijo krivuljo, zato nobene ni mogoče ugibati za nekoga "
        "drugega.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Lastno mejo te osebe in podrobnejše nastavitve lahko pozneje spremeniš v zavihku "
        "Profil, ko je ta oseba izbrana.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Hitro dodajanje",
    "Choose a favourite drink": "Izberi najljubšo pijačo",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Izberi pijačo, ki jo običajno naročiš, in gumb na zaslonu V živo jo bo zabeležil z "
        "enim dotikom.",
    "This is your quick-add drink": "To je tvoja pijača za hitro dodajanje",
    "Set as my quick-add drink": "Nastavi kot pijačo za hitro dodajanje",
    "This is now your usual": "To je zdaj tvoja običajna pijača",
    "Remove favourite": "Odstrani najljubšo pijačo",
    "Always add this one": "Vedno dodaj to pijačo",
    "Logs it straight away, without opening anything.":
        "Zabeleži jo takoj, brez odpiranja česar koli.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "En dotik na zaslonu V živo jo zabeleži, s predvidenim vrhom na gumbu. Napolnjenost "
        "želodca se prevzame od prejšnje pijače, popraviš pa jo lahko takoj zatem.",
    "Peak %@": "Vrh %@",
    "%@ added": "Dodano: %@",
    "Save": "Shrani",
    "Undo": "Razveljavi",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Varnostna kopija",
    "Export a backup": "Izvozi varnostno kopijo",
    "Import a backup": "Uvozi varnostno kopijo",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Varnostna kopija vsebuje vse osebe, dogodke in pijače. Uvoz doda le tisto, kar manjka "
        "— nikoli ne spremeni ali odstrani ničesar, kar je že tu.",
    "Import this backup?": "Uvozim to varnostno kopijo?",
    "Import": "Uvozi",
    "Everything in this backup is already here.": "Vse iz te varnostne kopije je že tu.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Dodani bodo dogodki: %@, pijače: %@. Nič od tega, kar je že tu, ne bo spremenjeno ali "
        "odstranjeno.",
    "Import finished": "Uvoz končan",
    "Added %@ occasions and %@ drinks.": "Dodani dogodki: %@, dodane pijače: %@.",
    "OK": "V redu",

    # --- LanguageSection: the app's language ---
    "Language": "Jezik",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Odpre to aplikacijo v Nastavitvah, kjer »Prednostni jezik« določi jezik same "
        "aplikacije — sistemski ostane nespremenjen. iOS ob spremembi znova zažene aplikacijo.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Uvoz ni uspel",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Ta datoteka ni varnostna kopija aplikacije DrinkSmart ali pa je poškodovana.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "To varnostno kopijo je ustvarila novejša različica aplikacije DrinkSmart. Posodobi "
        "aplikacijo in poskusi znova.",
}
