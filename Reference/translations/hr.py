"""
Croatian.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promil",
    "Percent": "Postotak",

    # --- DrinkCatalog: drink types ---
    "Beer": "Pivo",
    "Wine": "Vino",
    "Sparkling": "Pjenušac",
    "Spirit": "Žestoko piće",
    "Cocktail": "Koktel",
    "Custom": "Prilagođeno",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Prazan želudac",
    "Moderately full": "Umjereno pun",
    "Full stomach": "Pun želudac",
    "Empty": "Prazan",
    "Moderate": "Umjereno",
    "Full": "Pun",
    "Fast absorption, higher and earlier peak.": "Brza apsorpcija, viši i raniji vrhunac.",
    "Moderate absorption.": "Umjerena apsorpcija.",
    "Slow absorption, lower and later peak.": "Spora apsorpcija, niži i kasniji vrhunac.",

    # --- DrinkingFrequency ---
    "Rarely": "Rijetko",
    "A few times a month": "Nekoliko puta mjesečno",
    "Several times a week": "Više puta tjedno",
    "Almost daily": "Gotovo svakodnevno",
    "A few occasions a year": "Nekoliko puta godišnje",
    "Social drinking": "Društveno pijenje",
    "Weekly routine": "Tjedna rutina",
    "Daily or nearly daily": "Svaki dan ili gotovo svaki dan",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Vrijeme",
    "Level": "Razina",
    "Lower": "Donja",
    "Upper": "Gornja",
    "Lower estimate": "Donja procjena",
    "Upper estimate": "Gornja procjena",
    "Personal limit": "Osobna granica",
    "Drink": "Piće",

    # --- BACChartView ---
    "Expected peak around %@": "Očekivani vrhunac oko %@",
    "Peaked around %@": "Vrhunac je bio oko %@",
    "No active session": "Nema aktivne sesije",
    "Still rising": "Još raste",
    "YOUR LIMIT %@": "TVOJA GRANICA %@",
    "possible range": "mogući raspon",
    "drag to read values": "povuci za očitanje vrijednosti",
    "release to go back": "otpusti za povratak",
    "pour time": "vrijeme pijenja",
    "in one go": "naiskap",

    # --- Live screen: the day with nothing on it ---
    "Live": "Uživo",
    "Nothing logged today": "Danas ništa nije zabilježeno",
    "Add a drink when you have one.": "Dodaj piće kad ga popiješ.",

    # --- Tabs and history ---
    "History": "Povijest",
    "No past sessions yet": "Još nema prošlih sesija",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Sesija se ovdje pojavljuje nakon što završi — kad ti razina padne na nulu i prođe "
        "nekoliko sati.",
    "%@ drinks": "Pića: %@",
    "peak": "vrhunac",
    "Started": "Počelo",
    "Lasted": "Trajalo",
    "Calculated with your profile at the time": "Izračunato s tvojim tadašnjim profilom",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "procijenjena razina",
    "estimated range": "procijenjeni raspon",
    "Elapsed": "Proteklo",
    "Drinks": "Pića",
    "Units": "Jedinice",
    "Expected to clear": "Očekivani pad na nulu",
    "Drinks this session": "Pića u ovoj sesiji",
    "This is an estimate, not a measurement.": "Ovo je procjena, a ne mjerenje.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Stvarne vrijednosti znatno se razlikuju od osobe do osobe. Nikad ne koristi ovo za "
        "procjenu smiješ li voziti.",
    "Add drink": "Dodaj piće",

    # --- Editing an already logged drink ---
    "Edit drink": "Uredi piće",
    "Save changes": "Spremi promjene",
    "With this": "S ovim pićem",
    "Delete": "Izbriši",
    "tap to edit · swipe to delete": "dodirni za uređivanje · povuci za brisanje",

    # --- Drinking pace ---
    "How fast": "Koliko brzo",
    "In one go": "Naiskap",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Računa se kao jedan gutljaj — najstrmiji mogući porast.",
    "A quick drink. The level climbs fast.": "Brzo popijeno piće. Razina raste brzo.",
    "A normal pace.": "Uobičajen tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Polako ispijano. Mnogo blaži porast za istu količinu alkohola.",

    # --- AddDrinkSheet ---
    "Cancel": "Odustani",
    "Now": "Sada",
    "Projected peak": "Predviđeni vrhunac",
    "Peak at": "Vrhunac u",
    "Clears": "Pad na nulu",
    "This would cross your limit": "Ovo bi prešlo tvoju granicu",
    "Around %@, for up to %@.": "Oko %@, u trajanju do %@.",
    "This might cross your limit": "Ovo bi moglo prijeći tvoju granicu",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Uz sporiji metabolizam da, uz brži ne. To je neizvjesnost procjene.",
    "Type": "Vrsta",
    "Amount": "Količina",
    "Strength": "Jačina",
    "%@ units": "Jedinice: %@",
    "%@ g alcohol": "%@ g alkohola",
    "Stomach": "Želudac",
    "When": "Kada",
    "15 min ago": "Prije 15 min",
    "30 min ago": "Prije 30 min",
    "1 hr ago": "Prije 1 h",
    "Done": "Gotovo",
    "Set exact time": "Postavi točno vrijeme",
    "Add": "Dodaj",

    # --- ProfileSheet ---
    "Male": "Muško",
    "Female": "Žensko",
    "Sex": "Spol",
    "Weight": "Težina",
    "Height": "Visina",
    "Age": "Dob",
    "kg": "kg",
    "cm": "cm",
    "yrs": "god.",
    "Body": "Tijelo",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Ukupna tjelesna voda proizlazi iz Watsonovih jednadžbi, koje određuju volumen u koji "
        "se alkohol raspoređuje.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Ukupna tjelesna voda proizlazi iz Watsonovih jednadžbi, koje određuju volumen u koji "
        "se alkohol raspoređuje. Ženska jednadžba ne uključuje dob, pa njezina promjena neće "
        "utjecati na rezultat.",
    "Drinking frequency": "Učestalost pijenja",
    "How often do you drink?": "Koliko često piješ?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Ovako procjenjujemo tvoju brzinu eliminacije. Redovito pijenje potiče jetreni put "
        "CYP2E1, pa redoviti konzumenti brže razgrađuju alkohol. To je najslabija točka "
        "modela, zbog čega pod Napredno možeš postaviti koliko ti te neizvjesnosti aplikacija "
        "prikazuje.",
    "Your limit": "Tvoja granica",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Tvoj vlastiti orijentacijski broj, a ne zakonska granica. Aplikacija ti javlja kad bi "
        "te planirano piće odvelo preko nje i koliko dugo bi razina ostala iznad.",
    "Unit": "Mjerna jedinica",
    "Display": "Prikaz",
    "Calculated values": "Izračunate vrijednosti",
    "Total body water": "Ukupna tjelesna voda",
    "Distribution volume": "Volumen distribucije",
    "Widmark factor": "Widmarkov faktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmarkov faktor obično iznosi oko 0,68 za muškarce i 0,55 za žene. Ako je tvoj "
        "daleko od toga, vrijedi provjeriti vrijednosti iznad.",
    "Elimination rate": "Brzina eliminacije",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Koliko brzo tvoja jetra razgrađuje alkohol nakon što se apsorbira — nagib silazne "
        "strane krivulje.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol se razgrađuje otprilike stalnom količinom na sat, a ne u postotku, jer enzim "
        "koji ga razgrađuje već radi punim kapacitetom pri gotovo svakoj razini. Zato uopće i "
        "postoje pravila poput „jedno piće na sat”.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Pri ovoj postavci %@ pada na nulu za otprilike %@. Gotovo svi su između %@ na sat.",
    "How to find yours": "Kako pronaći svoju",
    "With a breathalyser": "Uz alkotest",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Puhni dvaput, s razmakom od najmanje sat vremena, na silaznoj strani — dva sata ili "
        "više nakon zadnjeg pića, bez ičega u međuvremenu. Oduzmi drugo očitanje od prvog i "
        "podijeli s brojem sati između njih.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Na primjer, %@ i %@ dva sata poslije daje %@ na sat.",
    "Without one": "Bez alkotesta",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Aplikacija ti govori kad očekuje da ćeš pasti na nulu. Ako se pouzdano vratiš u "
        "normalu znatno prije toga, tvoja je brzina veća od postavke — pomakni je stupanj gore "
        "i prati nekoliko sesija. Ako traje dulje od predviđenog, pomakni je stupanj dolje.",
    "What moves it": "Što na nju utječe",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Redovito pijenje je povećava: jetreni enzim koji obavlja posao potiče se upotrebom. U "
        "prosjeku je nešto viša i kod žena, a niža na prazan želudac ili uz bolest jetre.",
    "Uncertainty": "Neizvjesnost",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Na nuli je svaka brojka jedan broj — najbolja procjena aplikacije. Iznad nule iste se "
        "brojke prikazuju kao rasponi, a pojas na grafikonu proširuje se u skladu s tim.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Jedan broj je lakše naučiti: s vremenom otkriješ kako se osjećaš na svojih 0,6. "
        "Raspon je doslovniji odgovor, jer je brzina doista neizvjesna. Oboje je opravdano — "
        "odluka je tvoja.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Raspon koji proizlazi iz tvoje učestalosti pijenja iznosi ± %@ na sat.",
    "Rate": "Brzina",
    "Range": "Raspon",
    "Advanced": "Napredno",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Neizvjesnost je stvar ukusa: određuje hoće li se brojke čitati kao jedan broj ili kao "
        "raspon. Brzina ispod nije — prepusti je pitanju o učestalosti, osim ako imaš mjerenje "
        "s kojim je možeš usporediti.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Više osoba",
    "History trends": "Trendovi povijesti",
    "Week": "Tjedan",
    "Month": "Mjesec",
    "Year": "Godina",
    "Sober days": "Dani bez alkohola",
    "Change": "Promjena",
    "before records": "prije početka bilježenja",
    "See further back": "Pogledaj dalje unatrag",
    "Weeks, months and years side by side — and every evening older than seven days.": "Tjedni, mjeseci i godine jedni uz druge – i svaka večer starija od sedam dana.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Sve što si zabilježio već je spremljeno. Otključavanje to samo prikazuje.",
    "Coming soon": "Uskoro",
    "Grams": "Grami",
    "Grams of alcohol": "Grami alkohola",
    "Standard units": "Standardne jedinice",
    "Period": "Razdoblje",
    "Switch person": "Promijeni osobu",
    "Add person": "Dodaj osobu",
    "New person": "Nova osoba",
    "You": "Ti",
    "Name": "Ime",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Sve četiri vrijednosti mijenjaju krivulju, pa se nijedna ne može nagađati za nekog "
        "drugog.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Vlastitu granicu i finije postavke možeš promijeniti poslije na kartici Profil, dok "
        "je ta osoba odabrana.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Brzi unos",
    "Choose a favourite drink": "Odaberi omiljeno piće",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Odaberi piće koje obično naručuješ i gumb na zaslonu Uživo zabilježit će ga jednim "
        "dodirom.",
    "This is your quick-add drink": "Ovo je tvoje piće za brzi unos",
    "Set as my quick-add drink": "Postavi kao piće za brzi unos",
    "This is now your usual": "Ovo je sada tvoje uobičajeno piće",
    "Remove favourite": "Ukloni omiljeno piće",
    "Always add this one": "Uvijek dodaj ovo piće",
    "Logs it straight away, without opening anything.":
        "Bilježi ga odmah, bez otvaranja ičega.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Jedan dodir na zaslonu Uživo bilježi ovo piće, s predviđenim vrhuncem na gumbu. "
        "Koliko ti je želudac pun preuzima se od prethodnog pića i može se ispraviti odmah "
        "nakon toga.",
    "Peak %@": "Vrhunac %@",
    "%@ added": "Dodano: %@",
    "Save": "Spremi",
    "Undo": "Poništi",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Sigurnosna kopija",
    "Export a backup": "Izvezi sigurnosnu kopiju",
    "Import a backup": "Uvezi sigurnosnu kopiju",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Sigurnosna kopija sadrži svaku osobu, sesiju i piće. Uvoz dodaje ono što nedostaje — "
        "nikad ne mijenja ni ne uklanja ono što je već ovdje.",
    "Import this backup?": "Uvesti ovu sigurnosnu kopiju?",
    "Import": "Uvezi",
    "Everything in this backup is already here.": "Sve iz ove sigurnosne kopije već je ovdje.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Dodaje — sesije: %@, pića: %@. Ništa što je već ovdje ne mijenja se niti uklanja.",
    "Import finished": "Uvoz završen",
    "Added %@ occasions and %@ drinks.": "Dodano — sesije: %@, pića: %@.",
    "OK": "U redu",

    # --- LanguageSection: the app's language ---
    "Language": "Jezik",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Otvara ovu aplikaciju u Postavkama, gdje „Željeni jezik” određuje jezik same "
        "aplikacije — sistemski ostaje kakav jest. iOS ponovno pokreće aplikaciju kad ga "
        "promijeniš.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Uvoz nije uspio",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Ova datoteka nije DrinkSmart sigurnosna kopija ili je oštećena.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Ova sigurnosna kopija napravljena je novijom verzijom aplikacije DrinkSmart. Ažuriraj "
        "aplikaciju i pokušaj ponovno.",
}
