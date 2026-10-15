#!/usr/bin/env python3
"""Fix OCR letter/digit mixups using a dictionary: system.1og -> system.log.
stdin -> stdout. A token is only changed when it is a non-word and a
swapped variant is a word, so anything else (other languages, code) passes through."""
import itertools
import re
import sys

with open("/usr/share/dict/words") as f:
    WORDS = {w.strip().lower() for w in f}

# misread char -> letters it may really be (letter context)
AS_LETTER = {"1": "liI", "l": "I", "I": "l", "|": "lI", "0": "oO", "5": "sS", "8": "B"}
# misread char -> digit it may really be (number context)
AS_DIGIT = {"O": "0", "o": "0", "l": "1", "I": "1", "|": "1", "S": "5", "B": "8"}


def fix(m):
    t = m.group()
    if len(t) < 3 or t.isdigit() or t.lower() in WORDS:
        return t
    # number context: mostly digits, every other char is a known misread
    if sum(c.isdigit() for c in t) * 2 > len(t) and all(c.isdigit() or c in AS_DIGIT for c in t):
        return "".join(AS_DIGIT.get(c, c) for c in t)
    # ponytail: letters+trailing digits are identifiers (md5, utf8, eth0), so "Hell0" stays unfixed
    if re.fullmatch(r"[A-Za-z]+\d+", t):
        return t
    pos = [i for i, c in enumerate(t) if c in AS_LETTER]
    if not pos or len(pos) > 6:  # ponytail: 4^6 variants cap, raise if long tokens matter
        return t
    variants = itertools.product(*[t[i] + AS_LETTER[t[i]] for i in pos])
    for combo in sorted(variants, key=lambda v: sum(a != t[i] for a, i in zip(v, pos))):
        v = list(t)
        for i, c in zip(pos, combo):
            v[i] = c
        v = "".join(v)
        if v.lower() in WORDS:
            return v.upper() if t.isupper() else v
    return t


def run(text):
    return re.sub(r"(?:[^\W_]|\|)+", fix, text)


if __name__ == "__main__":
    if sys.argv[1:] == ["--test"]:
        assert run("see system.1og") == "see system.log"
        assert run("f1le Iog lnternet") == "file log Internet"
        assert run("2O24 1O0") == "2024 100"
        assert run("SYSTEM.1OG") == "SYSTEM.LOG"
        for keep in ("md5", "utf8", "eth0", "v1", "1", "hello", "tiếng Việt", "a | b", "x86_64"):
            assert run(keep) == keep, (keep, run(keep))
        print("ok")
    else:
        sys.stdout.write(run(sys.stdin.read()))
