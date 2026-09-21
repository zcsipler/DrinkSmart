"""
Czech.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promile",
    "Percent": "Procenta",

    # --- DrinkCatalog: drink types ---
    "Beer": "Pivo",
    "Wine": "Víno",
    "Sparkling": "Šumivé víno",
    "Spirit": "Destilát",
    "Cocktail": "Koktejl",
    "Custom": "Vlastní",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Prázdný žaludek",
    "Moderately full": "Středně plný",
    "Full stomach": "Plný žaludek",
    "Empty": "Prázdný",
    "Moderate": "Střední",
    "Full": "Plný",
    "Fast absorption, higher and earlier peak.": "Rychlé vstřebávání, vyšší a dřívější vrchol.",
    "Moderate absorption.": "Střední vstřebávání.",
    "Slow absorption, lower and later peak.": "Pomalé vstřebávání, nižší a pozdější vrchol.",

    # --- DrinkingFrequency ---
    "Rarely": "Zřídka",
    "A few times a month": "Několikrát měsíčně",
    "Several times a week": "Několikrát týdně",
    "Almost daily": "Téměř denně",
    "A few occasions a year": "Několikrát ročně",
    "Social drinking": "Společenské pití",
    "Weekly routine": "Týdenní rutina",
    "Daily or nearly daily": "Denně nebo téměř denně",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Čas",
    "Level": "Hladina",
    "Lower": "Dolní",
    "Upper": "Horní",
    "Lower estimate": "Dolní odhad",
    "Upper estimate": "Horní odhad",
    "Personal limit": "Osobní limit",
    "Drink": "Nápoj",

    # --- BACChartView ---
    "Expected peak around %@": "Očekávaný vrchol kolem %@",
    "Peaked around %@": "Vrchol byl kolem %@",
    "No active session": "Žádné aktivní posezení",
    "Still rising": "Stále stoupá",
    "YOUR LIMIT %@": "TVŮJ LIMIT %@",
    "possible range": "možné rozpětí",
    "drag to read values": "tažením zobrazíš hodnoty",
    "release to go back": "uvolněním se vrátíš",
    "pour time": "doba pití",
    "in one go": "naráz",

    # --- Live screen: the day with nothing on it ---
    "Live": "Aktuálně",
    "Nothing logged today": "Dnes nic zaznamenáno",
    "Add a drink when you have one.": "Přidej nápoj vždy, když si ho dáš.",

    # --- Tabs and history ---
    "History": "Historie",
    "No past sessions yet": "Zatím žádná minulá posezení",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Posezení se sem přidá, jakmile skončí — až hladina klesne na nulu a uplyne několik "
        "hodin.",
    "%@ drinks": "Nápoje: %@",
    "peak": "vrchol",
    "Started": "Začátek",
    "Lasted": "Trvalo",
    "Calculated with your profile at the time": "Spočítáno podle tvého tehdejšího profilu",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "odhadovaná hladina",
    "estimated range": "odhadované rozpětí",
    "Elapsed": "Uplynulo",
    "Drinks": "Nápoje",
    "Units": "Jednotky",
    "Expected to clear": "Očekávané vystřízlivění",
    "Drinks this session": "Nápoje v tomto posezení",
    "This is an estimate, not a measurement.": "Tohle je odhad, ne měření.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Skutečné hodnoty se mezi lidmi výrazně liší. Nikdy podle toho nerozhoduj, jestli "
        "můžeš řídit.",
    "Add drink": "Přidat nápoj",

    # --- Editing an already logged drink ---
    "Edit drink": "Upravit nápoj",
    "Save changes": "Uložit změny",
    "With this": "S ním",
    "Delete": "Smazat",
    "tap to edit · swipe to delete": "ťuknutím upravíš · přejetím smažeš",

    # --- Drinking pace ---
    "How fast": "Jak rychle",
    "In one go": "Naráz",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Počítá se jako jeden doušek — nejstrmější možný nárůst.",
    "A quick drink. The level climbs fast.": "Rychlé pití. Hladina stoupá rychle.",
    "A normal pace.": "Normální tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Popíjeno pomalu. Při stejném množství alkoholu mnohem mírnější nárůst.",

    # --- AddDrinkSheet ---
    "Cancel": "Zrušit",
    "Now": "Teď",
    "Projected peak": "Předpokládaný vrchol",
    "Peak at": "Vrchol v",
    "Clears": "Vystřízlivění",
    "This would cross your limit": "Tohle by překročilo tvůj limit",
    "Around %@, for up to %@.": "Kolem %@, až na %@.",
    "This might cross your limit": "Tohle může překročit tvůj limit",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "S pomalejším metabolismem ano, s rychlejším ne. To je nejistota odhadu.",
    "Type": "Typ",
    "Amount": "Množství",
    "Strength": "Síla",
    "%@ units": "Jednotky: %@",
    "%@ g alcohol": "%@ g alkoholu",
    "Stomach": "Žaludek",
    "When": "Kdy",
    "15 min ago": "Před 15 min",
    "30 min ago": "Před 30 min",
    "1 hr ago": "Před 1 h",
    "Done": "Hotovo",
    "Set exact time": "Nastavit přesný čas",
    "Add": "Přidat",

    # --- ProfileSheet ---
    "Male": "Muž",
    "Female": "Žena",
    "Sex": "Pohlaví",
    "Weight": "Hmotnost",
    "Height": "Výška",
    "Age": "Věk",
    "kg": "kg",
    "cm": "cm",
    "yrs": "let",
    "Body": "Tělo",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Celková tělesná voda vychází z Watsonových rovnic, které určují objem, do kterého se "
        "alkohol distribuuje.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Celková tělesná voda vychází z Watsonových rovnic, které určují objem, do kterého se "
        "alkohol distribuuje. Ženská rovnice věk nezahrnuje, takže jeho změna výsledek "
        "neovlivní.",
    "Drinking frequency": "Frekvence pití",
    "How often do you drink?": "Jak často piješ?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Takto odhadujeme tvoji rychlost odbourávání. Pravidelné pití indukuje jaterní dráhu "
        "CYP2E1, takže kdo pije často, odbourává alkohol rychleji. Je to nejslabší místo "
        "modelu — proto si můžeš v sekci Pokročilé určit, kolik z této nejistoty ti aplikace "
        "ukáže.",
    "Your limit": "Tvůj limit",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Tvoje vlastní referenční číslo, ne zákonný limit. Aplikace ti řekne, kdy by tě "
        "plánovaný nápoj dostal nad něj a jak dlouho by hladina nad ním zůstala.",
    "Unit": "Jednotka",
    "Display": "Zobrazení",
    "Calculated values": "Vypočtené hodnoty",
    "Total body water": "Celková tělesná voda",
    "Distribution volume": "Distribuční objem",
    "Widmark factor": "Widmarkův faktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmarkův faktor bývá u mužů kolem 0,68 a u žen kolem 0,55. Pokud je ten tvůj hodně "
        "jinde, vyplatí se zkontrolovat hodnoty výše.",
    "Elimination rate": "Rychlost odbourávání",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Jak rychle tvá játra odbourávají alkohol, jakmile se vstřebá — sklon klesající části "
        "křivky.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol se odbourává zhruba stálým množstvím za hodinu, ne v procentech, protože "
        "enzym, který ho rozkládá, běží na plný výkon prakticky při jakékoli hladině. Právě "
        "proto vůbec existují poučky jako „jeden nápoj za hodinu“.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Při tomto nastavení se %@ odbourá přibližně za %@. Téměř všichni se pohybují mezi %@ "
        "za hodinu.",
    "How to find yours": "Jak zjistit tu svoji",
    "With a breathalyser": "S alkotesterem",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Foukni si dvakrát, s odstupem aspoň hodiny, na klesající straně — dvě hodiny a víc po "
        "posledním nápoji a mezitím nic nepij. Druhý naměřený údaj odečti od prvního a vyděl "
        "počtem hodin mezi nimi.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Například %@ a o dvě hodiny později %@ vychází na %@ za hodinu.",
    "Without one": "Bez něj",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Aplikace ti řekne, kdy očekává, že vystřízlivíš. Pokud jsi spolehlivě v normálu "
        "výrazně dřív, tvoje rychlost je vyšší než nastavená — posuň ji o stupeň nahoru a "
        "sleduj to několik posezení. Pokud to trvá déle, než aplikace předpovídá, posuň ji "
        "dolů.",
    "What moves it": "Co ji ovlivňuje",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Pravidelné pití ji zvyšuje: jaterní enzym, který práci odvádí, se používáním "
        "indukuje. U žen bývá v průměru mírně vyšší, na lačno nebo při potížích s játry naopak "
        "nižší.",
    "Uncertainty": "Nejistota",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Na nule je každý údaj jedno číslo — nejlepší odhad aplikace. Nad nulou se tytéž údaje "
        "zobrazují jako rozpětí a pás v grafu se tomu přizpůsobí.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Podle jednoho čísla se to učí snáz: časem zjistíš, jak se u tebe projevuje 0,6. "
        "Rozpětí je doslovnější odpověď, protože rychlost je opravdu nejistá. Obojí se dá "
        "obhájit — rozhodnutí je na tobě.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Rozptyl odpovídající tvé frekvenci pití je ± %@ za hodinu.",
    "Rate": "Rychlost",
    "Range": "Rozpětí",
    "Advanced": "Pokročilé",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Nejistota je věc vkusu: rozhoduje, jestli se údaje čtou jako jedno číslo, nebo jako "
        "rozpětí. Rychlost níže věc vkusu není — nech ji na otázce o frekvenci, pokud nemáš "
        "měření, se kterým by se dala srovnat.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Více osob",
    "Switch person": "Přepnout osobu",
    "Add person": "Přidat osobu",
    "New person": "Nová osoba",
    "You": "Ty",
    "Name": "Jméno",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Všechny čtyři mění křivku, takže žádnou z nich nejde za někoho jiného odhadnout.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Vlastní limit a jemnější nastavení se dají změnit později na kartě Profil, když je "
        "tato osoba vybraná.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Rychlé přidání",
    "Choose a favourite drink": "Vyber oblíbený nápoj",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Vyber nápoj, který si dáváš nejčastěji, a tlačítko na obrazovce Aktuálně ho zaznamená "
        "jedním ťuknutím.",
    "This is your quick-add drink": "Tohle je tvůj nápoj pro rychlé přidání",
    "Set as my quick-add drink": "Nastavit jako nápoj pro rychlé přidání",
    "This is now your usual": "Tohle je teď tvůj obvyklý nápoj",
    "Remove favourite": "Odebrat oblíbený nápoj",
    "Always add this one": "Vždy přidávat tento nápoj",
    "Logs it straight away, without opening anything.":
        "Zaznamená ho hned, bez otevírání čehokoli.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Jedno ťuknutí na obrazovce Aktuálně tento nápoj zaznamená, na tlačítku je "
        "předpokládaný vrchol. Naplněnost žaludku se přebírá z předchozího nápoje a dá se hned "
        "potom opravit.",
    "Peak %@": "Vrchol %@",
    "%@ added": "Přidáno: %@",
    "Save": "Uložit",
    "Undo": "Zpět",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Záloha",
    "Export a backup": "Exportovat zálohu",
    "Import a backup": "Importovat zálohu",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Záloha obsahuje všechny osoby, posezení a nápoje. Import doplní, co chybí — nikdy "
        "nezmění ani neodstraní nic, co už tu je.",
    "Import this backup?": "Importovat tuto zálohu?",
    "Import": "Importovat",
    "Everything in this backup is already here.": "Všechno z této zálohy už tu je.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Přidá posezení (%@) a nápoje (%@). Nic, co už tu je, se nezmění ani neodstraní.",
    "Import finished": "Import dokončen",
    "Added %@ occasions and %@ drinks.": "Přidána posezení (%@) a nápoje (%@).",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Jazyk",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Otevře tuto aplikaci v Nastavení, kde volba „Preferovaný jazyk“ určuje jazyk samotné "
        "aplikace — jazyk systému zůstane beze změny. iOS aplikaci po změně restartuje.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Import se nezdařil",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Tento soubor není zálohou DrinkSmart, nebo je poškozený.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Tato záloha pochází z novější verze DrinkSmart. Aktualizuj aplikaci a zkus to znovu.",
}
