"""
One module per language, each holding a `TRANSLATIONS` dict from the English
source string to that language. `make_catalog.py` loads all of them and builds
`Localizable.xcstrings` from what it finds — adding a language is adding a file
here and nothing else.

Hungarian is the reference (`REFERENCE` in `make_catalog.py`): its key set is
what the catalog contains, and every other file is checked against it. English
needs no file, being the source language.
"""
