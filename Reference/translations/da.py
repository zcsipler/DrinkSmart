"""
Danish.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promille",
    "Percent": "Procent",

    # --- DrinkCatalog: drink types ---
    "Beer": "Øl",
    "Wine": "Vin",
    "Sparkling": "Mousserende",
    "Spirit": "Spiritus",
    "Cocktail": "Cocktail",
    "Custom": "Egen",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Tom mave",
    "Moderately full": "Delvist fyldt",
    "Full stomach": "Fuld mave",
    "Empty": "Tom",
    "Moderate": "Middel",
    "Full": "Fuld",
    "Fast absorption, higher and earlier peak.": "Hurtig optagelse, højere og tidligere top.",
    "Moderate absorption.": "Moderat optagelse.",
    "Slow absorption, lower and later peak.": "Langsom optagelse, lavere og senere top.",

    # --- DrinkingFrequency ---
    "Rarely": "Sjældent",
    "A few times a month": "Et par gange om måneden",
    "Several times a week": "Flere gange om ugen",
    "Almost daily": "Næsten dagligt",
    "A few occasions a year": "Et par gange om året",
    "Social drinking": "Ved sociale lejligheder",
    "Weekly routine": "Ugentlig rutine",
    "Daily or nearly daily": "Dagligt eller næsten dagligt",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Tidspunkt",
    "Level": "Niveau",
    "Lower": "Nedre",
    "Upper": "Øvre",
    "Lower estimate": "Nedre skøn",
    "Upper estimate": "Øvre skøn",
    "Personal limit": "Personlig grænse",
    "Drink": "Drink",

    # --- BACChartView ---
    "Expected peak around %@": "Forventet top omkring %@",
    "Peaked around %@": "Toppede omkring %@",
    "No active session": "Ingen aktiv session",
    "Still rising": "Stiger stadig",
    "YOUR LIMIT %@": "DIN GRÆNSE %@",
    "possible range": "muligt interval",
    "drag to read values": "træk for at aflæse værdier",
    "release to go back": "slip for at gå tilbage",
    "pour time": "drikketid",
    "in one go": "på én gang",

    # --- Live screen: the day with nothing on it ---
    "Live": "Live",
    "Nothing logged today": "Intet registreret i dag",
    "Add a drink when you have one.": "Tilføj en drink, når du får en.",

    # --- Tabs and history ---
    "History": "Historik",
    "No past sessions yet": "Ingen tidligere sessioner endnu",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "En session vises her, når den er slut — når dit niveau er nede på nul, og der er gået "
        "et par timer.",
    "%@ drinks": "%@ drinks",
    "peak": "top",
    "Started": "Startede",
    "Lasted": "Varede",
    "Calculated with your profile at the time": "Beregnet med din profil på det tidspunkt",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "skønnet niveau",
    "estimated range": "skønnet interval",
    "Elapsed": "Forløbet",
    "Drinks": "Drinks",
    "Units": "Genstande",
    "Expected to clear": "Forventet alkoholfri",
    "Drinks this session": "Drinks i denne session",
    "This is an estimate, not a measurement.": "Dette er et skøn, ikke en måling.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "De faktiske værdier varierer betydeligt fra person til person. Brug aldrig dette til "
        "at afgøre, om du kan køre bil.",
    "Add drink": "Tilføj drink",

    # --- Editing an already logged drink ---
    "Edit drink": "Rediger drink",
    "Save changes": "Gem ændringer",
    "With this": "Med denne",
    "Delete": "Slet",
    "tap to edit · swipe to delete": "tryk for at redigere · stryg for at slette",

    # --- Drinking pace ---
    "How fast": "Hvor hurtigt",
    "In one go": "På én gang",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 t",
    "Counts as a single swallow — the steepest possible rise.":
        "Tæller som en enkelt slurk — den stejlest mulige stigning.",
    "A quick drink. The level climbs fast.": "En hurtig drink. Niveauet stiger hurtigt.",
    "A normal pace.": "Et normalt tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Drukket langsomt. Meget blidere stigning for den samme mængde alkohol.",

    # --- AddDrinkSheet ---
    "Cancel": "Annuller",
    "Now": "Nu",
    "Projected peak": "Forventet top",
    "Peak at": "Top kl.",
    "Clears": "Alkoholfri",
    "This would cross your limit": "Dette vil overskride din grænse",
    "Around %@, for up to %@.": "Omkring %@, i op til %@.",
    "This might cross your limit": "Dette kan overskride din grænse",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Med en langsommere forbrænding ja, med en hurtigere nej. Det er skønnets usikkerhed.",
    "Type": "Type",
    "Amount": "Mængde",
    "Strength": "Styrke",
    "%@ units": "%@ genstande",
    "%@ g alcohol": "%@ g alkohol",
    "Stomach": "Mave",
    "When": "Hvornår",
    "15 min ago": "15 min siden",
    "30 min ago": "30 min siden",
    "1 hr ago": "1 t siden",
    "Done": "Færdig",
    "Set exact time": "Angiv præcist tidspunkt",
    "Add": "Tilføj",

    # --- ProfileSheet ---
    "Male": "Mand",
    "Female": "Kvinde",
    "Sex": "Køn",
    "Weight": "Vægt",
    "Height": "Højde",
    "Age": "Alder",
    "kg": "kg",
    "cm": "cm",
    "yrs": "år",
    "Body": "Krop",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Samlet kropsvand kommer fra Watson-ligningerne, som fastsætter det volumen, alkohol "
        "fordeler sig i.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Samlet kropsvand kommer fra Watson-ligningerne, som fastsætter det volumen, alkohol "
        "fordeler sig i. Ligningen for kvinder medregner ikke alder, så en ændring af den "
        "påvirker ikke resultatet.",
    "Drinking frequency": "Drikkefrekvens",
    "How often do you drink?": "Hvor ofte drikker du?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Sådan skønner vi din forbrændingshastighed. Regelmæssig indtagelse inducerer leverens "
        "CYP2E1-vej, så hyppige drikkere nedbryder alkohol hurtigere. Det er modellens "
        "svageste punkt, og derfor kan du under Avanceret bestemme, hvor meget af den "
        "usikkerhed appen viser dig.",
    "Your limit": "Din grænse",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Dit eget referencetal, ikke en lovbestemt grænse. Appen fortæller dig, hvornår en "
        "planlagt drink vil føre dig over den, og hvor længe du vil ligge over.",
    "Unit": "Genstand",
    "Display": "Visning",
    "Calculated values": "Beregnede værdier",
    "Total body water": "Samlet kropsvand",
    "Distribution volume": "Fordelingsvolumen",
    "Widmark factor": "Widmark-faktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmark-faktoren ligger typisk omkring 0,68 for mænd og 0,55 for kvinder. Hvis din "
        "ligger langt fra det, er det værd at tjekke værdierne ovenfor.",
    "Elimination rate": "Forbrændingshastighed",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Hvor hurtigt din lever nedbryder alkohol, når den først er optaget — hældningen på "
        "kurvens faldende side.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol forsvinder med en nogenlunde fast mængde i timen frem for med en procentdel, "
        "fordi det enzym, der nedbryder den, allerede kører for fuld kraft ved næsten alle "
        "niveauer. Det er derfor, tommelfingerregler som »én genstand i timen« overhovedet "
        "findes.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Ved denne indstilling tager %@ omkring %@ at nedbryde. Næsten alle ligger mellem %@ i "
        "timen.",
    "How to find yours": "Sådan finder du din",
    "With a breathalyser": "Med et alkometer",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Pust to gange med mindst en times mellemrum på den faldende side — to timer eller "
        "mere efter din sidste drink, uden noget ind imellem. Træk den anden måling fra den "
        "første, og divider med antallet af timer imellem dem.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "For eksempel giver %@ og %@ to timer senere %@ i timen.",
    "Without one": "Uden den",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Appen fortæller dig, hvornår den forventer, at du er alkoholfri. Hvis du konsekvent "
        "er tilbage til normal et godt stykke før det, er din hastighed højere end "
        "indstillingen — skru den et trin op, og hold øje i et par sessioner. Tager det "
        "længere end forudsagt, så skru den ned.",
    "What moves it": "Hvad påvirker den",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Regelmæssig indtagelse hæver den: det leverenzym, der udfører arbejdet, induceres af "
        "brug. Den er også en anelse højere hos kvinder i gennemsnit og lavere på tom mave "
        "eller ved leverproblemer.",
    "Uncertainty": "Usikkerhed",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Ved nul er hvert tal et enkelt tal — appens bedste skøn. Over nul vises de samme tal "
        "som intervaller, og båndet på grafen bliver tilsvarende bredere.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Et enkelt tal er nemmere at lære af: med tiden finder du ud af, hvordan din egen 0,6 "
        "føles. Et interval er det mere bogstavelige svar, for hastigheden er reelt usikker. "
        "Begge dele kan forsvares — det er dit valg.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Spredningen, som din drikkefrekvens peger på, er ± %@ i timen.",
    "Rate": "Hastighed",
    "Range": "Interval",
    "Advanced": "Avanceret",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Usikkerhed er en smagssag: den afgør, om tal vises som ét tal eller som et interval. "
        "Hastigheden nedenfor er ikke en smagssag — overlad den til spørgsmålet om frekvens, "
        "medmindre du har en måling at holde den op imod.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Flere personer",
    "History trends": "Tendenser i historikken",
    "Week": "Uge",
    "Month": "Måned",
    "Year": "År",
    "Sober days": "Dage uden alkohol",
    "Change": "Ændring",
    "before records": "før registreringen begyndte",
    "See further back": "Se længere tilbage",
    "Weeks, months and years side by side — and every evening older than seven days.": "Uger, måneder og år side om side – og hver aften ældre end syv dage.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Alt, du har registreret, er allerede gemt. At låse op viser det blot.",
    "Coming soon": "Kommer snart",
    "Grams": "Gram",
    "Grams of alcohol": "Gram alkohol",
    "Standard units": "Standardenheder",
    "Period": "Periode",
    "Switch person": "Skift person",
    "Add person": "Tilføj person",
    "New person": "Ny person",
    "You": "Dig",
    "Name": "Navn",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Alle fire ændrer kurven, så ingen af dem kan gættes for en anden person.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Deres egen grænse og de finere indstillinger kan ændres senere under fanen Profil, "
        "mens de er den valgte person.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Hurtigvalg",
    "Choose a favourite drink": "Vælg en yndlingsdrink",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Vælg den drink, du plejer at bestille, så registrerer en knap på Live-skærmen den med "
        "ét tryk.",
    "This is your quick-add drink": "Dette er din hurtigvalg-drink",
    "Set as my quick-add drink": "Vælg som min hurtigvalg-drink",
    "This is now your usual": "Dette er nu din faste drink",
    "Remove favourite": "Fjern yndlingsdrink",
    "Always add this one": "Tilføj altid denne",
    "Logs it straight away, without opening anything.":
        "Registrerer den med det samme, uden at åbne noget.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Ét tryk på Live-skærmen registrerer den, med den forventede top på knappen. Hvor fuld "
        "din mave er, kommer fra den foregående drink og kan rettes lige efter.",
    "Peak %@": "Top %@",
    "%@ added": "%@ tilføjet",
    "Save": "Gem",
    "Undo": "Fortryd",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Sikkerhedskopi",
    "Export a backup": "Eksporter en sikkerhedskopi",
    "Import a backup": "Importer en sikkerhedskopi",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "En sikkerhedskopi indeholder alle personer, sessioner og drinks. Import tilføjer det, "
        "der mangler — den ændrer eller fjerner aldrig noget, der allerede er her.",
    "Import this backup?": "Vil du importere denne sikkerhedskopi?",
    "Import": "Importer",
    "Everything in this backup is already here.":
        "Alt i denne sikkerhedskopi findes allerede her.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Tilføjer %@ sessioner og %@ drinks. Intet af det, der allerede er her, ændres eller "
        "fjernes.",
    "Import finished": "Import afsluttet",
    "Added %@ occasions and %@ drinks.": "Tilføjede %@ sessioner og %@ drinks.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Sprog",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Åbner denne app i Indstillinger, hvor »Foretrukket sprog« bestemmer appens eget sprog "
        "— systemets forbliver, som det er. iOS genstarter appen, når du ændrer det.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Kunne ikke importere",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Denne fil er ikke en DrinkSmart-sikkerhedskopi, eller den er beskadiget.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Denne sikkerhedskopi er lavet af en nyere version af DrinkSmart. Opdater appen, og "
        "prøv igen.",
}
