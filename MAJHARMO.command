#!/bin/bash
cd "$(dirname "$0")"

# ── Couleurs ──────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'

bar() { echo "═══════════════════════════════════════════════════════"; }
thin() { echo "───────────────────────────────────────────────────────"; }

echo ""
bar
echo "  HARMONIA · Mise à jour GitHub"
bar
echo ""

# ── Supprimer les verrous git ─────────────────────────────────
rm -f .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock

# ── Remote et credentials ─────────────────────────────────────
git remote set-url origin "https://github.com/atoutdunon-ship-it/harmonia-prod.git"
git config credential.helper osxkeychain
git config user.email "atout.dunon@gmail.com"
git config user.name "Harmonia"

# ── État AVANT ───────────────────────────────────────────────
PREV_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "aucun")
PREV_MSG=$(git log -1 --pretty="%s" 2>/dev/null || echo "")
PREV_JS_SIZE=$(wc -c < harmonia-shared.js 2>/dev/null || echo 0)
PREV_CSS_SIZE=$(wc -c < harmonia-shared.css 2>/dev/null || echo 0)

# ── BUILD ────────────────────────────────────────────────────
echo -e "${BOLD}🔨  Compilation (build.py)...${RESET}"
if [ -f "build.py" ]; then
  python3 build.py
  if [ $? -ne 0 ]; then
    echo -e "${RED}  ❌ BUILD ÉCHOUÉ — vérifiez harmonia-shared.src.js${RESET}"
    echo ""
    read -p "Appuie sur Entrée pour fermer..."
    exit 1
  fi
else
  echo -e "${YELLOW}  ⚠️  build.py introuvable — commit sans recompilation${RESET}"
fi
echo ""

# ── Tailles APRÈS build ───────────────────────────────────────
NEW_JS_SIZE=$(wc -c < harmonia-shared.js 2>/dev/null || echo 0)
NEW_CSS_SIZE=$(wc -c < harmonia-shared.css 2>/dev/null || echo 0)

# ── STAGE ────────────────────────────────────────────────────
git add -A

# ── COMPARATIF AVANT / APRÈS ──────────────────────────────────
if ! git diff --cached --quiet; then

  echo -e "${BOLD}╔═══════════════════════════════════════════════════════╗${RESET}"
  echo -e "${BOLD}║   COMPARATIF AVANT / APRÈS                            ║${RESET}"
  echo -e "${BOLD}╚═══════════════════════════════════════════════════════╝${RESET}"
  echo ""

  # ── Commit précédent ──────────────────────────────────────
  echo -e "  ${DIM}AVANT  [$PREV_HASH]  $PREV_MSG${RESET}"

  # ── Tailles build ─────────────────────────────────────────
  if [ "$PREV_JS_SIZE" -gt 0 ] && [ "$NEW_JS_SIZE" -gt 0 ]; then
    JS_DIFF=$(( NEW_JS_SIZE - PREV_JS_SIZE ))
    CSS_DIFF=$(( NEW_CSS_SIZE - PREV_CSS_SIZE ))
    if [ $JS_DIFF -ge 0 ]; then JS_SIGN="+"; else JS_SIGN=""; fi
    if [ $CSS_DIFF -ge 0 ]; then CSS_SIGN="+"; else CSS_SIGN=""; fi
    printf "  ${DIM}JS  : %s octets → %s octets  (%s%s)${RESET}\n" \
      "$PREV_JS_SIZE" "$NEW_JS_SIZE" "$JS_SIGN" "$JS_DIFF"
    printf "  ${DIM}CSS : %s octets → %s octets  (%s%s)${RESET}\n" \
      "$PREV_CSS_SIZE" "$NEW_CSS_SIZE" "$CSS_SIGN" "$CSS_DIFF"
  fi
  echo ""
  thin

  # ── Liste fichiers avec stats +/- ────────────────────────
  echo -e "\n  ${BOLD}FICHIERS MODIFIÉS${RESET}\n"
  git diff --cached --name-status | while IFS=$'\t' read STATUS FILE REST; do
    case "$STATUS" in
      A)  TAG="${GREEN}✚ NOUVEAU  ${RESET}" ;;
      M)  TAG="${CYAN}✎ MODIFIÉ  ${RESET}" ;;
      D)  TAG="${RED}✖ SUPPRIMÉ ${RESET}" ;;
      R*) TAG="${YELLOW}↷ RENOMMÉ  ${RESET}" ;;
      *)  TAG="? $STATUS    " ;;
    esac
    # Compter +/- lignes pour ce fichier
    STATS=$(git diff --cached --numstat -- "$FILE" 2>/dev/null | awk '{printf "+%s / -%s", $1, $2}')
    echo -e "    $TAG $FILE  ${DIM}$STATS${RESET}"
  done
  echo ""
  thin

  # ── Diff détaillé des fichiers SOURCE (pas le .js minifié) ───
  SOURCE_FILES=$(git diff --cached --name-only | grep -E '\.(src\.js|src\.css|html|md|py|json)$' | grep -v 'harmonia-shared\.js$' | grep -v 'harmonia-shared\.css$')

  if [ -n "$SOURCE_FILES" ]; then
    echo -e "\n  ${BOLD}DÉTAIL DES MODIFICATIONS (fichiers source)${RESET}\n"
    for FILE in $SOURCE_FILES; do
      echo -e "  ${CYAN}▶ $FILE${RESET}"
      thin
      # Afficher le diff avec contexte réduit (3 lignes)
      git diff --cached --unified=2 -- "$FILE" | tail -n +5 | while IFS= read -r line; do
        case "${line:0:1}" in
          +) echo -e "    ${GREEN}$line${RESET}" ;;
          -) echo -e "    ${RED}$line${RESET}" ;;
          @) echo -e "    ${DIM}$line${RESET}" ;;
          *) echo "    $line" ;;
        esac
      done
      echo ""
    done
    thin
  fi

  # ── Images / assets (pas de diff texte) ─────────────────
  ASSET_FILES=$(git diff --cached --name-only | grep -E '\.(jpg|jpeg|png|gif|webp|svg|ico|woff|woff2|ttf)$')
  if [ -n "$ASSET_FILES" ]; then
    echo -e "\n  ${BOLD}ASSETS (binaires)${RESET}"
    for FILE in $ASSET_FILES; do
      SIZE=$(du -h "$FILE" 2>/dev/null | cut -f1 || echo "?")
      echo -e "    ${YELLOW}◉${RESET} $FILE  ${DIM}($SIZE)${RESET}"
    done
    echo ""
    thin
  fi

  # ── COMMIT ───────────────────────────────────────────────
  echo ""
  MSG="MAJHARMO — $(date '+%Y-%m-%d %H:%M')"
  git commit -m "$MSG" 2>/dev/null
  NEW_HASH=$(git rev-parse --short HEAD)
  echo -e "  ${GREEN}✅ Commit : [$NEW_HASH] $MSG${RESET}"
  echo ""

