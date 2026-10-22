# Banque d'exercices web

Application statique Astro + React + TypeScript, Tailwind CSS 4 et daisyUI. MiniSearch indexe les métadonnées de la banque, CodeMirror fournit l'éditeur Typst et PDF.js affiche les PDF compilés par typst.ts dans un Web Worker.

## Lancer

Depuis la racine du dépôt `exercices/` :

```sh
just web
```

La commande entre dans l'environnement Nix du site et installe les dépendances npm au premier lancement. Si Just n'est pas déjà disponible, utiliser `nix develop . -c just web`. Astro lance le serveur en arrière-plan ; `just web-stop` l'arrête. Les arguments sont transmis à Astro, par exemple `just web --port 4322 --open`. Après une modification des dépendances, lancer `just web-install`.

Pour travailler directement depuis `exercices/web/` :

```sh
nix develop ..#web
npm ci
npm run dev
```

Ouvrir l'adresse locale indiquée par Astro (par défaut `http://127.0.0.1:4321`). L'environnement Nix fournit Node.js, Typst, les dépendances Typst verrouillées et les polices. Le démarrage exporte le catalogue et les ressources publiques avant de lancer Astro. Après une modification de la banque, relancer `npm run prepare:data` pour actualiser cet export.

```sh
npm run build
npm test
npm run preview
```

`build` régénère les ressources, vérifie les types et construit `dist/`, prêt à servir sur un hébergement statique. Les tests compilent toute la banque en WASM, dans les deux variantes, puis vérifient recherche, filtres et copie des ressources. Aucun serveur de compilation n'est nécessaire en production.

Pour servir le site sous un préfixe, utiliser le même `BASE_PATH` pour construire et prévisualiser :

```sh
BASE_PATH=/exercices npm run build
BASE_PATH=/exercices npm run preview
```

Le serveur doit servir les `index.html` des répertoires et les `.wasm` avec le type `application/wasm`. Activer sa compression HTTP pour les fichiers JSON, JS et WASM. Les fichiers publics générés, les dépendances npm et `dist/` sont exclus de Git.

## Publication GitHub Pages

Le site est publié à l'adresse <https://mpi-informatique.github.io/exercices/> par le [workflow de vérification et publication](../.github/workflows/check.yml). Chaque push sur `main` construit le site avec Nix, teste la banque et déploie `web/dist/` après réussite des deux jobs de vérification. Les pull requests construisent et testent le site sans le publier. Le workflow peut aussi être lancé manuellement depuis l'onglet Actions.

Dans **Settings → Pages → Build and deployment**, la source doit être **GitHub Actions**. Aucun secret supplémentaire n'est nécessaire. `configure-pages` fournit le préfixe et l'origine du site à Astro (`BASE_PATH` et `SITE_URL`) ; les routes, fichiers publics, workers et modules WASM utilisent ce préfixe. Un domaine personnalisé se configure dans ces mêmes réglages.

Pour reproduire la construction Pages localement depuis `web/` :

```sh
BASE_PATH=/exercices SITE_URL=https://mpi-informatique.github.io nix develop ..#web -c npm run build
BASE_PATH=/exercices SITE_URL=https://mpi-informatique.github.io nix develop ..#web -c npm run preview
```

## Utilisation

