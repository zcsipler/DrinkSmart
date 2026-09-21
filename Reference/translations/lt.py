"""
Lithuanian.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promilės",
    "Percent": "Procentai",

    # --- DrinkCatalog: drink types ---
    "Beer": "Alus",
    "Wine": "Vynas",
    "Sparkling": "Putojantis",
    "Spirit": "Stiprusis gėrimas",
    "Cocktail": "Kokteilis",
    "Custom": "Pasirinktinis",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Tuščias skrandis",
    "Moderately full": "Vidutiniškai pilnas",
    "Full stomach": "Pilnas skrandis",
    "Empty": "Tuščias",
    "Moderate": "Vidutinis",
    "Full": "Pilnas",
    "Fast absorption, higher and earlier peak.":
        "Greita absorbcija, aukštesnė ir ankstesnė viršūnė.",
    "Moderate absorption.": "Vidutinė absorbcija.",
    "Slow absorption, lower and later peak.": "Lėta absorbcija, žemesnė ir vėlesnė viršūnė.",

    # --- DrinkingFrequency ---
    "Rarely": "Retai",
    "A few times a month": "Kelis kartus per mėnesį",
    "Several times a week": "Kelis kartus per savaitę",
    "Almost daily": "Beveik kasdien",
    "A few occasions a year": "Kelis kartus per metus",
    "Social drinking": "Proginis gėrimas",
    "Weekly routine": "Kassavaitinis įprotis",
    "Daily or nearly daily": "Kasdien arba beveik kasdien",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Laikas",
    "Level": "Lygis",
    "Lower": "Apatinis",
    "Upper": "Viršutinis",
    "Lower estimate": "Apatinis įvertis",
    "Upper estimate": "Viršutinis įvertis",
    "Personal limit": "Asmeninė riba",
    "Drink": "Gėrimas",

    # --- BACChartView ---
    "Expected peak around %@": "Numatoma viršūnė apie %@",
    "Peaked around %@": "Viršūnė buvo apie %@",
    "No active session": "Nėra aktyvios sesijos",
    "Still rising": "Vis dar kyla",
    "YOUR LIMIT %@": "TAVO RIBA %@",
    "possible range": "galimas intervalas",
    "drag to read values": "vilk, kad matytum reikšmes",
    "release to go back": "atleisk, kad grįžtum",
    "pour time": "gėrimo trukmė",
    "in one go": "vienu mauku",

    # --- Live screen: the day with nothing on it ---
    "Live": "Tiesiogiai",
    "Nothing logged today": "Šiandien nieko neįrašyta",
    "Add a drink when you have one.": "Pridėk gėrimą, kai jį išgeri.",

    # --- Tabs and history ---
    "History": "Istorija",
    "No past sessions yet": "Praėjusių sesijų dar nėra",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Sesija čia atsiranda jai pasibaigus — kai alkoholis išnyksta ir praeina kelios "
        "valandos.",
    "%@ drinks": "Gėrimų: %@",
    "peak": "viršūnė",
    "Started": "Pradėta",
    "Lasted": "Truko",
    "Calculated with your profile at the time": "Apskaičiuota pagal tuometinį tavo profilį",

    # --- TodayView ---
    "Profile": "Profilis",
    "estimated level": "įvertintas lygis",
    "estimated range": "įvertintas intervalas",
    "Elapsed": "Praėjo",
    "Drinks": "Gėrimai",
    "Units": "Vienetai",
    "Expected to clear": "Numatomas išnykimas",
    "Drinks this session": "Šios sesijos gėrimai",
    "This is an estimate, not a measurement.": "Tai įvertis, o ne matavimas.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Tikrosios reikšmės tarp žmonių labai skiriasi. Niekada nesiremk tuo spręsdamas, ar "
        "gali vairuoti.",
    "Add drink": "Pridėti gėrimą",

    # --- Editing an already logged drink ---
    "Edit drink": "Redaguoti gėrimą",
    "Save changes": "Išsaugoti pakeitimus",
    "With this": "Su šiuo gėrimu",
    "Delete": "Ištrinti",
    "tap to edit · swipe to delete": "bakstelėk, kad redaguotum · perbrauk, kad ištrintum",

    # --- Drinking pace ---
    "How fast": "Kaip greitai",
    "In one go": "Vienu mauku",
    "15 min": "15 min.",
    "30 min": "30 min.",
    "1 hr": "1 val.",
    "Counts as a single swallow — the steepest possible rise.":
        "Skaičiuojama kaip vienas gurkšnis — sparčiausias įmanomas kilimas.",
    "A quick drink. The level climbs fast.": "Greitai išgertas gėrimas. Lygis kyla sparčiai.",
    "A normal pace.": "Įprastas tempas.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Geriama lėtai. Tas pats alkoholio kiekis kyla daug švelniau.",

    # --- AddDrinkSheet ---
    "Cancel": "Atšaukti",
    "Now": "Dabar",
    "Projected peak": "Numatoma viršūnė",
    "Peak at": "Viršūnė",
    "Clears": "Išnyks",
    "This would cross your limit": "Tai peržengtų tavo ribą",
    "Around %@, for up to %@.": "Apie %@, ne ilgiau kaip %@.",
    "This might cross your limit": "Tai gali peržengti tavo ribą",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Esant lėtesnei medžiagų apykaitai — taip, esant greitesnei — ne. Toks yra šio įverčio "
        "neapibrėžtumas.",
    "Type": "Tipas",
    "Amount": "Kiekis",
    "Strength": "Stiprumas",
    "%@ units": "Vienetų: %@",
    "%@ g alcohol": "%@ g alkoholio",
    "Stomach": "Skrandis",
    "When": "Kada",
    "15 min ago": "Prieš 15 min.",
    "30 min ago": "Prieš 30 min.",
    "1 hr ago": "Prieš 1 val.",
    "Done": "Atlikta",
    "Set exact time": "Nurodyti tikslų laiką",
    "Add": "Pridėti",

    # --- ProfileSheet ---
    "Male": "Vyras",
    "Female": "Moteris",
    "Sex": "Lytis",
    "Weight": "Svoris",
    "Height": "Ūgis",
    "Age": "Amžius",
    "kg": "kg",
    "cm": "cm",
    "yrs": "m.",
    "Body": "Kūnas",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Bendras kūno vandens kiekis apskaičiuojamas pagal Watson lygtis, kurios nustato tūrį, "
        "kuriame pasiskirsto alkoholis.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Bendras kūno vandens kiekis apskaičiuojamas pagal Watson lygtis, kurios nustato tūrį, "
        "kuriame pasiskirsto alkoholis. Moterų lygtyje amžius neįtraukiamas, todėl jo keitimas "
        "rezultato nepakeis.",
    "Drinking frequency": "Gėrimo dažnis",
    "How often do you drink?": "Kaip dažnai geri?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Taip vertiname tavo šalinimo greitį. Reguliarus gėrimas suaktyvina kepenų CYP2E1 "
        "kelią, todėl dažnai geriantieji alkoholį pašalina greičiau. Tai silpniausia modelio "
        "vieta — todėl skiltyje „Išplėstiniai nustatymai“ gali pasirinkti, kiek to "
        "neapibrėžtumo programėlė tau rodo.",
    "Your limit": "Tavo riba",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Tai tavo paties orientacinis skaičius, o ne teisinė riba. Programėlė pasako, kada "
        "planuojamas gėrimas ją peržengtų ir kiek laiko liktum virš jos.",
    "Unit": "Matavimo vienetas",
    "Display": "Rodymas",
    "Calculated values": "Apskaičiuotos reikšmės",
    "Total body water": "Bendras kūno vandens kiekis",
    "Distribution volume": "Pasiskirstymo tūris",
    "Widmark factor": "Widmark faktorius",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmark faktorius paprastai yra apie 0,68 vyrams ir 0,55 moterims. Jei tavasis nuo to "
        "labai skiriasi, verta patikrinti aukščiau esančias reikšmes.",
    "Elimination rate": "Šalinimo greitis",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Kaip greitai tavo kepenys pašalina alkoholį po to, kai jis įsisavinamas, — "
        "krintančios kreivės dalies nuolydis.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkoholis pasišalina maždaug pastoviu kiekiu per valandą, o ne procentais, nes jį "
        "skaidantis fermentas beveik esant bet kokiam lygiui jau dirba visu pajėgumu. Būtent "
        "todėl apskritai egzistuoja tokios praktinės taisyklės kaip „vienas gėrimas per "
        "valandą“.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Esant šiam nustatymui, %@ išnyksta maždaug per %@. Beveik visi patenka į intervalą %@ "
        "per valandą.",
    "How to find yours": "Kaip sužinoti savąjį",
    "With a breathalyser": "Su alkotesteriu",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Papūsk du kartus, bent valandos skirtumu, krintančioje kreivės dalyje — praėjus dviem "
        "ar daugiau valandų po paskutinio gėrimo ir nieko negeriant tarp matavimų. Iš pirmojo "
        "rodmens atimk antrąjį ir padalyk iš valandų skaičiaus tarp jų.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Pavyzdžiui, %@ ir %@ po dviejų valandų duoda %@ per valandą.",
    "Without one": "Be jo",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Programėlė pasako, kada, jos skaičiavimu, alkoholis turėtų išnykti. Jei nuolat "
        "pasijunti visiškai blaivus gerokai anksčiau, tavo greitis didesnis nei nustatyta — "
        "pakelk jį vienu žingsniu ir stebėk kelias sesijas. Jei tai trunka ilgiau, nei "
        "prognozuojama, sumažink.",
    "What moves it": "Kas jį keičia",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Reguliarus gėrimas jį didina: darbą atliekantis kepenų fermentas suaktyvėja nuo "
        "naudojimo. Vidutiniškai jis taip pat šiek tiek didesnis moterims, o tuščiu skrandžiu "
        "ar esant kepenų sutrikimų — mažesnis.",
    "Uncertainty": "Neapibrėžtumas",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Ties nuliu kiekviena reikšmė rodoma kaip vienas skaičius — geriausias programėlės "
        "įvertis. Virš nulio tos pačios reikšmės rodomos kaip intervalai, o juosta diagramoje "
        "atitinkamai praplatėja.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Iš vieno skaičiaus lengviau mokytis: laikui bėgant sužinai, kaip jautiesi, kai tavo "
        "lygis yra 0,6. Intervalas yra tikslesnis atsakymas, nes greitis iš tiesų nėra "
        "tiksliai žinomas. Abu variantai pagrįsti — spręsk pats.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Pagal tavo gėrimo dažnį siūloma sklaida yra ± %@ per valandą.",
    "Rate": "Greitis",
    "Range": "Intervalas",
    "Advanced": "Išplėstiniai nustatymai",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Neapibrėžtumas yra skonio reikalas: jis lemia, ar reikšmės rodomos kaip vienas "
        "skaičius, ar kaip intervalas. Žemiau esantis greitis — ne; palik jį nustatyti pagal "
        "dažnio klausimą, nebent turi matavimą, su kuriuo gali jį palyginti.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Keli žmonės",
    "History trends": "Istorijos tendencijos",
    "Switch person": "Keisti žmogų",
    "Add person": "Pridėti žmogų",
    "New person": "Naujas žmogus",
    "You": "Tu",
    "Name": "Vardas",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Visi keturi keičia kreivę, todėl nė vieno iš jų negalima atspėti už kitą žmogų.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Jo asmeninę ribą ir smulkesnius nustatymus vėliau gali pakeisti skiltyje „Profilis“, "
        "kai jis yra pasirinktas žmogus.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Greitasis pridėjimas",
    "Choose a favourite drink": "Pasirink mėgstamą gėrimą",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Pasirink gėrimą, kurį dažniausiai užsisakai, ir mygtukas ekrane „Tiesiogiai“ įrašys "
        "jį vienu bakstelėjimu.",
    "This is your quick-add drink": "Tai tavo greitojo pridėjimo gėrimas",
    "Set as my quick-add drink": "Nustatyti kaip greitojo pridėjimo gėrimą",
    "This is now your usual": "Nuo šiol tai tavo įprastas gėrimas",
    "Remove favourite": "Pašalinti mėgstamą",
    "Always add this one": "Visada pridėti šį",
    "Logs it straight away, without opening anything.":
        "Iš karto jį įrašo, nieko papildomai neatidarant.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Vienu bakstelėjimu ekrane „Tiesiogiai“ šis gėrimas įrašomas, o ant mygtuko matai "
        "numatomą viršūnę. Skrandžio pilnumas paimamas iš ankstesnio gėrimo ir gali būti "
        "pataisytas iš karto po to.",
    "Peak %@": "Viršūnė %@",
    "%@ added": "Pridėta: %@",
    "Save": "Išsaugoti",
    "Undo": "Atšaukti veiksmą",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Atsarginė kopija",
    "Export a backup": "Eksportuoti atsarginę kopiją",
    "Import a backup": "Importuoti atsarginę kopiją",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Atsarginėje kopijoje yra visi žmonės, sesijos ir gėrimai. Importavimas prideda tai, "
        "ko trūksta, — jis niekada nekeičia ir nepašalina to, kas jau yra.",
    "Import this backup?": "Importuoti šią atsarginę kopiją?",
    "Import": "Importuoti",
    "Everything in this backup is already here.": "Viskas iš šios atsarginės kopijos jau yra.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Bus pridėta sesijų: %@, gėrimų: %@. Niekas, kas jau yra, nebus pakeista ar pašalinta.",
    "Import finished": "Importavimas baigtas",
    "Added %@ occasions and %@ drinks.": "Pridėta sesijų: %@, gėrimų: %@.",
    "OK": "Gerai",

    # --- LanguageSection: the app's language ---
    "Language": "Kalba",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Atveria šią programėlę Nustatymuose, kur „Pageidaujama kalba“ nustato pačios "
        "programėlės kalbą — sistemos kalba lieka tokia pati. Pakeitus ją, iOS paleidžia "
        "programėlę iš naujo.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Nepavyko importuoti",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Šis failas nėra „DrinkSmart“ atsarginė kopija arba yra sugadintas.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Ši atsarginė kopija sukurta naujesne „DrinkSmart“ versija. Atnaujink programėlę ir "
        "bandyk dar kartą.",
}
