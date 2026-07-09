# HARMONIA — Historique des modifications
### Site : https://atoutdunon-ship-it.github.io/harmonia-prod/
### Fichiers sources : harmonia-shared.src.js · harmonia-shared.src.css · build.py
### Déploiement : MAJHARMO.command → GitHub Pages

---

## GUIDE DE VERSION
- Sources éditables : `harmonia-shared.src.js` / `harmonia-shared.src.css`
- Commande build : `python3 build.py` → génère `harmonia-shared.js` + `harmonia-shared.css`
- Bump version : `sed -i 's/v=XX/v=YY/g' *.html`
- Push : `MAJHARMO.command`

---

## CONTRAINTE DE SÉCURITÉ PERMANENTE
> Le compte et profil **super admin (PROD)** ne peut pas être modifié, ni supprimé sans le mot de passe **`Music7`**

---

## JOURNAL DES VERSIONS

---

### v195 — Carrousel Spotlight : swipe tactile mobile + corrections CSS — JS v195 / CSS v176

**Ajouts :**
- **Swipe tactile** : navigation par glissement horizontal sur mobile/tablette (seuil 50px, feedback visuel pendant le swipe)
- Détection intelligente swipe horizontal vs scroll vertical (pas d'interférence avec le scroll de page)
- `touch-action: pan-y` sur le wrapper pour laisser le scroll vertical natif fonctionner
- `-webkit-tap-highlight-color: transparent` pour supprimer le flash bleu au tap sur iOS
- Sauvegarde du `baseTransform` après chaque repositionnement pour un feedback de swipe précis

---

### v194 — Carrousel Spotlight : centrage corrigé + responsive affiné — JS v194 / CSS v175

**Corrections :**
- Centrage de la carte active corrigé via double `requestAnimationFrame` + `getBoundingClientRect()` pour lire les vraies largeurs après application du CSS flex
- Gap lu dynamiquement via `getComputedStyle` pour un calcul de positionnement exact
- Tailles des cartes adjacentes réduites sur chaque breakpoint pour éviter le débordement
- Flèches de navigation repositionnées et masquées quand désactivées sur mobile
- `min-height` du wrapper ajustée par breakpoint pour éviter l'espace vide sous le carrousel

---

### v193 — Carrousel Spotlight : format Netflix + responsive — JS v193 / CSS v174

**Modifications :**
- Carte centrale : 320px → **500px** (ratio 2:3 portrait cinéma)
- Cartes adjacentes : 320px → **340px**
- Responsive affiné sur tous les breakpoints (1100px / 900px / 640px / 400px)
- `min-height` du wrapper par breakpoint pour éviter l'espace vide

---

### v192 — Carrousel Spotlight : format Netflix initial — JS v192 / CSS v173

**Modifications :**
- Carte centrale portée à 500px, ratio 2:3
- Calcul de positionnement adapté à la largeur variable de la carte active

---

### v191 — Carrousel Spotlight Artistes — JS v191 / CSS v172

**Remplacement de la grille statique par un Carrousel Spotlight (Variante A) :**
- 1 grande carte centrale + 2 cartes partielles visibles de chaque côté
- Navigation par flèches gauche/droite + indicateurs de position (dots)
- Animation d'entrée en cascade au chargement (fade + translateY, décalage 80ms/carte)
- Transition de catégorie animée (slide-out gauche / slide-in droite)
- Carte active : photo zoom, overlay assombri, textes révélés (origine, style, nom, bio courte, bouton Découvrir)
- Cartes adjacentes : opacité réduite (0.72) + légèrément rétrécies (scale 0.94)
- Bordure lumineuse verte sur la carte active
- Recalcul automatique du positionnement au redimensionnement
- Responsive : 320px desktop / 260px tablette / 220px mobile / 180px petit mobile

---

### v190 — Vidéos réorganisées + vignettes +15% — JS v190 / CSS v171

**Réorganisation complète des vidéos YouTube d'Elida :**
- `youtubeVideos[]` enrichi : 3 clips → **20 clips** couvrant les 6 albums actifs
- Tri par album du plus récent au plus ancien : Spedju (2026) → Di Lonji (2023) → Gerasonobu (2020) → Kebrada (2017) → Elida (2017) → Ora Doci Ora Margos (2014)
- Noms d'albums corrigés pour correspondre exactement à `defaultAlbums()` (liaison album ↔ vidéo)
- Migration `mediaV9` : force-sync `youtubeVideos` Elida dans le localStorage existant

**CSS vignettes :**
- Vignettes desktop : 240px → **276px** (+15%)
- Vignettes mobile : 180px → **207px** (+15%)
- Gap entre cartes : 10px → 8px (plus compact)
- Espace entre sections albums : 24px → 16px
- Marge header album : 10px → 8px

---

### v189 — Ascenseurs (scrollbars) partout — JS v189 / CSS v189

**Système d'ascenseurs unifié sur toutes les zones scrollables :**
- Variables CSS globales `--sb-track`, `--sb-thumb`, `--sb-w/h/r` pour cohérence visuelle
- **Site public** : tracklists albums, tableau tournée, liste événements artiste, discographie, modal tracklist catalogue, mini-cart, modal checkout, modal produit, onglets filtres (shop/musique/compte), galerie photos, carrousel YouTube
- **Admin** : sidebar, contenu principal, tableaux (`.a-table-wrap`, `.orders-table-wrap`), toutes les zones `[class*="-table-wrap"]`
- **Mobile** : scrollbars réduites à 3px, listes longues (tracklists, événements, discographie) repassent en scroll page naturel sur mobile
- Charte : piste `rgba(255,255,255,0.05)` · pouce `rgba(46,204,128,0.45)` · hover `rgba(46,204,128,0.75)`

---

### v188 — Responsive 100% — JS v188 / CSS v188

**Corrections responsive complètes :**
- `harmonia-shared.src.css` : carrousel YouTube scroll tactile mobile, événements artiste layout colonne mobile, footer liens wrappés, badges désactivés adaptés, onglets artiste 380px, section SHOWCO responsive
- `mon-compte.html` : ajout media queries manquantes (900px / 640px) — padding, sections, boutons pleine largeur, historique commandes colonne
- `panier.html` : breakpoints alignés de 700px → 640px, items panier adaptés, onglets paiement scroll tactile, réassurance colonne mobile
- `jose-da-silva.html` : ajout breakpoints 600px et 380px (hauteur photo, events 1 colonne, très petits écrans)
- `cesaria.html` : ajout breakpoint 380px (padding réduit, photo 260px)

---

### v185 — Migration tracks localStorage : morceaux manquants injectés automatiquement
**Problème résolu :**
- Les morceaux ajoutés en v184 (Di Lonji, Gerasonobu, Spedju, Djunta Kudjer) n'apparaissaient pas car le `localStorage` contenait déjà une version ancienne de `DB.tracks` — la condition `if (!DB.tracks || DB.tracks.length === 0)` ne se déclenchait jamais

**Éléments codés :**
- `migrateTracksById()` : nouvelle IIFE qui compare les IDs de `defaultTracks()` avec `DB.tracks` en localStorage et injecte automatiquement les morceaux manquants sans écraser les existants
- Désormais, tout nouveau morceau ajouté dans le code source sera automatiquement injecté dans le localStorage de chaque visiteur au prochain chargement de page

---

### v184 — Tracklists Elida : corrections et complétions
**Problèmes résolus :**
- `Kebrada` : faute de frappe `Sapathinha` → `Sapatinha (Nha Mininensa)`
- `Djunta Kudjer` : titre `Besu d'Oro (Versao Tabanka)` → `Bersu d'Oru (Versão Tabanka)` (titre et orthographe corrects)
- `Gerasonobu` : 12 morceaux manquants ajoutés (seul `Bidibido` était présent) — tracklist complète 13 titres
- `Di Lonji` : 12 morceaux manquants ajoutés (seuls `Kaminhu Lonji` et `Mulata` étaient présents) — tracklist complète 14 titres
- `Spedju` : 13 morceaux complets ajoutés (aucun morceau n'était présent dans `DB.tracks`)
- IDs 136–172 créés pour les nouveaux morceaux

---

### v183 — Bouton "Mettre à jour" : message de confirmation
**Amélioration :**
- `_renderSyncReport()` : ajout d'un bloc de confirmation vert **"Mise à jour effectuée"** en bas du rapport de synchronisation, avec sous-titre explicatif
- `forceSiteSync()` : le bouton affiche **"\u2713 Mise \u00e0 jour effectuée"** (fond vert renforcé) pendant 3 secondes avant de revenir à son libellé initial

---

### v182 — Gestion des modules : superadmin exclusif + propagation complète
**Problèmes résolus :**
- Les modules `about`, `artists`, `cesaria`, `music`, `news`, `contact` étaient forcés actifs à chaque chargement, rendant leur désactivation impossible
- Les non-superadmins pouvaient voir et interagir avec les toggles de modules
- La désactivation d'un module ne se propagait pas en temps réel sur les onglets publics ouverts

**Éléments codés :**
- `harmonia-shared.src.js` — Bloc force permanente supprimé :
  - Remplacé par `initModules()` : initialisation douce qui respecte les choix admin
  - Seuls les modules **absents** de `DB.modules` sont initialisés depuis `defaultModules()`
  - Boutique + Panier : désactivés par défaut uniquement si jamais configurés
- `harmonia-shared.src.js` — `applyModules()` étendu :
  - Couvre `data-module-nav`, `data-module`, `data-module-footer`, `data-module-block`
  - Appelle `applyMaintenanceMode()` à chaque exécution
- `harmonia-shared.src.js` — `toggleModule()` + `_confirmDisableModule()` :
  - Notification `BroadcastChannel('harmonia_sync')` avec `type:'modules_update'` après chaque changement
- `harmonia-shared.src.js` — `initStorageSync()` :
  - Nouveau handler `modules_update` : met à jour `DB.modules` en mémoire et appelle `applyModules()` + `applyMaintenanceMode()` immédiatement
- `admin.html` — `_renderModulesCustom()` :
  - Si non-superadmin : section entièrement vide (totalement invisible)
  - Si superadmin : tous les modules affichés (y compris `shop`, `panier`, `jose`)
- `admin.html` — `_toggleModuleCustom()` + `_confirmModuleDisable()` :
  - Guard `isSuperAdmin()` en tête de chaque fonction
  - Notification `BroadcastChannel` après chaque changement

**Comportement attendu :**
- Le superadmin peut désactiver/réactiver **n'importe quel module** depuis le panneau admin
- Dès le toggle, tous les onglets publics ouverts reçoivent la mise à jour en temps réel
- Les visiteurs non-admin sont redirigés (mode `hidden`) ou voient la page maintenance
- Les admins/éditeurs ne voient pas la section Modules dans l'admin

---

### v181 — Bouton "Mettre à jour" : source de vérité admin complète
**Problème résolu :**
Le bouton "Mettre à jour le site" du Dashboard ne propagait pas réellement les changements sur le site public. Il se contentait d'ajouter des albums manquants et d'activer `_adminLocked`, sans propager les désactivations ni notifier les onglets publics ouverts.

**Éléments codés :**
- `harmonia-shared.src.js` — `forceSiteSync()` refonte complète :
  - Propagation complète `itemStates` → `album.disabled` → `discography[].disabled` pour tous les artistes
  - Rapport détaillé de l'état de chaque album (actif / DÉSACTIVÉ), artiste, module, actualité, événement
  - Sauvegarde `localStorage` + notification `BroadcastChannel('harmonia_sync')` pour tous les onglets ouverts
  - Bouton passe à "✓ Mis à jour" puis revient à "Mettre à jour le site"
- `harmonia-shared.src.js` — `initStorageSync()` orchestrateur de re-rendu complet :
  - Nouvelle fonction `_applyAdminUpdate(newDB)` qui re-rend toutes les sections publiques
  - Couverture étendue : événements (`renderEventsPage`), modules (`applyModules`), textes/images, page artiste full-page
  - Écoute `storage event` (cross-onglet) + `BroadcastChannel('harmonia_sync')` (même onglet)

---

### v1–v10 — Fondations du site statique
**Demandes :**
- Création du site HARMONIA — maison de production musicale Cabo Verde
- Page d'accueil avec sélecteur de langue (PT / FR / EN / ES)
- Charte graphique : noir dominant, bleu Navy, blanc — sans favicon ni icônes décoratives
- Structure multi-pages : qui-sommes-nous, artistes, cesaria, contact, musique, boutique, actualités

**Éléments codés :**
- `index.html` — page d'accueil plein écran, médaillon Cesária, drapeaux langue, footer fixe
- `harmonia-shared.src.js` — base JS partagée (DB localStorage, navigation, i18n)
- `harmonia-shared.src.css` — charte graphique complète (--navy, --accent2, --dark)
- `build.py` — script de build + minification JS/CSS
- `MAJHARMO.command` — script bash de push GitHub

---

### v11–v20 — Système d'administration & rôles
**Demandes :**
- Ajouter un rôle **superadmin** et promouvoir le compte PROD
- Créer un **système de modules** : activer/désactiver les sections du site
- Système **RBAC** (4 rôles) : superadmin, administrateur, editor, membre
- Authentification email + mot de passe + rôle membre
- Protection **Music7** : compte superadmin non modifiable/supprimable sans ce mot de passe

**Éléments codés :**
- `admin.html` — panneau administration complet (sidebar, sections, toggles modules)
- `harmonia-shared.src.js` :
  - `DB.users[]` — structure utilisateurs avec rôles et permissions
  - `defaultUsers()` — utilisateurs par défaut dont PROD/superadmin
  - `doLogin()` / `doLogout()` — authentification
  - `isSuperAdmin()` / `isEditor()` / `isAdmin()` — vérifications de rôles
  - `defaultModules()` — config modules nav + utilitaires
  - `applyModules()` — affichage/masquage items nav selon `enabled`
  - Protection Music7 : vérification mot de passe avant toute modif superadmin

---

### v21–v30 — Contenu dynamique & DB
**Demandes :**
- Ajouter champ `active` aux données (events, products, artists, news)
- Implémenter les **toggles on/off** en mode édition sur les cartes
- Masquer les éléments désactivés pour les visiteurs publics
- Module **PANIER** — sessionStorage + mini-cart + panier.html
- Déployer Harmonia sur **GitHub Pages**

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `DB.artists[]`, `DB.events[]`, `DB.products[]`, `DB.news[]` — champ `active`
  - `isItemActive()` — vérification visibilité publique
  - `renderArtists()`, `renderNews()`, `renderShop()` — masquage si `!active`
  - Système panier : `addToCart()`, `openMiniCart()`, `cartTotal()`
  - `sessionStorage` panier entre pages
- `panier.html` — page panier complète avec récapitulatif et checkout
- `.github/workflows/` — déploiement GitHub Pages automatique

---

### v31–v40 — Mode Édition inline
**Demandes :**
- **Mode Édition persistant** — reste actif entre les pages (sessionStorage)
- Bouton "Éditer le site" dans la sidebar admin
- Import image artiste en Mode Édition (upload base64)
- Réécriture complète **Mode Édition v2**
- Toolbar flottante : police, taille, B/I/U/S, couleur, alignement

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `_editModeActive` — flag persistant sessionStorage
  - `toggleEditMode()` — activation/désactivation avec barre de contrôle
  - `_showFloatingToolbar()` — toolbar WYSIWYG sur clic élément éditable
  - `injectAdminReturnBtn()` — bouton retour admin en mode édition
  - `data-editable-key` — attribut sur éléments éditables
  - Import image : `<input type="file">` → base64 → `DB.images[key]`
  - `applyImages()` — restauration images sauvegardées

---

### v41–v54 — Traduction & styles inline
**Demandes :**
- Étendre le modèle de données pour **sauvegarder les styles inline** (police, couleur…)
- **Traduction automatique multi-langues** lors de la sauvegarde
- Tester et valider le mécanisme de traduction

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `DB.pageTexts{}` — stockage textes édités par langue et par clé
  - `applyPageTexts()` — restauration styles et textes au chargement
  - `_autoTranslate()` — traduction automatique PT/FR/EN/ES à la sauvegarde
  - `LANGS{}` — dictionnaires complets 4 langues (11, 130, 249, 368 lignes src)
  - `T(key)` — fonction de traduction avec fallback français

> **Version v54 — premier push stable multi-langues**

---

### v55–v62 — Fix mode édition + persistence
**Demande :**
- Fix edit mode persistence sur toutes les sous-pages
- Bouton "Quitter Mode éditeur" repositionné pour ne pas chevaucher la barre

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `injectAdminReturnBtn()` : `bottom:64px` (au-dessus de la barre éditeur h=52px), `z-index:99999`
  - Auto-activation mode édition si `sessionStorage.editMode = '1'`
  - Bypass admin dans `applyMaintenanceMode()` étendu au rôle `'editor'`
  - Dual-check : `currentUser` + `sessionStorage.getItem('harmonia_user')` (timing fix)

---

### v63–v69 — Artistes URBAN + biographies
**Demandes :**
- Rechercher et intégrer les **artistes URBAN** (catégorie)
- Rechercher biographies et discographies — 3 nouveaux artistes

**Éléments codés :**
- `harmonia-shared.src.js` — `defaultArtists()` enrichi :
  - Elida Almeida, Ceuzany, Lucibela, Fábio, Jenifer, Neuza, Elly, Indira, Ley Lazz, Mureno, Neguinho, Sonia Sousa
  - Biographies longues (bioShort + bioLong) + discographies + liens Spotify/YouTube/Instagram
  - Catégories : `traditional` / `urban`
  - `renderArtistsByCategory()` — affichage par groupe

---

### v70 — Fix cache + modules hidden/maintenance
**Demandes :**
- Le bouton "Quitter Mode éditeur" ne fonctionne plus
- La page "Qui sommes-nous" reste visible après désactivation

**Causes racines :**
- HTML sur `?v=67` → navigateur chargeait ancienne version du JS (commit d74fe37)
- `applyMaintenanceMode()` ne gérait pas le mode `hidden` (seulement `maintenance`)

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `applyMaintenanceMode()` : redirect non-admins vers index.html pour pages `hidden`
  - Mode `hidden` : `window.location.href = 'index.html'` si non-admin
  - Mode `maintenance` : overlay avec message
- Bump HTML v67 → v70 (force rechargement JS propre)

---

### v71–v72 — MAJHARMO.command amélioré
**Demande :**
- Afficher point par point les mises à jour poussées vers GitHub
- Voir les fichiers modifiés, les lignes changées, le détail du push

**Éléments codés :**
- `MAJHARMO.command` — réécriture complète section push :
  - Liste fichiers avec tags ✚ NOUVEAU / ✎ MODIFIÉ / ✖ SUPPRIMÉ / ↷ RENOMMÉ
  - Taille fichier en Ko/Mo
  - Lignes modifiées en couleur (vert `+` / rouge `-`) via `git diff --cached --unified=0`
  - Compteurs `+N ajoutées / -N supprimées` par fichier
  - Hash du commit affiché
  - `git push --progress --verbose origin main 2>&1`

---

### v73 — Corrections visuelles majeures
**Demandes :**
- "Choose your language" toujours en anglais pour tous les visiteurs
- Lisibilité et organisation des menus en vue mobile — amélioration pro
- Logos de bas de page alignés au milieu sur toutes les pages
- Bas de page de `contact.html` doit correspondre aux autres pages

**Éléments codés :**
- `index.html` :
  - `<span>Choose your language</span>` — attribut `data-i18n-home` retiré (toujours anglais)
  - `HOME_LANGS{}` — toutes les langues retournent `choose_lang:'Choose your language'`
- `harmonia-shared.src.css` :
  - `.footer-logo` : `display:flex; justify-content:center; width:100%`
  - `.footer-logo img` : `margin:0 auto; display:block`
  - Menu mobile (≤900px) : hamburger animé, slide-down avec backdrop-filter blur(20px)
  - Items nav mobile : padding 18px 28px, font 11px, letter-spacing 3px
  - Page active : `border-left:2px solid #2ecc80`
  - Bouton Connect : pleine largeur, vert, bas du menu
  - Small mobile (≤640px) : sections, hero, titres, CTA, cards artistes adaptés
- `contact.html` : image footer `cartes-iles.png` → `logo-base.png` (height:40px)
- `mon-compte.html` : référence CSS corrompue `?v=73?v=46` → `?v=73`

---

### v74 — Section "Artistes en Promo" + galerie espacée
**Demandes :**
- 3 emplacements en bas de "Qui sommes-nous" pour artistes en promo
- Module admin "Artistes en promo" — sélection depuis la liste existante
- Photos de la galerie artistes ne doivent pas être collées

**Éléments codés :**
- `harmonia-shared.src.css` :
  - `.artists-grid` : `gap:3px` → `gap:16px` + `padding:16px`
  - `.promo-artist-card`, `.promo-artist-photo`, `.promo-artist-info`, `.promo-artist-btn` — nouveaux styles
  - `.promo-artist-slot-empty` — emplacement vide stylé
  - Responsive promo : 3 colonnes desktop → 1 colonne ≤640px
- `harmonia-shared.src.js` :
  - `DB.promoArtists = [null, null, null]` — init si absent
  - `renderPromoArtists()` — rendu 3 cartes depuis `DB.promoArtists[]`
  - Appel `try { renderPromoArtists(); } catch(e) {}` dans init global
- `qui-sommes-nous.html` :
  - `<section class="promo-artists-section">` avec `<div id="promo-artists-grid">`
- `admin.html` :
  - `<div id="promo-artists-admin">` dans la section Modules
  - `_renderPromoArtistsAdmin()` — 3 dropdowns listant `DB.artists`
  - `_saveAllPromoArtists()` — sauvegarde dans `DB.promoArtists`
  - Affiché automatiquement après `_renderModulesCustom()`

---

### v75 — Fix persistance langue + "Choose your language" visible
**Demandes :**
- La langue choisie sur la page d'accueil doit impacter tout le site
- Vérifier la continuité en vue normale et vue GSM
- "Choose your language" doit apparaître sur la page d'accueil

**Problèmes identifiés :**
- `sessionStorage` seul → perd la langue si l'onglet est tué en arrière-plan (iOS)
- `.home-flags-line span` à `opacity:0.3` → quasi invisible

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `currentLang` — lecture cascade : `sessionStorage → localStorage → 'pt'`
  - `setLang()` — double-write `sessionStorage` + `localStorage`
  - `initLang()` — cascade + resynchronisation sessionStorage depuis localStorage
- `index.html` :
  - `defaultLang` — cascade `sessionStorage → localStorage → 'pt'`
  - `enterSite()` — double-write `sessionStorage` + `localStorage`
  - `.home-flags-line span` : `color:rgba(255,255,255,0.3)` → `rgba(255,255,255,0.72)`
  - Mobile ≤600px : lisibilité renforcée sur tous les textes (0.78 → 0.82 selon élément)

---

### v76 — Désactivation module Boutique
**Demande :**
- Désactiver le module Boutique sans le supprimer, pour le réactiver plus tard
- Ne pas l'afficher dans le menu

**Éléments codés :**
- `harmonia-shared.src.js` :
  - `defaultModules()` : `shop.enabled:true` → `shop.enabled:false`
  - Bloc force permanente : `'shop'` retiré de la liste des modules forcés actifs
  - Nouveau bloc force : `DB.modules.shop.enabled = false` à chaque chargement
  - `DB.modules.panier.enabled = false` — panier aussi désactivé

---

### v77 — Masquage complet Boutique + Panier (nav + bouton)
**Demandes :**
- Le menu ne doit pas afficher la boutique
- Masquer aussi le bouton PANIER de la navigation

**Problème identifié :**
- `applyModules()` masquait `[data-module-nav="shop"]` mais pas `#nav-cart-btn`

**Éléments codés :**
- `harmonia-shared.src.js` — `applyModules()` :
  - Ajout : `var cartBtn = document.getElementById('nav-cart-btn'); if (cartBtn) cartBtn.style.display = shopOn ? '' : 'none';`
  - Bloc force : `DB.modules.panier.enabled = false` ajouté

---

### v78 — Fallback cover → photo artiste pour toute la discographie
**Demande :**
- Afficher les covers des albums pour tous les artistes
- Quand aucune cover n'est disponible, utiliser la photo de l'artiste à la place du ♪

**Éléments codés :**
- `harmonia-shared.src.js` — 2 emplacements :
  - `openArtistModal()` (modal discographie) : cascade `DB.images[coverKey] → al.cover → artistImg(a) → ♪`
  - `openArtistPage()` → `buildAlbumsHtml()` (vue plein écran) : cascade `al.cover → artistImg(a) → ♪`
- Bénéficie à tous les artistes dont les singles n'ont pas encore de cover dédiée (ex: Neguinho Tivane)

---

### v79 — Démo promo artistes par défaut
**Demande :**
- Remplir les 3 emplacements "Artistes en Promo" de qui-sommes-nous avec une sélection de démo

**Éléments codés :**
- `harmonia-shared.src.js` :
  - Init `DB.promoArtists` : si absent ou tous null → injecter `[1, 3, 11]` (Elida Almeida + Lucibela + Neguinho Tivane)
  - Logique : `if (!DB.promoArtists || DB.promoArtists.every(...null...))` → valeurs admin préservées

---

### v80 — Module SHOWCO : Showcases & Concerts par artiste
**Demande :**
- 2 nouveaux onglets sur la fiche artiste : Showcases + Concerts
- Module admin pour gérer les événements avec sélection multi-artistes et multi-dates
- Événements passés marqués d'un badge "Passé", à venir en vert

**Éléments codés :**
- `harmonia-shared.src.css` :
  - `.ap-tabs`, `.ap-tab-btn` — barre d'onglets sticky sous le hero
  - `.ap-event-card`, `.ap-event-dates`, `.ap-event-body`, `.ap-event-meta` — cartes événements
  - `.ap-event-badge.past` / `.ap-event-badge.upcoming` — statut visuel
  - `.ap-event-ticket`, `.ap-event-empty` — lien billetterie + état vide
  - Responsive : 2 colonnes mobile, masquage .ap-event-meta
- `harmonia-shared.src.js` :
  - `DB.artistEvents = []` — nouveau tableau dans le modèle de données
  - `switchArtistTab(btn, panelId)` — navigation entre onglets
  - `buildArtistEventHtml(events)` — rendu liste événements avec tri À venir/Passé
  - `openArtistPage()` — refactorisé : 4 panels (Albums, Vidéos, Showcases, Concerts)
- `admin.html` :
  - Sidebar : nav item "Showcases / Concerts" dans groupe Contenu
  - Section `#sec-showcases` avec filtre Tous/Showcases/Concerts
  - `_aeOpenForm(id)` — formulaire add/edit (type, titre, artistes checkboxes, dates multi, venue, ville, pays, description, billetterie)
  - `_aeSave(id)` — création / mise à jour avec ID auto-incrémenté
  - `_aeDelete(id)` — suppression avec confirmation
  - `_aeFilter(type)` — filtrage liste
  - `_aeRenderList()` — rendu tableau avec tri par date

**Code nom module : SHOWCO**

---

## FICHIERS CLÉS DU PROJET

| Fichier | Rôle |
|---|---|
| `harmonia-shared.src.js` | Source JS — à éditer, jamais le `.js` compilé |
| `harmonia-shared.src.css` | Source CSS — à éditer, jamais le `.css` compilé |
| `harmonia-shared.js` | Build output (ne pas éditer) |
| `harmonia-shared.css` | Build output (ne pas éditer) |
| `build.py` | Compile src → output + minification |
| `MAJHARMO.command` | Script bash : add + commit + push GitHub détaillé |
| `admin.html` | Panneau d'administration complet |
| `index.html` | Page d'accueil (sélecteur langue, médaillon Cesária) |
| `qui-sommes-nous.html` | About + section Artistes en Promo |
| `artistes.html` | Galerie artistes avec modal fiche + page artiste (4 onglets : Albums, Vidéos, Showcases, Concerts) |
| `contact.html` | Page contact |
| `boutique.html` | Boutique (désactivée v76-77, réactivable depuis admin) |
| `panier.html` | Page panier (désactivée v76-77) |

---

---

### v81 — Fix visibilité onglets page artiste
**Demande :** "Les écritures du mini menu dans la page des artistes (Album, vidéos…) ne sont pas très visibles. Corrigez."

**Éléments modifiés :**
- `harmonia-shared.src.css` — `.ap-tab-btn` : opacité inactif `0.4` → `0.65`, font-size `9px` → `10px`, letter-spacing `3px` → `2px`
- `.ap-tab-btn.active` : couleur `#fff` (pure white) au lieu de rgba partiel
- Build v82 + bump + push

---

### v82 — Fix vignettes YouTube + fallback onerror
**Demande :** "Pour l'artiste Ceuzany, les 2 vidéos n'affichent pas la vignette. Corrigez pour tous les artistes."

**Corrections IDs YouTube (5 IDs confirmés erronés) :**
- Ceuzany "Pays des Merveilles" : `lBCfSaMyaAg` → `x30kc8zgbm0`
- Ceuzany "Pedra Run" : `NZhG5JFjuMU` → `chbNmmhoKuM`
- Lucibela "Laço Umbilical" : `PfGHGbSXprI` → `CWjpLxduC24`
- Neuza "Flor di Bila" : `8Xq7bxuV6w0` → `naQ1EqomsWc`
- Sonia Sousa "Pa Bo" : `c9-LYtadmUA` → `5v_1jMCkFUE`

**Éléments modifiés :**
- `harmonia-shared.src.js` — `defaultArtists()` : correction globale des IDs (youtubeVideos, discography covers, tracks covers)
- `harmonia-shared.src.js` — `openArtistModal()` clips : ajout `onerror="opacity:0"` sur `<img class="clip-yt-thumb">`
- `harmonia-shared.src.js` — `openArtistPage()` onglet Vidéos : ajout `onerror="opacity:0"` sur vignettes YouTube
- Build v82 + bump + push

---

## PROCÉDURE DE MISE À JOUR

```bash
# 1. Éditer les sources
nano harmonia-shared.src.js
nano harmonia-shared.src.css

# 2. Builder
python3 build.py

# 3. Bumper la version (ex: v82 → v83)
OLDV=82; NEWV=83
for f in *.html; do sed -i "s/harmonia-shared\.js?v=${OLDV}/harmonia-shared.js?v=${NEWV}/g; s/harmonia-shared\.css?v=${OLDV}/harmonia-shared.css?v=${NEWV}/g" "$f"; done

# 4. Pusher
./MAJHARMO.command
```

---

## RÉACTIVATION BOUTIQUE (quand prêt)

Dans `harmonia-shared.src.js`, bloc "Force permanente" :
1. Changer `DB.modules.shop.enabled = false` → `true`
2. Changer `DB.modules.panier.enabled = false` → `true`
3. Remettre `'shop'` dans la liste des modules forcés actifs
4. Changer `defaultModules()` : `shop.enabled:false` → `true`
5. Build + bump + push

Ou depuis l'admin : **Modules → Boutique → toggle ON** (si le bloc force est retiré).

---

*Dernière mise à jour : v180 — Juillet 2026*

---

### v180 — Source de vérité admin : désactivation album = masquage total
**Demande :** Le panneau d'administration doit être la seule source de vérité pour ce qui s'affiche sur le site public. Quand un album est désactivé dans l'admin, tout ce qui le concerne doit disparaître du site public.

**Zones corrigées :**
- `harmonia-shared.src.js` — `enforceAdminLocked()` : activation automatique de `DB._adminLocked` à chaque chargement de page (bloque `mergeDefaults()` sur tout le site public)
- `harmonia-shared.src.js` — `openArtistPage()` : `artistAlbums` filtré selon `disabled` + `DB.itemStates` ; `artistTracks` filtré pour n'inclure que les morceaux d'albums actifs
- `harmonia-shared.src.js` — `openArtistPage()` — onglet Vidéos : carrousel YouTube filtré (exclut vidéos désactivées individuellement ET vidéos rattachées à un album désactivé)
- `harmonia-shared.src.js` — `openArtistPage()` — section albums désactivés : badge "DÉSACTIVÉ" visible uniquement pour les admins connectés, avec bouton "Activer dans l'admin"
- `harmonia-shared.src.js` — `openArtistModal()` — Clips : filtre identique (album désactivé via `discography.disabled` + `DB.albums.disabled` + `DB.itemStates` + `youtubeVideos[].disabled`)
- `harmonia-shared.src.js` — `doSearch()` : albums désactivés exclus des résultats de recherche ; morceaux d'albums désactivés exclus
- `harmonia-shared.src.js` — `openAlbumTracklist()` : garde admin — ne peut pas ouvrir un album désactivé
- `harmonia-shared.src.js` — `goToCatalogueAlbum()` : garde admin — ne navigue pas vers un album désactivé

**Portée :** Tous les artistes (pas seulement Elida).
**Build :** JS v180 / CSS v169