- Dans le menu Type, cocher Concours affiche une plage d'années sous cette case. Déplacer ses deux curseurs au clavier ou à la souris, ou saisir les bornes puis valider avec Entrée ou Tab. Les bornes inclusives s'adaptent aux concours sélectionnés. La plage filtre seulement les concours et laisse visibles les autres types cochés ; les concours sans année sont conservés tant qu'aucune plage n'est appliquée. Décocher Concours ou effacer la plage rétablit toutes les années.
- Le menu Difficulté permet de cocher plusieurs niveaux précis, par exemple 2 et 4. Les niveaux sont réunis par « ou » ; ils ne représentent plus une difficulté maximale. Le même filtre s'écrit `difficulté:2,4` dans la recherche.
- Dans le menu Chapitres, cocher une matière sélectionne tous ses chapitres présents dans la banque. Les cases Informatique et Mathématiques indiquent aussi les sélections partielles ; les matières se combinent entre elles et avec les autres filtres. Le classement provient de `lib/meta.typ`. Les résultats et la palette affichent le nom, l'année et la filière des concours lorsqu'ils sont renseignés.
- Rechercher par titre, nom de fichier, chapitre, concours, année ou autre métadonnée. `/` place le curseur dans la recherche hors des champs d'édition ; Entrée ouvre le premier résultat. Les filtres se cumulent ; plusieurs valeurs dans un filtre sont réunies par « ou ». Les cases à cocher acceptent Tab, Espace et Échap. Les critères peuvent aussi être saisis dans la recherche, par exemple `concours:CCINP année:2022`, `concours:CCINP,ENS`, `type:td` ou `chapitre:"automates finis"`. Répéter un critère ajoute une valeur ; les noms acceptent le singulier, le pluriel et les accents. Les filtres du panneau et du texte se cumulent ; la recherche ignore la casse et les accents et tolère les préfixes et petites fautes. Les filtres supplémentaires restent repliés par défaut.
- `⌘K` / `Ctrl+K` ouvre la palette, y compris depuis CodeMirror. Chercher une action ou un exercice, utiliser ↑ / ↓ puis Entrée ; Échap ferme la palette et restitue le focus. Préfixer la recherche par `>` pour limiter la liste aux commandes. La palette permet notamment de changer de panneau, de variante ou de thème, et de télécharger les fichiers.
- Dans la recherche, ↓ / ↑ rejoint le premier / dernier résultat. Dans les résultats, ↑ / ↓, Début et Fin déplacent le focus ; Entrée ouvre la ressource. Un seul résultat participe à la navigation par Tab, pour éviter de traverser toute la banque. Les onglets Énoncé / Corrigé acceptent ← / →, Début et Fin.
- Ouvrir directement `/residuels-minimisation/` ou `/residuels-minimisation/?vue=corrige` en local, et `/exercices/residuels-minimisation/` sur GitHub Pages. L'identifiant reste le nom du fichier sans `.typ`, y compris pour les documents composés. L'export refuse les doublons.
- Les oraux sont découverts dans `devoirs/concours/oral/<concours>/`, y compris dans les sous-dossiers de ressources. Après un déplacement ou un renommage, régénérer l'export : les URL suivent le nouveau nom du fichier, par exemple `/ens-oral-mp-automates-monoides/` en local, sous le préfixe `/exercices/` sur GitHub Pages. Les filtres utilisent toujours les métadonnées du sujet.
- Les commandes de l’application sont regroupées sous forme d’icônes en haut du panneau latéral. Déplacer les séparateurs ou les sélectionner au clavier et utiliser les flèches, Début ou Fin. Les boutons de recherche et de code replient les panneaux ; les commandes restent accessibles dans une colonne d’icônes lorsque la recherche est repliée. Sur petit écran, le code et le PDF alternent dans le panneau principal.
- Modifier le code : la compilation démarre après 450 ms d'inactivité. Une seule compilation s'exécute à la fois ; les modifications intermédiaires sont regroupées. Une erreur conserve le dernier aperçu valide et désactive le téléchargement PDF jusqu'à correction. Le worker est interrompu après 120 secondes et peut être relancé.
- Les sources `cours-et-presentation` proposent les boutons **Cours / Cours corrigé / Présentation**, comme dans l’extension VS Code. La palette utilise les mêmes libellés et le téléchargement produit `cours-kleene.pdf`, `cours-kleene-cor.pdf` ou `presentation-kleene.pdf` pour `cours-kleene.typ`. Un cours sans présentation propose **Cours / Cours corrigé**. Une présentation seule affiche un seul onglet. Le filtre Type permet de retrouver ces documents.
- Choisir Énoncé ou Corrigé, naviguer dans les pages, zoomer et télécharger le PDF affiché. Dans l'aperçu ayant le focus, ← / → change de page, + / − zoome et 0 ajuste à la largeur ; les touches de défilement habituelles fonctionnent aussi. Le texte du PDF est sélectionnable. Les pages sont rendues à proximité de la zone visible. Le thème sombre adapte aussi le papier et le texte du PDF ; le téléchargement conserve les couleurs originales.
- À 100 %, le PDF occupe la largeur disponible du lecteur, marges comprises, et s'adapte au redimensionnement des panneaux ou de la fenêtre. Le zoom est relatif à cette largeur ; le bouton du pourcentage ou la touche 0 rétablit l'ajustement à la largeur.
- Le sélecteur de fichiers de l’éditeur permet d’ouvrir les codes associés à la feuille ou à ses exercices importés dans CodeMirror en lecture seule, avec coloration syntaxique pour C, OCaml, Python et SQL. Il permet aussi de retrouver le `.typ` ; la croix revient à la source Typst. Le téléchargement porte sur le fichier affiché. La feuille, son brouillon et l’aperçu PDF sont conservés.
- Dans CodeMirror, cliquer sur un chemin de code souligné l'ouvre dans le même panneau ; Alt+Entrée fonctionne aussi. Pour les autres fichiers, Ctrl/Cmd+clic ou Alt+Entrée ouvre les exercices et documents dans le site, les ressources publiques associées dans un nouvel onglet. Les codes du dépôt privé chargé s'ouvrent également dans CodeMirror, sans requête vers la banque publique. Les longues lignes reviennent automatiquement à la ligne dans tous les fichiers, sans modifier leur contenu. Tab indente ; Échap puis Tab permet de quitter l'éditeur au clavier. La palette offre aussi des commandes pour ouvrir les codes associés et placer le focus dans la recherche, le code ou le PDF.
- Dans la barre de l'éditeur, le logo GitHub ouvre le fichier affiché dans son dépôt et le bouton d'issue permet de signaler un problème, avec le titre de la ressource et un lien vers le fichier préremplis. Ces liens suivent le fichier Typst ou le code associé sélectionné, ainsi que le dépôt et la branche de la banque privée le cas échéant.
- Le bouton de pull request dans la barre de l'éditeur propose le contenu modifié dans CodeMirror : après connexion à GitHub, une nouvelle branche contient le brouillon et GitHub affiche les différences avant l'envoi de la PR. Un fork personnel est créé si nécessaire. Le brouillon reste enregistré dans le navigateur. La [configuration du Worker OAuth](../worker/README.md) active ce parcours ; sans cette configuration, le bouton copie le brouillon et ouvre l'éditeur GitHub pour le coller manuellement. Si le fichier n'est pas modifié, le bouton ouvre directement l'éditeur GitHub.
- Les brouillons, le thème et les largeurs sont conservés dans `localStorage`. Les brouillons sont propres à ce navigateur et ne modifient pas le dépôt. Télécharger le fichier `.typ` pour l'emporter, ou réinitialiser le code pour retrouver la banque. La réinitialisation est annulable dans CodeMirror. Si la source publiée a changé depuis le brouillon, un message le signale.

