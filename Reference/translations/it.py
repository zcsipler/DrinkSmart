"""
Italian.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Per mille",
    "Percent": "Percentuale",

    # --- DrinkCatalog: drink types ---
    "Beer": "Birra",
    "Wine": "Vino",
    "Sparkling": "Spumante",
    "Spirit": "Superalcolico",
    "Cocktail": "Cocktail",
    "Custom": "Personalizzato",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Stomaco vuoto",
    "Moderately full": "Moderatamente pieno",
    "Full stomach": "Stomaco pieno",
    "Empty": "Vuoto",
    "Moderate": "Moderato",
    "Full": "Pieno",
    "Fast absorption, higher and earlier peak.":
        "Assorbimento rapido, picco più alto e più precoce.",
    "Moderate absorption.": "Assorbimento moderato.",
    "Slow absorption, lower and later peak.":
        "Assorbimento lento, picco più basso e più tardivo.",

    # --- DrinkingFrequency ---
    "Rarely": "Raramente",
    "A few times a month": "Qualche volta al mese",
    "Several times a week": "Più volte a settimana",
    "Almost daily": "Quasi ogni giorno",
    "A few occasions a year": "Qualche occasione all’anno",
    "Social drinking": "Bere in compagnia",
    "Weekly routine": "Abitudine settimanale",
    "Daily or nearly daily": "Ogni giorno o quasi",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Ora",
    "Level": "Livello",
    "Lower": "Inferiore",
    "Upper": "Superiore",
    "Lower estimate": "Stima inferiore",
    "Upper estimate": "Stima superiore",
    "Personal limit": "Limite personale",
    "Drink": "Drink",

    # --- BACChartView ---
    "Expected peak around %@": "Picco previsto intorno a %@",
    "Peaked around %@": "Picco intorno a %@",
    "No active session": "Nessuna sessione attiva",
    "Still rising": "Ancora in salita",
    "YOUR LIMIT %@": "IL TUO LIMITE %@",
    "possible range": "intervallo possibile",
    "drag to read values": "trascina per leggere i valori",
    "release to go back": "rilascia per tornare indietro",
    "pour time": "tempo di consumo",
    "in one go": "tutto d’un fiato",

    # --- Live screen: the day with nothing on it ---
    "Live": "Live",
    "Nothing logged today": "Niente registrato oggi",
    "Add a drink when you have one.": "Aggiungi un drink quando ne bevi uno.",

    # --- Tabs and history ---
    "History": "Cronologia",
    "No past sessions yet": "Ancora nessuna sessione passata",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Una sessione compare qui quando è finita: quando hai smaltito l’alcol e sono passate "
        "alcune ore.",
    "%@ drinks": "%@ drink",
    "peak": "picco",
    "Started": "Inizio",
    "Lasted": "Durata",
    "Calculated with your profile at the time": "Calcolato con il tuo profilo di allora",

    # --- TodayView ---
    "Profile": "Profilo",
    "estimated level": "livello stimato",
    "estimated range": "intervallo stimato",
    "Elapsed": "Trascorso",
    "Drinks": "Drink",
    "Units": "Unità",
    "Expected to clear": "Smaltimento previsto",
    "Drinks this session": "Drink di questa sessione",
    "This is an estimate, not a measurement.": "Questa è una stima, non una misurazione.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "I valori reali variano molto da persona a persona. Non usare mai questo dato per "
        "decidere se puoi guidare.",
    "Add drink": "Aggiungi drink",

    # --- Editing an already logged drink ---
    "Edit drink": "Modifica drink",
    "Save changes": "Salva le modifiche",
    "With this": "Con questo",
    "Delete": "Elimina",
    "tap to edit · swipe to delete": "tocca per modificare · scorri per eliminare",

    # --- Drinking pace ---
    "How fast": "Quanto in fretta",
    "In one go": "Tutto d’un fiato",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Conta come un solo sorso: la salita più ripida possibile.",
    "A quick drink. The level climbs fast.": "Un drink veloce. Il livello sale in fretta.",
    "A normal pace.": "Un ritmo normale.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Bevuto con calma. Salita molto più dolce a parità di alcol.",

    # --- AddDrinkSheet ---
    "Cancel": "Annulla",
    "Now": "Adesso",
    "Projected peak": "Picco previsto",
    "Peak at": "Picco alle",
    "Clears": "Smaltimento",
    "This would cross your limit": "Questo ti farebbe superare il limite",
    "Around %@, for up to %@.": "Intorno a %@, per un massimo di %@.",
    "This might cross your limit": "Questo potrebbe farti superare il limite",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Con un metabolismo più lento sì, con uno più rapido no. È l’incertezza della stima.",
    "Type": "Tipo",
    "Amount": "Quantità",
    "Strength": "Gradazione",
    "%@ units": "%@ unità",
    "%@ g alcohol": "%@ g di alcol",
    "Stomach": "Stomaco",
    "When": "Quando",
    "15 min ago": "15 min fa",
    "30 min ago": "30 min fa",
    "1 hr ago": "1 h fa",
    "Done": "Fine",
    "Set exact time": "Imposta l’ora esatta",
    "Add": "Aggiungi",

    # --- ProfileSheet ---
    "Male": "Maschio",
    "Female": "Femmina",
    "Sex": "Sesso",
    "Weight": "Peso",
    "Height": "Altezza",
    "Age": "Età",
    "kg": "kg",
    "cm": "cm",
    "yrs": "anni",
    "Body": "Corpo",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "L’acqua corporea totale deriva dalle equazioni di Watson, che definiscono il volume "
        "in cui l’alcol si distribuisce.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "L’acqua corporea totale deriva dalle equazioni di Watson, che definiscono il volume "
        "in cui l’alcol si distribuisce. L’equazione femminile non include l’età, quindi "
        "modificarla non cambierà il risultato.",
    "Drinking frequency": "Frequenza di consumo",
    "How often do you drink?": "Quanto spesso bevi?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "È così che stimiamo la tua velocità di eliminazione. Bere regolarmente induce la via "
        "epatica del CYP2E1, quindi chi beve spesso smaltisce l’alcol più in fretta. È il "
        "punto più debole del modello, ed è per questo che in Avanzate puoi impostare quanta "
        "parte di quell’incertezza l’app ti mostra.",
    "Your limit": "Il tuo limite",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Un tuo valore di riferimento, non un limite legale. L’app ti dice quando un drink in "
        "programma te lo farebbe superare, e per quanto tempo resteresti sopra.",
    "Unit": "Unità",
    "Display": "Visualizzazione",
    "Calculated values": "Valori calcolati",
    "Total body water": "Acqua corporea totale",
    "Distribution volume": "Volume di distribuzione",
    "Widmark factor": "Fattore di Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Il fattore di Widmark è di solito intorno a 0,68 per gli uomini e 0,55 per le donne. "
        "Se il tuo è molto distante, vale la pena controllare i valori qui sopra.",
    "Elimination rate": "Velocità di eliminazione",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Quanto in fretta il fegato smaltisce l’alcol una volta assorbito: la pendenza del "
        "versante discendente della curva.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "L’alcol se ne va a una quantità all’incirca fissa all’ora, non in percentuale, perché "
        "l’enzima che lo scompone lavora già a pieno regime a quasi qualsiasi livello. È per "
        "questo che esistono regole empiriche come «un drink all’ora».",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Con questa impostazione, per smaltire %@ servono circa %@. Quasi tutti rientrano tra "
        "%@ all’ora.",
    "How to find yours": "Come trovare la tua",
    "With a breathalyser": "Con un etilometro",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Soffia due volte, a distanza di almeno un’ora, sul versante discendente: due ore o "
        "più dopo l’ultimo drink, senza bere nulla nel frattempo. Sottrai la seconda lettura "
        "dalla prima e dividi per le ore che le separano.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Per esempio %@ e %@ due ore dopo danno %@ all’ora.",
    "Without one": "Senza",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "L’app ti dice quando prevede che avrai smaltito tutto. Se torni regolarmente alla "
        "normalità ben prima, la tua velocità è più alta dell’impostazione: alzala di un passo "
        "e osserva per qualche sessione. Se ci vuole più tempo del previsto, abbassala.",
    "What moves it": "Cosa la cambia",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Bere regolarmente la alza: l’enzima epatico che svolge il lavoro viene indotto "
        "dall’uso. In media è anche un po’ più alta nelle donne, e più bassa a stomaco vuoto o "
        "in presenza di problemi al fegato.",
    "Uncertainty": "Incertezza",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "A zero ogni valore è un numero singolo: la stima migliore dell’app. Sopra lo zero gli "
        "stessi valori sono mostrati come intervalli, e la banda sul grafico si allarga di "
        "conseguenza.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Su un numero singolo è più facile farsi l’occhio: col tempo scopri come ti senti al "
        "tuo 0,6. Un intervallo è la risposta più fedele, perché la velocità è davvero "
        "incerta. Entrambe le scelte sono valide: decidi tu.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "La dispersione suggerita dalla tua frequenza di consumo è ± %@ all’ora.",
    "Rate": "Velocità",
    "Range": "Intervallo",
    "Advanced": "Avanzate",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "L’incertezza è una questione di gusto: decide se i valori si leggono come un numero "
        "solo o come un intervallo. La velocità qui sotto non lo è: lasciala alla domanda "
        "sulla frequenza, a meno che tu non abbia una misurazione con cui confrontarla.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Più persone",
    "History trends": "Tendenze della cronologia",
    "Week": "Settimana",
    "Month": "Mese",
    "Year": "Anno",
    "Sober days": "Giorni senza alcol",
    "Change": "Variazione",
    "before records": "prima della registrazione",
    "See further back": "Guarda più indietro",
    "Weeks, months and years side by side — and every evening older than seven days.": "Settimane, mesi e anni affiancati, e ogni serata più vecchia di sette giorni.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Tutto ciò che hai registrato è già salvato. Sbloccare serve solo a mostrarlo.",
    "Coming soon": "Prossimamente",
    "Today": "Oggi",
    "Day": "Giorno",
    "Yesterday": "Ieri",
    "No drinks on this day": "Nessun drink in questo giorno",
    "Trend": "Tendenza",
    "day": "giorno",
    "Smoothing": "Livellamento",
    "%@ sessions": "%@ occasioni",
    "No data before %@": "Nessun dato prima del %@",
    "vs.": "vs.",
    "Grams": "Grammi",
    "Grams of alcohol": "Grammi di alcol",
    "Standard units": "Unità standard",
    "Period": "Periodo",
    "Switch person": "Cambia persona",
    "Add person": "Aggiungi persona",
    "New person": "Nuova persona",
    "You": "Tu",
    "Name": "Nome",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Tutti e quattro cambiano la curva, quindi nessuno di essi può essere indovinato per "
        "un’altra persona.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Il suo limite e le impostazioni più fini si possono cambiare in seguito nella scheda "
        "Profilo, mentre è la persona selezionata.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Aggiunta rapida",
    "Choose a favourite drink": "Scegli un drink preferito",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Scegli il drink che ordini di solito e un pulsante sulla schermata Live lo registrerà "
        "con un tocco.",
    "This is your quick-add drink": "È il tuo drink per l’aggiunta rapida",
    "Set as my quick-add drink": "Imposta come drink per l’aggiunta rapida",
    "This is now your usual": "Ora è il tuo drink abituale",
    "Remove favourite": "Rimuovi preferito",
    "Always add this one": "Aggiungi sempre questo",
    "Logs it straight away, without opening anything.":
        "Lo registra subito, senza aprire nulla.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Un tocco sulla schermata Live lo registra, con il picco previsto sul pulsante. Quanto "
        "è pieno lo stomaco viene dal drink precedente e si può correggere subito dopo.",
    "Peak %@": "Picco %@",
    "%@ added": "Hai aggiunto %@",
    "Save": "Salva",
    "Undo": "Annulla",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Backup",
    "Export a backup": "Esporta un backup",
    "Import a backup": "Importa un backup",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Un backup contiene tutte le persone, le occasioni e i drink. L’importazione aggiunge "
        "ciò che manca: non modifica né rimuove mai nulla di quanto è già qui.",
    "Import this backup?": "Importare questo backup?",
    "Import": "Importa",
    "Everything in this backup is already here.":
        "Tutto ciò che c’è in questo backup è già qui.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Aggiunge %@ occasioni e %@ drink. Nulla di quanto è già qui viene modificato o "
        "rimosso.",
    "Import finished": "Importazione completata",
    "Added %@ occasions and %@ drinks.": "Aggiunte %@ occasioni e %@ drink.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Lingua",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Apre questa app in Impostazioni, dove «Lingua preferita» imposta la lingua dell’app: "
        "quella del sistema resta com’è. iOS riavvia l’app quando la cambi.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Importazione non riuscita",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Questo file non è un backup di DrinkSmart, oppure è danneggiato.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Questo backup è stato creato da una versione più recente di DrinkSmart. Aggiorna "
        "l’app e riprova.",
}
