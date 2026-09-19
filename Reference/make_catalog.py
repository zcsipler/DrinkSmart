"""
Generates and verifies Localizable.xcstrings.

Source language is English; the Hungarian translations are maintained here by
hand. The script checks that every key really occurs in the source, and that
no localized string in the source was left without a translation.
"""

import json
import pathlib
import re
import sys

# Relative to this file, so the script runs from any checkout or sandbox.
APP = pathlib.Path(__file__).resolve().parent.parent / "DrinkSmart"

# en -> hu. In interpolated keys, %@ stands in for the substituted value.
TRANSLATIONS = {
    # --- BACUnit ---
    "Per mille": "Ezrelék",
    "Percent": "Százalék",

    # --- DrinkCatalog: drink types ---
    "Beer": "Sör",
    "Wine": "Bor",
    "Sparkling": "Pezsgő",
    "Spirit": "Tömény",
    "Cocktail": "Koktél",
    "Custom": "Egyedi",

    # --- DrinkCatalog: stomach state ---
    "Empty stomach": "Éhgyomor",
    "Moderately full": "Közepesen telt",
    "Full stomach": "Teli has",
    "Empty": "Éhgyomor",
    "Moderate": "Közepes",
    "Full": "Teli",
    "Fast absorption, higher and earlier peak.": "Gyors felszívódás, magasabb és korábbi csúcs.",
    "Moderate absorption.": "Mérsékelt felszívódás.",
    "Slow absorption, lower and later peak.": "Lassú felszívódás, alacsonyabb és későbbi csúcs.",

    # --- DrinkingFrequency ---
    "Rarely": "Ritkán",
    "A few times a month": "Havonta párszor",
    "Several times a week": "Hetente többször",
    "Almost daily": "Szinte naponta",
    "A few occasions a year": "Évente néhány alkalom",
    "Social drinking": "Alkalmi, társasági fogyasztás",
    "Weekly routine": "Heti rendszeresség",
    "Daily or nearly daily": "Napi vagy majdnem napi",

    # --- BACChartView: chart axis and series labels (VoiceOver reads these) ---
    "Time": "Idő",
    "Level": "Szint",
    "Lower": "Alsó",
    "Upper": "Felső",
    "Lower estimate": "Alsó becslés",
    "Upper estimate": "Felső becslés",
    "Personal limit": "Saját határ",
    "Drink": "Ital",

    # --- BACChartView ---
    "Expected peak around %@": "Várható csúcs %@ körül",
    "Peaked around %@": "Csúcs volt %@ körül",
    "No active session": "Nincs aktív alkalom",
    "Still rising": "Még emelkedik",
    "YOUR LIMIT %@": "SAJÁT HATÁR %@",
    "possible range": "lehetséges tartomány",
    "drag to read values": "húzd a leolvasáshoz",
    "release to go back": "engedd el a visszatéréshez",

    # --- Live screen: the day with nothing on it ---
    "Live": "Élő",
    "Nothing logged today": "Ma még nincs felvitt ital",
    "Add a drink when you have one.": "Vidd fel, amikor iszol valamit.",

    # --- Tabs and history ---
    "History": "Előzmény",
    "No past sessions yet": "Még nincs lezárt alkalom",
    "A session appears here once it has ended — when your level has cleared and a few hours have passed.":
        "Egy alkalom akkor kerül ide, ha lezárult — amikor a szinted kiürült, és eltelt néhány óra.",
    "%@ drinks": "%@ ital",
    "peak": "csúcs",
    "Started": "Kezdés",
    "Lasted": "Tartam",
    "Calculated with your profile at the time": "Az akkori profiloddal számolva",

    # --- TodayView ---
    "Profile": "Profil",
    "End session": "Alkalom lezárása",
    "estimated level": "becsült szint",
    "estimated range": "becsült tartomány",
    "Elapsed": "Tartam",
    "Drinks": "Italok",
    "Units": "Egység",
    "Expected to clear": "Várhatóan ekkorra ürül ki",
    "Drinks this session": "Az alkalom italai",
    "This is an estimate, not a measurement.": "Ez egy becslés, nem mérés.",
    "Actual values vary considerably between individuals. Never use this to decide whether you can drive.":
        "A tényleges érték egyénenként jelentősen eltérhet. Soha ne használd annak eldöntésére, hogy vezethetsz-e.",
    "Add drink": "Ital hozzáadása",

    # --- Editing an already logged drink ---
    "Edit drink": "Ital szerkesztése",
    "Save changes": "Mentés",
    "With this": "Ezzel",
    "Delete": "Törlés",
    "tap to edit · swipe to delete": "koppints a szerkesztéshez · húzd a törléshez",

    # --- Drinking pace ---
    "How fast": "Milyen tempóban",
    "In one go": "Egy hajtásra",
    "15 min": "15 perc",
    "30 min": "30 perc",
    "1 hr": "1 óra",
    "Counts as a single swallow — the steepest possible rise.":
        "Egyetlen kortynak számít — ez a lehető legmeredekebb emelkedés.",
    "A quick drink. The level climbs fast.":
        "Gyors ital. A szint meredeken emelkedik.",
    "A normal pace.": "Szokásos tempó.",
    "Nursed slowly. Much gentler climb for the same alcohol.":
        "Lassan kortyolva. Ugyanannyi alkohol, sokkal szelídebb emelkedés.",

    # --- AddDrinkSheet ---
    "Cancel": "Mégse",
    "Now": "Most",
    "Projected peak": "Vetített csúcs",
    "Peak at": "Csúcs ekkor",
    "Clears": "Kiürül",
    "This would cross your limit": "Átlépnéd a saját határod",
    "Around %@, for up to %@.": "%@ körül, legfeljebb %@ hosszan.",
    "This might cross your limit": "Átlépheted a saját határod",
    "With slower metabolism yes, with faster no. That's the uncertainty of the estimate.":
        "A lassabb lebontás esetén igen, a gyorsabbnál nem. Ez a becslés bizonytalansága.",
    "Type": "Típus",
    "Amount": "Mennyiség",
    "Strength": "Alkoholfok",
    "%@ units": "%@ egység",
    "%@ g alcohol": "%@ g alkohol",
    "Stomach": "Gyomor",
    "When": "Időpont",
    "15 min ago": "15 perce",
    "30 min ago": "30 perce",
    "1 hr ago": "1 órája",
    "Done": "Kész",
    "Set exact time": "Pontos idő megadása",
    "Add": "Hozzáadás",

    # --- ProfileSheet ---
    "Male": "Férfi",
    "Female": "Nő",
    "Sex": "Nem",
    "Weight": "Testsúly",
    "Height": "Magasság",
    "Age": "Életkor",
    "kg": "kg",
    "cm": "cm",
    "yrs": "év",
    "Body": "Testalkat",
    "Total body water comes from the Watson equations, which set the volume alcohol distributes into.":
        "A teljes testvíz a Watson-formulákból jön, ez adja meg az alkohol eloszlási terét.",
    "Total body water comes from the Watson equations, which set the volume alcohol distributes into. "
    "The female equation does not include age, so changing it will not affect the result.":
        "A teljes testvíz a Watson-formulákból jön, ez adja meg az alkohol eloszlási terét. "
        "A női egyenlet nem tartalmazza az életkort, ezért annak állítása nem változtat az eredményen.",
    "Drinking frequency": "Fogyasztás gyakorisága",
    "How often do you drink?": "Milyen gyakran iszol?",
    "This is how we estimate your elimination rate. Regular drinking induces the liver's CYP2E1 pathway, "
    "so frequent drinkers clear alcohol faster. It is the weakest point of the model, which is why you can "
    "set under Advanced how much of that uncertainty the app shows you.":
        "Ebből becsüljük a lebontási sebességet. A rendszeres fogyasztás indukálja a máj CYP2E1 útvonalát, "
        "ezért a gyakori fogyasztók gyorsabban bontják le az alkoholt. Ez a modell leggyengébb pontja, "
        "ezért a Haladó beállításokban megadhatod, mennyit mutasson meg az app ebből a bizonytalanságból.",
    "Your limit": "Saját határ",
    "Your own reference number, not a legal limit. The app tells you when a planned drink would take you "
    "past it, and for how long you would stay above.":
        "A te referenciaszámod, nem jogi limit. Az app jelzi, ha egy tervezett ital átvinne rajta — és azt "
        "is, mennyi ideig maradnál fölötte.",
    "Unit": "Mértékegység",
    "Display": "Megjelenítés",
    "Calculated values": "Számított értékek",
    "Total body water": "Teljes testvíz",
    "Distribution volume": "Eloszlási térfogat",
    "Widmark factor": "Widmark-faktor",
    "The Widmark factor is typically around 0.68 for men and 0.55 for women. If yours is far from that, "
    "it is worth checking the values above.":
        "A Widmark-faktor tipikusan 0,68 körül van férfiaknál és 0,55 körül nőknél. Ha a tiéd messze esik "
        "ettől, érdemes ellenőrizni a fenti adatokat.",
    "Elimination rate": "Lebontási sebesség",
    "How fast your liver clears alcohol once it has been absorbed — the slope of the falling side of the curve.":
        "Milyen gyorsan üríti a májad a már felszívódott alkoholt — ez a görbe lecsengő szakaszának meredeksége.",
    "Alcohol leaves at a roughly fixed amount per hour rather than a percentage, because the enzyme that breaks it down already runs at full capacity at almost any level. That is why rules of thumb like “one drink an hour” exist at all.":
        "Az alkohol nem százalékosan tűnik el, hanem óránként fix mennyiséggel, mert a lebontó enzim már nagyon alacsony szinten is teljes kapacitáson dolgozik. Innen van, hogy egyáltalán létezik olyan ökölszabály, mint az „óránként egy ital”.",
    "At this setting, %@ takes about %@ to clear. Almost everyone falls between %@ per hour.":
        "Ezzel a beállítással %@ körülbelül %@ alatt ürül ki. Szinte mindenkinél %@ közé esik ez az "
        "érték óránként.",
    "How to find yours": "Hogyan derítheted ki a sajátodat?",
    "With a breathalyser": "Alkoholszondával",
    "Blow twice, at least an hour apart, on the falling side — two hours or more after your last drink, "
    "with nothing in between. Subtract the second reading from the first and divide by the hours between "
    "them.":
        "Fújj kétszer, legalább egy óra különbséggel, a lecsengő ágon — az utolsó ital után legalább két "
        "órával, és közben ne igyál. Vond ki a második mérést az elsőből, és oszd el a köztük eltelt órák "
        "számával.",
    "For example %@ and %@ two hours later works out to %@ per hour.":
        "Például %@, majd két órával később %@: ez %@ óránként.",
    "Without one": "Szonda nélkül",
    "The app tells you when it expects you to clear. If you are reliably back to normal well before that, "
    "your rate is higher than the setting — nudge it up a step and watch for a few sessions. If it takes "
    "longer than predicted, nudge it down.":
        "Az app megmondja, mikorra várja a kiürülést. Ha ennél jóval hamarabb vagy rendben, a lebontásod "
        "gyorsabb a beállítottnál — vidd feljebb egy lépéssel, és figyeld néhány alkalmon át. Ha tovább "
        "tart, vidd lejjebb.",
    "What moves it": "Mi befolyásolja",
    "Regular drinking raises it: the liver enzyme that does the work is induced by use. It also runs "
    "slightly higher in women on average, and lower on an empty stomach or with liver trouble.":
        "A rendszeres fogyasztás növeli: a munkát végző májenzim a használattól indukálódik. Nőknél "
        "átlagosan valamivel magasabb, éhgyomorra és májbetegség esetén pedig alacsonyabb.",
    "Uncertainty": "Bizonytalanság",
    "At zero every figure is a single number — the app's best estimate. Above zero the same figures are "
    "shown as ranges, and the band on the chart widens to match.":
        "Nullán minden szám egyetlen érték — az app legjobb becslése. Nulla fölött ugyanezek "
        "tartományként jelennek meg, és a grafikon sávja is ennek megfelelően szélesedik.",
    "A single number is easier to learn against: over time you find out what your own 0.6 feels like. "
    "A range is the more literal answer, because the rate really is uncertain. Both are defensible — "
    "this is your call.":
        "Egyetlen számhoz könnyebb tanulni: idővel megtudod, nálad mit jelent a 0,6. A tartomány a szó "
        "szerintibb válasz, mert a lebontási sebesség tényleg bizonytalan. Mindkettő védhető — ez a te "
        "döntésed.",
    "The spread suggested by your drinking frequency is ± %@ per hour.":
        "A fogyasztási gyakoriságod alapján javasolt szórás ± %@ óránként.",
    "Rate": "Sebesség",
    "Range": "Sáv",
    "Advanced": "Haladó beállítások",
    "Uncertainty is a matter of taste: it decides whether figures read as one number or as a range. "
    "The rate below is not — leave it to the frequency question unless you have a measurement to match "
    "it against.":
        "A bizonytalanság ízlés kérdése: ez dönti el, hogy a számok egy értékként vagy tartományként "
        "jelennek meg. Az alatta lévő sebesség nem az — hagyd a gyakorisági kérdésre, hacsak nincs mért "
        "értéked, amihez igazítanád.",
}