Le premier aperçu charge le compilateur WASM (environ 27 Mo non compressés), les polices et la banque. Les éditions suivantes réutilisent le moteur et les ressources en mémoire. Le site n'utilise aucun CDN, compte ou service externe pour compiler. Une nouvelle dépendance Typst doit être ajoutée au manifeste Nix de la banque puis réexportée.

Le package `code-extract`, fourni par le dépôt public `mpi-informatique/typst-code-extract`, est verrouillé dans `flake.lock`. L'export inclut son namespace `local`, son interface Typst et son module WASM. L'extraction des déclarations C et OCaml s'exécute ainsi dans le navigateur, avec les mêmes appels que les PDF compilés en ligne de commande.

Le compilateur typst.ts est fixé à `0.8.0-rc3` : cette préversion intègre Typst 0.15, nécessaire aux imports de l'API commune et à Touying 0.8. L'export inclut le point d'entrée `load.typ` ; le test WASM compile toute la banque pour vérifier sa compatibilité.

## Lecteur intégrable

La route `/apercu/<id>/` affiche uniquement le lecteur PDF et ses variantes, sans recherche ni éditeur. Par exemple : `/apercu/cours-langages-reguliers/`. Elle charge directement le PDF publié et conserve les commandes de navigation, zoom et téléchargement. La présentation est choisie par défaut si elle existe ; `?vue=enonce`, `?vue=corrige` ou `?vue=presentation` choisit la version initiale. `cor=0` retire le corrigé des onglets, sans restreindre l'accès à la ressource publique.

`prepare:data` compile les PDF avec le cache de `scripts/build.py`, puis les exporte dans `public/banque/pdf/`. Leur nom contient une empreinte des sources et dépendances pour renouveler le cache à chaque changement. Le lecteur intégré ne télécharge ni le compilateur WASM, ni la banque Typst, ni les polices du compilateur. En consultant le cours écrit, il précharge aussi le PDF de présentation en arrière-plan. L'éditeur de la banque conserve sa compilation dans le navigateur pour les modifications.

`public/banque/catalogue.json` expose les métadonnées évaluées par Typst, dont les titres et les chemins des PDF. Le site de cours utilise ces titres pour sa sidebar.

`theme=light` ou `theme=dark` choisit le thème initial. Pour suivre un site qui intègre le lecteur sans recharger le PDF, le parent envoie `{type: 'exercices:theme', theme: 'dark' | 'light'}` par `postMessage` à l'origine de la banque. Le lecteur accepte ces messages uniquement de sa fenêtre parente et de l'origine de son référent ; il annonce `{type: 'exercices:ready'}` lorsque son écouteur est prêt.

Le bouton **Présenter en plein écran**, commun à la banque et au lecteur intégrable, affiche une page à la fois et l'ajuste à la largeur et à la hauteur disponibles. La barre d'outils est masquée pendant la présentation. Les flèches gauche/droite, Espace, Page précédente/suivante, Début et Fin permettent de présenter ; Échap quitte le plein écran. Une iframe doit autoriser le plein écran (`allow="fullscreen"`).

