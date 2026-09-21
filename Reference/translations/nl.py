"""
Dutch.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promille",
    "Percent": "Procent",

    # --- DrinkCatalog: drink types ---
    "Beer": "Bier",
    "Wine": "Wijn",
    "Sparkling": "Mousserend",
    "Spirit": "Sterkedrank",
    "Cocktail": "Cocktail",
    "Custom": "Aangepast",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Lege maag",
    "Moderately full": "Half volle maag",
    "Full stomach": "Volle maag",
    "Empty": "Leeg",
    "Moderate": "Half",
    "Full": "Vol",
    "Fast absorption, higher and earlier peak.": "Snelle opname, hogere en vroegere piek.",
    "Moderate absorption.": "Gemiddelde opname.",
    "Slow absorption, lower and later peak.": "Langzame opname, lagere en latere piek.",

    # --- DrinkingFrequency ---
    "Rarely": "Zelden",
    "A few times a month": "Een paar keer per maand",
    "Several times a week": "Meerdere keren per week",
    "Almost daily": "Bijna dagelijks",
    "A few occasions a year": "Een paar gelegenheden per jaar",
    "Social drinking": "Sociaal drinken",
    "Weekly routine": "Wekelijkse routine",
    "Daily or nearly daily": "Dagelijks of bijna dagelijks",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Tijd",
    "Level": "Niveau",
    "Lower": "Onder",
    "Upper": "Boven",
    "Lower estimate": "Onderste schatting",
    "Upper estimate": "Bovenste schatting",
    "Personal limit": "Persoonlijke limiet",
    "Drink": "Drankje",

    # --- BACChartView ---
    "Expected peak around %@": "Verwachte piek rond %@",
    "Peaked around %@": "Piek lag rond %@",
    "No active session": "Geen actieve sessie",
    "Still rising": "Nog stijgend",
    "YOUR LIMIT %@": "JE LIMIET %@",
    "possible range": "mogelijk bereik",
    "drag to read values": "sleep om waarden af te lezen",
    "release to go back": "laat los om terug te gaan",
    "pour time": "drinktijd",
    "in one go": "in één keer",

    # --- Live screen: the day with nothing on it ---
    "Live": "Live",
    "Nothing logged today": "Vandaag niets vastgelegd",
    "Add a drink when you have one.": "Voeg een drankje toe wanneer je er een neemt.",

    # --- Tabs and history ---
    "History": "Geschiedenis",
    "No past sessions yet": "Nog geen eerdere sessies",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Een sessie verschijnt hier zodra hij is afgelopen — wanneer je niveau weer op nul "
        "staat en er een paar uur voorbij zijn.",
    "%@ drinks": "%@ drankjes",
    "peak": "piek",
    "Started": "Begonnen",
    "Lasted": "Duurde",
    "Calculated with your profile at the time": "Berekend met je profiel van dat moment",

    # --- TodayView ---
    "Profile": "Profiel",
    "estimated level": "geschat niveau",
    "estimated range": "geschat bereik",
    "Elapsed": "Verstreken",
    "Drinks": "Drankjes",
    "Units": "Eenheden",
    "Expected to clear": "Verwacht weer op nul",
    "Drinks this session": "Drankjes deze sessie",
    "This is an estimate, not a measurement.": "Dit is een schatting, geen meting.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "De werkelijke waarden verschillen sterk van persoon tot persoon. Gebruik dit nooit om "
        "te bepalen of je kunt rijden.",
    "Add drink": "Drankje toevoegen",

    # --- Editing an already logged drink ---
    "Edit drink": "Drankje bewerken",
    "Save changes": "Wijzigingen bewaren",
    "With this": "Hiermee",
    "Delete": "Verwijderen",
    "tap to edit · swipe to delete": "tik om te bewerken · veeg om te verwijderen",

    # --- Drinking pace ---
    "How fast": "Hoe snel",
    "In one go": "In één keer",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 uur",
    "Counts as a single swallow — the steepest possible rise.":
        "Telt als één slok — de steilst mogelijke stijging.",
    "A quick drink. The level climbs fast.": "Snel gedronken. Het niveau stijgt snel.",
    "A normal pace.": "Een normaal tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Langzaam opgedronken. Veel vlakkere stijging bij dezelfde hoeveelheid alcohol.",

    # --- AddDrinkSheet ---
    "Cancel": "Annuleren",
    "Now": "Nu",
    "Projected peak": "Verwachte piek",
    "Peak at": "Piek om",
    "Clears": "Weer op nul",
    "This would cross your limit": "Hiermee kom je boven je limiet",
    "Around %@, for up to %@.": "Rond %@, gedurende maximaal %@.",
    "This might cross your limit": "Hiermee kom je mogelijk boven je limiet",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Bij een tragere stofwisseling wel, bij een snellere niet. Dat is de onzekerheid van "
        "de schatting.",
    "Type": "Soort",
    "Amount": "Hoeveelheid",
    "Strength": "Sterkte",
    "%@ units": "%@ eenheden",
    "%@ g alcohol": "%@ g alcohol",
    "Stomach": "Maag",
    "When": "Wanneer",
    "15 min ago": "15 min geleden",
    "30 min ago": "30 min geleden",
    "1 hr ago": "1 uur geleden",
    "Done": "Gereed",
    "Set exact time": "Exacte tijd instellen",
    "Add": "Toevoegen",

    # --- ProfileSheet ---
    "Male": "Man",
    "Female": "Vrouw",
    "Sex": "Geslacht",
    "Weight": "Gewicht",
    "Height": "Lengte",
    "Age": "Leeftijd",
    "kg": "kg",
    "cm": "cm",
    "yrs": "jr",
    "Body": "Lichaam",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Het totale lichaamswater komt uit de Watson-vergelijkingen, die het volume bepalen "
        "waarin alcohol zich verdeelt.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Het totale lichaamswater komt uit de Watson-vergelijkingen, die het volume bepalen "
        "waarin alcohol zich verdeelt. De vergelijking voor vrouwen bevat geen leeftijd, dus "
        "die wijzigen heeft geen invloed op het resultaat.",
    "Drinking frequency": "Drinkfrequentie",
    "How often do you drink?": "Hoe vaak drink je?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Zo schatten we je afbraaksnelheid. Regelmatig drinken induceert de CYP2E1-route in de "
        "lever, waardoor frequente drinkers alcohol sneller afbreken. Het is het zwakste punt "
        "van het model, en daarom kun je onder Geavanceerd instellen hoeveel van die "
        "onzekerheid de app je laat zien.",
    "Your limit": "Je limiet",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Je eigen richtgetal, geen wettelijke limiet. De app vertelt je wanneer een gepland "
        "drankje je eroverheen zou brengen, en hoe lang je erboven zou blijven.",
    "Unit": "Eenheid",
    "Display": "Weergave",
    "Calculated values": "Berekende waarden",
    "Total body water": "Totaal lichaamswater",
    "Distribution volume": "Verdelingsvolume",
    "Widmark factor": "Widmark-factor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "De Widmark-factor ligt doorgaans rond 0,68 bij mannen en 0,55 bij vrouwen. Ligt die "
        "van jou daar ver vandaan, dan is het de moeite waard de waarden hierboven te "
        "controleren.",
    "Elimination rate": "Afbraaksnelheid",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Hoe snel je lever alcohol afbreekt zodra die is opgenomen — de helling van de dalende "
        "kant van de curve.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alcohol verdwijnt met een ongeveer vaste hoeveelheid per uur in plaats van met een "
        "percentage, omdat het enzym dat het afbreekt bij vrijwel elk niveau al op volle "
        "capaciteit draait. Daarom bestaan vuistregels als “één drankje per uur” überhaupt.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Met deze instelling duurt het bij %@ ongeveer %@ voordat je weer op nul bent. Bijna "
        "iedereen zit tussen %@ per uur.",
    "How to find yours": "Hoe je die van jou vindt",
    "With a breathalyser": "Met een blaastest",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Blaas twee keer, met minstens een uur ertussen, op de dalende kant — twee uur of "
        "langer na je laatste drankje, zonder iets ertussendoor. Trek de tweede meting van de "
        "eerste af en deel door het aantal uren ertussen.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Bijvoorbeeld %@ en twee uur later %@ komt neer op %@ per uur.",
    "Without one": "Zonder",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "De app vertelt je wanneer hij verwacht dat je weer op nul bent. Ben je steevast ruim "
        "daarvoor weer normaal, dan ligt je snelheid hoger dan de instelling — zet hem een "
        "stap omhoog en let er een paar sessies op. Duurt het langer dan voorspeld, zet hem "
        "dan een stap omlaag.",
    "What moves it": "Wat hem beïnvloedt",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Regelmatig drinken verhoogt hem: het leverenzym dat het werk doet, wordt door gebruik "
        "geïnduceerd. Hij ligt gemiddeld ook iets hoger bij vrouwen, en lager op een lege maag "
        "of bij leverproblemen.",
    "Uncertainty": "Onzekerheid",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Op nul is elk cijfer één getal — de beste schatting van de app. Boven nul worden "
        "dezelfde cijfers als bereiken getoond, en de band op de grafiek wordt navenant "
        "breder.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Tegen één getal leer je jezelf makkelijker afzetten: na verloop van tijd weet je hoe "
        "jouw eigen 0,6 voelt. Een bereik is het letterlijkere antwoord, want de snelheid is "
        "werkelijk onzeker. Beide zijn te verdedigen — dit is jouw keuze.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "De spreiding die je drinkfrequentie suggereert is ± %@ per uur.",
    "Rate": "Snelheid",
    "Range": "Bereik",
    "Advanced": "Geavanceerd",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Onzekerheid is een kwestie van smaak: die bepaalt of cijfers als één getal of als een "
        "bereik worden gelezen. De snelheid hieronder is dat niet — laat die over aan de vraag "
        "over frequentie, tenzij je een meting hebt om hem aan te toetsen.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Meerdere personen",
    "History trends": "Trends in geschiedenis",
    "Week": "Week",
    "Month": "Maand",
    "Year": "Jaar",
    "Sober days": "Droge dagen",
    "Change": "Verandering",
    "before records": "vóór de registratie",
    "See further back": "Verder terugkijken",
    "Weeks, months and years side by side — and every evening older than seven days.": "Weken, maanden en jaren naast elkaar – en elke avond ouder dan zeven dagen.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Alles wat je hebt ingevoerd is al opgeslagen. Ontgrendelen laat het alleen zien.",
    "Coming soon": "Binnenkort",
    "Grams": "Gram",
    "Grams of alcohol": "Gram alcohol",
    "Standard units": "Standaardeenheden",
    "Period": "Periode",
    "Switch person": "Van persoon wisselen",
    "Add person": "Persoon toevoegen",
    "New person": "Nieuwe persoon",
    "You": "Jij",
    "Name": "Naam",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Alle vier veranderen de curve, dus geen ervan valt voor iemand anders te raden.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Hun eigen limiet en de fijnere instellingen kun je later aanpassen op het tabblad "
        "Profiel, zolang zij de geselecteerde persoon zijn.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Snel toevoegen",
    "Choose a favourite drink": "Kies een favoriet drankje",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Kies het drankje dat je meestal bestelt, dan legt een knop op het Live-scherm het met "
        "één tik vast.",
    "This is your quick-add drink": "Dit is je drankje voor snel toevoegen",
    "Set as my quick-add drink": "Instellen als mijn drankje voor snel toevoegen",
    "This is now your usual": "Dit is nu je vaste drankje",
    "Remove favourite": "Favoriet verwijderen",
    "Always add this one": "Altijd deze toevoegen",
    "Logs it straight away, without opening anything.":
        "Legt het meteen vast, zonder iets te openen.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Eén tik op het Live-scherm legt dit vast, met de verwachte piek op de knop. Hoe vol "
        "je maag is komt van het drankje ervoor, en kun je er meteen na corrigeren.",
    "Peak %@": "Piek %@",
    "%@ added": "%@ toegevoegd",
    "Save": "Bewaren",
    "Undo": "Ongedaan maken",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Back-up",
    "Export a backup": "Back-up exporteren",
    "Import a backup": "Een back-up importeren",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Een back-up bevat elke persoon, gelegenheid en elk drankje. Importeren voegt toe wat "
        "ontbreekt — het verandert of verwijdert nooit iets wat er al staat.",
    "Import this backup?": "Deze back-up importeren?",
    "Import": "Importeren",
    "Everything in this backup is already here.": "Alles in deze back-up staat er al.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Voegt %@ gelegenheden en %@ drankjes toe. Er wordt niets veranderd of verwijderd wat "
        "er al staat.",
    "Import finished": "Importeren voltooid",
    "Added %@ occasions and %@ drinks.": "%@ gelegenheden en %@ drankjes toegevoegd.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Taal",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Opent deze app in Instellingen, waar “Voorkeurstaal” de taal van de app zelf instelt "
        "— die van het systeem blijft zoals hij is. iOS start de app opnieuw wanneer je dit "
        "wijzigt.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Importeren mislukt",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Dit bestand is geen DrinkSmart-back-up, of het is beschadigd.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Deze back-up is gemaakt met een nieuwere versie van DrinkSmart. Werk de app bij en "
        "probeer het opnieuw.",
}
