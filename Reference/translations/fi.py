"""
Finnish.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promille",
    "Percent": "Prosentti",

    # --- DrinkCatalog: drink types ---
    "Beer": "Olut",
    "Wine": "Viini",
    "Sparkling": "Kuohuviini",
    "Spirit": "Väkevä",
    "Cocktail": "Cocktail",
    "Custom": "Oma",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Tyhjä vatsa",
    "Moderately full": "Kohtalaisen täysi",
    "Full stomach": "Täysi vatsa",
    "Empty": "Tyhjä",
    "Moderate": "Kohtalainen",
    "Full": "Täysi",
    "Fast absorption, higher and earlier peak.":
        "Nopea imeytyminen, korkeampi ja aikaisempi huippu.",
    "Moderate absorption.": "Kohtalainen imeytyminen.",
    "Slow absorption, lower and later peak.":
        "Hidas imeytyminen, matalampi ja myöhäisempi huippu.",

    # --- DrinkingFrequency ---
    "Rarely": "Harvoin",
    "A few times a month": "Muutaman kerran kuukaudessa",
    "Several times a week": "Useita kertoja viikossa",
    "Almost daily": "Lähes päivittäin",
    "A few occasions a year": "Muutaman kerran vuodessa",
    "Social drinking": "Seurustelujuominen",
    "Weekly routine": "Viikoittainen tapa",
    "Daily or nearly daily": "Päivittäin tai lähes päivittäin",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Aika",
    "Level": "Taso",
    "Lower": "Alempi",
    "Upper": "Ylempi",
    "Lower estimate": "Alempi arvio",
    "Upper estimate": "Ylempi arvio",
    "Personal limit": "Oma raja",
    "Drink": "Juoma",

    # --- BACChartView ---
    "Expected peak around %@": "Huippu odotettavissa noin %@",
    "Peaked around %@": "Huippu oli noin %@",
    "No active session": "Ei aktiivista juomakertaa",
    "Still rising": "Yhä nousussa",
    "YOUR LIMIT %@": "OMA RAJASI %@",
    "possible range": "mahdollinen vaihteluväli",
    "drag to read values": "vedä lukeaksesi arvoja",
    "release to go back": "vapauta palataksesi",
    "pour time": "juomisaika",
    "in one go": "kerralla",

    # --- Live screen: the day with nothing on it ---
    "Live": "Live",
    "Nothing logged today": "Ei kirjauksia tänään",
    "Add a drink when you have one.": "Lisää juoma, kun juot sellaisen.",

    # --- Tabs and history ---
    "History": "Historia",
    "No past sessions yet": "Ei vielä menneitä juomakertoja",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Juomakerta ilmestyy tähän, kun se on päättynyt – kun tasosi on nollautunut ja muutama "
        "tunti on kulunut.",
    "%@ drinks": "%@ juomaa",
    "peak": "huippu",
    "Started": "Alkoi",
    "Lasted": "Kesto",
    "Calculated with your profile at the time": "Laskettu silloisella profiilillasi",

    # --- TodayView ---
    "Profile": "Profiili",
    "estimated level": "arvioitu taso",
    "estimated range": "arvioitu vaihteluväli",
    "Elapsed": "Kulunut",
    "Drinks": "Juomat",
    "Units": "Yksiköt",
    "Expected to clear": "Nollautuu arviolta",
    "Drinks this session": "Juomat tällä juomakerralla",
    "This is an estimate, not a measurement.": "Tämä on arvio, ei mittaus.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Todelliset arvot vaihtelevat huomattavasti yksilöiden välillä. Älä koskaan käytä tätä "
        "sen ratkaisemiseen, voitko ajaa.",
    "Add drink": "Lisää juoma",

    # --- Editing an already logged drink ---
    "Edit drink": "Muokkaa juomaa",
    "Save changes": "Tallenna muutokset",
    "With this": "Tämän kanssa",
    "Delete": "Poista",
    "tap to edit · swipe to delete": "napauta muokataksesi · pyyhkäise poistaaksesi",

    # --- Drinking pace ---
    "How fast": "Kuinka nopeasti",
    "In one go": "Kerralla",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Lasketaan yhdeksi kulaukseksi – jyrkin mahdollinen nousu.",
    "A quick drink. The level climbs fast.": "Nopea juoma. Taso nousee nopeasti.",
    "A normal pace.": "Tavallinen tahti.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Juotu hitaasti pitkän aikaa. Paljon loivempi nousu samalla alkoholimäärällä.",

    # --- AddDrinkSheet ---
    "Cancel": "Peruuta",
    "Now": "Nyt",
    "Projected peak": "Ennustettu huippu",
    "Peak at": "Huippu klo",
    "Clears": "Nollautuu",
    "This would cross your limit": "Tämä ylittäisi rajasi",
    "Around %@, for up to %@.": "Noin %@, enintään %@ ajan.",
    "This might cross your limit": "Tämä saattaa ylittää rajasi",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Hitaammalla aineenvaihdunnalla kyllä, nopeammalla ei. Se on arvion epävarmuus.",
    "Type": "Tyyppi",
    "Amount": "Määrä",
    "Strength": "Vahvuus",
    "%@ units": "%@ annosta",
    "%@ g alcohol": "%@ g alkoholia",
    "Stomach": "Vatsa",
    "When": "Milloin",
    "15 min ago": "15 min sitten",
    "30 min ago": "30 min sitten",
    "1 hr ago": "1 h sitten",
    "Done": "Valmis",
    "Set exact time": "Aseta tarkka aika",
    "Add": "Lisää",

    # --- ProfileSheet ---
    "Male": "Mies",
    "Female": "Nainen",
    "Sex": "Sukupuoli",
    "Weight": "Paino",
    "Height": "Pituus",
    "Age": "Ikä",
    "kg": "kg",
    "cm": "cm",
    "yrs": "v",
    "Body": "Keho",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Kehon kokonaisvesimäärä lasketaan Watsonin yhtälöillä, jotka määrittävät tilavuuden, "
        "johon alkoholi jakautuu.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Kehon kokonaisvesimäärä lasketaan Watsonin yhtälöillä, jotka määrittävät tilavuuden, "
        "johon alkoholi jakautuu. Naisten yhtälö ei sisällä ikää, joten sen muuttaminen ei "
        "vaikuta tulokseen.",
    "Drinking frequency": "Juomistiheys",
    "How often do you drink?": "Kuinka usein juot?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Näin arvioimme palamisnopeutesi. Säännöllinen juominen indusoi maksan CYP2E1-reittiä, "
        "joten usein juovilla alkoholi palaa nopeammin. Tämä on mallin heikoin kohta, ja siksi "
        "voit määrittää Lisäasetuksissa, kuinka paljon tästä epävarmuudesta sovellus näyttää "
        "sinulle.",
    "Your limit": "Rajasi",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Oma viitearvosi, ei laillinen raja. Sovellus kertoo, milloin suunniteltu juoma veisi "
        "sinut sen yli ja kuinka kauan pysyisit sen yläpuolella.",
    "Unit": "Yksikkö",
    "Display": "Esitystapa",
    "Calculated values": "Lasketut arvot",
    "Total body water": "Kehon kokonaisvesimäärä",
    "Distribution volume": "Jakautumistilavuus",
    "Widmark factor": "Widmarkin kerroin",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmarkin kerroin on tyypillisesti noin 0,68 miehillä ja 0,55 naisilla. Jos omasi "
        "poikkeaa siitä paljon, yllä olevat arvot kannattaa tarkistaa.",
    "Elimination rate": "Palamisnopeus",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Kuinka nopeasti maksasi polttaa alkoholin sen imeydyttyä – käyrän laskevan puolen "
        "jyrkkyys.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkoholi poistuu suunnilleen kiinteänä määränä tunnissa eikä prosenttiosuutena, koska "
        "sitä hajottava entsyymi toimii jo täydellä teholla lähes millä tahansa tasolla. Juuri "
        "siksi nyrkkisäännöt kuten ”yksi annos tunnissa” ovat ylipäätään olemassa.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Tällä asetuksella %@ nollautuu noin ajassa %@. Lähes kaikki osuvat välille %@ "
        "tunnissa.",
    "How to find yours": "Näin löydät omasi",
    "With a breathalyser": "Alkometrillä",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Puhalla kahdesti vähintään tunnin välein laskevalla puolella – kaksi tuntia tai "
        "enemmän viimeisen juoman jälkeen, eikä mitään siinä välissä. Vähennä jälkimmäinen "
        "lukema ensimmäisestä ja jaa niiden väliin jääneillä tunneilla.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Esimerkiksi %@ ja %@ kaksi tuntia myöhemmin tarkoittaa %@ tunnissa.",
    "Without one": "Ilman sitä",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Sovellus kertoo, milloin tasosi arviolta nollautuu. Jos olet luotettavasti taas "
        "normaalissa selvästi ennen sitä, palamisnopeutesi on asetusta suurempi – nosta sitä "
        "yksi pykälä ja seuraa muutaman juomakerran ajan. Jos se kestää ennustettua kauemmin, "
        "laske sitä.",
    "What moves it": "Mikä siihen vaikuttaa",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Säännöllinen juominen nostaa sitä: työn tekevä maksaentsyymi indusoituu käytöstä. Se "
        "on myös keskimäärin hieman korkeampi naisilla ja matalampi tyhjällä vatsalla tai "
        "maksavaivojen yhteydessä.",
    "Uncertainty": "Epävarmuus",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Nollassa jokainen luku on yksi arvo – sovelluksen paras arvio. Nollan yläpuolella "
        "samat luvut näytetään vaihteluväleinä, ja kuvaajan vyöhyke levenee vastaavasti.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Yhteen lukuun on helpompi oppia suhtautumaan: ajan myötä huomaat, miltä oma 0,6 "
        "tuntuu. Vaihteluväli on kirjaimellisempi vastaus, koska palamisnopeus on todella "
        "epävarma. Molemmat ovat perusteltuja – valinta on sinun.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Juomistiheytesi perusteella hajonta on ± %@ tunnissa.",
    "Rate": "Nopeus",
    "Range": "Vaihteluväli",
    "Advanced": "Lisäasetukset",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Epävarmuus on makuasia: se ratkaisee, näytetäänkö luvut yhtenä arvona vai "
        "vaihteluvälinä. Alla oleva nopeus ei ole makuasia – jätä se juomistiheyskysymyksen "
        "varaan, ellei sinulla ole mittausta, johon verrata sitä.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Useita henkilöitä",
    "History trends": "Historian trendit",
    "Week": "Viikko",
    "Month": "Kuukausi",
    "Year": "Vuosi",
    "Sober days": "Alkoholittomat päivät",
    "Change": "Muutos",
    "before records": "ennen kirjausten alkua",
    "See further back": "Katso kauemmas taakse",
    "Weeks, months and years side by side — and every evening older than seven days.": "Viikot, kuukaudet ja vuodet rinnakkain – ja jokainen yli seitsemän päivää vanha ilta.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Kaikki kirjaamasi on jo tallennettu. Avaaminen vain näyttää sen.",
    "Coming soon": "Tulossa pian",
    "Today": "Tänään",
    "Trend": "Trendi",
    "day": "päivä",
    "Smoothing": "Tasoitus",
    "%@ sessions": "%@ kertaa",
    "No data before %@": "Ei tietoja ennen %@",
    "vs.": "vrt.",
    "Grams": "Grammaa",
    "Grams of alcohol": "Grammaa alkoholia",
    "Standard units": "Vakioannokset",
    "Period": "Jakso",
    "Switch person": "Vaihda henkilöä",
    "Add person": "Lisää henkilö",
    "New person": "Uusi henkilö",
    "You": "Sinä",
    "Name": "Nimi",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Kaikki neljä muuttavat käyrää, joten mitään niistä ei voi arvata toisen puolesta.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Hänen oman rajansa ja tarkemmat asetuksensa voi muuttaa myöhemmin "
        "Profiili-välilehdellä silloin, kun hän on valittuna henkilönä.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Pikalisäys",
    "Choose a favourite drink": "Valitse suosikkijuoma",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Valitse juoma, jonka yleensä tilaat, niin Live-näytön painike kirjaa sen yhdellä "
        "napautuksella.",
    "This is your quick-add drink": "Tämä on pikalisäysjuomasi",
    "Set as my quick-add drink": "Aseta pikalisäysjuomakseni",
    "This is now your usual": "Tämä on nyt vakiojuomasi",
    "Remove favourite": "Poista suosikki",
    "Always add this one": "Lisää aina tämä",
    "Logs it straight away, without opening anything.": "Kirjaa sen heti avaamatta mitään.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Yksi napautus Live-näytöllä kirjaa tämän, ja painikkeessa näkyy ennustettu huippu. "
        "Vatsan täyteys periytyy sitä edeltäneestä juomasta, ja sen voi korjata heti "
        "jälkeenpäin.",
    "Peak %@": "Huippu %@",
    "%@ added": "%@ lisätty",
    "Save": "Tallenna",
    "Undo": "Kumoa",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Varmuuskopio",
    "Export a backup": "Vie varmuuskopio",
    "Import a backup": "Tuo varmuuskopio",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Varmuuskopio sisältää kaikki henkilöt, juomakerrat ja juomat. Tuonti lisää sen, mikä "
        "puuttuu – se ei koskaan muuta tai poista mitään, mikä on jo tallennettu.",
    "Import this backup?": "Tuodaanko tämä varmuuskopio?",
    "Import": "Tuo",
    "Everything in this backup is already here.":
        "Kaikki tässä varmuuskopiossa on jo tallennettu.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Lisää %@ juomakertaa ja %@ juomaa. Mitään jo tallennettua ei muuteta eikä poisteta.",
    "Import finished": "Tuonti valmis",
    "Added %@ occasions and %@ drinks.": "Lisätty %@ juomakertaa ja %@ juomaa.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Kieli",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Avaa tämän sovelluksen Asetuksissa, jossa ”Ensisijainen kieli” määrittää sovelluksen "
        "oman kielen – järjestelmän kieli pysyy ennallaan. iOS käynnistää sovelluksen "
        "uudelleen, kun vaihdat sitä.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Tuonti ei onnistunut",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Tämä tiedosto ei ole DrinkSmart-varmuuskopio tai se on vaurioitunut.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Tämä varmuuskopio on tehty DrinkSmartin uudemmalla versiolla. Päivitä sovellus ja "
        "yritä uudelleen.",
}
