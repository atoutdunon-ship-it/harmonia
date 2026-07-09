#!/bin/bash
cd "$(dirname "$0")"
echo "🎵 HARMONIA — Serveur local démarré"
echo "Ouvrez Chrome → http://localhost:8888"
echo "Ctrl+C pour arrêter"
python3 -m http.server 8888
