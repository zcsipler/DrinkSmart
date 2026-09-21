"""
Portuguese (European).

Drafted in one pass and not yet read by a speaker of the language, so every
string lands in the catalog as `needs_review`. Moving the code into REVIEWED
in make_catalog.py is the act of vouching for it.
"""

TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Por mil",
    "Percent": "Percentagem",

    # --- DrinkCatalog: drink types ---
    "Beer": "Cerveja",
    "Wine": "Vinho",
    "Sparkling": "Espumante",
    "Spirit": "Destilado",
    "Cocktail": "Cocktail",
    "Custom": "Personalizado",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Estômago vazio",
    "Moderately full": "Moderadamente cheio",
    "Full stomach": "Estômago cheio",
    "Empty": "Vazio",
    "Moderate": "Moderado",
    "Full": "Cheio",
    "Fast absorption, higher and earlier peak.": "Absorção rápida, pico mais alto e mais cedo.",
    "Moderate absorption.": "Absorção moderada.",
    "Slow absorption, lower and later peak.": "Absorção lenta, pico mais baixo e mais tarde.",

    # --- DrinkingFrequency ---
    "Rarely": "Raramente",
    "A few times a month": "Algumas vezes por mês",
    "Several times a week": "Várias vezes por semana",
    "Almost daily": "Quase todos os dias",
    "A few occasions a year": "Algumas ocasiões por ano",
    "Social drinking": "Consumo social",
    "Weekly routine": "Rotina semanal",
    "Daily or nearly daily": "Todos os dias ou quase",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Hora",
    "Level": "Nível",
    "Lower": "Inferior",
    "Upper": "Superior",
    "Lower estimate": "Estimativa inferior",
    "Upper estimate": "Estimativa superior",
    "Personal limit": "Limite pessoal",
    "Drink": "Bebida",

    # --- BACChartView ---
    "Expected peak around %@": "Pico previsto por volta de %@",
    "Peaked around %@": "Pico por volta de %@",
    "No active session": "Nenhuma sessão ativa",
    "Still rising": "Ainda a subir",
    "YOUR LIMIT %@": "O TEU LIMITE %@",
    "possible range": "intervalo possível",
    "drag to read values": "arrasta para ler os valores",
    "release to go back": "larga para voltar",
    "pour time": "tempo de ingestão",
    "in one go": "de uma vez",

    # --- Live screen: the day with nothing on it ---
    "Live": "Em direto",
    "Nothing logged today": "Nada registado hoje",
    "Add a drink when you have one.": "Adiciona uma bebida sempre que beberes uma.",

    # --- Tabs and history ---
    "History": "Histórico",
    "No past sessions yet": "Ainda não há sessões anteriores",
    "A session appears here once it has ended — when your level has cleared and a few hours "
    "have passed.":
        "Uma sessão aparece aqui depois de terminar — quando o teu nível voltou a zero e "
        "passaram algumas horas.",
    "%@ drinks": "%@ bebidas",
    "peak": "pico",
    "Started": "Começou",
    "Lasted": "Durou",
    "Calculated with your profile at the time": "Calculado com o teu perfil da altura",

    # --- TodayView ---
    "Profile": "Perfil",
    "estimated level": "nível estimado",
    "estimated range": "intervalo estimado",
    "Elapsed": "Decorrido",
    "Drinks": "Bebidas",
    "Units": "Unidades",
    "Expected to clear": "Previsão de voltar a zero",
    "Drinks this session": "Bebidas nesta sessão",
    "This is an estimate, not a measurement.": "Isto é uma estimativa, não uma medição.",
    "Actual values vary considerably between individuals. Never use this to decide whether you "
    "can drive.":
        "Os valores reais variam consideravelmente de pessoa para pessoa. Nunca uses isto para "
        "decidir se podes conduzir.",
    "Add drink": "Adicionar bebida",

    # --- Editing an already logged drink ---
    "Edit drink": "Editar bebida",
    "Save changes": "Guardar alterações",
    "With this": "Com esta",
    "Delete": "Eliminar",
    "tap to edit · swipe to delete": "toca para editar · desliza para eliminar",

    # --- Drinking pace ---
    "How fast": "Com que rapidez",
    "In one go": "De uma vez",
    "15 min": "15 min",
    "30 min": "30 min",
    "1 hr": "1 h",
    "Counts as a single swallow — the steepest possible rise.":
        "Conta como um único gole — a subida mais acentuada possível.",
    "A quick drink. The level climbs fast.": "Uma bebida rápida. O nível sobe depressa.",
    "A normal pace.": "Um ritmo normal.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Bebida devagar. Subida muito mais suave para o mesmo álcool.",

    # --- AddDrinkSheet ---
    "Cancel": "Cancelar",
    "Now": "Agora",
    "Projected peak": "Pico previsto",
    "Peak at": "Pico às",
    "Clears": "Volta a zero",
    "This would cross your limit": "Isto ultrapassaria o teu limite",
    "Around %@, for up to %@.": "Cerca de %@, durante até %@.",
    "This might cross your limit": "Isto pode ultrapassar o teu limite",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "Com um metabolismo mais lento sim, com um mais rápido não. É essa a incerteza da "
        "estimativa.",
    "Type": "Tipo",
    "Amount": "Quantidade",
    "Strength": "Teor",
    "%@ units": "%@ unidades",
    "%@ g alcohol": "%@ g de álcool",
    "Stomach": "Estômago",
    "When": "Quando",
    "15 min ago": "há 15 min",
    "30 min ago": "há 30 min",
    "1 hr ago": "há 1 h",
    "Done": "Concluído",
    "Set exact time": "Definir hora exata",
    "Add": "Adicionar",

    # --- ProfileSheet ---
    "Male": "Masculino",
    "Female": "Feminino",
    "Sex": "Sexo",
    "Weight": "Peso",
    "Height": "Altura",
    "Age": "Idade",
    "kg": "kg",
    "cm": "cm",
    "yrs": "anos",
    "Body": "Corpo",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into.":
        "A água corporal total vem das equações de Watson, que definem o volume no qual o "
        "álcool se distribui.",
    "Total body water comes from the Watson equations, which set the volume alcohol "
    "distributes into. The female equation does not include age, so changing it will not "
    "affect the result.":
        "A água corporal total vem das equações de Watson, que definem o volume no qual o "
        "álcool se distribui. A equação feminina não inclui a idade, por isso alterá-la não "
        "afeta o resultado.",
    "Drinking frequency": "Frequência de consumo",
    "How often do you drink?": "Com que frequência bebes?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's "
    "CYP2E1 pathway, so frequent drinkers clear alcohol faster. It is the weakest point of the "
    "model, which is why you can set under Advanced how much of that uncertainty the app shows "
    "you.":
        "É assim que estimamos a tua taxa de eliminação. Beber com regularidade induz a via do "
        "CYP2E1 no fígado, por isso quem bebe com frequência elimina o álcool mais depressa. É "
        "o ponto mais fraco do modelo, e é por isso que podes definir em Avançado quanto dessa "
        "incerteza a app te mostra.",
    "Your limit": "O teu limite",
    "Your own reference number, not a legal limit. The app tells you when a planned drink "
    "would take you past it, and for how long you would stay above.":
        "Um número de referência teu, não um limite legal. A app avisa-te quando uma bebida "
        "planeada te faria ultrapassá-lo, e durante quanto tempo ficarias acima.",
    "Unit": "Unidade",
    "Display": "Apresentação",
    "Calculated values": "Valores calculados",
    "Total body water": "Água corporal total",
    "Distribution volume": "Volume de distribuição",
    "Widmark factor": "Fator de Widmark",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far "
    "from that, it is worth checking the values above.":
        "O fator de Widmark ronda normalmente 0,68 nos homens e 0,55 nas mulheres. Se o teu "
        "estiver longe disso, vale a pena verificar os valores acima.",
    "Elimination rate": "Taxa de eliminação",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling "
    "side of the curve.":
        "Com que rapidez o teu fígado elimina o álcool depois de absorvido — o declive da "
        "parte descendente da curva.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the "
    "enzyme that breaks it down already runs at full capacity at almost any level. That is why "
    "rules of thumb like “one drink an hour” exist at all.":
        "O álcool sai a um ritmo aproximadamente fixo por hora, e não a uma percentagem, "
        "porque a enzima que o decompõe já trabalha no máximo em quase qualquer nível. É por "
        "isso que existem regras práticas como «uma bebida por hora».",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Com esta definição, %@ demora cerca de %@ a voltar a zero. Quase toda a gente fica "
        "entre %@ por hora.",
    "How to find yours": "Como descobrir a tua",
    "With a breathalyser": "Com um alcoolímetro",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your "
    "last drink, with nothing in between. Subtract the second reading from the first and "
    "divide by the hours between them.":
        "Sopra duas vezes, com pelo menos uma hora de intervalo, na parte descendente — duas "
        "horas ou mais depois da última bebida, sem beber nada pelo meio. Subtrai a segunda "
        "leitura à primeira e divide pelas horas entre elas.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Por exemplo, %@ e %@ duas horas depois dão %@ por hora.",
    "Without one": "Sem ela",
    "The app tells you when it expects you to clear. If you are reliably back to normal well "
    "before that, your rate is higher than the setting — nudge it up a step and watch for a "
    "few sessions. If it takes longer than predicted, nudge it down.":
        "A app diz-te quando espera que voltes a zero. Se estiveres sempre normal bem antes "
        "disso, a tua taxa é mais alta do que a definição — sobe-a um passo e observa durante "
        "algumas sessões. Se demorar mais do que o previsto, desce-a.",
    "What moves it": "O que a altera",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It "
    "also runs slightly higher in women on average, and lower on an empty stomach or with "
    "liver trouble.":
        "Beber com regularidade aumenta-a: a enzima hepática que faz o trabalho é induzida "
        "pelo uso. Em média, também é ligeiramente mais alta nas mulheres, e mais baixa com o "
        "estômago vazio ou com problemas de fígado.",
    "Uncertainty": "Incerteza",
    "At zero every figure is a single number — the app's best estimate. Above zero the same "
    "figures are shown as ranges, and the band on the chart widens to match.":
        "A zero, cada valor é um número único — a melhor estimativa da app. Acima de zero, os "
        "mesmos valores são apresentados como intervalos, e a banda no gráfico alarga em "
        "conformidade.",
    "A single number is easier to learn against: over time you find out what your own 0.6 "
    "feels like. A range is the more literal answer, because the rate really is uncertain. "
    "Both are defensible — this is your call.":
        "Um número único é mais fácil de interiorizar: com o tempo, descobres o que o teu "
        "próprio 0,6 significa para ti. Um intervalo é a resposta mais literal, porque a taxa "
        "é mesmo incerta. Ambos se defendem — a escolha é tua.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "A dispersão sugerida pela tua frequência de consumo é de ± %@ por hora.",
    "Rate": "Taxa",
    "Range": "Intervalo",
    "Advanced": "Avançado",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a "
    "range. The rate below is not — leave it to the frequency question unless you have a "
    "measurement to match it against.":
        "A incerteza é uma questão de gosto: decide se os valores aparecem como um número ou "
        "como um intervalo. A taxa abaixo não é — deixa-a à pergunta da frequência, a não ser "
        "que tenhas uma medição com que a comparar.",

    # --- PersonSwitcher / FeatureFlags: more than one person (11.5) ---
    "Multiple people": "Várias pessoas",
    "History trends": "Tendências do histórico",
    "Week": "Semana",
    "Month": "Mês",
    "Year": "Ano",
    "Sober days": "Dias sem beber",
    "Change": "Variação",
    "before records": "antes do registo",
    "See further back": "Ver mais para trás",
    "Weeks, months and years side by side — and every evening older than seven days.": "Semanas, meses e anos lado a lado – e cada noite com mais de sete dias.",
    "Everything you have logged is already saved. Unlocking only shows it.": "Tudo o que registou já está guardado. Desbloquear apenas o mostra.",
    "Coming soon": "Em breve",
    "No data before %@": "Sem dados antes de %@",
    "vs.": "vs.",
    "Grams": "Gramas",
    "Grams of alcohol": "Gramas de álcool",
    "Standard units": "Unidades padrão",
    "Period": "Período",
    "Switch person": "Mudar de pessoa",
    "Add person": "Adicionar pessoa",
    "New person": "Nova pessoa",
    "You": "Tu",
    "Name": "Nome",
    "All four change the curve, so none of them can be guessed for someone else.":
        "Os quatro alteram a curva, por isso nenhum deles pode ser adivinhado para outra "
        "pessoa.",
    "Their own limit and the finer settings can be changed later on the Profile tab, while "
    "they are the selected person.":
        "O limite próprio e as definições mais detalhadas podem ser alterados depois no "
        "separador Perfil, enquanto esta for a pessoa selecionada.",

    # --- FavouriteDrinkSection and QuickAddBar: the one-tap usual ---
    "Quick add": "Registo rápido",
    "Choose a favourite drink": "Escolhe uma bebida favorita",
    "Pick the drink you usually order, and a button on the Live screen will log it in one tap.":
        "Escolhe a bebida que costumas pedir e um botão no ecrã Em direto regista-a com um "
        "toque.",
    "This is your quick-add drink": "Esta é a tua bebida de registo rápido",
    "Set as my quick-add drink": "Definir como a minha bebida de registo rápido",
    "This is now your usual": "Esta é agora a tua habitual",
    "Remove favourite": "Remover favorita",
    "Always add this one": "Adicionar sempre esta",
    "Logs it straight away, without opening anything.":
        "Regista-a de imediato, sem abrir nada.",
    "One tap on the Live screen logs this, with the projected peak on the button. How full "
    "your stomach is comes from the drink before it, and can be corrected straight after.":
        "Um toque no ecrã Em direto regista-a, com o pico previsto no botão. O quão cheio está "
        "o teu estômago vem da bebida anterior e pode ser corrigido logo a seguir.",
    "Peak %@": "Pico %@",
    "%@ added": "Adicionaste %@",
    "Save": "Guardar",
    "Undo": "Anular",

    # --- DataTransferSection: backup and restore ---
    "Backup": "Cópia de segurança",
    "Export a backup": "Exportar uma cópia de segurança",
    "Import a backup": "Importar uma cópia de segurança",
    "A backup holds every person, occasion and drink. Importing adds what is missing — it "
    "never changes or removes anything already here.":
        "Uma cópia de segurança contém todas as pessoas, ocasiões e bebidas. Importar "
        "acrescenta o que falta — nunca altera nem remove nada do que já está aqui.",
    "Import this backup?": "Importar esta cópia de segurança?",
    "Import": "Importar",
    "Everything in this backup is already here.":
        "Tudo o que está nesta cópia de segurança já está aqui.",
    "Adds %@ occasions and %@ drinks. Nothing already here is changed or removed.":
        "Adiciona %@ ocasiões e %@ bebidas. Nada do que já está aqui é alterado ou removido.",
    "Import finished": "Importação concluída",
    "Added %@ occasions and %@ drinks.": "Adicionadas %@ ocasiões e %@ bebidas.",
    "OK": "OK",

    # --- LanguageSection: the app's language ---
    "Language": "Idioma",
    "Opens this app in Settings, where “Preferred Language” sets the app's own language — the "
    "system's stays as it is. iOS restarts the app when you change it.":
        "Abre esta app nas Definições, onde «Idioma preferido» define o idioma da própria app "
        "— o do sistema mantém-se como está. O iOS reinicia a app quando o alteras.",

    # --- DataArchive: why a file could not be read ---
    "Could not import": "Não foi possível importar",
    "This file is not a DrinkSmart backup, or it is damaged.":
        "Este ficheiro não é uma cópia de segurança do DrinkSmart, ou está danificado.",
    "This backup was made by a newer version of DrinkSmart. Update the app and try again.":
        "Esta cópia de segurança foi feita por uma versão mais recente do DrinkSmart. Atualiza "
        "a app e tenta novamente.",
}
