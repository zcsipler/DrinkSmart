"""
Greek.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Τοις χιλίοις",
    "Percent": "Τοις εκατό",

    # --- DrinkCatalog: drink types ---
    "Beer": "Μπίρα",
    "Wine": "Κρασί",
    "Sparkling": "Αφρώδες",
    "Spirit": "Απόσταγμα",
    "Cocktail": "Κοκτέιλ",
    "Custom": "Προσαρμοσμένο",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Άδειο στομάχι",
    "Moderately full": "Μέτρια γεμάτο",
    "Full stomach": "Γεμάτο στομάχι",
    "Empty": "Άδειο",
    "Moderate": "Μέτριο",
    "Full": "Γεμάτο",
    "Fast absorption, higher and earlier peak.":
        "Γρήγορη απορρόφηση, υψηλότερη και πιο πρώιμη αιχμή.",
    "Moderate absorption.": "Μέτρια απορρόφηση.",
    "Slow absorption, lower and later peak.":
        "Αργή απορρόφηση, χαμηλότερη και πιο όψιμη αιχμή.",

    # --- DrinkingFrequency ---
    "Rarely": "Σπάνια",
    "A few times a month": "Λίγες φορές τον μήνα",
    "Several times a week": "Αρκετές φορές την εβδομάδα",
    "Almost daily": "Σχεδόν καθημερινά",
    "A few occasions a year": "Λίγες φορές τον χρόνο",
    "Social drinking": "Κοινωνική κατανάλωση",
    "Weekly routine": "Εβδομαδιαία συνήθεια",
    "Daily or nearly daily": "Καθημερινά ή σχεδόν καθημερινά",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Ώρα",
    "Level": "Επίπεδο",
    "Lower": "Κάτω",
    "Upper": "Άνω",
    "Lower estimate": "Κατώτερη εκτίμηση",
    "Upper estimate": "Ανώτερη εκτίμηση",
    "Personal limit": "Προσωπικό όριο",
    "Drink": "Ποτό",

    # --- BACChartView ---
    "Expected peak around %@": "Αναμενόμενη αιχμή γύρω στις %@",
    "Peaked around %@": "Έφτασε στην αιχμή γύρω στις %@",
    "No active session": "Καμία ενεργή βραδιά",
    "Still rising": "Ακόμη ανεβαίνει",
    "YOUR LIMIT %@": "ΤΟ ΟΡΙΟ ΣΟΥ %@",
    "possible range": "πιθανό εύρος",
    "drag to read values": "σύρε για να δεις τιμές",
    "release to go back": "άσε για επιστροφή",
    "pour time": "χρόνος κατανάλωσης",
    "in one go": "μονορούφι",

    # --- Live screen: the day with nothing on it ---
    "Live": "Ζωντανά",
    "Nothing logged today": "Καμία καταγραφή σήμερα",
    "Add a drink when you have one.": "Πρόσθεσε ένα ποτό όταν το πίνεις.",

    # --- Tabs and history ---
    "History": "Ιστορικό",
    "No past sessions yet": "Δεν υπάρχουν προηγούμενες βραδιές ακόμη",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Μια βραδιά εμφανίζεται εδώ μόλις ολοκληρωθεί — όταν το επίπεδό σου έχει μηδενιστεί "
        "και έχουν περάσει μερικές ώρες.",
    "%@ drinks": "%@ ποτά",
    "peak": "αιχμή",
    "Started": "Ξεκίνησε",
    "Lasted": "Διήρκεσε",
    "Calculated with your profile at the time":
        "Υπολογίστηκε με το προφίλ σου εκείνη τη στιγμή",

    # --- TodayView ---
    "Profile": "Προφίλ",
    "estimated level": "εκτιμώμενο επίπεδο",
    "estimated range": "εκτιμώμενο εύρος",
    "Elapsed": "Έχει περάσει",
    "Drinks": "Ποτά",
    "Units": "Μονάδες",
    "Expected to clear": "Αναμένεται μηδενισμός",
    "Drinks this session": "Ποτά αυτή τη βραδιά",
    "This is an estimate, not a measurement.": "Αυτό είναι εκτίμηση, όχι μέτρηση.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Οι πραγματικές τιμές διαφέρουν σημαντικά από άτομο σε άτομο. Μη χρησιμοποιείς ποτέ "
        "αυτό για να αποφασίσεις αν μπορείς να οδηγήσεις.",
    "Add drink": "Προσθήκη ποτού",

    # --- Editing an already logged drink ---
    "Edit drink": "Επεξεργασία ποτού",
    "Save changes": "Αποθήκευση αλλαγών",
    "With this": "Με αυτό",
    "Delete": "Διαγραφή",
    "tap to edit · swipe to delete": "πάτα για επεξεργασία · σύρε για διαγραφή",

    # --- Drinking pace ---
    "How fast": "Πόσο γρήγορα",
    "In one go": "Μονορούφι",
    "15 min": "15 λεπτά",
    "30 min": "30 λεπτά",
    "1 hr": "1 ώρα",
    "Counts as a single swallow — the steepest possible rise.":
        "Μετράει ως μία γουλιά — η πιο απότομη δυνατή άνοδος.",
    "A quick drink. The level climbs fast.": "Γρήγορο ποτό. Το επίπεδο ανεβαίνει γρήγορα.",
    "A normal pace.": "Κανονικός ρυθμός.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Πίνεται αργά. Πολύ πιο ήπια άνοδος για το ίδιο αλκοόλ.",

    # --- AddDrinkSheet ---
    "Cancel": "Άκυρο",
    "Now": "Τώρα",
    "Projected peak": "Προβλεπόμενη αιχμή",
    "Peak at": "Αιχμή στις",
    "Clears": "Μηδενίζεται",
    "This would cross your limit": "Αυτό θα ξεπερνούσε το όριό σου",
    "Around %@, for up to %@.": "Γύρω στο %@, για έως και %@.",
    "This might cross your limit": "Αυτό μπορεί να ξεπεράσει το όριό σου",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Με πιο αργό μεταβολισμό ναι, με πιο γρήγορο όχι. Αυτή είναι η αβεβαιότητα της "
        "εκτίμησης.",
    "Type": "Τύπος",
    "Amount": "Ποσότητα",
    "Strength": "Περιεκτικότητα",
    "%@ units": "%@ μονάδες",
    "%@ g alcohol": "%@ g αλκοόλ",
    "Stomach": "Στομάχι",
    "When": "Πότε",
    "15 min ago": "Πριν από 15 λεπτά",
    "30 min ago": "Πριν από 30 λεπτά",
    "1 hr ago": "Πριν από 1 ώρα",
    "Done": "Τέλος",
    "Set exact time": "Ορισμός ακριβούς ώρας",
    "Add": "Προσθήκη",

    # --- ProfileSheet ---
    "Male": "Άνδρας",
    "Female": "Γυναίκα",
    "Sex": "Φύλο",
    "Weight": "Βάρος",
    "Height": "Ύψος",
    "Age": "Ηλικία",
    "kg": "kg",
    "cm": "cm",
    "yrs": "έτη",
    "Body": "Σώμα",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Το ολικό σωματικό νερό προκύπτει από τις εξισώσεις Watson, οι οποίες ορίζουν τον όγκο "
        "στον οποίο κατανέμεται το αλκοόλ.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Το ολικό σωματικό νερό προκύπτει από τις εξισώσεις Watson, οι οποίες ορίζουν τον όγκο "
        "στον οποίο κατανέμεται το αλκοόλ. Η εξίσωση για τις γυναίκες δεν περιλαμβάνει την "
        "ηλικία, οπότε η αλλαγή της δεν θα επηρεάσει το αποτέλεσμα.",
    "Drinking frequency": "Συχνότητα κατανάλωσης",
    "How often do you drink?": "Πόσο συχνά πίνεις;",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Έτσι εκτιμούμε τον ρυθμό αποβολής σου. Η τακτική κατανάλωση επάγει το μονοπάτι CYP2E1 "
        "του ήπατος, οπότε όσοι πίνουν συχνά αποβάλλουν το αλκοόλ γρηγορότερα. Είναι το πιο "
        "αδύναμο σημείο του μοντέλου, γι’ αυτό μπορείς να ορίσεις στις ρυθμίσεις «Για "
        "προχωρημένους» πόση από αυτή την αβεβαιότητα σού δείχνει η εφαρμογή.",
    "Your limit": "Το όριό σου",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Ο δικός σου αριθμός αναφοράς, όχι νόμιμο όριο. Η εφαρμογή σού λέει πότε ένα ποτό που "
        "σχεδιάζεις θα σε περνούσε πάνω από αυτό και για πόση ώρα θα έμενες από πάνω.",
    "Unit": "Μονάδα",
    "Display": "Εμφάνιση",
    "Calculated values": "Υπολογισμένες τιμές",
    "Total body water": "Ολικό σωματικό νερό",
    "Distribution volume": "Όγκος κατανομής",
    "Widmark factor": "Παράγοντας Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Ο παράγοντας Widmark είναι συνήθως γύρω στο 0,68 για τους άνδρες και 0,55 για τις "
        "γυναίκες. Αν ο δικός σου απέχει πολύ από αυτά, αξίζει να ελέγξεις τις παραπάνω τιμές.",
    "Elimination rate": "Ρυθμός αποβολής",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Πόσο γρήγορα το συκώτι σου αποβάλλει το αλκοόλ αφού απορροφηθεί — η κλίση της "
        "κατιούσας πλευράς της καμπύλης.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Το αλκοόλ αποβάλλεται σε περίπου σταθερή ποσότητα ανά ώρα και όχι ως ποσοστό, επειδή "
        "το ένζυμο που το διασπά λειτουργεί ήδη στο μέγιστο σχεδόν σε κάθε επίπεδο. Γι’ αυτό "
        "υπάρχουν εξαρχής εμπειρικοί κανόνες όπως «ένα ποτό την ώρα».",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Με αυτή τη ρύθμιση, %@ χρειάζεται περίπου %@ για να μηδενιστεί. Σχεδόν όλοι "
        "βρίσκονται μεταξύ %@ ανά ώρα.",
    "How to find yours": "Πώς να βρεις τον δικό σου",
    "With a breathalyser": "Με αλκοτέστ",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Φύσα δύο φορές, με απόσταση τουλάχιστον μίας ώρας, στην κατιούσα πλευρά — δύο ώρες ή "
        "περισσότερο μετά το τελευταίο σου ποτό, χωρίς τίποτα ενδιάμεσα. Αφαίρεσε τη δεύτερη "
        "ένδειξη από την πρώτη και διαίρεσε με τις ώρες που μεσολάβησαν.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Για παράδειγμα %@ και %@ δύο ώρες αργότερα βγάζει %@ ανά ώρα.",
    "Without one": "Χωρίς αυτό",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Η εφαρμογή σού λέει πότε αναμένει να μηδενιστείς. Αν σταθερά επανέρχεσαι στο "
        "φυσιολογικό αρκετά πριν από τότε, ο ρυθμός σου είναι υψηλότερος από τη ρύθμιση — "
        "ανέβασέ την ένα βήμα και παρακολούθησε για μερικές βραδιές. Αν χρειάζεται περισσότερο "
        "απ’ ό,τι προβλέπεται, κατέβασέ την.",
    "What moves it": "Τι τον μεταβάλλει",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Η τακτική κατανάλωση τον αυξάνει: το ηπατικό ένζυμο που κάνει τη δουλειά επάγεται από "
        "τη χρήση. Είναι επίσης κατά μέσο όρο ελαφρώς υψηλότερος στις γυναίκες και χαμηλότερος "
        "με άδειο στομάχι ή σε πρόβλημα του ήπατος.",
    "Uncertainty": "Αβεβαιότητα",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Στο μηδέν κάθε τιμή είναι ένας μόνο αριθμός — η καλύτερη εκτίμηση της εφαρμογής. Πάνω "
        "από το μηδέν οι ίδιες τιμές εμφανίζονται ως εύρη και η ζώνη στο γράφημα πλαταίνει "
        "ανάλογα.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Με έναν μόνο αριθμό μαθαίνεις πιο εύκολα: με τον καιρό ανακαλύπτεις πώς νιώθεις στο "
        "δικό σου 0,6. Το εύρος είναι η πιο κυριολεκτική απάντηση, γιατί ο ρυθμός είναι όντως "
        "αβέβαιος. Και τα δύο στέκουν — η επιλογή είναι δική σου.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Η διασπορά που προκύπτει από τη συχνότητα κατανάλωσής σου είναι ± %@ ανά ώρα.",
    "Rate": "Ρυθμός",
    "Range": "Εύρος",
    "Advanced": "Για προχωρημένους",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Η αβεβαιότητα είναι θέμα προτίμησης: καθορίζει αν οι τιμές διαβάζονται ως ένας "
        "αριθμός ή ως εύρος. Ο ρυθμός παρακάτω δεν είναι — άφησέ τον στην ερώτηση για τη "
        "συχνότητα, εκτός αν έχεις μια μέτρηση για να τον συγκρίνεις.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Πολλά άτομα",
    "History trends": "Τάσεις ιστορικού",
    "Week": "Εβδομάδα",
    "Month": "Μήνας",
    "Year": "Έτος",
    "Sober days": "Ημέρες χωρίς αλκοόλ",
    "Change": "Μεταβολή",
    "before records": "πριν από την έναρξη καταγραφής",
    "See further back": "Δείτε πιο πίσω",
    "Weeks, months and years side by side — and every evening older than seven days.": "Εβδομάδες, μήνες και χρόνια το ένα δίπλα στο άλλο – και κάθε βραδιά παλαιότερη από επτά ημέρες.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Όλα όσα έχετε καταγράψει είναι ήδη αποθηκευμένα. Το ξεκλείδωμα απλώς τα εμφανίζει.",
    "Coming soon": "Σύντομα",
    "Grams": "Γραμμάρια",
    "Grams of alcohol": "Γραμμάρια αλκοόλ",
    "Standard units": "Τυπικές μονάδες",
    "Period": "Περίοδος",
    "Switch person": "Αλλαγή ατόμου",
    "Add person": "Προσθήκη ατόμου",
    "New person": "Νέο άτομο",
    "You": "Εσύ",
    "Name": "Όνομα",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Και τα τέσσερα αλλάζουν την καμπύλη, οπότε κανένα δεν μπορεί να μαντευτεί για κάποιον "
        "άλλον.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Το δικό τους όριο και οι λεπτομερέστερες ρυθμίσεις μπορούν να αλλάξουν αργότερα στην "
        "καρτέλα «Προφίλ», όσο είναι το επιλεγμένο άτομο.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Γρήγορη προσθήκη",
    "Choose a favourite drink": "Διάλεξε ένα αγαπημένο ποτό",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Διάλεξε το ποτό που συνήθως παραγγέλνεις και ένα κουμπί στην οθόνη «Ζωντανά» θα το "
        "καταγράφει με ένα πάτημα.",
    "This is your quick-add drink": "Αυτό είναι το ποτό γρήγορης προσθήκης σου",
    "Set as my quick-add drink": "Ορισμός ως ποτό γρήγορης προσθήκης",
    "This is now your usual": "Αυτό είναι πλέον το συνηθισμένο σου",
    "Remove favourite": "Αφαίρεση αγαπημένου",
    "Always add this one": "Να προστίθεται πάντα αυτό",
    "Logs it straight away, without opening anything.":
        "Το καταγράφει αμέσως, χωρίς να ανοίξει τίποτα.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Ένα πάτημα στην οθόνη «Ζωντανά» το καταγράφει, με την προβλεπόμενη αιχμή πάνω στο "
        "κουμπί. Το πόσο γεμάτο είναι το στομάχι σου προκύπτει από το προηγούμενο ποτό και "
        "μπορεί να διορθωθεί αμέσως μετά.",
    "Peak %@": "Αιχμή %@",
    "%@ added": "Προστέθηκε %@",
    "Save": "Αποθήκευση",
    "Undo": "Αναίρεση",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Αντίγραφο ασφαλείας",
    "Export a backup": "Εξαγωγή αντιγράφου ασφαλείας",
    "Import a backup": "Εισαγωγή αντιγράφου ασφαλείας",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Ένα αντίγραφο ασφαλείας περιέχει κάθε άτομο, βραδιά και ποτό. Η εισαγωγή προσθέτει "
        "ό,τι λείπει — δεν αλλάζει και δεν αφαιρεί ποτέ κάτι που υπάρχει ήδη εδώ.",
    "Import this backup?": "Εισαγωγή αυτού του αντιγράφου ασφαλείας;",
    "Import": "Εισαγωγή",
    "Everything in this backup is already here.":
        "Όλα όσα περιέχει αυτό το αντίγραφο ασφαλείας υπάρχουν ήδη εδώ.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Προσθέτει %@ βραδιές και %@ ποτά. Τίποτα από όσα υπάρχουν ήδη δεν αλλάζει ούτε "
        "αφαιρείται.",
    "Import finished": "Η εισαγωγή ολοκληρώθηκε",
    "Added %@ occasions and %@ drinks.": "Προστέθηκαν %@ βραδιές και %@ ποτά.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Γλώσσα",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Ανοίγει αυτή την εφαρμογή στις Ρυθμίσεις, όπου η «Προτιμώμενη γλώσσα» ορίζει τη "
        "γλώσσα της ίδιας της εφαρμογής — του συστήματος παραμένει ως έχει. Το iOS κάνει "
        "επανεκκίνηση της εφαρμογής όταν την αλλάζεις.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Δεν ήταν δυνατή η εισαγωγή",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Αυτό το αρχείο δεν είναι αντίγραφο ασφαλείας του DrinkSmart ή είναι κατεστραμμένο.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Αυτό το αντίγραφο ασφαλείας δημιουργήθηκε από νεότερη έκδοση του DrinkSmart. "
        "Ενημέρωσε την εφαρμογή και δοκίμασε ξανά.",
}
