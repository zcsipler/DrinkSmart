"""
Irish.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Sa mhíle",
    "Percent": "Faoin gcéad",

    # --- DrinkCatalog: drink types ---
    "Beer": "Beoir",
    "Wine": "Fíon",
    "Sparkling": "Súilíneach",
    "Spirit": "Biotáille",
    "Cocktail": "Manglam",
    "Custom": "Saincheaptha",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Goile folamh",
    "Moderately full": "Measartha lán",
    "Full stomach": "Goile lán",
    "Empty": "Folamh",
    "Moderate": "Measartha",
    "Full": "Lán",
    "Fast absorption, higher and earlier peak.":
        "Ionsú tapa, buaic níos airde agus níos luaithe.",
    "Moderate absorption.": "Ionsú measartha.",
    "Slow absorption, lower and later peak.": "Ionsú mall, buaic níos ísle agus níos déanaí.",

    # --- DrinkingFrequency ---
    "Rarely": "Is annamh",
    "A few times a month": "Cúpla uair sa mhí",
    "Several times a week": "Roinnt uaireanta sa tseachtain",
    "Almost daily": "Beagnach gach lá",
    "A few occasions a year": "Cúpla ócáid sa bhliain",
    "Social drinking": "Ól sóisialta",
    "Weekly routine": "Gnás seachtainiúil",
    "Daily or nearly daily": "Gach lá nó beagnach gach lá",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Am",
    "Level": "Leibhéal",
    "Lower": "Íochtar",
    "Upper": "Uachtar",
    "Lower estimate": "Meastachán íochtair",
    "Upper estimate": "Meastachán uachtair",
    "Personal limit": "Teorainn phearsanta",
    "Drink": "Deoch",

    # --- BACChartView ---
    "Expected peak around %@": "Táthar ag súil le buaic thart ar %@",
    "Peaked around %@": "Bhí an bhuaic thart ar %@",
    "No active session": "Níl seisiún gníomhach ann",
    "Still rising": "Ag ardú fós",
    "YOUR LIMIT %@": "DO THEORAINN %@",
    "possible range": "raon féideartha",
    "drag to read values": "tarraing chun luachanna a léamh",
    "release to go back": "scaoil chun dul ar ais",
    "pour time": "fad óil",
    "in one go": "d'aon iarraidh",

    # --- Live screen: the day with nothing on it ---
    "Live": "Beo",
    "Nothing logged today": "Níor logáladh aon rud inniu",
    "Add a drink when you have one.": "Cuir deoch leis nuair a bhíonn ceann agat.",

    # --- Tabs and history ---
    "History": "Stair",
    "No past sessions yet": "Níl aon seisiún caite ann fós",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Taispeántar seisiún anseo a luaithe atá deireadh leis — nuair atá do leibhéal glanta "
        "agus cúpla uair an chloig imithe thart.",
    "%@ drinks": "Deochanna: %@",
    "peak": "buaic",
    "Started": "Thosaigh",
    "Lasted": "Mhair",
    "Calculated with your profile at the time": "Ríofa le do phróifíl mar a bhí ag an am",

    # --- TodayView ---
    "Profile": "Próifíl",
    "estimated level": "leibhéal measta",
    "estimated range": "raon measta",
    "Elapsed": "Caite",
    "Drinks": "Deochanna",
    "Units": "Aonaid",
    "Expected to clear": "Ag súil le glanadh",
    "Drinks this session": "Deochanna sa seisiún seo",
    "This is an estimate, not a measurement.": "Is meastachán é seo, ní tomhas.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Athraíonn na fíorluachanna go mór ó dhuine go duine. Ná bain úsáid as seo choíche le "
        "cinneadh a dhéanamh an féidir leat tiomáint.",
    "Add drink": "Cuir deoch leis",

    # --- Editing an already logged drink ---
    "Edit drink": "Cuir deoch in eagar",
    "Save changes": "Sábháil na hathruithe",
    "With this": "Leis an gceann seo",
    "Delete": "Scrios",
    "tap to edit · swipe to delete": "tapáil chun eagrú · svaidhpeáil chun scriosadh",

    # --- Drinking pace ---
    "How fast": "Cé chomh tapa",
    "In one go": "D'aon iarraidh",
    "15 min": "15 nóim",
    "30 min": "30 nóim",
    "1 hr": "1 uair",
    "Counts as a single swallow — the steepest possible rise.":
        "Áirítear é mar bholgam amháin — an t-ardú is géire is féidir.",
    "A quick drink. The level climbs fast.": "Deoch sciobtha. Ardaíonn an leibhéal go tapa.",
    "A normal pace.": "Luas gnách.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Á ól go mall. Ardú i bhfad níos míne don mhéid céanna alcóil.",

    # --- AddDrinkSheet ---
    "Cancel": "Cealaigh",
    "Now": "Anois",
    "Projected peak": "Buaic mheasta",
    "Peak at": "Buaic ag",
    "Clears": "Glanann",
    "This would cross your limit": "Rachadh sé seo thar do theorainn",
    "Around %@, for up to %@.": "Timpeall %@, ar feadh suas le %@.",
    "This might cross your limit": "D'fhéadfadh sé seo dul thar do theorainn",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Le meitibileacht níos moille, rachadh; le ceann níos tapúla, ní rachadh. Sin "
        "éiginnteacht an mheastacháin.",
    "Type": "Cineál",
    "Amount": "Méid",
    "Strength": "Neart",
    "%@ units": "Aonaid: %@",
    "%@ g alcohol": "%@ g alcóil",
    "Stomach": "Goile",
    "When": "Cathain",
    "15 min ago": "15 nóim ó shin",
    "30 min ago": "30 nóim ó shin",
    "1 hr ago": "1 uair ó shin",
    "Done": "Déanta",
    "Set exact time": "Socraigh an t-am beacht",
    "Add": "Cuir leis",

    # --- ProfileSheet ---
    "Male": "Fireann",
    "Female": "Baineann",
    "Sex": "Gnéas",
    "Weight": "Meáchan",
    "Height": "Airde",
    "Age": "Aois",
    "kg": "kg",
    "cm": "cm",
    "yrs": "bl",
    "Body": "Corp",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Tagann uisce iomlán an choirp ó chothromóidí Watson, a shocraíonn an toirt ina "
        "ndáiltear an t-alcól.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Tagann uisce iomlán an choirp ó chothromóidí Watson, a shocraíonn an toirt ina "
        "ndáiltear an t-alcól. Níl an aois san áireamh sa chothromóid do mhná, agus mar sin ní "
        "bheidh tionchar ag athrú uirthi ar an toradh.",
    "Drinking frequency": "Minicíocht óil",
    "How often do you drink?": "Cé chomh minic a ólann tú?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Seo mar a dhéanaimid do ráta glanta a mheas. Spreagann ól rialta conair CYP2E1 an ae, "
        "agus mar sin glanann daoine a ólann go minic alcól níos tapúla. Seo an pointe is "
        "laige sa tsamhail, agus sin an fáth gur féidir leat a shocrú faoi Ardroghanna cé "
        "mhéad den éiginnteacht sin a thaispeánann an aip duit.",
    "Your limit": "Do theorainn",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "D'uimhir thagartha féin, ní teorainn dhlíthiúil. Insíonn an aip duit nuair a "
        "thabharfadh deoch bheartaithe thairsti thú, agus cé chomh fada a d'fhanfá os a cionn.",
    "Unit": "Aonad",
    "Display": "Taispeáint",
    "Calculated values": "Luachanna ríofa",
    "Total body water": "Uisce iomlán an choirp",
    "Distribution volume": "Toirt dáileacháin",
    "Widmark factor": "Fachtóir Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Bíonn fachtóir Widmark thart ar 0.68 d'fhir agus 0.55 do mhná de ghnáth. Má tá do "
        "cheannsa i bhfad ó sin, is fiú na luachanna thuas a sheiceáil.",
    "Elimination rate": "Ráta glanta",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Cé chomh tapa a ghlanann d'ae an t-alcól a luaithe atá sé ionsúite — fána an taoibh "
        "íslithigh den chuar.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Imíonn an t-alcól ag méid réasúnta seasta in aghaidh na huaire seachas mar chéatadán, "
        "toisc go bhfuil an einsím a bhriseann síos é ag obair ar a lánacmhainn cheana féin ag "
        "beagnach aon leibhéal. Sin an fáth a bhfuil rialacha ordóige ar nós “deoch amháin san "
        "uair” ann ar chor ar bith.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Leis an socrú seo, glanann %@ i gceann thart ar %@. Titeann beagnach gach duine idir "
        "%@ in aghaidh na huaire.",
    "How to find yours": "Conas do cheann féin a aimsiú",
    "With a breathalyser": "Le hanálaitheoir",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Séid faoi dhó, uair an chloig ar a laghad eatarthu, ar an taobh íslitheach — dhá uair "
        "an chloig nó níos mó tar éis do dheoch dheireanach, gan aon rud eatarthu. Bain an "
        "dara léamh ón gcéad cheann agus roinn ar líon na n-uaireanta eatarthu.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Mar shampla, %@ agus ansin %@ dhá uair an chloig ina dhiaidh sin: sin %@ in aghaidh "
        "na huaire.",
    "Without one": "Gan ceann",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Insíonn an aip duit cathain a bhfuil sí ag súil go nglanfaidh tú. Má bhíonn tú ar ais "
        "mar is gnách go hiontaofa i bhfad roimhe sin, tá do ráta níos airde ná an socrú — "
        "ardaigh céim amháin é agus coinnigh súil air ar feadh cúpla seisiún. Má thógann sé "
        "níos faide ná mar a tuaradh, ísligh céim amháin é.",
    "What moves it": "Cad a athraíonn é",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Ardaíonn ól rialta é: spreagtar einsím an ae a dhéanann an obair tríd an úsáid. Bíonn "
        "sé beagán níos airde i mná ar an meán freisin, agus níos ísle ar ghoile folamh nó le "
        "fadhbanna ae.",
    "Uncertainty": "Éiginnteacht",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Ag nialas is uimhir aonair gach figiúr — an meastachán is fearr atá ag an aip. Os "
        "cionn nialais taispeántar na figiúirí céanna mar raonta, agus leathnaíonn an banda ar "
        "an gcairt dá réir.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Is fusa foghlaim ó uimhir amháin: le himeacht ama tuigfidh tú cén chaoi a mbraitheann "
        "do 0.6 féin. Is é an raon an freagra is litriúla, mar tá an ráta éiginnte go deimhin. "
        "Tá an dá rud inchosanta — is fútsa atá sé.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Is é ± %@ in aghaidh na huaire an scaipeadh a mholann do mhinicíocht óil.",
    "Rate": "Ráta",
    "Range": "Raon",
    "Advanced": "Ardroghanna",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Is ceist blais í an éiginnteacht: socraíonn sí an léitear figiúirí mar uimhir amháin "
        "nó mar raon. Ní hamhlaidh don ráta thíos — fág faoin gceist minicíochta é mura bhfuil "
        "tomhas agat le cur i gcomparáid leis.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Roinnt daoine",
    "History trends": "Treochtaí staire",
    "Week": "Seachtain",
    "Month": "Mí",
    "Year": "Bliain",
    "Sober days": "Laethanta gan alcól",
    "Change": "Athrú",
    "before records": "roimh thús na dtaifead",
    "See further back": "Féach níos faide siar",
    "Weeks, months and years side by side — and every evening older than seven days.": "Seachtainí, míonna agus blianta taobh le taobh – agus gach oíche níos sine ná seacht lá.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Tá gach rud a logáil tú sábháilte cheana féin. Ní dhéanann an díghlasáil ach é a thaispeáint.",
    "Coming soon": "Ag teacht go luath",
    "No data before %@": "Gan sonraí roimh %@",
    "vs.": "i gcomparáid le",
    "Grams": "Graim",
    "Grams of alcohol": "Graim alcóil",
    "Standard units": "Aonaid chaighdeánacha",
    "Period": "Tréimhse",
    "Switch person": "Athraigh duine",
    "Add person": "Cuir duine leis",
    "New person": "Duine nua",
    "You": "Tusa",
    "Name": "Ainm",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Athraíonn na ceithre cinn an cuar, agus mar sin ní féidir buille faoi thuairim a "
        "thabhairt faoi cheann ar bith acu do dhuine eile.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Is féidir a dteorainn féin agus na socruithe míne a athrú níos déanaí ar an gcluaisín "
        "Próifíl, fad is iad an duine roghnaithe.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Mearchur",
    "Choose a favourite drink": "Roghnaigh deoch is fearr leat",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Roghnaigh an deoch a ordaíonn tú de ghnáth, agus logálfaidh cnaipe ar an scáileán Beo "
        "í le tapáil amháin.",
    "This is your quick-add drink": "Seo do dheoch mhearchuir",
    "Set as my quick-add drink": "Socraigh mar mo dheoch mhearchuir",
    "This is now your usual": "Seo do ghnáthdheoch anois",
    "Remove favourite": "Bain an deoch is fearr leat",
    "Always add this one": "Cuir an ceann seo leis i gcónaí",
    "Logs it straight away, without opening anything.":
        "Logálann sé láithreach é, gan aon rud a oscailt.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Logálann tapáil amháin ar an scáileán Beo é seo, agus an bhuaic mheasta ar an "
        "gcnaipe. Tagann an méid atá i do ghoile ón deoch roimhe, agus is féidir é a cheartú "
        "díreach ina dhiaidh sin.",
    "Peak %@": "Buaic %@",
    "%@ added": "%@ curtha leis",
    "Save": "Sábháil",
    "Undo": "Cuir ar ceal",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Cúltaca",
    "Export a backup": "Easpórtáil cúltaca",
    "Import a backup": "Iompórtáil cúltaca",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Coinníonn cúltaca gach duine, gach ócáid agus gach deoch. Cuireann an iompórtáil leis "
        "an méid atá in easnamh — ní athraíonn agus ní bhaineann sí riamh aon rud atá anseo "
        "cheana.",
    "Import this backup?": "An cúltaca seo a iompórtáil?",
    "Import": "Iompórtáil",
    "Everything in this backup is already here.": "Tá gach rud sa chúltaca seo anseo cheana.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Cuirfidh sé seo %@ ócáid agus %@ deoch leis. Ní athrófar agus ní bhainfear aon rud "
        "atá anseo cheana.",
    "Import finished": "Iompórtáil críochnaithe",
    "Added %@ occasions and %@ drinks.": "Cuireadh %@ ócáid agus %@ deoch leis.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Teanga",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Osclaíonn sé seo an aip seo sna Socruithe, áit a socraíonn “Teanga Roghnaithe” teanga "
        "na haipe féin — fanann teanga an chórais mar atá. Atosaíonn iOS an aip nuair a "
        "athraíonn tú í.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Níorbh fhéidir iompórtáil",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Ní cúltaca DrinkSmart é an comhad seo, nó tá sé damáistithe.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Rinneadh an cúltaca seo le leagan níos nuaí de DrinkSmart. Nuashonraigh an aip agus "
        "bain triail eile as.",
}
