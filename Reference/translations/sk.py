"""
Slovak.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promile",
    "Percent": "Percento",

    # --- DrinkCatalog: drink types ---
    "Beer": "Pivo",
    "Wine": "Víno",
    "Sparkling": "Šumivé víno",
    "Spirit": "Destilát",
    "Cocktail": "Koktail",
    "Custom": "Vlastné",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Prázdny žalúdok",
    "Moderately full": "Stredne plný",
    "Full stomach": "Plný žalúdok",
    "Empty": "Prázdny",
    "Moderate": "Stredný",
    "Full": "Plný",
    "Fast absorption, higher and earlier peak.": "Rýchle vstrebávanie, vyšší a skorší vrchol.",
    "Moderate absorption.": "Stredne rýchle vstrebávanie.",
    "Slow absorption, lower and later peak.": "Pomalé vstrebávanie, nižší a neskorší vrchol.",

    # --- DrinkingFrequency ---
    "Rarely": "Zriedka",
    "A few times a month": "Niekoľkokrát do mesiaca",
    "Several times a week": "Niekoľkokrát do týždňa",
    "Almost daily": "Takmer denne",
    "A few occasions a year": "Niekoľkokrát do roka",
    "Social drinking": "Spoločenské pitie",
    "Weekly routine": "Týždenný zvyk",
    "Daily or nearly daily": "Denne alebo takmer denne",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Čas",
    "Level": "Hladina",
    "Lower": "Dolný",
    "Upper": "Horný",
    "Lower estimate": "Dolný odhad",
    "Upper estimate": "Horný odhad",
    "Personal limit": "Osobný limit",
    "Drink": "Nápoj",

    # --- BACChartView ---
    "Expected peak around %@": "Očakávaný vrchol okolo %@",
    "Peaked around %@": "Vrchol bol okolo %@",
    "No active session": "Žiadne aktívne posedenie",
    "Still rising": "Stále stúpa",
    "YOUR LIMIT %@": "TVOJ LIMIT %@",
    "possible range": "možné rozpätie",
    "drag to read values": "potiahnutím zobrazíš hodnoty",
    "release to go back": "pustením sa vrátiš",
    "pour time": "čas pitia",
    "in one go": "naraz",

    # --- Live screen: the day with nothing on it ---
    "Live": "Naživo",
    "Nothing logged today": "Dnes nič zaznamenané",
    "Add a drink when you have one.": "Pridaj nápoj vždy, keď si nejaký dáš.",

    # --- Tabs and history ---
    "History": "História",
    "No past sessions yet": "Zatiaľ žiadne minulé posedenia",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Posedenie sa tu objaví, keď sa skončí — keď alkohol vyprchá a uplynie niekoľko hodín.",
    "%@ drinks": "Nápoje: %@",
    "peak": "vrchol",
    "Started": "Začiatok",
    "Lasted": "Trvanie",
    "Calculated with your profile at the time": "Vypočítané s tvojím vtedajším profilom",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "odhadovaná hladina",
    "estimated range": "odhadované rozpätie",
    "Elapsed": "Uplynulo",
    "Drinks": "Nápoje",
    "Units": "Jednotky",
    "Expected to clear": "Predpokladané vyprchanie",
    "Drinks this session": "Nápoje na tomto posedení",
    "This is an estimate, not a measurement.": "Toto je odhad, nie meranie.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Skutočné hodnoty sa medzi ľuďmi výrazne líšia. Nikdy podľa toho nerozhoduj o tom, či "
        "môžeš šoférovať.",
    "Add drink": "Pridať nápoj",

    # --- Editing an already logged drink ---
    "Edit drink": "Upraviť nápoj",
    "Save changes": "Uložiť zmeny",
    "With this": "S týmto nápojom",
    "Delete": "Odstrániť",
    "tap to edit · swipe to delete": "ťuknutím upravíš · potiahnutím odstrániš",

    # --- Drinking pace ---
    "How fast": "Ako rýchlo",
    "In one go": "Naraz",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Počíta sa ako jeden dúšok — najstrmší možný nárast.",
    "A quick drink. The level climbs fast.": "Rýchlo vypitý nápoj. Hladina stúpa rýchlo.",
    "A normal pace.": "Bežné tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Popíjané pomaly. Pri rovnakom množstve alkoholu oveľa miernejší nárast.",

    # --- AddDrinkSheet ---
    "Cancel": "Zrušiť",
    "Now": "Teraz",
    "Projected peak": "Predpokladaný vrchol",
    "Peak at": "Vrchol o",
    "Clears": "Vyprchá",
    "This would cross your limit": "Toto by prekročilo tvoj limit",
    "Around %@, for up to %@.": "Okolo %@, najviac na %@.",
    "This might cross your limit": "Toto by mohlo prekročiť tvoj limit",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Pri pomalšom metabolizme áno, pri rýchlejšom nie. To je neistota odhadu.",
    "Type": "Typ",
    "Amount": "Množstvo",
    "Strength": "Obsah alkoholu",
    "%@ units": "Jednotky: %@",
    "%@ g alcohol": "%@ g alkoholu",
    "Stomach": "Žalúdok",
    "When": "Kedy",
    "15 min ago": "Pred 15 min",
    "30 min ago": "Pred 30 min",
    "1 hr ago": "Pred 1 h",
    "Done": "Hotovo",
    "Set exact time": "Nastaviť presný čas",
    "Add": "Pridať",

    # --- ProfileSheet ---
    "Male": "Muž",
    "Female": "Žena",
    "Sex": "Pohlavie",
    "Weight": "Hmotnosť",
    "Height": "Výška",
    "Age": "Vek",
    "kg": "kg",
    "cm": "cm",
    "yrs": "r.",
    "Body": "Telo",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Celková telesná voda vychádza z Watsonových rovníc, ktoré určujú objem, v ktorom sa "
        "alkohol distribuuje.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Celková telesná voda vychádza z Watsonových rovníc, ktoré určujú objem, v ktorom sa "
        "alkohol distribuuje. Ženská rovnica nezahŕňa vek, takže jeho zmena výsledok "
        "neovplyvní.",
    "Drinking frequency": "Frekvencia pitia",
    "How often do you drink?": "Ako často piješ?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Takto odhadujeme tvoju rýchlosť odbúravania. Pravidelné pitie indukuje pečeňovú dráhu "
        "CYP2E1, takže kto pije často, odbúrava alkohol rýchlejšie. Je to najslabšie miesto "
        "modelu, a preto si v časti Rozšírené môžeš nastaviť, koľko z tejto neistoty ti "
        "aplikácia ukáže.",
    "Your limit": "Tvoj limit",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Tvoje vlastné referenčné číslo, nie zákonný limit. Aplikácia ti povie, keď by ťa "
        "plánovaný nápoj dostal nad neho a ako dlho by si nad ním zostal.",
    "Unit": "Jednotka",
    "Display": "Zobrazenie",
    "Calculated values": "Vypočítané hodnoty",
    "Total body water": "Celková telesná voda",
    "Distribution volume": "Distribučný objem",
    "Widmark factor": "Widmarkov faktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmarkov faktor býva zvyčajne okolo 0,68 u mužov a 0,55 u žien. Ak je ten tvoj od "
        "toho ďaleko, oplatí sa skontrolovať hodnoty vyššie.",
    "Elimination rate": "Rýchlosť odbúravania",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Ako rýchlo tvoja pečeň odbúrava alkohol po jeho vstrebaní — sklon klesajúcej časti "
        "krivky.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol sa odbúrava približne pevným množstvom za hodinu, nie percentuálnym podielom, "
        "pretože enzým, ktorý ho rozkladá, beží naplno už takmer pri každej hladine. Práve "
        "preto vôbec existujú pravidlá ako „jeden nápoj za hodinu“.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Pri tomto nastavení %@ vyprchá asi za %@. Takmer všetci sa pohybujú medzi %@ za "
        "hodinu.",
    "How to find yours": "Ako zistiť svoju rýchlosť",
    "With a breathalyser": "S alkoholtesterom",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Fúkni dvakrát, s odstupom aspoň jednej hodiny, na klesajúcej strane — dve alebo viac "
        "hodín po poslednom nápoji a medzitým nič nepi. Od prvej hodnoty odčítaj druhú a vydeľ "
        "počtom hodín medzi nimi.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Napríklad %@ a o dve hodiny neskôr %@ dáva %@ za hodinu.",
    "Without one": "Bez neho",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Aplikácia ti povie, kedy podľa nej alkohol vyprchá. Ak si spoľahlivo v normále "
        "výrazne skôr, tvoja rýchlosť je vyššia než nastavená — posuň ju o krok nahor a sleduj "
        "to počas niekoľkých posedení. Ak to trvá dlhšie, než predpovedá, posuň ju nadol.",
    "What moves it": "Čo ju ovplyvňuje",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Pravidelné pitie ju zvyšuje: pečeňový enzým, ktorý túto prácu robí, sa používaním "
        "indukuje. U žien býva v priemere mierne vyššia a na prázdny žalúdok alebo pri "
        "problémoch s pečeňou nižšia.",
    "Uncertainty": "Neistota",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Pri nule je každý údaj jediné číslo — najlepší odhad aplikácie. Nad nulou sa tie isté "
        "údaje zobrazujú ako rozpätia a pás v grafe sa tomu úmerne rozšíri.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Jediné číslo sa lepšie učí: časom zistíš, ako sa cítiš pri svojich 0,6. Rozpätie je "
        "doslovnejšia odpoveď, pretože rýchlosť je naozaj neistá. Oboje sa dá obhájiť — "
        "rozhodnutie je na tebe.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Rozptyl, ktorý vyplýva z tvojej frekvencie pitia, je ± %@ za hodinu.",
    "Rate": "Rýchlosť",
    "Range": "Rozpätie",
    "Advanced": "Rozšírené",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Neistota je vecou vkusu: rozhoduje o tom, či sa údaje čítajú ako jedno číslo alebo "
        "ako rozpätie. Rýchlosť nižšie vecou vkusu nie je — nechaj ju na otázku o frekvencii, "
        "pokiaľ nemáš meranie, s ktorým ju môžeš porovnať.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Viac osôb",
    "History trends": "Trendy v histórii",
    "Week": "Týždeň",
    "Month": "Mesiac",
    "Year": "Rok",
    "Sober days": "Dni bez alkoholu",
    "Change": "Zmena",
    "before records": "pred začiatkom záznamov",
    "See further back": "Pozrieť sa ďalej do minulosti",
    "Weeks, months and years side by side — and every evening older than seven days.": "Týždne, mesiace a roky vedľa seba – a každý večer starší ako sedem dní.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Všetko, čo ste zaznamenali, je už uložené. Odomknutie to len zobrazí.",
    "Coming soon": "Už čoskoro",
    "Grams": "Gramy",
    "Grams of alcohol": "Gramy alkoholu",
    "Standard units": "Štandardné jednotky",
    "Period": "Obdobie",
    "Switch person": "Prepnúť osobu",
    "Add person": "Pridať osobu",
    "New person": "Nová osoba",
    "You": "Ty",
    "Name": "Meno",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Všetky štyri údaje menia krivku, takže ani jeden z nich sa nedá odhadnúť za niekoho "
        "iného.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Vlastný limit a jemnejšie nastavenia sa dajú zmeniť neskôr na karte Profil, keď je "
        "táto osoba vybraná.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Rýchle pridanie",
    "Choose a favourite drink": "Vyber si obľúbený nápoj",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Vyber si nápoj, ktorý si zvyčajne dávaš, a tlačidlo na obrazovke Naživo ho zaznamená "
        "jedným ťuknutím.",
    "This is your quick-add drink": "Toto je tvoj nápoj na rýchle pridanie",
    "Set as my quick-add drink": "Nastaviť ako môj nápoj na rýchle pridanie",
    "This is now your usual": "Toto je odteraz tvoj obvyklý nápoj",
    "Remove favourite": "Odstrániť obľúbený nápoj",
    "Always add this one": "Vždy pridávať tento nápoj",
    "Logs it straight away, without opening anything.":
        "Zaznamená ho okamžite, bez otvárania čohokoľvek.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Jedno ťuknutie na obrazovke Naživo ho zaznamená, na tlačidle je predpokladaný vrchol. "
        "Plnosť žalúdka sa prevezme z predchádzajúceho nápoja a hneď potom sa dá opraviť.",
    "Peak %@": "Vrchol %@",
    "%@ added": "Pridané: %@",
    "Save": "Uložiť",
    "Undo": "Späť",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Záloha",
    "Export a backup": "Exportovať zálohu",
    "Import a backup": "Importovať zálohu",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Záloha obsahuje všetky osoby, posedenia a nápoje. Import doplní to, čo chýba — nikdy "
        "nezmení ani neodstráni nič, čo tu už je.",
    "Import this backup?": "Importovať túto zálohu?",
    "Import": "Importovať",
    "Everything in this backup is already here.": "Všetko z tejto zálohy tu už je.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Doplní: posedenia (%@), nápoje (%@). Nič, čo tu už je, sa nezmení ani neodstráni.",
    "Import finished": "Import dokončený",
    "Added %@ occasions and %@ drinks.": "Doplnené: posedenia (%@), nápoje (%@).",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Jazyk",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Otvorí túto aplikáciu v Nastaveniach, kde položka „Preferovaný jazyk“ nastaví jazyk "
        "samotnej aplikácie — jazyk systému zostane nezmenený. iOS po zmene aplikáciu "
        "reštartuje.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Import sa nepodaril",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Tento súbor nie je zálohou DrinkSmart alebo je poškodený.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Táto záloha pochádza z novšej verzie DrinkSmart. Aktualizuj aplikáciu a skús to "
        "znova.",
}
