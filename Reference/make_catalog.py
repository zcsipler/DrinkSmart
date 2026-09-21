"""
Generates and verifies Localizable.xcstrings.

Source language is English. Every other language lives in its own module under
`translations/`, each one a plain `TRANSLATIONS` dict from the English source
string to that language. In interpolated keys, %@ stands for the substituted
value.

The script checks that every key really occurs in the Swift source, that no
localized string in the source was left without a translation, and that every
language file carries exactly the same key set with the same number of format
specifiers.

Hungarian is the reference: it was written and read by someone who speaks it,
and its key set defines what the catalog contains. The rest were drafted in
bulk and land in the catalog as `needs_review`, which is what Xcode shows as
"needs review" and what tells the next reader which strings nobody has
checked yet. Moving a language into `REVIEWED` is the act of vouching for it.
"""

import importlib
import json
import pathlib
import re
import sys

# Relative to this file, so the script runs from any checkout or sandbox.
HERE = pathlib.Path(__file__).resolve().parent
APP = HERE.parent / "DrinkSmart"

# The reference translation, and the ones a human has actually read.
REFERENCE = "hu"
REVIEWED = {"hu"}


def languages() -> dict[str, dict[str, str]]:
    """Every `translations/<code>.py`, by language code."""
    sys.path.insert(0, str(HERE))
    found = {}
    for f in sorted((HERE / "translations").glob("*.py")):
        if f.stem.startswith("_"):
            continue
        found[f.stem] = importlib.import_module(f"translations.{f.stem}").TRANSLATIONS
    return found


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

    langs = languages()
    if REFERENCE not in langs:
        print(f"MISSING REFERENCE: translations/{REFERENCE}.py")
        return 1
    keys = langs[REFERENCE]

    # 1. every key must occur in the source
    for key in keys:
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
        if norm not in keys:
            problems.append(f"NO TRANSLATION: {norm!r}")

    # 3. a literal percent sign would be read as a format specifier
    for en in keys:
        if "%" in en.replace("%@", ""):
            problems.append(f"SUSPICIOUS PERCENT SIGN: {en!r}")

    # 4. every language carries the same keys, with the same specifiers
    for code, table in sorted(langs.items()):
        for key in sorted(set(keys) - set(table)):
            problems.append(f"{code}: MISSING KEY: {key!r}")
        for key in sorted(set(table) - set(keys)):
            problems.append(f"{code}: UNKNOWN KEY: {key!r}")
        for en, translated in sorted(table.items()):
            if not translated.strip():
                problems.append(f"{code}: EMPTY: {en!r}")
            elif en.count("%@") != translated.count("%@"):
                problems.append(
                    f"{code}: SPECIFIER MISMATCH: {en!r} ({en.count('%@')}) "
                    f"vs {translated!r} ({translated.count('%@')})"
                )

    if problems:
        print("PROBLEMS:")
        for p in problems:
            print("  -", p)
        return 1

    def localizations(en: str) -> dict:
        out = {"en": {"stringUnit": {"state": "translated", "value": en}}}
        for code in sorted(langs):
            state = "translated" if code in REVIEWED else "needs_review"
            out[code] = {"stringUnit": {"state": state, "value": langs[code][en]}}
        return out

    catalog = {
        "sourceLanguage": "en",
        "version": "1.0",
        "strings": {
            en: {
                "extractionState": "manual",
                "localizations": localizations(en),
            }
            for en in sorted(keys)
        },
    }

    out = APP / "Localizable.xcstrings"
    out.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n")
    reviewed = sorted(REVIEWED & set(langs))
    print(
        f"OK - {len(keys)} keys x {len(langs) + 1} languages -> {out}\n"
        f"     reviewed: en, {', '.join(reviewed)}"
        f" | needs review: {', '.join(sorted(set(langs) - REVIEWED)) or 'none'}"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
