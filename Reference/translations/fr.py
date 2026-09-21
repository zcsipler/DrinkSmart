"""
French.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Pour mille",
    "Percent": "Pourcentage",

    # --- DrinkCatalog: drink types ---
    "Beer": "Bière",
    "Wine": "Vin",
    "Sparkling": "Mousseux",
    "Spirit": "Spiritueux",
    "Cocktail": "Cocktail",
    "Custom": "Personnalisé",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Estomac vide",
    "Moderately full": "Moyennement plein",
    "Full stomach": "Estomac plein",
    "Empty": "Vide",
    "Moderate": "Moyen",
    "Full": "Plein",
    "Fast absorption, higher and earlier peak.":
        "Absorption rapide, pic plus haut et plus précoce.",
    "Moderate absorption.": "Absorption modérée.",
    "Slow absorption, lower and later peak.": "Absorption lente, pic plus bas et plus tardif.",

    # --- DrinkingFrequency ---
    "Rarely": "Rarement",
    "A few times a month": "Quelques fois par mois",
    "Several times a week": "Plusieurs fois par semaine",
    "Almost daily": "Presque tous les jours",
    "A few occasions a year": "Quelques fois par an",
    "Social drinking": "Consommation sociale",
    "Weekly routine": "Rythme hebdomadaire",
    "Daily or nearly daily": "Tous les jours ou presque",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Heure",
    "Level": "Taux",
    "Lower": "Basse",
    "Upper": "Haute",
    "Lower estimate": "Estimation basse",
    "Upper estimate": "Estimation haute",
    "Personal limit": "Limite personnelle",
    "Drink": "Verre",

    # --- BACChartView ---
    "Expected peak around %@": "Pic attendu vers %@",
    "Peaked around %@": "Pic atteint vers %@",
    "No active session": "Aucune session en cours",
    "Still rising": "Encore en hausse",
    "YOUR LIMIT %@": "TA LIMITE %@",
    "possible range": "fourchette possible",
    "drag to read values": "fais glisser pour lire les valeurs",
    "release to go back": "relâche pour revenir",
    "pour time": "durée de consommation",
    "in one go": "d'un trait",

    # --- Live screen: the day with nothing on it ---
    "Live": "Direct",
    "Nothing logged today": "Rien d'enregistré aujourd'hui",
    "Add a drink when you have one.": "Ajoute un verre quand tu en bois un.",

    # --- Tabs and history ---
    "History": "Historique",
    "No past sessions yet": "Aucune session passée pour l'instant",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Une session apparaît ici une fois terminée — quand ton taux est redescendu à zéro et "
        "que quelques heures se sont écoulées.",
    "%@ drinks": "%@ verres",
    "peak": "pic",
    "Started": "Début",
    "Lasted": "Durée",
    "Calculated with your profile at the time": "Calculé avec le profil que tu avais alors",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "taux estimé",
    "estimated range": "fourchette estimée",
    "Elapsed": "Écoulé",
    "Drinks": "Verres",
    "Units": "Unités",
    "Expected to clear": "Retour à zéro prévu",
    "Drinks this session": "Verres de cette session",
    "This is an estimate, not a measurement.": "C'est une estimation, pas une mesure.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Les valeurs réelles varient considérablement d'une personne à l'autre. Ne t'en sers "
        "jamais pour décider si tu peux conduire.",
    "Add drink": "Ajouter un verre",

    # --- Editing an already logged drink ---
    "Edit drink": "Modifier le verre",
    "Save changes": "Enregistrer les modifications",
    "With this": "Avec ce verre",
    "Delete": "Supprimer",
    "tap to edit · swipe to delete": "touche pour modifier · balaie pour supprimer",

    # --- Drinking pace ---
    "How fast": "À quelle vitesse",
    "In one go": "D'un trait",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Compte comme une seule gorgée — la montée la plus raide possible.",
    "A quick drink. The level climbs fast.": "Un verre bu vite. Le taux monte rapidement.",
    "A normal pace.": "Un rythme normal.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Bu lentement. Montée bien plus douce pour la même quantité d'alcool.",

    # --- AddDrinkSheet ---
    "Cancel": "Annuler",
    "Now": "Maintenant",
    "Projected peak": "Pic prévu",
    "Peak at": "Pic à",
    "Clears": "Retour à zéro",
    "This would cross your limit": "Cela dépasserait ta limite",
    "Around %@, for up to %@.": "Vers %@, pendant %@ au maximum.",
    "This might cross your limit": "Cela pourrait dépasser ta limite",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Avec un métabolisme plus lent, oui ; avec un plus rapide, non. C'est l'incertitude de "
        "l'estimation.",
    "Type": "Type",
    "Amount": "Quantité",
    "Strength": "Degré",
    "%@ units": "%@ unités",
    "%@ g alcohol": "%@ g d'alcool",
    "Stomach": "Estomac",
    "When": "Quand",
    "15 min ago": "il y a 15 min",
    "30 min ago": "il y a 30 min",
    "1 hr ago": "il y a 1 h",
    "Done": "Terminé",
    "Set exact time": "Définir l'heure exacte",
    "Add": "Ajouter",

    # --- ProfileSheet ---
    "Male": "Homme",
    "Female": "Femme",
    "Sex": "Sexe",
    "Weight": "Poids",
    "Height": "Taille",
    "Age": "Âge",
    "kg": "kg",
    "cm": "cm",
    "yrs": "ans",
    "Body": "Corps",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "L'eau corporelle totale vient des équations de Watson, qui déterminent le volume dans "
        "lequel l'alcool se répartit.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "L'eau corporelle totale vient des équations de Watson, qui déterminent le volume dans "
        "lequel l'alcool se répartit. L'équation féminine ne tient pas compte de l'âge : le "
        "modifier n'aura donc aucun effet sur le résultat.",
    "Drinking frequency": "Fréquence de consommation",
    "How often do you drink?": "À quelle fréquence bois-tu ?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "C'est ainsi que nous estimons ta vitesse d'élimination. Une consommation régulière "
        "induit la voie CYP2E1 du foie : les buveurs fréquents éliminent donc l'alcool plus "
        "vite. C'est le point le plus faible du modèle, et c'est pourquoi tu peux régler sous "
        "Avancé la part de cette incertitude que l'app te montre.",
    "Your limit": "Ta limite",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Ton propre repère, pas une limite légale. L'app t'indique quand un verre envisagé te "
        "ferait la dépasser, et pendant combien de temps tu resterais au-dessus.",
    "Unit": "Unité",
    "Display": "Affichage",
    "Calculated values": "Valeurs calculées",
    "Total body water": "Eau corporelle totale",
    "Distribution volume": "Volume de distribution",
    "Widmark factor": "Facteur de Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Le facteur de Widmark est généralement d'environ 0,68 chez les hommes et 0,55 chez "
        "les femmes. Si le tien s'en éloigne beaucoup, il vaut la peine de vérifier les "
        "valeurs ci-dessus.",
    "Elimination rate": "Vitesse d'élimination",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "À quelle vitesse ton foie élimine l'alcool une fois qu'il a été absorbé — la pente de "
        "la phase descendante de la courbe.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "L'alcool est éliminé à raison d'une quantité à peu près fixe par heure, et non d'un "
        "pourcentage, parce que l'enzyme qui le dégrade tourne déjà à pleine capacité à "
        "presque n'importe quel taux. C'est pour cela que des règles empiriques comme « un "
        "verre par heure » existent.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Avec ce réglage, %@ met environ %@ à redescendre à zéro. Presque tout le monde se "
        "situe entre %@ par heure.",
    "How to find yours": "Comment trouver la tienne",
    "With a breathalyser": "Avec un éthylotest",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Souffle deux fois, à au moins une heure d'intervalle, sur la phase descendante — deux "
        "heures ou plus après ton dernier verre, sans rien boire entre les deux. Soustrais la "
        "seconde mesure de la première et divise par le nombre d'heures qui les séparent.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Par exemple, %@ puis %@ deux heures plus tard donne %@ par heure.",
    "Without one": "Sans éthylotest",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "L'app t'indique quand elle prévoit ton retour à zéro. Si tu es systématiquement "
        "revenu à la normale bien avant, ta vitesse est plus élevée que le réglage — "
        "augmente-le d'un cran et observe pendant quelques sessions. Si cela prend plus de "
        "temps que prévu, baisse-le d'un cran.",
    "What moves it": "Ce qui la fait varier",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Une consommation régulière l'augmente : l'enzyme hépatique qui fait le travail est "
        "induite par l'usage. Elle est aussi légèrement plus élevée chez les femmes en "
        "moyenne, et plus basse à jeun ou en cas de problèmes de foie.",
    "Uncertainty": "Incertitude",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "À zéro, chaque valeur est un chiffre unique — la meilleure estimation de l'app. "
        "Au-dessus de zéro, les mêmes valeurs sont affichées sous forme de fourchettes, et la "
        "bande du graphique s'élargit en conséquence.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Un chiffre unique est plus facile à apprivoiser : avec le temps, tu découvres ce que "
        "représente ton propre 0,6. Une fourchette est la réponse la plus littérale, car la "
        "vitesse d'élimination est réellement incertaine. Les deux se défendent — à toi de "
        "choisir.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "L'écart suggéré par ta fréquence de consommation est de ± %@ par heure.",
    "Rate": "Vitesse",
    "Range": "Fourchette",
    "Advanced": "Avancé",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "L'incertitude est affaire de goût : elle détermine si les valeurs se lisent comme un "
        "chiffre unique ou comme une fourchette. La vitesse ci-dessous, non — laisse-la à la "
        "question sur la fréquence, sauf si tu as une mesure à laquelle la comparer.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Plusieurs personnes",
    "History trends": "Tendances de l’historique",
    "Week": "Semaine",
    "Month": "Mois",
    "Year": "Année",
    "Dry days": "Jours sans alcool",
    "Change": "Évolution",
    "before records": "avant le début du suivi",
    "See further back": "Voir plus loin en arrière",
    "Weeks, months and years side by side — and every evening older than seven days.": "Semaines, mois et années côte à côte – et chaque soirée de plus de sept jours.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Tout ce que vous avez saisi est déjà enregistré. Le déverrouillage ne fait que l’afficher.",
    "Coming soon": "Bientôt disponible",
    "Grams": "Grammes",
    "Grams of alcohol": "Grammes d’alcool",
    "Standard units": "Unités standard",
    "Period": "Période",
    "Switch person": "Changer de personne",
    "Add person": "Ajouter une personne",
    "New person": "Nouvelle personne",
    "You": "Toi",
    "Name": "Nom",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Les quatre modifient la courbe, donc aucun ne peut être deviné pour quelqu'un "
        "d'autre.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Sa limite personnelle et les réglages plus fins pourront être modifiés plus tard dans "
        "l'onglet Profil, lorsqu'elle est la personne sélectionnée.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Ajout rapide",
    "Choose a favourite drink": "Choisir un verre favori",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Choisis le verre que tu commandes d'habitude : un bouton sur l'écran Direct "
        "l'enregistrera en un seul appui.",
    "This is your quick-add drink": "C'est ton verre d'ajout rapide",
    "Set as my quick-add drink": "Définir comme mon verre d'ajout rapide",
    "This is now your usual": "C'est désormais ton verre habituel",
    "Remove favourite": "Retirer le favori",
    "Always add this one": "Toujours ajouter celui-ci",
    "Logs it straight away, without opening anything.":
        "L'enregistre immédiatement, sans rien ouvrir.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Un appui sur l'écran Direct l'enregistre, avec le pic prévu affiché sur le bouton. Le "
        "remplissage de ton estomac est repris du verre précédent, et peut être corrigé juste "
        "après.",
    "Peak %@": "Pic %@",
    "%@ added": "Ajout de %@",
    "Save": "Enregistrer",
    "Undo": "Annuler",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Sauvegarde",
    "Export a backup": "Exporter une sauvegarde",
    "Import a backup": "Importer une sauvegarde",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Une sauvegarde contient toutes les personnes, toutes les sessions et tous les verres. "
        "L'importation ajoute ce qui manque — elle ne modifie ni ne supprime jamais ce qui est "
        "déjà là.",
    "Import this backup?": "Importer cette sauvegarde ?",
    "Import": "Importer",
    "Everything in this backup is already here.":
        "Tout ce que contient cette sauvegarde est déjà là.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Ajoute %@ sessions et %@ verres. Rien de ce qui est déjà là n'est modifié ni "
        "supprimé.",
    "Import finished": "Importation terminée",
    "Added %@ occasions and %@ drinks.": "%@ sessions et %@ verres ajoutés.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Langue",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Ouvre cette app dans Réglages, où « Langue préférée » définit la langue de l'app "
        "elle-même — celle du système reste inchangée. iOS redémarre l'app quand tu la "
        "changes.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Importation impossible",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Ce fichier n'est pas une sauvegarde DrinkSmart, ou il est endommagé.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Cette sauvegarde a été créée avec une version plus récente de DrinkSmart. Mets l'app "
        "à jour et réessaie.",
}
