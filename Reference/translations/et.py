"""
Estonian.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promill",
    "Percent": "Protsent",

    # --- DrinkCatalog: drink types ---
    "Beer": "Õlu",
    "Wine": "Vein",
    "Sparkling": "Vahuvein",
    "Spirit": "Kange alkohol",
    "Cocktail": "Kokteil",
    "Custom": "Kohandatud",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Tühi kõht",
    "Moderately full": "Keskmiselt täis",
    "Full stomach": "Täis kõht",
    "Empty": "Tühi",
    "Moderate": "Keskmine",
    "Full": "Täis",
    "Fast absorption, higher and earlier peak.": "Kiire imendumine, kõrgem ja varasem tipp.",
    "Moderate absorption.": "Keskmine imendumine.",
    "Slow absorption, lower and later peak.": "Aeglane imendumine, madalam ja hilisem tipp.",

    # --- DrinkingFrequency ---
    "Rarely": "Harva",
    "A few times a month": "Paar korda kuus",
    "Several times a week": "Mitu korda nädalas",
    "Almost daily": "Peaaegu iga päev",
    "A few occasions a year": "Paar korda aastas",
    "Social drinking": "Seltskondlik joomine",
    "Weekly routine": "Iganädalane rutiin",
    "Daily or nearly daily": "Iga päev või peaaegu iga päev",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Aeg",
    "Level": "Tase",
    "Lower": "Alumine",
    "Upper": "Ülemine",
    "Lower estimate": "Alumine hinnang",
    "Upper estimate": "Ülemine hinnang",
    "Personal limit": "Isiklik piir",
    "Drink": "Jook",

    # --- BACChartView ---
    "Expected peak around %@": "Eeldatav tipp umbes %@",
    "Peaked around %@": "Tipp oli umbes %@",
    "No active session": "Aktiivset joomiskorda pole",
    "Still rising": "Tõuseb veel",
    "YOUR LIMIT %@": "SINU PIIR %@",
    "possible range": "võimalik vahemik",
    "drag to read values": "lohista väärtuste lugemiseks",
    "release to go back": "tagasi minekuks lase lahti",
    "pour time": "joomise kestus",
    "in one go": "ühe korraga",

    # --- Live screen: the day with nothing on it ---
    "Live": "Hetkeseis",
    "Nothing logged today": "Täna pole midagi lisatud",
    "Add a drink when you have one.": "Lisa jook siis, kui selle võtad.",

    # --- Tabs and history ---
    "History": "Ajalugu",
    "No past sessions yet": "Varasemaid joomiskordi veel pole",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Joomiskord ilmub siia siis, kui see on lõppenud — kui su tase on kadunud ja paar "
        "tundi möödunud.",
    "%@ drinks": "Joogid: %@",
    "peak": "tipp",
    "Started": "Algas",
    "Lasted": "Kestis",
    "Calculated with your profile at the time": "Arvutatud toonase profiiliga",

    # --- TodayView ---
    "Profile": "Profiil",
    "estimated level": "hinnanguline tase",
    "estimated range": "hinnanguline vahemik",
    "Elapsed": "Möödunud",
    "Drinks": "Joogid",
    "Units": "Ühikud",
    "Expected to clear": "Eeldatavalt kaob",
    "Drinks this session": "Selle korra joogid",
    "This is an estimate, not a measurement.": "See on hinnang, mitte mõõtmistulemus.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Tegelikud väärtused erinevad inimeseti märgatavalt. Ära kunagi kasuta seda "
        "otsustamaks, kas võid autot juhtida.",
    "Add drink": "Lisa jook",

    # --- Editing an already logged drink ---
    "Edit drink": "Muuda jooki",
    "Save changes": "Salvesta muudatused",
    "With this": "Selle joogiga",
    "Delete": "Kustuta",
    "tap to edit · swipe to delete": "puuduta muutmiseks · nipsa kustutamiseks",

    # --- Drinking pace ---
    "How fast": "Kui kiiresti",
    "In one go": "Ühe korraga",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Loeb üheks sõõmuks — järsim võimalik tõus.",
    "A quick drink. The level climbs fast.": "Kiire jook. Tase tõuseb kiiresti.",
    "A normal pace.": "Tavaline tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Aeglaselt nauditud. Sama alkoholikoguse juures palju laugem tõus.",

    # --- AddDrinkSheet ---
    "Cancel": "Loobu",
    "Now": "Praegu",
    "Projected peak": "Prognoositav tipp",
    "Peak at": "Tipp kell",
    "Clears": "Kaob",
    "This would cross your limit": "See ületaks su piiri",
    "Around %@, for up to %@.": "Umbes %@, kuni %@ vältel.",
    "This might cross your limit": "See võib su piiri ületada",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Aeglasema ainevahetuse korral jah, kiirema korral ei. Selles ongi hinnangu "
        "ebakindlus.",
    "Type": "Tüüp",
    "Amount": "Kogus",
    "Strength": "Kangus",
    "%@ units": "Ühikud: %@",
    "%@ g alcohol": "%@ g alkoholi",
    "Stomach": "Kõht",
    "When": "Millal",
    "15 min ago": "15 min tagasi",
    "30 min ago": "30 min tagasi",
    "1 hr ago": "1 h tagasi",
    "Done": "Valmis",
    "Set exact time": "Määra täpne aeg",
    "Add": "Lisa",

    # --- ProfileSheet ---
    "Male": "Mees",
    "Female": "Naine",
    "Sex": "Sugu",
    "Weight": "Kaal",
    "Height": "Pikkus",
    "Age": "Vanus",
    "kg": "kg",
    "cm": "cm",
    "yrs": "a",
    "Body": "Keha",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Keha koguvesi tuleneb Watsoni võrranditest, mis määravad ruumala, millesse alkohol "
        "jaotub.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Keha koguvesi tuleneb Watsoni võrranditest, mis määravad ruumala, millesse alkohol "
        "jaotub. Naiste võrrand ei sisalda vanust, seega selle muutmine tulemust ei mõjuta.",
    "Drinking frequency": "Joomise sagedus",
    "How often do you drink?": "Kui tihti sa jood?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Nii me sinu lagundamiskiirust hindamegi. Regulaarne joomine aktiveerib maksa CYP2E1 "
        "raja, seega lagundavad sagedased joojad alkoholi kiiremini. See on mudeli nõrgim koht "
        "ja just seepärast saad täpsemate seadete all määrata, kui palju sellest ebakindlusest "
        "rakendus sulle näitab.",
    "Your limit": "Sinu piir",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Sinu enda võrdlusarv, mitte seaduslik piirmäär. Rakendus ütleb, kui kavandatud jook "
        "viiks sind sellest üle ja kui kaua sa sellest kõrgemal püsiksid.",
    "Unit": "Ühik",
    "Display": "Kuva",
    "Calculated values": "Arvutatud väärtused",
    "Total body water": "Keha koguvesi",
    "Distribution volume": "Jaotusruumala",
    "Widmark factor": "Widmarki tegur",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Widmarki tegur on meestel tavaliselt umbes 0,68 ja naistel 0,55. Kui sinu oma on "
        "sellest kaugel, tasub ülaltoodud väärtused üle vaadata.",
    "Elimination rate": "Lagundamiskiirus",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Kui kiiresti su maks alkoholi lagundab, kui see on juba imendunud — kõvera langeva "
        "poole kalle.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol lahkub kehast pigem ligikaudu püsiva koguse kaupa tunnis kui protsendina, "
        "sest ensüüm, mis seda lagundab, töötab peaaegu igal tasemel juba täisvõimsusel. Just "
        "seepärast on üldse olemas rusikareeglid nagu „üks jook tunnis“.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Selle seade juures kulub %@ kadumiseks umbes %@. Peaaegu kõik jäävad vahemikku %@ "
        "tunnis.",
    "How to find yours": "Kuidas enda oma leida",
    "With a breathalyser": "Alkomeetriga",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Puhu kaks korda, vähemalt tunniajase vahega, langeval poolel — kaks tundi või rohkem "
        "pärast viimast jooki, ilma et vahepeal midagi juurde võtaksid. Lahuta teine näit "
        "esimesest ja jaga nendevaheliste tundide arvuga.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Näiteks %@ ja %@ kaks tundi hiljem teeb %@ tunnis.",
    "Without one": "Ilma alkomeetrita",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Rakendus ütleb, millal ta eeldab sinu taseme kadumist. Kui oled kindlalt tavapärane "
        "juba tükk aega enne seda, on su kiirus seadest suurem — nihuta seda samm võrra "
        "ülespoole ja jälgi paari joomiskorra jooksul. Kui kadumine võtab ennustatust kauem, "
        "nihuta seda allapoole.",
    "What moves it": "Mis seda mõjutab",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Regulaarne joomine tõstab seda: maksaensüüm, mis selle töö ära teeb, aktiveerub "
        "kasutamisest. Keskmiselt on see naistel veidi kõrgem ning tühja kõhuga või "
        "maksaprobleemide korral madalam.",
    "Uncertainty": "Ebakindlus",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Nulli juures on iga näit üks arv — rakenduse parim hinnang. Nullist ülalpool "
        "näidatakse samu näite vahemikena ja graafiku riba laieneb vastavalt.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Üksiku arvu järgi on lihtsam õppida: aja jooksul saad teada, milline tundub sinu enda "
        "0,6. Vahemik on otsesem vastus, sest kiirus ongi ebakindel. Mõlemad on põhjendatud — "
        "see on sinu valik.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Sinu joomise sagedusest tulenev hajuvus on ± %@ tunnis.",
    "Rate": "Kiirus",
    "Range": "Vahemik",
    "Advanced": "Täpsemad seaded",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Ebakindlus on maitse asi: see otsustab, kas näite loetakse ühe arvuna või vahemikuna. "
        "Allpool olev kiirus ei ole maitse asi — jäta see sageduse küsimuse hooleks, kui sul "
        "pole mõõtmistulemust, millega seda kõrvutada.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Mitu inimest",
    "History trends": "Ajaloo suundumused",
    "Week": "Nädal",
    "Month": "Kuu",
    "Year": "Aasta",
    "Sober days": "Alkoholivabad päevad",
    "Change": "Muutus",
    "before records": "enne kirjete algust",
    "See further back": "Vaata kaugemale tagasi",
    "Weeks, months and years side by side — and every evening older than seven days.": "Nädalad, kuud ja aastad kõrvuti – ja iga üle seitsme päeva vanune õhtu.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Kõik, mille oled kirja pannud, on juba salvestatud. Avamine ainult näitab seda.",
    "Coming soon": "Peagi",
    "Today": "Täna",
    "Trend": "Trend",
    "day": "päev",
    "Smoothing": "Silumine",
    "%@ sessions": "%@ korda",
    "No data before %@": "Andmed puuduvad enne %@",
    "vs.": "võrreldes",
    "Grams": "Grammi",
    "Grams of alcohol": "Grammi alkoholi",
    "Standard units": "Standardühikud",
    "Period": "Periood",
    "Switch person": "Vaheta inimest",
    "Add person": "Lisa inimene",
    "New person": "Uus inimene",
    "You": "Sina",
    "Name": "Nimi",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Kõik neli muudavad kõverat, nii et ühtegi neist ei saa kellegi teise eest ära arvata.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Tema enda piiri ja peenemaid seadeid saab hiljem muuta Profiili vahekaardil, kui tema "
        "on valitud inimene.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Kiirlisamine",
    "Choose a favourite drink": "Vali lemmikjook",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Vali jook, mida tavaliselt tellid, ja Hetkeseisu ekraanil olev nupp salvestab selle "
        "ühe puudutusega.",
    "This is your quick-add drink": "See on sinu kiirlisamise jook",
    "Set as my quick-add drink": "Määra kiirlisamise joogiks",
    "This is now your usual": "See on nüüd sinu tavaline",
    "Remove favourite": "Eemalda lemmik",
    "Always add this one": "Lisa alati see",
    "Logs it straight away, without opening anything.":
        "Salvestab selle kohe, ilma midagi avamata.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Üks puudutus Hetkeseisu ekraanil salvestab selle ja nupul on näha prognoositav tipp. "
        "Kõhutäius võetakse eelmiselt joogilt ja seda saab kohe pärast parandada.",
    "Peak %@": "Tipp %@",
    "%@ added": "%@ lisatud",
    "Save": "Salvesta",
    "Undo": "Võta tagasi",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Varukoopia",
    "Export a backup": "Ekspordi varukoopia",
    "Import a backup": "Impordi varukoopia",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Varukoopia sisaldab kõiki inimesi, joomiskordi ja jooke. Importimine lisab selle, mis "
        "puudub — see ei muuda ega eemalda kunagi midagi, mis siin juba on.",
    "Import this backup?": "Kas importida see varukoopia?",
    "Import": "Impordi",
    "Everything in this backup is already here.": "Kõik selles varukoopias on juba siin.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Lisatavad joomiskorrad: %@, joogid: %@. Midagi siinolevast ei muudeta ega eemaldata.",
    "Import finished": "Importimine lõpetatud",
    "Added %@ occasions and %@ drinks.": "Lisatud joomiskorrad: %@, joogid: %@.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Keel",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Avab selle rakenduse Seadetes, kus „Eelistatud keel“ määrab rakenduse enda keele — "
        "süsteemi oma jääb samaks. iOS käivitab rakenduse muutmise järel uuesti.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Importimine ebaõnnestus",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "See fail ei ole DrinkSmarti varukoopia või on see kahjustatud.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "See varukoopia on tehtud DrinkSmarti uuema versiooniga. Uuenda rakendust ja proovi "
        "uuesti.",
}
