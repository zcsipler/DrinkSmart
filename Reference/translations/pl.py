"""
Polish.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Promile",
    "Percent": "Procent",

    # --- DrinkCatalog: drink types ---
    "Beer": "Piwo",
    "Wine": "Wino",
    "Sparkling": "Musujące",
    "Spirit": "Mocny alkohol",
    "Cocktail": "Koktajl",
    "Custom": "Własny",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Pusty żołądek",
    "Moderately full": "Średnio pełny",
    "Full stomach": "Pełny żołądek",
    "Empty": "Pusty",
    "Moderate": "Średni",
    "Full": "Pełny",
    "Fast absorption, higher and earlier peak.":
        "Szybkie wchłanianie, wyższy i wcześniejszy szczyt.",
    "Moderate absorption.": "Umiarkowane wchłanianie.",
    "Slow absorption, lower and later peak.":
        "Powolne wchłanianie, niższy i późniejszy szczyt.",

    # --- DrinkingFrequency ---
    "Rarely": "Rzadko",
    "A few times a month": "Kilka razy w miesiącu",
    "Several times a week": "Kilka razy w tygodniu",
    "Almost daily": "Prawie codziennie",
    "A few occasions a year": "Kilka okazji w roku",
    "Social drinking": "Picie towarzyskie",
    "Weekly routine": "Tygodniowa rutyna",
    "Daily or nearly daily": "Codziennie lub prawie codziennie",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Czas",
    "Level": "Poziom",
    "Lower": "Dolne",
    "Upper": "Górne",
    "Lower estimate": "Dolne oszacowanie",
    "Upper estimate": "Górne oszacowanie",
    "Personal limit": "Osobisty limit",
    "Drink": "Drink",

    # --- BACChartView ---
    "Expected peak around %@": "Szczyt spodziewany około %@",
    "Peaked around %@": "Szczyt był około %@",
    "No active session": "Brak aktywnej sesji",
    "Still rising": "Nadal rośnie",
    "YOUR LIMIT %@": "TWÓJ LIMIT %@",
    "possible range": "możliwy zakres",
    "drag to read values": "przeciągnij, aby odczytać wartości",
    "release to go back": "puść, aby wrócić",
    "pour time": "czas picia",
    "in one go": "duszkiem",

    # --- Live screen: the day with nothing on it ---
    "Live": "Na żywo",
    "Nothing logged today": "Nic dziś nie zapisano",
    "Add a drink when you have one.": "Dodaj drinka, kiedy go wypijesz.",

    # --- Tabs and history ---
    "History": "Historia",
    "No past sessions yet": "Brak wcześniejszych sesji",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Sesja pojawia się tutaj po zakończeniu — gdy twój poziom zejdzie do zera i minie "
        "kilka godzin.",
    "%@ drinks": "Drinki: %@",
    "peak": "szczyt",
    "Started": "Początek",
    "Lasted": "Trwała",
    "Calculated with your profile at the time":
        "Obliczone na podstawie twojego ówczesnego profilu",

    # --- TodayView ---
    "Profile": "Profil",
    "estimated level": "szacowany poziom",
    "estimated range": "szacowany zakres",
    "Elapsed": "Upłynęło",
    "Drinks": "Drinki",
    "Units": "Jednostki",
    "Expected to clear": "Przewidywane zejście do zera",
    "Drinks this session": "Drinki w tej sesji",
    "This is an estimate, not a measurement.": "To jest oszacowanie, nie pomiar.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Rzeczywiste wartości różnią się znacznie między osobami. Nigdy nie używaj tego do "
        "oceny, czy możesz prowadzić.",
    "Add drink": "Dodaj drinka",

    # --- Editing an already logged drink ---
    "Edit drink": "Edytuj drinka",
    "Save changes": "Zapisz zmiany",
    "With this": "Z nim",
    "Delete": "Usuń",
    "tap to edit · swipe to delete": "dotknij, aby edytować · przesuń, aby usunąć",

    # --- Drinking pace ---
    "How fast": "Jak szybko",
    "In one go": "Duszkiem",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 godz.",
    "Counts as a single swallow — the steepest possible rise.":
        "Liczy się jako jeden łyk — najbardziej stromy możliwy wzrost.",
    "A quick drink. The level climbs fast.": "Szybki drink. Poziom rośnie szybko.",
    "A normal pace.": "Normalne tempo.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Pity powoli. Dużo łagodniejszy wzrost przy tej samej ilości alkoholu.",

    # --- AddDrinkSheet ---
    "Cancel": "Anuluj",
    "Now": "Teraz",
    "Projected peak": "Przewidywany szczyt",
    "Peak at": "Szczyt o",
    "Clears": "Zejście do zera",
    "This would cross your limit": "To przekroczyłoby twój limit",
    "Around %@, for up to %@.": "Około %@, przez maksymalnie %@.",
    "This might cross your limit": "To może przekroczyć twój limit",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Przy wolniejszym metabolizmie tak, przy szybszym nie. Na tym polega niepewność tego "
        "oszacowania.",
    "Type": "Rodzaj",
    "Amount": "Ilość",
    "Strength": "Moc",
    "%@ units": "Jednostki: %@",
    "%@ g alcohol": "%@ g alkoholu",
    "Stomach": "Żołądek",
    "When": "Kiedy",
    "15 min ago": "15 min temu",
    "30 min ago": "30 min temu",
    "1 hr ago": "1 godz. temu",
    "Done": "Gotowe",
    "Set exact time": "Ustaw dokładną godzinę",
    "Add": "Dodaj",

    # --- ProfileSheet ---
    "Male": "Mężczyzna",
    "Female": "Kobieta",
    "Sex": "Płeć",
    "Weight": "Waga",
    "Height": "Wzrost",
    "Age": "Wiek",
    "kg": "kg",
    "cm": "cm",
    "yrs": "lat",
    "Body": "Ciało",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Całkowita woda ustrojowa pochodzi z równań Watsona, które wyznaczają objętość, w "
        "jakiej rozprowadza się alkohol.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Całkowita woda ustrojowa pochodzi z równań Watsona, które wyznaczają objętość, w "
        "jakiej rozprowadza się alkohol. Równanie dla kobiet nie uwzględnia wieku, więc jego "
        "zmiana nie wpłynie na wynik.",
    "Drinking frequency": "Częstotliwość picia",
    "How often do you drink?": "Jak często pijesz?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Tak szacujemy twoje tempo eliminacji. Regularne picie indukuje wątrobowy szlak "
        "CYP2E1, więc osoby pijące często usuwają alkohol szybciej. To najsłabszy punkt modelu "
        "i dlatego w ustawieniach zaawansowanych możesz określić, jak dużo tej niepewności "
        "aplikacja ci pokazuje.",
    "Your limit": "Twój limit",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Twoja własna liczba odniesienia, nie limit prawny. Aplikacja informuje, kiedy "
        "planowany drink przekroczyłby ten poziom i jak długo pozostaniesz powyżej.",
    "Unit": "Jednostka",
    "Display": "Wyświetlanie",
    "Calculated values": "Wartości obliczone",
    "Total body water": "Całkowita woda ustrojowa",
    "Distribution volume": "Objętość dystrybucji",
    "Widmark factor": "Współczynnik Widmarka",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Współczynnik Widmarka wynosi zwykle około 0,68 u mężczyzn i 0,55 u kobiet. Jeśli twój "
        "jest daleki od tych wartości, warto sprawdzić dane powyżej.",
    "Elimination rate": "Tempo eliminacji",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Jak szybko twoja wątroba usuwa alkohol po jego wchłonięciu — nachylenie opadającej "
        "strony krzywej.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Alkohol znika w mniej więcej stałej ilości na godzinę, a nie jako procent poziomu, "
        "ponieważ enzym, który go rozkłada, przy niemal każdym poziomie pracuje już na pełnych "
        "obrotach. Dlatego w ogóle istnieją reguły w rodzaju „jeden drink na godzinę”.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Przy tym ustawieniu %@ schodzi do zera w około %@. Prawie wszyscy mieszczą się w "
        "przedziale %@ na godzinę.",
    "How to find yours": "Jak poznać swoje tempo",
    "With a breathalyser": "Z alkomatem",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Dmuchnij dwa razy, w odstępie co najmniej godziny, po opadającej stronie — dwie "
        "godziny lub więcej po ostatnim drinku, bez niczego w międzyczasie. Odejmij drugi "
        "odczyt od pierwszego i podziel przez liczbę godzin między nimi.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Na przykład %@ i %@ dwie godziny później daje %@ na godzinę.",
    "Without one": "Bez niego",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Aplikacja podaje, kiedy spodziewa się twojego zejścia do zera. Jeśli regularnie "
        "wracasz do normy wyraźnie wcześniej, twoje tempo jest wyższe niż ustawione — podnieś "
        "je o jeden stopień i obserwuj przez kilka sesji. Jeśli trwa to dłużej, niż "
        "przewidywano, obniż je.",
    "What moves it": "Co na to wpływa",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Regularne picie je podnosi: enzym wątrobowy, który wykonuje tę pracę, jest indukowany "
        "przez używanie. Średnio jest też nieco wyższe u kobiet, a niższe na pusty żołądek lub "
        "przy problemach z wątrobą.",
    "Uncertainty": "Niepewność",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "Przy zerze każda wartość to pojedyncza liczba — najlepsze oszacowanie aplikacji. "
        "Powyżej zera te same wartości pokazywane są jako zakresy, a pasmo na wykresie "
        "odpowiednio się poszerza.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Pojedyncza liczba jest łatwiejszym punktem odniesienia: z czasem dowiesz się, jak się "
        "czujesz przy swoim własnym 0,6. Zakres to odpowiedź bardziej dosłowna, bo tempo "
        "naprawdę jest niepewne. Oba podejścia da się obronić — to twoja decyzja.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Rozrzut wynikający z twojej częstotliwości picia to ± %@ na godzinę.",
    "Rate": "Tempo",
    "Range": "Zakres",
    "Advanced": "Zaawansowane",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Niepewność to kwestia gustu: decyduje o tym, czy wartości czyta się jako jedną "
        "liczbę, czy jako zakres. Tempo poniżej kwestią gustu nie jest — zostaw je pytaniu o "
        "częstotliwość, chyba że masz pomiar, z którym możesz je porównać.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Wiele osób",
    "History trends": "Trendy w historii",
    "Week": "Tydzień",
    "Month": "Miesiąc",
    "Year": "Rok",
    "Sober days": "Dni bez alkoholu",
    "Change": "Zmiana",
    "before records": "przed rozpoczęciem zapisów",
    "See further back": "Zobacz dalej wstecz",
    "Weeks, months and years side by side — and every evening older than seven days.": "Tygodnie, miesiące i lata obok siebie – oraz każdy wieczór starszy niż siedem dni.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Wszystko, co zapisałeś, jest już zachowane. Odblokowanie tylko to pokazuje.",
    "Coming soon": "Wkrótce",
    "No data before %@": "Brak danych przed %@",
    "vs.": "wobec",
    "Grams": "Gramy",
    "Grams of alcohol": "Gramy alkoholu",
    "Standard units": "Jednostki standardowe",
    "Period": "Okres",
    "Switch person": "Zmień osobę",
    "Add person": "Dodaj osobę",
    "New person": "Nowa osoba",
    "You": "Ty",
    "Name": "Imię",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Wszystkie cztery zmieniają przebieg krzywej, więc żadnej z nich nie da się zgadnąć za "
        "kogoś innego.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Własny limit tej osoby i dokładniejsze ustawienia można zmienić później na karcie "
        "Profil, gdy ta osoba jest wybrana.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Szybkie dodawanie",
    "Choose a favourite drink": "Wybierz ulubionego drinka",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Wybierz drinka, który zwykle zamawiasz, a przycisk na ekranie Na żywo zapisze go "
        "jednym dotknięciem.",
    "This is your quick-add drink": "To twój drink do szybkiego dodawania",
    "Set as my quick-add drink": "Ustaw jako drink do szybkiego dodawania",
    "This is now your usual": "To teraz twój zwykły drink",
    "Remove favourite": "Usuń z ulubionych",
    "Always add this one": "Zawsze dodawaj ten",
    "Logs it straight away, without opening anything.":
        "Zapisuje go od razu, bez otwierania czegokolwiek.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Jedno dotknięcie na ekranie Na żywo zapisuje tego drinka, razem z przewidywanym "
        "szczytem na przycisku. Stan wypełnienia żołądka bierze się z poprzedniego drinka i "
        "można go poprawić zaraz po zapisaniu.",
    "Peak %@": "Szczyt %@",
    "%@ added": "Dodano: %@",
    "Save": "Zapisz",
    "Undo": "Cofnij",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Kopia zapasowa",
    "Export a backup": "Eksportuj kopię zapasową",
    "Import a backup": "Importuj kopię zapasową",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Kopia zapasowa zawiera wszystkie osoby, sesje i drinki. Import dodaje tylko to, czego "
        "brakuje — nigdy nie zmienia ani nie usuwa niczego, co już tu jest.",
    "Import this backup?": "Zaimportować tę kopię zapasową?",
    "Import": "Importuj",
    "Everything in this backup is already here.": "Wszystko z tej kopii zapasowej już tu jest.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Dodaje sesji: %@, drinków: %@. Nic z tego, co już tu jest, nie zostanie zmienione ani "
        "usunięte.",
    "Import finished": "Import zakończony",
    "Added %@ occasions and %@ drinks.": "Dodano sesji: %@, drinków: %@.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Język",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Otwiera tę aplikację w Ustawieniach, gdzie „Preferowany język” ustawia język samej "
        "aplikacji — język systemu pozostaje bez zmian. iOS uruchamia aplikację ponownie po "
        "zmianie.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Nie udało się zaimportować",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Ten plik nie jest kopią zapasową DrinkSmart albo jest uszkodzony.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Ta kopia zapasowa została utworzona w nowszej wersji aplikacji DrinkSmart. "
        "Zaktualizuj aplikację i spróbuj ponownie.",
}