def swift_sources() -> str:
    """All Swift sources concatenated, with comments stripped."""
    parts = []
    for f in sorted(APP.rglob("*.swift")):
        src = f.read_text()
        parts.append(re.sub(r"//[^\n]*", "", src))
    return "\n".join(parts)


def source_key(key: str) -> str:
    """Turns a catalog key back into the pattern it takes in the Swift source."""
    # %@ may stand for any interpolation, including nested parentheses
    escaped = re.escape(key)
    for token in (re.escape("%@"), "%@"):
        escaped = escaped.replace(token, r"\\\([^\n]+?\)+?")
    return escaped


def main() -> int:
    sources = swift_sources()
    problems = []

    # 1. every key must occur in the source
    for key in TRANSLATIONS:
        pattern = source_key(key)
        if not re.search(pattern, sources, re.S):
            problems.append(f"NOT IN SOURCE: {key!r}")

    # 2. no localized string in the source may be missing a translation
    literals = set()
    # Text("..."), Button("...") - Text(verbatim:) is deliberately excluded,
    # because those are not translated (numbers, times, symbols).
    for m in re.finditer(r'\b(?:Text|Button)\(\s*"((?:[^"\\]|\\.)*)"', sources):
        literals.add(m.group(1))

    # Only the switch arms of properties returning LocalizedStringResource.
    # `suffix` and `icon` are plain Strings - SF Symbol names and the ‰/%
    # signs - and must not be translated.
    for block in re.finditer(
        r"var \w+: LocalizedStringResource \{(.*?)\n    \}", sources, re.S
    ):
        for m in re.finditer(r'case \.\w+:\s*"((?:[^"\\]|\\.)*)"', block.group(1)):
            literals.add(m.group(1))

    # Swift Charts .value("...") labels: Xcode extracts these too, and
    # VoiceOver reads them out, so they need translating.
    for m in re.finditer(r'\.value\(\s*"((?:[^"\\]|\\.)*)"', sources):
        literals.add(m.group(1))

    # DrinkTemplate names are LocalizedStringResource too. We only look
    # inside the template constructor: Drink(name:) stores the template
    # IDENTIFIER, which must not be translated.
    for block in re.finditer(r"DrinkTemplate\((.*?)\n        \)", sources, re.S):
        for m in re.finditer(r'name:\s*"((?:[^"\\]|\\.)*)"', block.group(1)):
            literals.add(m.group(1))

    # Local helper views take LocalizedStringKey parameters, and a literal
    # passed to one is just as translatable as the same literal inside Text().
    #
    # Position matters: the very same helpers also take plain Strings —
    # already-formatted values, SF Symbol names — which must NOT be
    # translated. So we read each signature, note which argument positions are
    # LocalizedStringKey, and only harvest literals sitting at those positions
    # of the call. Swift keeps argument order, so the index is enough.

    def split_top_level(text: str) -> list[str]:
        """Splits an argument or parameter list on its top-level commas."""
        parts, depth, in_string, current = [], 0, False, []
        i = 0
        while i < len(text):
            ch = text[i]
            if in_string:
                if ch == "\\":
                    current.append(text[i : i + 2])
                    i += 2
                    continue
                if ch == '"':
                    in_string = False
            elif ch == '"':
                in_string = True
            elif ch in "([{":
                depth += 1
            elif ch in ")]}":
                depth -= 1
            elif ch == "," and depth == 0:
                parts.append("".join(current))
                current = []
                i += 1
                continue
            current.append(ch)
            i += 1
        parts.append("".join(current))
        return parts

    def argument_list(text: str, start: int) -> str | None:
        """The balanced argument list that opens at `start` (just past `(`)."""
        i, depth, in_string = start, 1, False
        while i < len(text):
            ch = text[i]
            if in_string:
                if ch == "\\":
                    i += 2
                    continue
                if ch == '"':
                    in_string = False
            elif ch == '"':
                in_string = True
            elif ch == "(":
                depth += 1
            elif ch == ")":
                depth -= 1
                if depth == 0:
                    return text[start:i]
            i += 1
        return None

    for sig in re.finditer(r"func (\w+)\(", sources):
        params = argument_list(sources, sig.end())
        if params is None or "LocalizedStringKey" not in params:
            continue
        localized = {
            i for i, p in enumerate(split_top_level(params))
            if "LocalizedStringKey" in p
        }
        for call in re.finditer(rf"\b{sig.group(1)}\(", sources):
            args = argument_list(sources, call.end())
            if args is None:
                continue
            for i, arg in enumerate(split_top_level(args)):
                if i not in localized:
                    continue
                lit = re.fullmatch(r'\s*(?:\w+:\s*)?"((?:[^"\\]|\\.)*)"\s*', arg)
                if lit:
                    literals.add(lit.group(1))

    def normalize(lit: str) -> str:
        """Replaces `\\(...)` interpolations with %@, keeping parens balanced."""
        out, i = [], 0
        while i < len(lit):
            if lit.startswith("\\(", i):
                depth, j = 1, i + 2
                while j < len(lit) and depth:
                    if lit[j] == "(":
                        depth += 1
                    elif lit[j] == ")":
                        depth -= 1
                    j += 1
                out.append("%@")
                i = j
            else:
                out.append(lit[i])
                i += 1
        return "".join(out)

    for lit in sorted(literals):
        norm = normalize(lit)
        if norm not in TRANSLATIONS:
            problems.append(f"NO TRANSLATION: {norm!r}")

    # 3. format specifiers must match on both sides
    for en, hu in TRANSLATIONS.items():
        if en.count("%@") != hu.count("%@"):
            problems.append(f"SPECIFIER MISMATCH: {en!r} ({en.count('%@')}) vs {hu!r} ({hu.count('%@')})")
        if "%" in en.replace("%@", ""):
            problems.append(f"SUSPICIOUS PERCENT SIGN: {en!r}")

    if problems:
        print("PROBLEMS:")
        for p in problems:
            print("  -", p)
        return 1

    catalog = {
        "sourceLanguage": "en",
        "version": "1.0",
        "strings": {
            en: {
                "extractionState": "manual",
                "localizations": {
                    "en": {"stringUnit": {"state": "translated", "value": en}},
                    "hu": {"stringUnit": {"state": "translated", "value": hu}},
                },
            }
            for en, hu in sorted(TRANSLATIONS.items())
        },
    }

    out = APP / "Localizable.xcstrings"
    out.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n")
    print(f"OK - {len(TRANSLATIONS)} keys -> {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
