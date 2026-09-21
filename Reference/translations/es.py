"""
Spanish (European).

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Por mil",
    "Percent": "Porcentaje",

    # --- DrinkCatalog: drink types ---
    "Beer": "Cerveza",
    "Wine": "Vino",
    "Sparkling": "Espumoso",
    "Spirit": "Licor",
    "Cocktail": "Cóctel",
    "Custom": "Personalizado",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Estómago vacío",
    "Moderately full": "Moderadamente lleno",
    "Full stomach": "Estómago lleno",
    "Empty": "Vacío",
    "Moderate": "Moderado",
    "Full": "Lleno",
    "Fast absorption, higher and earlier peak.":
        "Absorción rápida, pico más alto y más temprano.",
    "Moderate absorption.": "Absorción moderada.",
    "Slow absorption, lower and later peak.": "Absorción lenta, pico más bajo y más tardío.",

    # --- DrinkingFrequency ---
    "Rarely": "Rara vez",
    "A few times a month": "Unas pocas veces al mes",
    "Several times a week": "Varias veces a la semana",
    "Almost daily": "Casi a diario",
    "A few occasions a year": "Unas pocas ocasiones al año",
    "Social drinking": "Consumo social",
    "Weekly routine": "Rutina semanal",
    "Daily or nearly daily": "A diario o casi a diario",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Hora",
    "Level": "Nivel",
    "Lower": "Inferior",
    "Upper": "Superior",
    "Lower estimate": "Estimación inferior",
    "Upper estimate": "Estimación superior",
    "Personal limit": "Límite personal",
    "Drink": "Bebida",

    # --- BACChartView ---
    "Expected peak around %@": "Pico previsto en torno a %@",
    "Peaked around %@": "Pico alcanzado en torno a %@",
    "No active session": "Ninguna sesión activa",
    "Still rising": "Todavía subiendo",
    "YOUR LIMIT %@": "TU LÍMITE %@",
    "possible range": "rango posible",
    "drag to read values": "arrastra para leer los valores",
    "release to go back": "suelta para volver",
    "pour time": "tiempo de consumo",
    "in one go": "de un trago",

    # --- Live screen: the day with nothing on it ---
    "Live": "En directo",
    "Nothing logged today": "Hoy no has registrado nada",
    "Add a drink when you have one.": "Añade una bebida cuando te la tomes.",

    # --- Tabs and history ---
    "History": "Historial",
    "No past sessions yet": "Aún no hay sesiones anteriores",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Una sesión aparece aquí cuando ha terminado: cuando tu nivel se ha eliminado y han "
        "pasado unas horas.",
    "%@ drinks": "%@ bebidas",
    "peak": "pico",
    "Started": "Inicio",
    "Lasted": "Duración",
    "Calculated with your profile at the time": "Calculado con tu perfil de ese momento",

    # --- TodayView ---
    "Profile": "Perfil",
    "estimated level": "nivel estimado",
    "estimated range": "rango estimado",
    "Elapsed": "Transcurrido",
    "Drinks": "Bebidas",
    "Units": "Unidades",
    "Expected to clear": "Eliminación prevista",
    "Drinks this session": "Bebidas de esta sesión",
    "This is an estimate, not a measurement.": "Esto es una estimación, no una medición.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Los valores reales varían considerablemente de una persona a otra. No uses nunca esto "
        "para decidir si puedes conducir.",
    "Add drink": "Añadir bebida",

    # --- Editing an already logged drink ---
    "Edit drink": "Editar bebida",
    "Save changes": "Guardar cambios",
    "With this": "Con esta",
    "Delete": "Eliminar",
    "tap to edit · swipe to delete": "toca para editar · desliza para eliminar",

    # --- Drinking pace ---
    "How fast": "A qué velocidad",
    "In one go": "De un trago",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Cuenta como un solo trago: la subida más rápida posible.",
    "A quick drink. The level climbs fast.": "Una bebida rápida. El nivel sube deprisa.",
    "A normal pace.": "Un ritmo normal.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Bebida despacio. Subida mucho más suave con el mismo alcohol.",

    # --- AddDrinkSheet ---
    "Cancel": "Cancelar",
    "Now": "Ahora",
    "Projected peak": "Pico previsto",
    "Peak at": "Pico a las",
    "Clears": "Se elimina",
    "This would cross your limit": "Esto superaría tu límite",
    "Around %@, for up to %@.": "Alrededor de %@, durante hasta %@.",
    "This might cross your limit": "Esto podría superar tu límite",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Con un metabolismo más lento sí, con uno más rápido no. Esa es la incertidumbre de la "
        "estimación.",
    "Type": "Tipo",
    "Amount": "Cantidad",
    "Strength": "Graduación",
    "%@ units": "%@ unidades",
    "%@ g alcohol": "%@ g de alcohol",
    "Stomach": "Estómago",
    "When": "Cuándo",
    "15 min ago": "hace 15 min",
    "30 min ago": "hace 30 min",
    "1 hr ago": "hace 1 h",
    "Done": "Listo",
    "Set exact time": "Fijar hora exacta",
    "Add": "Añadir",

    # --- ProfileSheet ---
    "Male": "Hombre",
    "Female": "Mujer",
    "Sex": "Sexo",
    "Weight": "Peso",
    "Height": "Altura",
    "Age": "Edad",
    "kg": "kg",
    "cm": "cm",
    "yrs": "años",
    "Body": "Cuerpo",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "El agua corporal total procede de las ecuaciones de Watson, que determinan el volumen "
        "en el que se distribuye el alcohol.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "El agua corporal total procede de las ecuaciones de Watson, que determinan el volumen "
        "en el que se distribuye el alcohol. La ecuación femenina no incluye la edad, así que "
        "cambiarla no afectará al resultado.",
    "Drinking frequency": "Frecuencia de consumo",
    "How often do you drink?": "¿Con qué frecuencia bebes?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "Así estimamos tu tasa de eliminación. Beber con regularidad induce la vía CYP2E1 del "
        "hígado, por lo que quien bebe con frecuencia elimina el alcohol más rápido. Es el "
        "punto más débil del modelo, y por eso en Avanzado puedes elegir cuánta de esa "
        "incertidumbre te muestra la app.",
    "Your limit": "Tu límite",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Tu propia cifra de referencia, no un límite legal. La app te avisa cuando una bebida "
        "prevista te haría superarlo y durante cuánto tiempo estarías por encima.",
    "Unit": "Unidad",
    "Display": "Visualización",
    "Calculated values": "Valores calculados",
    "Total body water": "Agua corporal total",
    "Distribution volume": "Volumen de distribución",
    "Widmark factor": "Factor de Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "El factor de Widmark suele rondar 0,68 en hombres y 0,55 en mujeres. Si el tuyo se "
        "aleja mucho de eso, conviene revisar los valores de arriba.",
    "Elimination rate": "Tasa de eliminación",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "A qué velocidad elimina el alcohol tu hígado una vez absorbido: la pendiente de la "
        "parte descendente de la curva.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "El alcohol se elimina en una cantidad más o menos fija por hora, y no en un "
        "porcentaje, porque la enzima que lo descompone ya funciona a pleno rendimiento con "
        "casi cualquier nivel. Por eso existen reglas generales como «una bebida por hora».",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Con este ajuste, %@ tarda aproximadamente %@ en eliminarse. Casi todo el mundo está "
        "entre %@ por hora.",
    "How to find yours": "Cómo averiguar la tuya",
    "With a breathalyser": "Con un alcoholímetro",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Sopla dos veces, con al menos una hora de diferencia, en la parte descendente: dos "
        "horas o más después de tu última bebida, sin nada en medio. Resta la segunda lectura "
        "de la primera y divide entre las horas transcurridas.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Por ejemplo, %@ y %@ dos horas después dan %@ por hora.",
    "Without one": "Sin ella",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "La app te indica cuándo prevé que habrás eliminado el alcohol. Si vuelves a la "
        "normalidad de forma constante bastante antes, tu tasa es más alta que el ajuste: "
        "súbela un paso y observa durante unas cuantas sesiones. Si tarda más de lo previsto, "
        "bájala.",
    "What moves it": "Qué la modifica",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Beber con regularidad la aumenta: la enzima hepática que hace el trabajo se induce "
        "con el uso. También es algo más alta de media en las mujeres, y más baja con el "
        "estómago vacío o con problemas hepáticos.",
    "Uncertainty": "Incertidumbre",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "En cero, cada cifra es un solo número: la mejor estimación de la app. Por encima de "
        "cero, las mismas cifras se muestran como rangos, y la banda del gráfico se ensancha "
        "en consecuencia.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Con un solo número es más fácil aprender: con el tiempo descubres cómo se siente tu "
        "propio 0,6. Un rango es la respuesta más literal, porque la tasa es realmente "
        "incierta. Ambas opciones son defendibles; la decisión es tuya.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "El margen que sugiere tu frecuencia de consumo es de ± %@ por hora.",
    "Rate": "Tasa",
    "Range": "Rango",
    "Advanced": "Avanzado",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "La incertidumbre es cuestión de gustos: decide si las cifras se leen como un número o "
        "como un rango. La tasa de abajo no lo es: déjasela a la pregunta sobre la frecuencia, "
        "salvo que tengas una medición con la que contrastarla.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Varias personas",
    "History trends": "Tendencias del historial",
    "Week": "Semana",
    "Month": "Mes",
    "Year": "Año",
    "Sober days": "Días sin beber",
    "Change": "Cambio",
    "before records": "antes del registro",
    "See further back": "Ver más atrás",
    "Weeks, months and years side by side — and every evening older than seven days.": "Semanas, meses y años uno junto a otro, y cada noche de hace más de siete días.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Todo lo que has registrado ya está guardado. Desbloquear solo lo muestra.",
    "Coming soon": "Próximamente",
    "Grams": "Gramos",
    "Grams of alcohol": "Gramos de alcohol",
    "Standard units": "Unidades estándar",
    "Period": "Periodo",
    "Switch person": "Cambiar de persona",
    "Add person": "Añadir persona",
    "New person": "Nueva persona",
    "You": "Tú",
    "Name": "Nombre",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Los cuatro cambian la curva, así que ninguno se puede suponer para otra persona.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "Su propio límite y los ajustes más detallados se pueden cambiar después en la pestaña "
        "Perfil, mientras sea la persona seleccionada.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Añadido rápido",
    "Choose a favourite drink": "Elige una bebida favorita",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Elige la bebida que sueles pedir y un botón en la pantalla En directo la registrará "
        "con un solo toque.",
    "This is your quick-add drink": "Esta es tu bebida de añadido rápido",
    "Set as my quick-add drink": "Fijar como mi bebida de añadido rápido",
    "This is now your usual": "Ahora es tu bebida habitual",
    "Remove favourite": "Quitar favorita",
    "Always add this one": "Añadir siempre esta",
    "Logs it straight away, without opening anything.":
        "La registra al instante, sin abrir nada.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Un toque en la pantalla En directo la registra, con el pico previsto en el botón. Lo "
        "lleno que está tu estómago se toma de la bebida anterior y se puede corregir justo "
        "después.",
    "Peak %@": "Pico %@",
    "%@ added": "Se ha añadido %@",
    "Save": "Guardar",
    "Undo": "Deshacer",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Copia de seguridad",
    "Export a backup": "Exportar una copia de seguridad",
    "Import a backup": "Importar una copia de seguridad",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Una copia de seguridad contiene todas las personas, ocasiones y bebidas. Al importar "
        "se añade lo que falta; nunca se modifica ni se elimina nada de lo que ya hay aquí.",
    "Import this backup?": "¿Importar esta copia de seguridad?",
    "Import": "Importar",
    "Everything in this backup is already here.":
        "Todo lo que hay en esta copia de seguridad ya está aquí.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Añade %@ ocasiones y %@ bebidas. No se modifica ni se elimina nada de lo que ya hay "
        "aquí.",
    "Import finished": "Importación finalizada",
    "Added %@ occasions and %@ drinks.": "Se han añadido %@ ocasiones y %@ bebidas.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Idioma",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Abre esta app en Ajustes, donde «Idioma preferido» define el idioma de la propia app; "
        "el del sistema se mantiene igual. iOS reinicia la app cuando lo cambias.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "No se ha podido importar",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Este archivo no es una copia de seguridad de DrinkSmart o está dañado.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Esta copia de seguridad se creó con una versión más reciente de DrinkSmart. Actualiza "
        "la app e inténtalo de nuevo.",
}
