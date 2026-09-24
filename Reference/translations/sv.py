"""
Swedish.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promille",
    "Percent": "Procent",

    # --- DrinkCatalog: drink types ---
    "Beer": "Öl",
    "Wine": "Vin",
    "Sparkling": "Mousserande",
    "Spirit": "Sprit",
    "Cocktail": "Cocktail",
    "Custom": "Egen",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Tom mage",
    "Moderately full": "Måttligt fylld mage",
    "Full stomach": "Full mage",
    "Empty": "Tom",
    "Moderate": "Måttlig",
    "Full": "Full",
    "Fast absorption, higher and earlier peak.": "Snabbt upptag, högre och tidigare topp.",
    "Moderate absorption.": "Måttligt upptag.",
    "Slow absorption, lower and later peak.": "Långsamt upptag, lägre och senare topp.",

    # --- DrinkingFrequency ---
    "Rarely": "Sällan",
    "A few times a month": "Några gånger i månaden",
    "Several times a week": "Flera gånger i veckan",
    "Almost daily": "Nästan varje dag",
    "A few occasions a year": "Några tillfällen om året",
    "Social drinking": "Sällskapsdrickande",
    "Weekly routine": "Veckorutin",
    "Daily or nearly daily": "Dagligen eller nästan dagligen",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Tid",
    "Level": "Nivå",
    "Lower": "Nedre",
    "Upper": "Övre",
    "Lower estimate": "Nedre uppskattning",
    "Upper estimate": "Övre uppskattning",
    "Personal limit": "Personlig gräns",
    "Drink": "Dryck",

    # --- BACChartView ---
    "Expected peak around %@": "Förväntad topp omkring %@",
    "Peaked around %@": "Toppade omkring %@",
    "No active session": "Inget pågående tillfälle",
    "Still rising": "Stiger fortfarande",
    "YOUR LIMIT %@": "DIN GRÄNS %@",
    "possible range": "möjligt intervall",
    "drag to read values": "dra för att läsa av värden",
    "release to go back": "släpp för att gå tillbaka",
    "pour time": "dricktid",
    "in one go": "i ett svep",

    # --- Live screen: the day with nothing on it ---
    "Live": "Live",
    "Nothing logged today": "Inget loggat i dag",
    "Add a drink when you have one.": "Lägg till en dryck när du tar en.",

    # --- Tabs and history ---
    "History": "Historik",
    "No past sessions yet": "Inga tidigare tillfällen än",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Ett tillfälle dyker upp här när det har avslutats — när din nivå har nått noll och "
        "några timmar har gått.",
    "%@ drinks": "%@ drycker",
    "peak": "topp",
    "Started": "Startade",
    "Lasted": "Varade",
    "Calculated with your profile at the time": "Beräknat med din profil vid det tillfället",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "uppskattad nivå",
    "estimated range": "uppskattat intervall",
    "Elapsed": "Förfluten tid",
    "Drinks": "Drycker",
    "Units": "Enheter",
    "Expected to clear": "Förväntas nå noll",
    "Drinks this session": "Drycker under tillfället",
    "This is an estimate, not a measurement.": "Det här är en uppskattning, inte en mätning.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Faktiska värden varierar kraftigt mellan individer. Använd aldrig det här för att "
        "avgöra om du kan köra bil.",
    "Add drink": "Lägg till dryck",

    # --- Editing an already logged drink ---
    "Edit drink": "Redigera dryck",
    "Save changes": "Spara ändringar",
    "With this": "Med den här",
    "Delete": "Ta bort",
    "tap to edit · swipe to delete": "tryck för att redigera · svep för att ta bort",

    # --- Drinking pace ---
    "How fast": "Hur snabbt",
    "In one go": "I ett svep",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 tim",
    "Counts as a single swallow — the steepest possible rise.":
        "Räknas som en enda klunk — den brantaste möjliga stigningen.",
    "A quick drink. The level climbs fast.": "En snabb dryck. Nivån stiger snabbt.",
    "A normal pace.": "Ett normalt tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Drucken långsamt. Mycket mjukare stigning för samma mängd alkohol.",

    # --- AddDrinkSheet ---
    "Cancel": "Avbryt",
    "Now": "Nu",
    "Projected peak": "Beräknad topp",
    "Peak at": "Topp kl.",
    "Clears": "Når noll",
    "This would cross your limit": "Det här skulle passera din gräns",
    "Around %@, for up to %@.": "Omkring %@, i upp till %@.",
    "This might cross your limit": "Det här kan passera din gräns",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Med långsammare ämnesomsättning ja, med snabbare nej. Det är osäkerheten i "
        "uppskattningen.",
    "Type": "Typ",
    "Amount": "Mängd",
    "Strength": "Styrka",
    "%@ units": "%@ enheter",
    "%@ g alcohol": "%@ g alkohol",
    "Stomach": "Mage",
    "When": "När",
    "15 min ago": "för 15 min sedan",
    "30 min ago": "för 30 min sedan",
    "1 hr ago": "för 1 tim sedan",
    "Done": "Klar",
    "Set exact time": "Ange exakt tid",
    "Add": "Lägg till",

    # --- ProfileSheet ---
    "Male": "Man",
    "Female": "Kvinna",
    "Sex": "Kön",
    "Weight": "Vikt",
    "Height": "Längd",
    "Age": "Ålder",
    "kg": "kg",
    "cm": "cm",
    "yrs": "år",
    "Body": "Kropp",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Totalt kroppsvatten kommer från Watson-ekvationerna, som anger volymen som alkoholen "
        "fördelar sig i.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Totalt kroppsvatten kommer från Watson-ekvationerna, som anger volymen som alkoholen "
        "fördelar sig i. Ekvationen för kvinnor innehåller inte ålder, så att ändra den "
        "påverkar inte resultatet.",
    "Drinking frequency": "Dryckesfrekvens",
    "How often do you drink?": "Hur ofta dricker du?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Så här uppskattar vi din förbränningshastighet. Regelbundet drickande inducerar "
        "leverns CYP2E1-väg, så den som dricker ofta bryter ner alkohol snabbare. Det är "
        "modellens svagaste punkt, och därför kan du under Avancerat ställa in hur mycket av "
        "den osäkerheten appen visar dig.",
    "Your limit": "Din gräns",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Ditt eget referensvärde, inte en laglig gräns. Appen talar om när en planerad dryck "
        "skulle ta dig förbi den, och hur länge du skulle ligga över.",
    "Unit": "Enhet",
    "Display": "Visning",
    "Calculated values": "Beräknade värden",
    "Total body water": "Totalt kroppsvatten",
    "Distribution volume": "Distributionsvolym",
    "Widmark factor": "Widmarkfaktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmarkfaktorn ligger vanligtvis runt 0,68 för män och 0,55 för kvinnor. Om din "
        "ligger långt ifrån det är det värt att kontrollera värdena ovan.",
    "Elimination rate": "Förbränningshastighet",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Hur snabbt levern bryter ner alkohol när den väl har tagits upp — lutningen på "
        "kurvans fallande sida.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol lämnar kroppen med en ungefär fast mängd per timme snarare än med en andel, "
        "eftersom enzymet som bryter ner den redan går för full kapacitet vid nästan varje "
        "nivå. Det är därför tumregler som ”en dryck i timmen” finns över huvud taget.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Med den här inställningen tar %@ ungefär %@ att nå noll. Nästan alla ligger mellan %@ "
        "per timme.",
    "How to find yours": "Så hittar du din",
    "With a breathalyser": "Med en alkometer",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Blås två gånger, med minst en timme emellan, på den fallande sidan — två timmar eller "
        "mer efter din sista dryck, utan något däremellan. Dra det andra värdet från det "
        "första och dela med antalet timmar mellan dem.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Till exempel %@ och %@ två timmar senare blir %@ per timme.",
    "Without one": "Utan den",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Appen talar om när den räknar med att du är nere på noll. Om du tillförlitligt är "
        "tillbaka till det normala en bra stund före det är din hastighet högre än "
        "inställningen — höj den ett steg och följ det under några tillfällen. Om det tar "
        "längre tid än beräknat, sänk den ett steg.",
    "What moves it": "Vad som påverkar den",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Regelbundet drickande höjer den: leverenzymet som gör jobbet induceras av användning. "
        "Den är i genomsnitt också något högre hos kvinnor, och lägre på tom mage eller vid "
        "leverproblem.",
    "Uncertainty": "Osäkerhet",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Vid noll är varje siffra ett enda tal — appens bästa uppskattning. Över noll visas "
        "samma siffror som intervall, och bandet i diagrammet breddas på motsvarande sätt.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Ett enda tal är lättare att lära sig av: med tiden får du reda på hur din egen 0,6 "
        "känns. Ett intervall är det mer bokstavliga svaret, eftersom hastigheten verkligen är "
        "osäker. Båda går att försvara — det här är ditt val.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Spridningen som din dryckesfrekvens antyder är ± %@ per timme.",
    "Rate": "Hastighet",
    "Range": "Intervall",
    "Advanced": "Avancerat",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Osäkerhet är en smaksak: den avgör om siffrorna läses som ett tal eller som ett "
        "intervall. Hastigheten nedanför är det inte — låt frågan om frekvens bestämma den, om "
        "du inte har en mätning att stämma av mot.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Flera personer",
    "History trends": "Trender i historiken",
    "Week": "Vecka",
    "Month": "Månad",
    "Year": "År",
    "Sober days": "Dagar utan alkohol",
    "Change": "Förändring",
    "before records": "före registreringen började",
    "See further back": "Se längre tillbaka",
    "Weeks, months and years side by side — and every evening older than seven days.": "Veckor, månader och år sida vid sida – och varje kväll äldre än sju dagar.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Allt du har loggat är redan sparat. Att låsa upp visar det bara.",
    "Coming soon": "Kommer snart",
    "Today": "Idag",
    "Trend": "Trend",
    "day": "dag",
    "Smoothing": "Utjämning",
    "%@ sessions": "%@ tillfällen",
    "No data before %@": "Inga data före %@",
    "vs.": "jfr",
    "Grams": "Gram",
    "Grams of alcohol": "Gram alkohol",
    "Standard units": "Standardenheter",
    "Period": "Period",
    "Switch person": "Byt person",
    "Add person": "Lägg till person",
    "New person": "Ny person",
    "You": "Du",
    "Name": "Namn",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Alla fyra påverkar kurvan, så ingen av dem går att gissa åt någon annan.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Deras egen gräns och de finare inställningarna kan ändras senare under fliken Profil, "
        "när de är den valda personen.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Snabbval",
    "Choose a favourite drink": "Välj en favoritdryck",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Välj drycken du brukar beställa, så loggar en knapp på Live-skärmen den med ett "
        "tryck.",
    "This is your quick-add drink": "Det här är ditt snabbval",
    "Set as my quick-add drink": "Använd som mitt snabbval",
    "This is now your usual": "Det här är nu din vanliga dryck",
    "Remove favourite": "Ta bort favorit",
    "Always add this one": "Lägg alltid till den här",
    "Logs it straight away, without opening anything.":
        "Loggar den direkt, utan att öppna något.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Ett tryck på Live-skärmen loggar den här, med den beräknade toppen på knappen. Hur "
        "full din mage är hämtas från drycken före, och kan rättas direkt efteråt.",
    "Peak %@": "Topp %@",
    "%@ added": "%@ har lagts till",
    "Save": "Spara",
    "Undo": "Ångra",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Säkerhetskopia",
    "Export a backup": "Exportera en säkerhetskopia",
    "Import a backup": "Importera en säkerhetskopia",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "En säkerhetskopia innehåller alla personer, tillfällen och drycker. En import lägger "
        "till det som saknas — den ändrar eller tar aldrig bort något som redan finns här.",
    "Import this backup?": "Importera den här säkerhetskopian?",
    "Import": "Importera",
    "Everything in this backup is already here.":
        "Allt i den här säkerhetskopian finns redan här.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Lägger till %@ tillfällen och %@ drycker. Inget som redan finns här ändras eller tas "
        "bort.",
    "Import finished": "Importen klar",
    "Added %@ occasions and %@ drinks.": "Lade till %@ tillfällen och %@ drycker.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Språk",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Öppnar den här appen i Inställningar, där ”Föredraget språk” ställer in appens eget "
        "språk — systemets förblir som det är. iOS startar om appen när du ändrar det.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Kunde inte importera",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Den här filen är ingen säkerhetskopia från DrinkSmart, eller så är den skadad.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Den här säkerhetskopian skapades av en nyare version av DrinkSmart. Uppdatera appen "
        "och försök igen.",
}