else
  echo -e "  ${DIM}ℹ️   Aucune modification locale à committer${RESET}"
  NEW_HASH=$(git rev-parse --short HEAD)
  echo ""
fi

# ── PUSH ─────────────────────────────────────────────────────
echo -e "${BOLD}╔═══════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}║   ENVOI VERS GITHUB                                   ║${RESET}"
echo -e "${BOLD}╚═══════════════════════════════════════════════════════╝${RESET}"
echo ""

# Commits locaux non poussés
PENDING=$(git log origin/main..HEAD --oneline 2>/dev/null)
if [ -n "$PENDING" ]; then
  echo -e "  ${BOLD}Commits en attente de push :${RESET}"
  echo "$PENDING" | while read -r line; do
    echo -e "    ${CYAN}·${RESET} $line"
  done
  echo ""
fi

git push origin main 2>&1
PUSH_CODE=$?
PUSHED_HASH=$(git rev-parse --short HEAD)

echo ""
thin
if [ $PUSH_CODE -eq 0 ]; then
  echo -e "  ${GREEN}✅ Push réussi${RESET}"
  echo -e "  ${DIM}Avant  : [$PREV_HASH] $PREV_MSG${RESET}"
  echo -e "  ${DIM}Après  : [$PUSHED_HASH] $(git log -1 --pretty='%s')${RESET}"
  echo ""
  echo -e "  ${GREEN}✅ DÉPLOIEMENT TERMINÉ${RESET}"
  echo -e "  ${CYAN}→ https://atoutdunon-ship-it.github.io/harmonia-prod/${RESET}"
  echo -e "  ${DIM}→ GitHub Pages rebuild : ~1 min${RESET}"
  echo -e "  ${DIM}→ Vider cache si besoin : Cmd+Shift+R${RESET}"
else
  echo -e "  ${RED}❌ PUSH ÉCHOUÉ (code $PUSH_CODE)${RESET}"
  echo -e "  ${DIM}→ Vérifiez votre connexion et vos accès GitHub${RESET}"
  echo ""
  echo -e "  ${YELLOW}⚠️   Commit local OK — relancez MAJHARMO ou poussez manuellement${RESET}"
fi
thin
echo ""
read -p "Appuie sur Entrée pour fermer..."