Cette route peut être chargée dans une iframe sur le site de cours. Avec GitHub Pages, son adresse est `https://mpi-informatique.github.io/exercices/apercu/cours-langages-reguliers/`. Le navigateur charge PDF.js et le PDF sélectionné.

## Organisation

| Chemin | Rôle |
| --- | --- |
| `../shared/src/index.ts` | Types, identifiants, validation du catalogue et utilitaires communs au site et à l'extension VS Code. |
| `scripts/prepare.py` | Réutilise `../scripts/catalogue.py` et la découverte publique ; interroge Typst pour les métadonnées des documents et de leurs exercices. |
| `scripts/assets.mjs` | Copie les fichiers WASM et PDF.js depuis les versions npm verrouillées. |
| `src/compiler/engine.ts` | Système de fichiers virtuel, packages verrouillés et compilation PDF ; également utilisé par les tests. |
| `src/compiler/typst.worker.ts` | Chargement des ressources et protocole du worker. |
| `src/hooks/useCompiler.ts` | Temporisation, file d'attente, résultats périmés, erreurs et délai maximal. |
| `src/components/` | Recherche, éditeur, lecteur PDF, séparateurs et assemblage de l'interface. |
| `src/pages/` | Accueil, routes statiques par identifiant et page 404. |

La banque publique est exportée au build. Les sources privées facultatives sont chargées uniquement dans le navigateur après connexion GitHub. Les cours et présentations sont indexés avec les exercices et les autres documents, dans les banques publiques et privées.

Les licences des packages Typst restent dans `public/banque/packages/`. Celles des polices New Computer Modern 8.1.1 et DejaVu 2.37 sont dans `public/licenses/` ; leurs fichiers sont distribués sans modification. La licence de PDF.js est copiée avec ses ressources.

Le favicon reprend `../../vscode-mpi-exercices/media/mpi.png`. Pour les résultats Google, [une seule icône est associée à chaque nom d’hôte](https://developers.google.com/search/docs/appearance/favicon-in-search) : si ce site est déployé sous `/exercices/`, la page d’accueil du domaine doit aussi déclarer cette icône. Son affichage dépend ensuite de Google.

## Banque privée

L’icône de cadenas du panneau latéral ouvre le panneau **Exercices privés**. Après autorisation GitHub, sélectionner un dépôt privé et cliquer **Charger le dépôt**. Les exercices s’ajoutent aux résultats publics avec le badge **Privé** ; le filtre **Visibilité** et la recherche `tag:privé` permettent de les retrouver. Les doublons de noms entre banques sont conservés. Le dépôt est lu sur un commit fixe de sa branche par défaut.

Le dépôt doit contenir des sources Typst compatibles avec l’API de cette banque : exercices exportant `ex`, documents utilisant `feuille`, ainsi que leurs dépendances locales. Les métadonnées sont évaluées par Typst dans le navigateur ; aucun catalogue préexporté n’est nécessaire. Les fichiers `lib/`, `templates/` et `load.typ` du dépôt choisi remplacent les équivalents publics uniquement dans son moteur privé. En leur absence, le moteur utilise les modèles publics. Le package public `@mpi-informatique/exercices:0.1.0` est disponible à la révision du site, ainsi que ses dépendances Typst verrouillées. Le verrou Nix du dépôt privé ne change pas cette révision dans le navigateur. Le dossier `corrections/` des copies et notes est exclu du chargement et de l’indexation. Les fichiers non indexables sont signalés dans le panneau. Les arbres GitHub tronqués et les ressources dépassant 50 Mo sont refusés explicitement.

Les exercices privés proposent le même éditeur, les variantes et les téléchargements. Leurs brouillons restent en mémoire, sans `localStorage`. **Se déconnecter**, retirer le dépôt ou recharger la page retire les fichiers privés de l’onglet ; télécharger les modifications souhaitées avant cette opération. La déconnexion locale ne révoque pas l’autorisation de l’application sur GitHub. Le bouton de contribution à la banque publique est masqué pour les ressources privées.

Le bouton **Créer un commit sur GitHub** dans la barre de CodeMirror enregistre le fichier modifié directement sur la branche par défaut du dépôt privé chargé. Il est désactivé sans modification et pendant l’enregistrement. Le compte connecté doit disposer du droit d’écriture ; GitHub applique les protections de branche. Si le fichier distant a changé, le commit est refusé et le brouillon conservé. Après réussite, la source enregistrée devient la nouvelle référence locale ; les éditions réalisées pendant l’enregistrement restent dans le brouillon.

La connexion utilise le [même Worker OAuth](../worker/README.md), sans nouvelle configuration serveur. Le scope OAuth `repo` couvre la lecture de la banque privée et l’enregistrement de ses modifications. Les autorisations d’organisation restent gérées par GitHub.
