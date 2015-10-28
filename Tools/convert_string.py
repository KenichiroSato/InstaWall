#!/usr/bin/env python3
# -*- coding : utf-8 -*-

"""
Convert csv or xls file to iOS Localizable.strings

[installation]
    brew install python3
    pip3 install openpyxl
Developed with Python 3.4.1 and openpyxl 2.1.0

[usage]
0.Convert excel file to utf-8 csv with LibreOffice.
    Character set     Unicode(UTF-8)
    Field delimiter   ,
    Text delimiter    "

1.Run `python3 ./convert_string.py ./UI_TVS2.8_Strings_Ver.0.30.00.csv`
   or `python3 ./convert_string.py ./UI_TVS2.8_Strings_Ver.0.30.00.xlsm`
  Note that StringIDs are sorted internally.
"""

__author__ = "Kenichiro Sato"
__version__ = "0.0.1"
__date__ = "28 October 2015"

import csv
from os.path import join, dirname, isdir
from os import mkdir
import openpyxl
import argparse

COL_STR_ID = -1
ALT_LANG = "en"
LANGS = [("jp",0, "ja"), ("en", 1, "Base")]
OUT_DIR = "../"
DIR_SUFFIX = ".lproj"
OUT_NAME = "Localizable.strings"
IGNORED_ID = set()


def load_csv(file_path):
    """
    Load data from csv file and returns a dictionary {Language: {StringID: String}}.
    """
    ret = {l[0]: {} for l in LANGS}
    with open(file_path, "r") as f:
        [[ret[lang].update({r[COL_STR_ID]: r[col]}) for lang, col, path in LANGS] for r in csv.reader(f) if
         is_valid_string_id(r[COL_STR_ID])]
    return ret


def load_xls(file_path):
    """
    Load data from xlsm file and returns a dictionary {Language: {StringID: String}}.
    """
    print("Loading excel file...")
    wb = openpyxl.load_workbook(filename=file_path)
    print("Processing excel file...")
    sheet = wb["strings"]

    esc = lambda x: x if x is not None else ""

    ret = {l[0]: {} for l in LANGS}
    for row in sheet.rows:
        [ret[lang].update({row[COL_STR_ID].value: esc(row[col].value)}) for lang, col, path in LANGS if
         is_valid_string_id(row[COL_STR_ID].value)]

    return ret


def escape_string(s):
    """
    Returns escaped string.
    """
    for c in ('"', "<", ">"):
        s = s.replace(c, "\\" + c)
    s = s.replace("\n", "\\n")
    return s


def is_valid_string_id(k):
    """
    Determines if a StringID is valid.
    """
    print("k=" + k)
    ret = k is not None and k != "" and (k.startswith("IDMR_") or k.startswith("TMP_")) \
          and "espresso_" not in k and "duration_" not in k and "elapsed_" not in k
    if not ret and k:
        global IGNORED_ID
        IGNORED_ID.add(k)
    return ret


def print_localizable_strings(strs):
    """
    Overwrites strings to Localizable.string.
    Create directories and files if not exist.
    """
    out_dir = join(dirname(__file__), OUT_DIR)
    if not isdir(out_dir):
        mkdir(out_dir)
    p = lambda x: join(out_dir, x + DIR_SUFFIX)
    for lang, column, lang_dir in LANGS:
        print("Processing " + lang)
        if not isdir(p(lang_dir)):
            mkdir(p(lang_dir))
        with open(join(p(lang_dir), OUT_NAME), "w") as f:
            for k in sorted(strs[lang].keys(), key=lambda k: k.lower().replace("_", "0")):
                v = strs[lang][k]
                v = strs[ALT_LANG][k] if v == "" else v
                v = escape_string(v)
                f.write('"' + k + '" = "' + v + '";\n')


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert CSV to Localizable.strings file.")
    parser.add_argument("file", type=str, help="CSV file path to convert.")
    args = parser.parse_args()

    if not "2.7" in args.file:
        COL_STR_ID += 1
        LANGS = [(x[0], x[1] + 1, x[2]) for x in LANGS]

    strings = {}
    if args.file.endswith(".csv"):
        strings = load_csv(args.file)
    elif args.file.endswith(".xlsm"):
        strings = load_xls(args.file)
    else:
        print("Only csv or xlsm are supported.")
        exit()
    print_localizable_strings(strings)

    if len(IGNORED_ID) > 0:
        print("Some IDs are ignored. Please confirm.")
        print("\033[93m(" + ", ".join(list(IGNORED_ID)) + ")\033[0m")
