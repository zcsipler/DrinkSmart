"""
Maltese.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Per mille",
    "Percent": "Perċentwali",

    # --- DrinkCatalog: drink types ---
    "Beer": "Birra",
    "Wine": "Inbid",
    "Sparkling": "Frizzanti",
    "Spirit": "Spirtu",
    "Cocktail": "Kokteil",
    "Custom": "Personalizzat",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Stonku vojt",
    "Moderately full": "Moderatament mimli",
    "Full stomach": "Stonku mimli",
    "Empty": "Vojt",
    "Moderate": "Moderat",
    "Full": "Mimli",
    "Fast absorption, higher and earlier peak.":
        "Assorbiment mgħaġġel, quċċata ogħla u aktar kmieni.",
    "Moderate absorption.": "Assorbiment moderat.",
    "Slow absorption, lower and later peak.":
        "Assorbiment bil-mod, quċċata aktar baxxa u aktar tard.",

    # --- DrinkingFrequency ---
    "Rarely": "Rarament",
    "A few times a month": "Ftit drabi fix-xahar",
    "Several times a week": "Diversi drabi fil-ġimgħa",
    "Almost daily": "Kważi kuljum",
    "A few occasions a year": "Ftit okkażjonijiet fis-sena",
    "Social drinking": "Xorb soċjali",
    "Weekly routine": "Rutina ta' kull ġimgħa",
    "Daily or nearly daily": "Kuljum jew kważi kuljum",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Ħin",
    "Level": "Livell",
    "Lower": "Inferjuri",
    "Upper": "Superjuri",
    "Lower estimate": "Stima inferjuri",
    "Upper estimate": "Stima superjuri",
    "Personal limit": "Limitu personali",
    "Drink": "Xarba",

    # --- BACChartView ---
    "Expected peak around %@": "Quċċata mistennija madwar %@",
    "Peaked around %@": "Laħqet il-quċċata madwar %@",
    "No active session": "L-ebda sessjoni attiva",
    "Still rising": "Għadu tiela'",
    "YOUR LIMIT %@": "IL-LIMITU TIEGĦEK %@",
    "possible range": "firxa possibbli",
    "drag to read values": "iġbed biex taqra l-valuri",
    "release to go back": "itlaq biex terġa' lura",
    "pour time": "ħin tax-xorb",
    "in one go": "f'daqqa",

    # --- Live screen: the day with nothing on it ---
    "Live": "Dirett",
    "Nothing logged today": "Xejn irreġistrat illum",
    "Add a drink when you have one.": "Żid xarba meta tixrob waħda.",

    # --- Tabs and history ---
    "History": "Storja",
    "No past sessions yet": "Għad m'hemm l-ebda sessjoni li għaddiet",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Sessjoni tidher hawn ladarba tkun intemmet — meta l-livell tiegħek ikun għadda u "
        "jkunu għaddew ftit sigħat.",
    "%@ drinks": "Xarbiet: %@",
    "peak": "quċċata",
    "Started": "Bdiet",
    "Lasted": "Damet",
    "Calculated with your profile at the time":
        "Ikkalkulat bil-profil tiegħek ta' dak iż-żmien",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "livell stmat",
    "estimated range": "firxa stmata",
    "Elapsed": "Ħin li għadda",
    "Drinks": "Xarbiet",
    "Units": "Unitajiet",
    "Expected to clear": "Mistenni jgħaddi",
    "Drinks this session": "Xarbiet f'din is-sessjoni",
    "This is an estimate, not a measurement.": "Din hi stima, mhux kejl.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Il-valuri reali jvarjaw ħafna minn persuna għal oħra. Qatt tuża dan biex tiddeċiedi "
        "jekk tistax issuq.",
    "Add drink": "Żid xarba",

    # --- Editing an already logged drink ---
    "Edit drink": "Immodifika x-xarba",
    "Save changes": "Issejvja l-bidliet",
    "With this": "B'din",
    "Delete": "Ħassar",
    "tap to edit · swipe to delete": "agħfas biex timmodifika · iżżerżaq biex tħassar",

    # --- Drinking pace ---
    "How fast": "Kemm malajr",
    "In one go": "F'daqqa",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 siegħa",
    "Counts as a single swallow — the steepest possible rise.":
        "Jgħodd bħala belgħa waħda — l-aktar tlugħ qawwi possibbli.",
    "A quick drink. The level climbs fast.": "Xarba mgħaġġla. Il-livell jitla' malajr.",
    "A normal pace.": "Pass normali.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Mixrub bil-mod. Tlugħ ħafna aktar ħafif għall-istess alkoħol.",

    # --- AddDrinkSheet ---
    "Cancel": "Ikkanċella",
    "Now": "Issa",
    "Projected peak": "Quċċata prevista",
    "Peak at": "Quċċata fi",
    "Clears": "Jgħaddi",
    "This would cross your limit": "Din taqbeż il-limitu tiegħek",
    "Around %@, for up to %@.": "Madwar %@, sa %@.",
    "This might cross your limit": "Din tista' taqbeż il-limitu tiegħek",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "B'metaboliżmu aktar bil-mod iva, b'wieħed aktar mgħaġġel le. Dik hi l-inċertezza "
        "tal-istima.",
    "Type": "Tip",
    "Amount": "Ammont",
    "Strength": "Qawwa",
    "%@ units": "Unitajiet: %@",
    "%@ g alcohol": "%@ g alkoħol",
    "Stomach": "Stonku",
    "When": "Meta",
    "15 min ago": "15 min ilu",
    "30 min ago": "30 min ilu",
    "1 hr ago": "1 siegħa ilu",
    "Done": "Lest",
    "Set exact time": "Issettja l-ħin eżatt",
    "Add": "Żid",

    # --- ProfileSheet ---
    "Male": "Raġel",
    "Female": "Mara",
    "Sex": "Sess",
    "Weight": "Piż",
    "Height": "Tul",
    "Age": "Età",
    "kg": "kg",
    "cm": "cm",
    "yrs": "snin",
    "Body": "Ġisem",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "L-ilma totali tal-ġisem ġej mill-ekwazzjonijiet ta' Watson, li jiddeterminaw il-volum "
        "li fih jinfirex l-alkoħol.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "L-ilma totali tal-ġisem ġej mill-ekwazzjonijiet ta' Watson, li jiddeterminaw il-volum "
        "li fih jinfirex l-alkoħol. L-ekwazzjoni għan-nisa ma tinkludix l-età, għalhekk li "
        "tibdilha mhux se taffettwa r-riżultat.",
    "Drinking frequency": "Frekwenza tax-xorb",
    "How often do you drink?": "Kemm-il darba tixrob?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Hekk nistmaw ir-rata ta' eliminazzjoni tiegħek. Ix-xorb regolari jistimula l-mogħdija "
        "CYP2E1 tal-fwied, għalhekk min jixrob ta' spiss ineħħi l-alkoħol aktar malajr. Dan hu "
        "l-aktar punt dgħajjef tal-mudell, u għalhekk taħt Avvanzat tista' tissettja kemm minn "
        "dik l-inċertezza turik l-app.",
    "Your limit": "Il-limitu tiegħek",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "In-numru ta' referenza tiegħek stess, mhux limitu legali. L-app tgħidlek meta xarba "
        "ppjanata tieħdok lil hinn minnu, u għal kemm żmien tibqa' 'l fuq minnu.",
    "Unit": "Unità",
    "Display": "Wiri",
    "Calculated values": "Valuri kkalkulati",
    "Total body water": "Ilma totali tal-ġisem",
    "Distribution volume": "Volum ta' distribuzzjoni",
    "Widmark factor": "Fattur Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Il-fattur Widmark normalment ikun madwar 0.68 għall-irġiel u 0.55 għan-nisa. Jekk "
        "tiegħek hu 'l bogħod minn hekk, ta' min tiċċekkja l-valuri ta' fuq.",
    "Elimination rate": "Rata ta' eliminazzjoni",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Kemm malajr il-fwied tiegħek ineħħi l-alkoħol ladarba jkun ġie assorbit — ix-xaqliba "
        "tan-naħa niżla tal-kurva.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "L-alkoħol jitlaq b'ammont bejn wieħed u ieħor fiss kull siegħa, u mhux bħala "
        "perċentwali, għax l-enzima li tkissru diġà taħdem bl-aqwa kapaċità tagħha kważi "
        "f'kull livell. Huwa għalhekk li jeżistu regoli prattiċi bħal “xarba waħda "
        "fis-siegħa”.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "B'dan l-issettjar, %@ jieħu madwar %@ biex jgħaddi. Kważi kulħadd jaqa' bejn %@ "
        "fis-siegħa.",
    "How to find yours": "Kif issib tiegħek",
    "With a breathalyser": "B'test tan-nifs",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Onfoħ darbtejn, tal-anqas siegħa bejn waħda u oħra, fuq in-naħa niżla — sagħtejn jew "
        "aktar wara l-aħħar xarba, mingħajr xejn bejniethom. Naqqas it-tieni qari mill-ewwel "
        "wieħed u aqsam bis-sigħat ta' bejniethom.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Ngħidu aħna, %@ u %@ sagħtejn wara jagħtu %@ fis-siegħa.",
    "Without one": "Mingħajr wieħed",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "L-app tgħidlek meta tistenna li l-livell tiegħek jgħaddi. Jekk b'mod konsistenti "
        "terġa' lura għan-normal sew qabel dak il-ħin, ir-rata tiegħek hi ogħla mill-issettjar "
        "— għollieha pass wieħed u osserva għal ftit sessjonijiet. Jekk tieħu aktar milli "
        "mbassar, baxxiha.",
    "What moves it": "X'jibdilha",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Ix-xorb regolari jgħollieha: l-enzima tal-fwied li tagħmel ix-xogħol tiżdied bl-użu. "
        "Bħala medja tkun ukoll kemmxejn ogħla fin-nisa, u aktar baxxa fuq stonku vojt jew bi "
        "problemi fil-fwied.",
    "Uncertainty": "Inċertezza",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Fuq żero kull ċifra hi numru wieħed — l-aħjar stima tal-app. 'Il fuq minn żero "
        "l-istess ċifri jintwerew bħala firxiet, u l-faxxa fuq il-graff titwessa' biex taqbel.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Numru wieħed hu eħfef biex titgħallem miegħu: maż-żmien issir taf kif tħossok bi 0.6 "
        "tiegħek. Firxa hi t-tweġiba aktar letterali, għax ir-rata tassew mhijiex ċerta. "
        "It-tnejn jistgħu jiġu difiżi — id-deċiżjoni hi tiegħek.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Il-firxa suġġerita mill-frekwenza tax-xorb tiegħek hi ± %@ fis-siegħa.",
    "Rate": "Rata",
    "Range": "Firxa",
    "Advanced": "Avvanzat",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "L-inċertezza hi kwistjoni ta' gost: tiddeċiedi jekk iċ-ċifri jinqrawx bħala numru "
        "wieħed jew bħala firxa. Ir-rata t'hawn taħt mhijiex — ħalliha f'idejn il-mistoqsija "
        "dwar il-frekwenza sakemm ma jkollokx kejl biex tqabbilha miegħu.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Diversi persuni",
    "History trends": "Xejriet tal-istorja",
    "Switch person": "Ibdel il-persuna",
    "Add person": "Żid persuna",
    "New person": "Persuna ġdida",
    "You": "Int",
    "Name": "Isem",
    "All four change the curve, so none of them can be guessed for someone else.":
        "L-erbgħa kollha jbiddlu l-kurva, għalhekk ebda wieħed minnhom ma jista' jitbassar "
        "għal ħaddieħor.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Il-limitu tagħhom u l-issettjar aktar dettaljat jistgħu jinbidlu aktar tard fit-tab "
        "Profil, waqt li huma l-persuna magħżula.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Żieda mgħaġġla",
    "Choose a favourite drink": "Agħżel xarba favorita",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Agħżel ix-xarba li normalment tordna, u buttuna fuq l-iskrin Dirett tirreġistraha "
        "b'daqqa waħda.",
    "This is your quick-add drink": "Din hi x-xarba tiegħek għaż-żieda mgħaġġla",
    "Set as my quick-add drink": "Agħmilha x-xarba tiegħi għaż-żieda mgħaġġla",
    "This is now your usual": "Din issa hi s-soltu tiegħek",
    "Remove favourite": "Neħħi l-favorita",
    "Always add this one": "Dejjem żid din",
    "Logs it straight away, without opening anything.":
        "Jirreġistrah mill-ewwel, mingħajr ma jiftaħ xejn.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Daqqa waħda fuq l-iskrin Dirett tirreġistra din, bil-quċċata prevista fuq il-buttuna. "
        "Kemm hu mimli l-istonku tiegħek jittieħed mix-xarba ta' qabel, u jista' jiġi kkoreġut "
        "mill-ewwel wara.",
    "Peak %@": "Quċċata %@",
    "%@ added": "Żieda: %@",
    "Save": "Issejvja",
    "Undo": "Annulla",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Backup",
    "Export a backup": "Esporta backup",
    "Import a backup": "Importa backup",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Backup fih kull persuna, okkażjoni u xarba. L-importazzjoni żżid dak li hu nieqes — "
        "qatt ma tibdel jew tneħħi dak li diġà hawn.",
    "Import this backup?": "Timporta dan il-backup?",
    "Import": "Importa",
    "Everything in this backup is already here.": "Kollox f'dan il-backup diġà jinsab hawn.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Okkażjonijiet li se jiżdiedu: %@. Xarbiet: %@. Xejn minn dak li diġà hawn ma jinbidel "
        "jew jitneħħa.",
    "Import finished": "L-importazzjoni lestiet",
    "Added %@ occasions and %@ drinks.": "Okkażjonijiet miżjuda: %@. Xarbiet miżjuda: %@.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Lingwa",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Tiftaħ din l-app f'Settings, fejn “Preferred Language” jissettja l-lingwa tal-app "
        "innifisha — dik tas-sistema tibqa' kif inhi. iOS jerġa' jibda l-app meta tibdilha.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "L-importazzjoni ma rnexxietx",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Dan il-fajl mhuwiex backup ta' DrinkSmart, jew inkella hu korrott.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Dan il-backup sar b'verżjoni aktar ġdida ta' DrinkSmart. Aġġorna l-app u erġa' "
        "pprova.",
}
