#!/usr/bin/env python3
"""
HARMONIA — Script de build / protection copyright
Usage : python3 build.py

- Supprime commentaires JS/CSS sans altérer le code
- Ajoute en-tête copyright
- Sources restent dans .src.js / .src.css (gitignore)
"""
import shutil, os

COPYRIGHT_JS = """\
/*!
 * © 2025 HARMONIA — Maison de Production. Tous droits réservés.
 * Code source protégé. Reproduction interdite sans autorisation écrite.
 * contact@harmonia.cv
 */"""

COPYRIGHT_CSS = """\
/*!
 * © 2025 HARMONIA — Maison de Production. Tous droits réservés.
 */"""


# ─── Parseur JS avec machine à états ─────────────────────────────────────────

def strip_js_comments(src: str) -> str:
    """
    Parcourt le code caractère par caractère.
    Supprime les commentaires // et /* */ sans toucher aux chaînes ni aux regex.
    Gère : chaînes '', "", ``, regex literals /.../, commentaires //, /* */
    """
    out = []
    i = 0
    n = len(src)
    # Dernier caractère "significatif" émis (hors espaces/newlines)
    # Permet de distinguer regex '/' de division '/'
    last_sig = ';'  # on commence comme après un statement

    # Caractères qui précèdent un opérateur de division (expression terminée)
    EXPR_END = frozenset('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$)]\'"}`')

    while i < n:
        c = src[i]

        # ── Chaîne simple quote ──────────────────────────────────────────
        if c == "'":
            j = i + 1
            while j < n:
                if src[j] == '\\':
                    j += 2
                    continue
                if src[j] == "'":
                    j += 1
                    break
                j += 1
            out.append(src[i:j])
            last_sig = "'"
            i = j
            continue

        # ── Chaîne double quote ──────────────────────────────────────────
        if c == '"':
            j = i + 1
            while j < n:
                if src[j] == '\\':
                    j += 2
                    continue
                if src[j] == '"':
                    j += 1
                    break
                j += 1
            out.append(src[i:j])
            last_sig = '"'
            i = j
            continue

        # ── Template literal ──────────────────────────────────────────────
        if c == '`':
            j = i + 1
            depth = 0
            while j < n:
                if src[j] == '\\':
                    j += 2
                    continue
                if src[j] == '$' and j + 1 < n and src[j+1] == '{':
                    depth += 1
                    j += 2
                    continue
                if src[j] == '}' and depth > 0:
                    depth -= 1
                    j += 1
                    continue
                if src[j] == '`' and depth == 0:
                    j += 1
                    break
                j += 1
            out.append(src[i:j])
            last_sig = '`'
            i = j
            continue

        # ── Commentaire // ────────────────────────────────────────────────
        if c == '/' and i + 1 < n and src[i+1] == '/':
            j = i + 2
            while j < n and src[j] != '\n':
                j += 1
            i = j
            continue

        # ── Commentaire bloc /* ... */ ────────────────────────────────────
        if c == '/' and i + 1 < n and src[i+1] == '*':
            j = i + 2
            while j < n - 1:
                if src[j] == '*' and src[j+1] == '/':
                    j += 2
                    break
                j += 1
            i = j
            continue

        # ── Regex literal /.../ ───────────────────────────────────────────
        # Un '/' est un début de regex si le dernier token significatif
        # n'est PAS la fin d'une expression (identifiant, ), ], nombre…)
        if c == '/' and i + 1 < n and last_sig not in EXPR_END:
            j = i + 1
            in_class = False  # à l'intérieur de [...]
            while j < n:
                if src[j] == '\\':
                    j += 2
                    continue
                if src[j] == '[':
                    in_class = True
                    j += 1
                    continue
                if src[j] == ']' and in_class:
                    in_class = False
                    j += 1
                    continue
                if src[j] == '/' and not in_class:
                    j += 1
                    # consommer les flags (gimsuy)
                    while j < n and src[j] in 'gimsuy':
                        j += 1
                    break
                if src[j] == '\n':
                    # Pas une regex valide, traiter comme division
                    break
                j += 1
            else:
                # fin de fichier sans fermeture — traiter comme division
                out.append(c)
                last_sig = c
                i += 1
                continue
            out.append(src[i:j])
            last_sig = '/'
            i = j
            continue

        out.append(c)
        if c not in ' \t\n\r':
            last_sig = c
        i += 1

    code = ''.join(out)

    # Supprimer les lignes vides consécutives (max 1)
    import re
    code = re.sub(r'\n{3,}', '\n\n', code)
    # Supprimer espaces en fin de ligne
    lines = [l.rstrip() for l in code.split('\n')]
    return '\n'.join(lines).strip()


# ─── Minification CSS (conservative) ─────────────────────────────────────────

def strip_css_comments(src: str) -> str:
    import re
    # Supprimer /* ... */ sauf /*!
    def remove_comment(m):
        return '' if not m.group(0).startswith('/*!') else m.group(0)
    src = re.sub(r'/\*[\s\S]*?\*/', remove_comment, src)
    src = re.sub(r'\n{3,}', '\n\n', src)
    lines = [l.rstrip() for l in src.split('\n')]
    return '\n'.join(lines).strip()


# ─── Main ─────────────────────────────────────────────────────────────────────

def main():
    base = os.path.dirname(os.path.abspath(__file__))

    # ── JS ──
    src_js = os.path.join(base, 'harmonia-shared.src.js')
    out_js = os.path.join(base, 'harmonia-shared.js')

    if not os.path.exists(src_js):
        shutil.copy(out_js, src_js)
        print("[init] harmonia-shared.src.js créé")

    with open(src_js, encoding='utf-8') as f:
        js_src = f.read()

    js_out = COPYRIGHT_JS + '\n' + strip_js_comments(js_src)

    with open(out_js, 'w', encoding='utf-8') as f:
        f.write(js_out)

    ratio = (1 - len(js_out) / max(len(js_src), 1)) * 100
    print(f"[JS]  {len(js_src):,} → {len(js_out):,} octets  ({ratio:.1f}% réduction)")

    # ── CSS ──
    src_css = os.path.join(base, 'harmonia-shared.src.css')
    out_css = os.path.join(base, 'harmonia-shared.css')

    if not os.path.exists(src_css):
        shutil.copy(out_css, src_css)
        print("[init] harmonia-shared.src.css créé")

    with open(src_css, encoding='utf-8') as f:
        css_src = f.read()

    css_out = COPYRIGHT_CSS + '\n' + strip_css_comments(css_src)

    with open(out_css, 'w', encoding='utf-8') as f:
        f.write(css_out)

    ratio = (1 - len(css_out) / max(len(css_src), 1)) * 100
    print(f"[CSS] {len(css_src):,} → {len(css_out):,} octets  ({ratio:.1f}% réduction)")

    print("\n✓ Build OK — prêt pour git push")
    print("  Editez : harmonia-shared.src.js / .src.css  puis relancez build.py")


if __name__ == '__main__':
    main()
