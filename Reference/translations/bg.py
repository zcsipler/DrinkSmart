"""
Bulgarian.

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Промил",
    "Percent": "Процент",

    # --- DrinkCatalog: drink types ---
    "Beer": "Бира",
    "Wine": "Вино",
    "Sparkling": "Пенливо",
    "Spirit": "Концентрат",
    "Cocktail": "Коктейл",
    "Custom": "По избор",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Празен стомах",
    "Moderately full": "Умерено пълен",
    "Full stomach": "Пълен стомах",
    "Empty": "Празен",
    "Moderate": "Умерен",
    "Full": "Пълен",
    "Fast absorption, higher and earlier peak.": "Бързо усвояване, по-висок и по-ранен пик.",
    "Moderate absorption.": "Умерено усвояване.",
    "Slow absorption, lower and later peak.": "Бавно усвояване, по-нисък и по-късен пик.",

    # --- DrinkingFrequency ---
    "Rarely": "Рядко",
    "A few times a month": "Няколко пъти в месеца",
    "Several times a week": "Няколко пъти седмично",
    "Almost daily": "Почти всеки ден",
    "A few occasions a year": "Няколко пъти в годината",
    "Social drinking": "Социално пиене",
    "Weekly routine": "Седмична рутина",
    "Daily or nearly daily": "Всеки ден или почти всеки ден",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Час",
    "Level": "Ниво",
    "Lower": "Долна",
    "Upper": "Горна",
    "Lower estimate": "Долна оценка",
    "Upper estimate": "Горна оценка",
    "Personal limit": "Личен лимит",
    "Drink": "Напитка",

    # --- BACChartView ---
    "Expected peak around %@": "Очакван пик около %@",
    "Peaked around %@": "Достигна пик около %@",
    "No active session": "Няма активна сесия",
    "Still rising": "Все още се покачва",
    "YOUR LIMIT %@": "ТВОЯТ ЛИМИТ %@",
    "possible range": "възможен диапазон",
    "drag to read values": "плъзни, за да четеш стойности",
    "release to go back": "пусни, за да се върнеш",
    "pour time": "време на изпиване",
    "in one go": "наведнъж",

    # --- Live screen: the day with nothing on it ---
    "Live": "На живо",
    "Nothing logged today": "Днес няма нищо записано",
    "Add a drink when you have one.": "Добавяй напитка, когато изпиеш такава.",

    # --- Tabs and history ---
    "History": "История",
    "No past sessions yet": "Все още няма минали сесии",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Сесията се появява тук, след като приключи — когато нивото ти се изчисти и минат "
        "няколко часа.",
    "%@ drinks": "Напитки: %@",
    "peak": "пик",
    "Started": "Започна",
    "Lasted": "Продължи",
    "Calculated with your profile at the time": "Изчислено с профила ти от онзи момент",

    # --- TodayView ---
    "Profile": "Профил",
    "estimated level": "прогнозно ниво",
    "estimated range": "прогнозен диапазон",
    "Elapsed": "Изминало",
    "Drinks": "Напитки",
    "Units": "Единици",
    "Expected to clear": "Очаквано изчистване",
    "Drinks this session": "Напитки в тази сесия",
    "This is an estimate, not a measurement.": "Това е оценка, а не измерване.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Действителните стойности се различават значително при отделните хора. Никога не "
        "използвай това, за да решиш дали можеш да шофираш.",
    "Add drink": "Добави напитка",

    # --- Editing an already logged drink ---
    "Edit drink": "Редактирай напитката",
    "Save changes": "Запази промените",
    "With this": "С тази напитка",
    "Delete": "Изтрий",
    "tap to edit · swipe to delete": "докосни за редакция · плъзни за изтриване",

    # --- Drinking pace ---
    "How fast": "Колко бързо",
    "In one go": "Наведнъж",
    "15 min": "15 мин",
    "30 min": "30 мин",
    "1 hr": "1 ч",
    "Counts as a single swallow — the steepest possible rise.":
        "Брои се като една глътка — възможно най-стръмното покачване.",
    "A quick drink. The level climbs fast.": "Бързо изпита напитка. Нивото се покачва бързо.",
    "A normal pace.": "Нормално темпо.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Изпита бавно. Много по-плавно покачване при същия алкохол.",

    # --- AddDrinkSheet ---
    "Cancel": "Отказ",
    "Now": "Сега",
    "Projected peak": "Прогнозен пик",
    "Peak at": "Пик в",
    "Clears": "Изчиства се",
    "This would cross your limit": "Това би преминало лимита ти",
    "Around %@, for up to %@.": "Около %@, в продължение на до %@.",
    "This might cross your limit": "Това може да премине лимита ти",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "При по-бавен метаболизъм — да, при по-бърз — не. Това е несигурността на оценката.",
    "Type": "Вид",
    "Amount": "Количество",
    "Strength": "Градус",
    "%@ units": "Единици: %@",
    "%@ g alcohol": "%@ г алкохол",
    "Stomach": "Стомах",
    "When": "Кога",
    "15 min ago": "преди 15 мин",
    "30 min ago": "преди 30 мин",
    "1 hr ago": "преди 1 ч",
    "Done": "Готово",
    "Set exact time": "Задай точен час",
    "Add": "Добави",

    # --- ProfileSheet ---
    "Male": "Мъж",
    "Female": "Жена",
    "Sex": "Пол",
    "Weight": "Тегло",
    "Height": "Височина",
    "Age": "Възраст",
    "kg": "кг",
    "cm": "см",
    "yrs": "год.",
    "Body": "Тяло",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "Общата телесна вода идва от уравненията на Watson, които определят обема, в който се "
        "разпределя алкохолът.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "Общата телесна вода идва от уравненията на Watson, които определят обема, в който се "
        "разпределя алкохолът. Женското уравнение не включва възрастта, затова промяната ѝ "
        "няма да повлияе на резултата.",
    "Drinking frequency": "Честота на пиене",
    "How often do you drink?": "Колко често пиеш?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Така оценяваме скоростта ти на елиминиране. Редовното пиене индуцира чернодробния път "
        "CYP2E1, затова честите консуматори изчистват алкохола по-бързо. Това е най-слабото "
        "място на модела и затова в „Разширени“ можеш да зададеш колко от тази несигурност да "
        "ти показва приложението.",
    "Your limit": "Твоят лимит",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Твоя собствена отправна стойност, а не законова граница. Приложението ти казва кога "
        "планирана напитка би те извела над нея и колко време ще останеш отгоре.",
    "Unit": "Мерна единица",
    "Display": "Показване",
    "Calculated values": "Изчислени стойности",
    "Total body water": "Обща телесна вода",
    "Distribution volume": "Обем на разпределение",
    "Widmark factor": "Фактор на Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "Факторът на Widmark обикновено е около 0,68 при мъжете и 0,55 при жените. Ако твоят е "
        "далеч от това, си струва да провериш стойностите по-горе.",
    "Elimination rate": "Скорост на елиминиране",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Колко бързо черният ти дроб изчиства алкохола, след като той е усвоен — наклонът на "
        "спадащата част от кривата.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "Алкохолът се изчиства с приблизително постоянно количество на час, а не с процент от "
        "наличното, защото ензимът, който го разгражда, вече работи с пълен капацитет при "
        "почти всяко ниво. Затова изобщо съществуват правила като „една напитка на час“.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "При тази настройка %@ се изчиства за около %@. Почти всички попадат между %@ на час.",
    "How to find yours": "Как да откриеш своята",
    "With a breathalyser": "С алкотестер",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Духни два пъти, с поне час разлика, в спадащата част — два или повече часа след "
        "последната напитка и без нищо междувременно. Извади второто отчитане от първото и "
        "раздели на часовете между тях.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Например %@ и %@ два часа по-късно дават %@ на час.",
    "Without one": "Без алкотестер",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "Приложението ти казва кога очаква нивото ти да се изчисти. Ако редовно се връщаш към "
        "нормалното доста преди това, скоростта ти е по-висока от настройката — вдигни я с "
        "една стъпка и наблюдавай няколко сесии. Ако отнема повече от предвиденото, свали я с "
        "една стъпка.",
    "What moves it": "Какво я променя",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Редовното пиене я повишава: чернодробният ензим, който върши работата, се индуцира от "
        "употреба. Средно тя е и малко по-висока при жените, а по-ниска на празен стомах или "
        "при чернодробни проблеми.",
    "Uncertainty": "Несигурност",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "При нула всяка стойност е едно число — най-добрата преценка на приложението. Над нула "
        "същите стойности се показват като диапазони, а лентата на графиката се разширява "
        "съответно.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "С едно число се учиш по-лесно: с времето разбираш как се усещат твоите собствени 0,6. "
        "Диапазонът е по-буквалният отговор, защото скоростта наистина е несигурна. И двете са "
        "защитими — решението е твое.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "Разсейването, което честотата ти на пиене подсказва, е ± %@ на час.",
    "Rate": "Скорост",
    "Range": "Диапазон",
    "Advanced": "Разширени",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "Несигурността е въпрос на вкус: тя решава дали стойностите се четат като едно число, "
        "или като диапазон. Скоростта по-долу не е — остави я на въпроса за честотата, освен "
        "ако нямаш измерване, с което да я сверяваш.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Няколко души",
    "History trends": "Тенденции в историята",
    "Week": "Седмица",
    "Month": "Месец",
    "Year": "Година",
    "Sober days": "Дни без алкохол",
    "Change": "Промяна",
    "before records": "преди началото на записите",
    "See further back": "Виж по-назад",
    "Weeks, months and years side by side — and every evening older than seven days.": "Седмици, месеци и години една до друга – и всяка вечер, по-стара от седем дни.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Всичко, което си записал, вече е запазено. Отключването само го показва.",
    "Coming soon": "Очаквайте скоро",
    "Today": "Днес",
    "No data before %@": "Няма данни преди %@",
    "vs.": "спрямо",
    "Grams": "Грамове",
    "Grams of alcohol": "Грамове алкохол",
    "Standard units": "Стандартни единици",
    "Period": "Период",
    "Switch person": "Смени човека",
    "Add person": "Добави човек",
    "New person": "Нов човек",
    "You": "Ти",
    "Name": "Име",
    "All four change the curve, so none of them can be guessed for someone else.":
        "И четирите променят кривата, затова нито едно от тях не може да се гадае за друг "
        "човек.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Собственият им лимит и по-фините настройки могат да се променят по-късно в раздела "
        "„Профил“, докато този човек е избран.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Бързо добавяне",
    "Choose a favourite drink": "Избери любима напитка",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Избери напитката, която обикновено поръчваш, и бутон на екрана „На живо“ ще я записва "
        "с едно докосване.",
    "This is your quick-add drink": "Това е напитката ти за бързо добавяне",
    "Set as my quick-add drink": "Задай като напитка за бързо добавяне",
    "This is now your usual": "Това вече е обичайната ти напитка",
    "Remove favourite": "Премахни любимата",
    "Always add this one": "Винаги добавяй тази напитка",
    "Logs it straight away, without opening anything.":
        "Записва я веднага, без да отваря нищо.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Едно докосване на екрана „На живо“ я записва, а прогнозният пик стои на бутона. Колко "
        "пълен е стомахът ти се взема от предишната напитка и може да се коригира веднага след "
        "това.",
    "Peak %@": "Пик %@",
    "%@ added": "Добавено: %@",
    "Save": "Запази",
    "Undo": "Отмени",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Резервно копие",
    "Export a backup": "Експортирай резервно копие",
    "Import a backup": "Импортирай резервно копие",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Резервното копие съдържа всеки човек, всяка сесия и всяка напитка. Импортирането "
        "добавя липсващото — то никога не променя и не премахва нищо от вече наличното.",
    "Import this backup?": "Да се импортира ли това резервно копие?",
    "Import": "Импортирай",
    "Everything in this backup is already here.": "Всичко от това резервно копие вече е тук.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Ще добави сесии: %@, напитки: %@. Нищо, което вече е тук, не се променя и не се "
        "премахва.",
    "Import finished": "Импортирането завърши",
    "Added %@ occasions and %@ drinks.": "Добавени сесии: %@, напитки: %@.",
    "OK": "Добре",

    # --- LanguageSection: the app's language ---
    "Language": "Език",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Отваря това приложение в Настройки, където „Предпочитан език“ задава езика на самото "
        "приложение — системният остава непроменен. iOS рестартира приложението, когато го "
        "смениш.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Импортирането е неуспешно",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Този файл не е резервно копие на DrinkSmart или е повреден.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Това резервно копие е направено с по-нова версия на DrinkSmart. Обнови приложението и "
        "опитай отново.",
}
