#!/bin/bash
cd "$(dirname "$0")"
rm -f .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock
git remote set-url origin "https://github.com/atoutdunon-ship-it/harmonia-prod.git"
git config user.email "atout.dunon@gmail.com"
git config user.name "Harmonia"
echo ""
echo "=== BUILD ==="
python3 build.py
echo ""
echo "=== FICHIERS MODIFIES ==="
git add -A
git diff --cached --name-status
echo ""
echo "=== COMMIT ==="
git commit -m "MAJHARMO — $(date '+%Y-%m-%d %H:%M')"
echo ""
echo "=== PUSH ==="
git push origin main
echo ""
echo "=== TERMINE ==="
read -p "Entree pour fermer..."
