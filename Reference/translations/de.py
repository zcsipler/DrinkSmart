"""
German.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promille",
    "Percent": "Prozent",

    # --- DrinkCatalog: drink types ---
    "Beer": "Bier",
    "Wine": "Wein",
    "Sparkling": "Sekt",
    "Spirit": "Spirituose",
    "Cocktail": "Cocktail",
    "Custom": "Eigenes",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Leerer Magen",
    "Moderately full": "Mäßig voll",
    "Full stomach": "Voller Magen",
    "Empty": "Leer",
    "Moderate": "Mäßig",
    "Full": "Voll",
    "Fast absorption, higher and earlier peak.":
        "Schnelle Aufnahme, höherer und früherer Höchstwert.",
    "Moderate absorption.": "Mäßige Aufnahme.",
    "Slow absorption, lower and later peak.":
        "Langsame Aufnahme, niedrigerer und späterer Höchstwert.",

    # --- DrinkingFrequency ---
    "Rarely": "Selten",
    "A few times a month": "Ein paar Mal im Monat",
    "Several times a week": "Mehrmals pro Woche",
    "Almost daily": "Fast täglich",
    "A few occasions a year": "Ein paar Mal im Jahr",
    "Social drinking": "Geselliges Trinken",
    "Weekly routine": "Wöchentliche Routine",
    "Daily or nearly daily": "Täglich oder fast täglich",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Zeit",
    "Level": "Alkoholspiegel",
    "Lower": "Untere",
    "Upper": "Obere",
    "Lower estimate": "Untere Schätzung",
    "Upper estimate": "Obere Schätzung",
    "Personal limit": "Persönliches Limit",
    "Drink": "Getränk",

    # --- BACChartView ---
    "Expected peak around %@": "Höchstwert voraussichtlich gegen %@",
    "Peaked around %@": "Höchstwert gegen %@",
    "No active session": "Keine aktive Sitzung",
    "Still rising": "Steigt noch",
    "YOUR LIMIT %@": "DEIN LIMIT %@",
    "possible range": "möglicher Bereich",
    "drag to read values": "ziehen, um Werte abzulesen",
    "release to go back": "loslassen, um zurückzugehen",
    "pour time": "Trinkdauer",
    "in one go": "in einem Zug",

    # --- Live screen: the day with nothing on it ---
    "Live": "Live",
    "Nothing logged today": "Heute nichts eingetragen",
    "Add a drink when you have one.": "Trag ein Getränk ein, wenn du eines trinkst.",

    # --- Tabs and history ---
    "History": "Verlauf",
    "No past sessions yet": "Noch keine vergangenen Sitzungen",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Eine Sitzung erscheint hier, sobald sie beendet ist — wenn dein Alkohol abgebaut ist "
        "und ein paar Stunden vergangen sind.",
    "%@ drinks": "%@ Getränke",
    "peak": "Höchstwert",
    "Started": "Begonnen",
    "Lasted": "Dauer",
    "Calculated with your profile at the time": "Berechnet mit deinem damaligen Profil",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "geschätzter Alkoholspiegel",
    "estimated range": "geschätzter Bereich",
    "Elapsed": "Vergangen",
    "Drinks": "Getränke",
    "Units": "Einheiten",
    "Expected to clear": "Voraussichtlich abgebaut",
    "Drinks this session": "Getränke in dieser Sitzung",
    "This is an estimate, not a measurement.": "Das ist eine Schätzung, keine Messung.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Die tatsächlichen Werte schwanken erheblich von Person zu Person. Entscheide damit "
        "nie, ob du fahren kannst.",
    "Add drink": "Getränk hinzufügen",

    # --- Editing an already logged drink ---
    "Edit drink": "Getränk bearbeiten",
    "Save changes": "Änderungen sichern",
    "With this": "Mit diesem Getränk",
    "Delete": "Löschen",
    "tap to edit · swipe to delete": "tippen zum Bearbeiten · wischen zum Löschen",

    # --- Drinking pace ---
    "How fast": "Wie schnell",
    "In one go": "In einem Zug",
    "15 min": "15 Min.",
    "30 min": "30 Min.",
    "1 hr": "1 Std.",
    "Counts as a single swallow — the steepest possible rise.":
        "Zählt als ein einziger Schluck — der steilstmögliche Anstieg.",
    "A quick drink. The level climbs fast.":
        "Schnell getrunken. Der Alkoholspiegel steigt rasch.",
    "A normal pace.": "Ein normales Tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Langsam getrunken. Deutlich sanfterer Anstieg bei gleicher Alkoholmenge.",

    # --- AddDrinkSheet ---
    "Cancel": "Abbrechen",
    "Now": "Jetzt",
    "Projected peak": "Erwarteter Höchstwert",
    "Peak at": "Höchstwert um",
    "Clears": "Abgebaut",
    "This would cross your limit": "Das würde dein Limit überschreiten",
    "Around %@, for up to %@.": "Etwa %@, für bis zu %@.",
    "This might cross your limit": "Das könnte dein Limit überschreiten",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Bei langsamerem Stoffwechsel ja, bei schnellerem nein. Das ist die Unsicherheit der "
        "Schätzung.",
    "Type": "Art",
    "Amount": "Menge",
    "Strength": "Stärke",
    "%@ units": "%@ Einheiten",
    "%@ g alcohol": "%@ g Alkohol",
    "Stomach": "Magen",
    "When": "Wann",
    "15 min ago": "vor 15 Min.",
    "30 min ago": "vor 30 Min.",
    "1 hr ago": "vor 1 Std.",
    "Done": "Fertig",
    "Set exact time": "Genaue Zeit festlegen",
    "Add": "Hinzufügen",

    # --- ProfileSheet ---
    "Male": "Männlich",
    "Female": "Weiblich",
    "Sex": "Geschlecht",
    "Weight": "Gewicht",
    "Height": "Größe",
    "Age": "Alter",
    "kg": "kg",
    "cm": "cm",
    "yrs": "Jahre",
    "Body": "Körper",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Das Gesamtkörperwasser stammt aus den Watson-Gleichungen, die das Volumen festlegen, "
        "in dem sich der Alkohol verteilt.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Das Gesamtkörperwasser stammt aus den Watson-Gleichungen, die das Volumen festlegen, "
        "in dem sich der Alkohol verteilt. Die Gleichung für Frauen enthält kein Alter, eine "
        "Änderung wirkt sich daher nicht auf das Ergebnis aus.",
    "Drinking frequency": "Trinkhäufigkeit",
    "How often do you drink?": "Wie oft trinkst du?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "So schätzen wir deine Abbaurate. Regelmäßiges Trinken induziert den "
        "CYP2E1-Stoffwechselweg der Leber, deshalb bauen häufig Trinkende Alkohol schneller "
        "ab. Das ist die schwächste Stelle des Modells, und deshalb kannst du unter "
        "„Erweitert“ einstellen, wie viel von dieser Unsicherheit die App dir zeigt.",
    "Your limit": "Dein Limit",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Deine eigene Bezugsgröße, kein gesetzlicher Grenzwert. Die App sagt dir, wann ein "
        "geplantes Getränk dich darüber hinausbringen würde und wie lange du darüber bleiben "
        "würdest.",
    "Unit": "Einheit",
    "Display": "Anzeige",
    "Calculated values": "Berechnete Werte",
    "Total body water": "Gesamtkörperwasser",
    "Distribution volume": "Verteilungsvolumen",
    "Widmark factor": "Widmark-Faktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Der Widmark-Faktor liegt typischerweise bei etwa 0,68 bei Männern und 0,55 bei "
        "Frauen. Wenn deiner weit davon entfernt ist, lohnt sich ein Blick auf die Werte oben.",
    "Elimination rate": "Abbaurate",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Wie schnell deine Leber Alkohol abbaut, sobald er aufgenommen ist — die Steigung der "
        "fallenden Seite der Kurve.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol wird pro Stunde in etwa gleichbleibender Menge abgebaut und nicht als Anteil, "
        "weil das abbauende Enzym schon bei fast jedem Spiegel mit voller Kapazität arbeitet. "
        "Nur deshalb gibt es Faustregeln wie „ein Getränk pro Stunde“.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Bei dieser Einstellung braucht %@ etwa %@ bis zum Abbau. Fast alle liegen zwischen %@ "
        "pro Stunde.",
    "How to find yours": "So findest du deine Rate",
    "With a breathalyser": "Mit einem Alkoholtester",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Blas zweimal, mit mindestens einer Stunde Abstand, auf der fallenden Seite — zwei "
        "Stunden oder mehr nach deinem letzten Getränk, ohne etwas dazwischen. Zieh den "
        "zweiten Wert vom ersten ab und teile durch die Stunden dazwischen.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Zum Beispiel: %@ und zwei Stunden später %@ ergibt %@ pro Stunde.",
    "Without one": "Ohne Alkoholtester",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Die App sagt dir, wann sie mit dem vollständigen Abbau rechnet. Wenn du verlässlich "
        "deutlich früher wieder normal bist, ist deine Rate höher als eingestellt — stell sie "
        "eine Stufe höher und beobachte ein paar Sitzungen. Dauert es länger als vorhergesagt, "
        "stell sie eine Stufe niedriger.",
    "What moves it": "Was sie beeinflusst",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Regelmäßiges Trinken erhöht sie: Das Leberenzym, das die Arbeit macht, wird durch "
        "Gebrauch induziert. Bei Frauen liegt sie im Mittel etwas höher, auf leeren Magen oder "
        "bei Leberproblemen niedriger.",
    "Uncertainty": "Unsicherheit",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Bei null ist jeder Wert eine einzelne Zahl — die beste Schätzung der App. Über null "
        "werden dieselben Werte als Bereiche angezeigt, und das Band im Diagramm wird "
        "entsprechend breiter.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "An einer einzelnen Zahl lässt sich leichter lernen: Mit der Zeit findest du heraus, "
        "wie sich deine eigenen 0,6 anfühlen. Ein Bereich ist die ehrlichere Antwort, denn die "
        "Abbaurate ist tatsächlich unsicher. Beides lässt sich vertreten — das ist deine "
        "Entscheidung.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Die aus deiner Trinkhäufigkeit abgeleitete Spanne beträgt ± %@ pro Stunde.",
    "Rate": "Rate",
    "Range": "Bereich",
    "Advanced": "Erweitert",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Unsicherheit ist Geschmackssache: Sie entscheidet, ob Werte als eine Zahl oder als "
        "Bereich erscheinen. Die Rate darunter ist es nicht — überlass sie der Frage nach der "
        "Häufigkeit, außer du hast eine Messung, mit der du sie abgleichen kannst.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Mehrere Personen",
    "History trends": "Verlaufstrends",
    "Week": "Woche",
    "Month": "Monat",
    "Year": "Jahr",
    "Sober days": "Trockene Tage",
    "Change": "Veränderung",
    "before records": "vor Beginn der Aufzeichnung",
    "See further back": "Weiter zurückblicken",
    "Weeks, months and years side by side — and every evening older than seven days.": "Wochen, Monate und Jahre nebeneinander – und jeder Abend, der älter als sieben Tage ist.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Alles, was du bisher eingetragen hast, ist bereits gespeichert. Das Freischalten zeigt es nur an.",
    "Coming soon": "Bald verfügbar",
    "Grams": "Gramm",
    "Grams of alcohol": "Gramm Alkohol",
    "Standard units": "Standardeinheiten",
    "Period": "Zeitraum",
    "Switch person": "Person wechseln",
    "Add person": "Person hinzufügen",
    "New person": "Neue Person",
    "You": "Du",
    "Name": "Name",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Alle vier verändern die Kurve, deshalb lässt sich keiner davon für jemand anderen "
        "schätzen.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Das eigene Limit und die feineren Einstellungen lassen sich später im Tab „Profil“ "
        "ändern, solange die Person ausgewählt ist.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Schnelleingabe",
    "Choose a favourite drink": "Lieblingsgetränk wählen",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Wähl das Getränk, das du sonst bestellst, dann trägt eine Taste auf dem "
        "Live-Bildschirm es mit einem Tippen ein.",
    "This is your quick-add drink": "Das ist dein Getränk für die Schnelleingabe",
    "Set as my quick-add drink": "Als Getränk für die Schnelleingabe festlegen",
    "This is now your usual": "Das ist jetzt dein Standardgetränk",
    "Remove favourite": "Favorit entfernen",
    "Always add this one": "Immer dieses hinzufügen",
    "Logs it straight away, without opening anything.":
        "Trägt es sofort ein, ohne dass sich etwas öffnet.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Ein Tippen auf dem Live-Bildschirm trägt das ein, mit dem erwarteten Höchstwert auf "
        "der Taste. Wie voll dein Magen ist, wird vom vorherigen Getränk übernommen und lässt "
        "sich direkt danach korrigieren.",
    "Peak %@": "Höchstwert %@",
    "%@ added": "%@ hinzugefügt",
    "Save": "Sichern",
    "Undo": "Rückgängig",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Backup",
    "Export a backup": "Backup exportieren",
    "Import a backup": "Backup importieren",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Ein Backup enthält alle Personen, Sitzungen und Getränke. Beim Import wird nur "
        "ergänzt, was fehlt — vorhandene Daten werden nie geändert oder entfernt.",
    "Import this backup?": "Dieses Backup importieren?",
    "Import": "Importieren",
    "Everything in this backup is already here.":
        "Alles aus diesem Backup ist bereits vorhanden.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Fügt %@ Sitzungen und %@ Getränke hinzu. Vorhandenes wird nicht geändert oder "
        "entfernt.",
    "Import finished": "Import abgeschlossen",
    "Added %@ occasions and %@ drinks.": "%@ Sitzungen und %@ Getränke hinzugefügt.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Sprache",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Öffnet diese App in den Einstellungen, wo „Bevorzugte Sprache“ die Sprache der App "
        "festlegt — die des Systems bleibt, wie sie ist. iOS startet die App neu, wenn du sie "
        "änderst.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Import nicht möglich",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Diese Datei ist kein DrinkSmart-Backup oder sie ist beschädigt.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Dieses Backup wurde mit einer neueren Version von DrinkSmart erstellt. Aktualisiere "
        "die App und versuch es erneut.",
}
