"""
Romanian.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promile",
    "Percent": "Procent",

    # --- DrinkCatalog: drink types ---
    "Beer": "Bere",
    "Wine": "Vin",
    "Sparkling": "Spumant",
    "Spirit": "Tărie",
    "Cocktail": "Cocktail",
    "Custom": "Personalizat",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Stomac gol",
    "Moderately full": "Stomac parțial plin",
    "Full stomach": "Stomac plin",
    "Empty": "Gol",
    "Moderate": "Moderat",
    "Full": "Plin",
    "Fast absorption, higher and earlier peak.":
        "Absorbție rapidă, vârf mai ridicat și mai devreme.",
    "Moderate absorption.": "Absorbție moderată.",
    "Slow absorption, lower and later peak.": "Absorbție lentă, vârf mai scăzut și mai târziu.",

    # --- DrinkingFrequency ---
    "Rarely": "Rar",
    "A few times a month": "De câteva ori pe lună",
    "Several times a week": "De câteva ori pe săptămână",
    "Almost daily": "Aproape zilnic",
    "A few occasions a year": "Câteva ocazii pe an",
    "Social drinking": "Consum social",
    "Weekly routine": "Rutină săptămânală",
    "Daily or nearly daily": "Zilnic sau aproape zilnic",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Oră",
    "Level": "Nivel",
    "Lower": "Inferior",
    "Upper": "Superior",
    "Lower estimate": "Estimare inferioară",
    "Upper estimate": "Estimare superioară",
    "Personal limit": "Limită personală",
    "Drink": "Băutură",

    # --- BACChartView ---
    "Expected peak around %@": "Vârf estimat în jurul orei %@",
    "Peaked around %@": "Vârf atins în jurul orei %@",
    "No active session": "Nicio sesiune activă",
    "Still rising": "Încă în creștere",
    "YOUR LIMIT %@": "LIMITA TA %@",
    "possible range": "interval posibil",
    "drag to read values": "trage pentru a citi valorile",
    "release to go back": "eliberează pentru a reveni",
    "pour time": "durata consumului",
    "in one go": "dintr-o dată",

    # --- Live screen: the day with nothing on it ---
    "Live": "Live",
    "Nothing logged today": "Nimic înregistrat azi",
    "Add a drink when you have one.": "Adaugă o băutură atunci când bei una.",

    # --- Tabs and history ---
    "History": "Istoric",
    "No past sessions yet": "Încă nicio sesiune anterioară",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "O sesiune apare aici după ce s-a încheiat — când alcoolul s-a eliminat complet și au "
        "trecut câteva ore.",
    "%@ drinks": "Băuturi: %@",
    "peak": "vârf",
    "Started": "A început",
    "Lasted": "A durat",
    "Calculated with your profile at the time": "Calculat cu profilul tău de la acel moment",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "nivel estimat",
    "estimated range": "interval estimat",
    "Elapsed": "Timp scurs",
    "Drinks": "Băuturi",
    "Units": "Unități",
    "Expected to clear": "Eliminare estimată",
    "Drinks this session": "Băuturi în această sesiune",
    "This is an estimate, not a measurement.": "Aceasta este o estimare, nu o măsurătoare.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Valorile reale variază considerabil de la o persoană la alta. Nu folosi niciodată "
        "acest lucru pentru a decide dacă poți conduce.",
    "Add drink": "Adaugă băutură",

    # --- Editing an already logged drink ---
    "Edit drink": "Editează băutura",
    "Save changes": "Salvează modificările",
    "With this": "Cu aceasta",
    "Delete": "Șterge",
    "tap to edit · swipe to delete": "apasă pentru editare · glisează pentru ștergere",

    # --- Drinking pace ---
    "How fast": "Cât de repede",
    "In one go": "Dintr-o dată",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Se consideră o singură înghițitură — cea mai abruptă creștere posibilă.",
    "A quick drink. The level climbs fast.": "O băutură consumată repede. Nivelul urcă rapid.",
    "A normal pace.": "Un ritm normal.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Băută încet. Creștere mult mai lină pentru aceeași cantitate de alcool.",

    # --- AddDrinkSheet ---
    "Cancel": "Renunță",
    "Now": "Acum",
    "Projected peak": "Vârf estimat",
    "Peak at": "Vârf la ora",
    "Clears": "Eliminare completă",
    "This would cross your limit": "Aceasta ar depăși limita ta",
    "Around %@, for up to %@.": "În jur de %@, timp de până la %@.",
    "This might cross your limit": "Aceasta ar putea depăși limita ta",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Cu un metabolism mai lent, da; cu unul mai rapid, nu. Aceasta este incertitudinea "
        "estimării.",
    "Type": "Tip",
    "Amount": "Cantitate",
    "Strength": "Concentrație",
    "%@ units": "Unități: %@",
    "%@ g alcohol": "%@ g alcool",
    "Stomach": "Stomac",
    "When": "Când",
    "15 min ago": "acum 15 min",
    "30 min ago": "acum 30 min",
    "1 hr ago": "acum 1 h",
    "Done": "Gata",
    "Set exact time": "Setează ora exactă",
    "Add": "Adaugă",

    # --- ProfileSheet ---
    "Male": "Masculin",
    "Female": "Feminin",
    "Sex": "Sex",
    "Weight": "Greutate",
    "Height": "Înălțime",
    "Age": "Vârstă",
    "kg": "kg",
    "cm": "cm",
    "yrs": "ani",
    "Body": "Corp",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Apa totală din organism provine din ecuațiile Watson, care stabilesc volumul în care "
        "se distribuie alcoolul.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Apa totală din organism provine din ecuațiile Watson, care stabilesc volumul în care "
        "se distribuie alcoolul. Ecuația pentru femei nu include vârsta, așa că modificarea ei "
        "nu va afecta rezultatul.",
    "Drinking frequency": "Frecvența consumului",
    "How often do you drink?": "Cât de des bei?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Așa estimăm rata ta de eliminare. Consumul regulat induce calea hepatică CYP2E1, așa "
        "că persoanele care beau frecvent elimină alcoolul mai repede. Este punctul cel mai "
        "slab al modelului, motiv pentru care poți stabili în secțiunea Avansat cât din "
        "această incertitudine îți arată aplicația.",
    "Your limit": "Limita ta",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Un reper stabilit de tine, nu o limită legală. Aplicația îți spune când o băutură "
        "planificată te-ar duce peste el și cât timp ai rămâne deasupra.",
    "Unit": "Unitate",
    "Display": "Afișare",
    "Calculated values": "Valori calculate",
    "Total body water": "Apa totală din organism",
    "Distribution volume": "Volum de distribuție",
    "Widmark factor": "Factorul Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Factorul Widmark este de obicei în jur de 0,68 la bărbați și 0,55 la femei. Dacă al "
        "tău este departe de aceste valori, merită să verifici valorile de mai sus.",
    "Elimination rate": "Rata de eliminare",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Cât de repede elimină ficatul tău alcoolul după ce a fost absorbit — panta părții "
        "descendente a curbei.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alcoolul se elimină într-o cantitate aproximativ fixă pe oră, nu ca procent, pentru "
        "că enzima care îl descompune funcționează deja la capacitate maximă la aproape orice "
        "nivel. De aceea există reguli empirice precum „o băutură pe oră”.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "La această setare, %@ se elimină în aproximativ %@. Aproape toată lumea se încadrează "
        "între %@ pe oră.",
    "How to find yours": "Cum să o afli pe a ta",
    "With a breathalyser": "Cu un etilotest",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Suflă de două ori, la cel puțin o oră distanță, pe partea descendentă — la două ore "
        "sau mai mult după ultima băutură, fără nimic între timp. Scade a doua valoare din "
        "prima și împarte la numărul de ore dintre ele.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "De exemplu, %@ și %@ două ore mai târziu înseamnă %@ pe oră.",
    "Without one": "Fără unul",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Aplicația îți spune când estimează că alcoolul se va elimina complet. Dacă revii "
        "constant la normal cu mult înainte de acel moment, rata ta este mai mare decât "
        "setarea — crește-o cu o treaptă și urmărește câteva sesiuni. Dacă durează mai mult "
        "decât estimarea, scade-o.",
    "What moves it": "Ce o influențează",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Consumul regulat o crește: enzima hepatică ce face această treabă este indusă de "
        "utilizare. În medie, este ușor mai mare la femei și mai mică pe stomacul gol sau în "
        "caz de probleme hepatice.",
    "Uncertainty": "Incertitudine",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "La zero, fiecare valoare este un singur număr — cea mai bună estimare a aplicației. "
        "Peste zero, aceleași valori sunt afișate ca intervale, iar banda de pe grafic se "
        "lărgește corespunzător.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Un singur număr e mai ușor de folosit ca reper: cu timpul afli cum se simte propriul "
        "tău 0,6. Un interval e răspunsul mai fidel realității, pentru că rata chiar este "
        "incertă. Ambele variante se susțin — tu decizi.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Marja sugerată de frecvența consumului tău este de ± %@ pe oră.",
    "Rate": "Rată",
    "Range": "Interval",
    "Advanced": "Avansat",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Incertitudinea ține de preferință: decide dacă valorile apar ca un singur număr sau "
        "ca un interval. Rata de mai jos nu ține de preferință — las-o pe seama întrebării "
        "despre frecvență, dacă nu ai o măsurătoare cu care să o compari.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Mai multe persoane",
    "History trends": "Tendințe ale istoricului",
    "Week": "Săptămână",
    "Month": "Lună",
    "Year": "An",
    "Dry days": "Zile fără alcool",
    "Change": "Schimbare",
    "before records": "înainte de începerea înregistrărilor",
    "See further back": "Privește mai departe în urmă",
    "Weeks, months and years side by side — and every evening older than seven days.": "Săptămâni, luni și ani unul lângă altul – și fiecare seară mai veche de șapte zile.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Tot ce ai înregistrat este deja salvat. Deblocarea doar îl afișează.",
    "Coming soon": "În curând",
    "Grams": "Grame",
    "Grams of alcohol": "Grame de alcool",
    "Standard units": "Unități standard",
    "Period": "Perioadă",
    "Switch person": "Schimbă persoana",
    "Add person": "Adaugă persoană",
    "New person": "Persoană nouă",
    "You": "Tu",
    "Name": "Nume",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Toate cele patru valori modifică curba, așa că niciuna nu poate fi ghicită pentru "
        "altcineva.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Limita proprie și setările mai fine pot fi modificate ulterior în fila Profil, cât "
        "timp este persoana selectată.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Adăugare rapidă",
    "Choose a favourite drink": "Alege o băutură preferată",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Alege băutura pe care o comanzi de obicei, iar un buton de pe ecranul Live o va "
        "înregistra dintr-o singură apăsare.",
    "This is your quick-add drink": "Aceasta este băutura ta pentru adăugare rapidă",
    "Set as my quick-add drink": "Setează ca băutură pentru adăugare rapidă",
    "This is now your usual": "Aceasta este acum băutura ta obișnuită",
    "Remove favourite": "Elimină băutura preferată",
    "Always add this one": "Adaugă mereu această băutură",
    "Logs it straight away, without opening anything.":
        "O înregistrează imediat, fără să deschidă nimic.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "O apăsare pe ecranul Live o înregistrează, cu vârful estimat afișat pe buton. Cât de "
        "plin e stomacul se preia de la băutura anterioară și poate fi corectat imediat după.",
    "Peak %@": "Vârf %@",
    "%@ added": "S-a adăugat %@",
    "Save": "Salvează",
    "Undo": "Anulează",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Copie de rezervă",
    "Export a backup": "Exportă o copie de rezervă",
    "Import a backup": "Importă o copie de rezervă",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "O copie de rezervă conține fiecare persoană, ocazie și băutură. Importul adaugă ce "
        "lipsește — nu modifică și nu șterge niciodată nimic din ce există deja aici.",
    "Import this backup?": "Imporți această copie de rezervă?",
    "Import": "Importă",
    "Everything in this backup is already here.":
        "Tot ce se află în această copie de rezervă există deja aici.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Ocazii de adăugat: %@. Băuturi de adăugat: %@. Nimic din ce există deja nu este "
        "modificat sau șters.",
    "Import finished": "Import finalizat",
    "Added %@ occasions and %@ drinks.": "Ocazii adăugate: %@. Băuturi adăugate: %@.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Limbă",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Deschide această aplicație în Configurări, unde „Limbă preferată” stabilește limba "
        "aplicației — cea a sistemului rămâne neschimbată. iOS repornește aplicația când o "
        "modifici.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Importul nu a reușit",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Acest fișier nu este o copie de rezervă DrinkSmart sau este deteriorat.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Această copie de rezervă a fost creată cu o versiune mai nouă a DrinkSmart. "
        "Actualizează aplicația și încearcă din nou.",
}
