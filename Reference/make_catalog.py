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

APP = pathlib.Path("/sessions/affectionate-admiring-hawking/mnt/test/DrinkSmart/DrinkSmart")

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

    # --- RootView ---
    "Profile": "Profil",
    "End session": "Alkalom lezárása",
    "estimated level": "becsült szint",
    "estimated range": "becsült tartomány",
    "Elapsed": "Tartam",
    "Drinks": "Italok",
    "Units": "Egység",
    "Expected to clear": "Várhatóan ekkorra ürül ki",
    "Drinks this session": "Az alkalom italai",
    "No drinks logged yet": "Még nincs felvitt ital",
    "Add your first one and you'll see how your level develops over time.":
        "Vidd fel az elsőt, és látni fogod, hogyan alakul a szinted az idő múlásával.",
    "This is an estimate, not a measurement.": "Ez egy becslés, nem mérés.",
    "Actual values vary considerably between individuals. Never use this to decide whether you can drive.":
        "A tényleges érték egyénenként jelentősen eltérhet. Soha ne használd annak eldöntésére, hogy vezethetsz-e.",
    "Add drink": "Ital hozzáadása",

    # --- Editing an already logged drink ---
    "Edit drink": "Ital szerkesztése",
    "Save changes": "Mentés",
    "Without this": "Enélkül",
    "With this": "Ezzel",
    "Delete": "Törlés",
    "tap to edit · swipe to delete": "koppints a szerkesztéshez · húzd a törléshez",

    # --- AddDrinkSheet ---
    "Cancel": "Mégse",
    "Now": "Most",
    "Projected peak": "Vetített csúcs",
    "Peak at": "Csúcs ekkor",
    "Time to peak": "Csúcsig",
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
    "so frequent drinkers clear alcohol faster. This is the weakest point of the model — which is why the "
    "app shows a range instead of a single number.":
        "Ebből becsüljük a lebontási sebességet. A rendszeres fogyasztás indukálja a máj CYP2E1 útvonalát, "
        "ezért a gyakori fogyasztók gyorsabban bontják le az alkoholt. Ez a modell leggyengébb pontja — "
        "ezért mutat az app tartományt egyetlen szám helyett.",
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
    "Uncertainty": "Bizonytalanság",
    "Range": "Sáv",
    "Advanced": "Haladó beállítások",
    "Only set these by hand if you have something to calibrate against — for example an actual breathalyser "
    "reading you can compare the estimate to.":
        "Csak akkor állítsd kézzel, ha van mihez igazítanod — például ha valaha alkoholszondával "
        "visszamérted magad, és tudod, mennyire tért el a becslés.",
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
