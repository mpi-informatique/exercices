# Banque web

[Site public](https://mpi-informatique.github.io/exercices/) en Astro, React et TypeScript. MiniSearch assure la recherche, CodeMirror l'édition et PDF.js l'aperçu ; Typst compile dans un Web Worker.

## Développement

Depuis la racine : `just web --open`, puis `just web-stop`. La première commande installe les dépendances ; `just web-install` les actualise. Si Just manque, préfixer par `nix develop . -c`. Les options, comme `--port 4322`, sont transmises à Astro.

Pour travailler depuis `web/` :

```sh
nix develop ..#web
npm ci
npm run dev
```

`npm run prepare:data` actualise la banque exportée après modification des sources. `npm run build` prépare les ressources, vérifie les types et génère `dist/` ; `npm test` vérifie le site et compile la banque en WASM dans ses variantes disponibles. `npm run preview` sert le résultat.

## Recherche et édition

- Rechercher par texte et métadonnées : `concours:CCINP année:2022`, `difficulté:2,4`, `type:td`, `chapitre:"automates finis"`. Les critères se cumulent ; plusieurs valeurs d'un critère sont réunies par « ou ».
- `/` rejoint la recherche ; Entrée ouvre le premier résultat. `⌘K` / `Ctrl+K` ouvre la palette ; `>` limite la recherche aux commandes.
- Une ressource est accessible par son nom sans `.typ`, par exemple `/residuels-minimisation/?vue=corrige`, sous le préfixe `/exercices/` sur GitHub Pages.
- L'éditeur compile automatiquement et conserve le dernier aperçu valide en cas d'erreur. Les codes associés sont consultables depuis le sélecteur de fichiers ou leurs liens dans la source.
- Les brouillons publics restent dans ce navigateur sans modifier GitHub. Télécharger le `.typ` pour les emporter. Le bouton de contribution crée une branche ou un fork puis ouvre la comparaison avant soumission de la PR ; un changement distant de la source bloque l'envoi.

Les PDF proposent les variantes du document, la navigation, le zoom, le téléchargement et le plein écran. Dans l'aperçu : ← / → change de page, + / − zoome, 0 ajuste à la largeur ; Échap quitte le plein écran. Le téléchargement conserve les couleurs originales, même en thème sombre.

## Publication GitHub Pages

Le [workflow](../.github/workflows/checks-and-deploy.yml) publie `web/dist/` après vérification des pushes sur `main`. Les PR sont vérifiées sans publication.

Les compilations de vérification ciblent les ressources modifiées et leurs dépendants. La bibliothèque, les modèles ou l'outillage commun déclenchent une vérification complète ; le moteur et les dépendances web déclenchent toutes les compilations WASM. Sans base Git, la vérification est complète. La construction du site, l'export des PDF publiés et les autres tests restent systématiques.

Dans **Settings → Pages**, choisir **GitHub Actions**. Pour reproduire la construction depuis `web/` :

```sh
BASE_PATH=/exercices SITE_URL=https://mpi-informatique.github.io nix develop ..#web -c npm run build
BASE_PATH=/exercices SITE_URL=https://mpi-informatique.github.io nix develop ..#web -c npm run preview
```

Sur un autre hébergement, servir les `index.html` des répertoires et les WASM avec `application/wasm`, en activant la compression HTTP. Conserver le même `BASE_PATH` à la construction et à la prévisualisation.

## Référencement

La construction génère automatiquement `dist/sitemap-index.xml` et `dist/sitemap-0.xml` à partir des routes publiques du catalogue. Le sitemap principal du domaine référence `https://mpi-informatique.github.io/exercices/sitemap-0.xml`. Les aperçus intégrables, la page de contribution et la page 404 sont exclus de l’indexation.

Les pages fournissent leur adresse canonique, une description, des métadonnées de partage et des données structurées. Le catalogue et les fiches des ressources sont présents dans le HTML initial, avec leurs liens vers les sources et les PDF publiés, puis remplacés par l’éditeur interactif après son chargement. Les variantes `?vue=…` partagent l’adresse canonique de la ressource.

## Lecteur intégrable

`/apercu/<id>/` affiche les PDF publiés sans charger le compilateur ni l'éditeur. Exemple : `https://mpi-informatique.github.io/exercices/apercu/cours-langages/`. La présentation est sélectionnée si disponible ; `vue=enonce`, `vue=corrige` ou `vue=presentation` choisit la variante. `cor=0` masque l'onglet corrigé sans protéger la ressource publique. Une iframe doit autoriser `allow="fullscreen"`.

Les PDF publiés suivent `cours/pages-typst.md` du dépôt voisin, ou sa branche distante `main` pour un clone autonome. `COURS_PAGES_TYPST` choisit un autre fichier. Les entrées `: cor` autorisent le corrigé ; les liens `doc:` et HTTP(S) sont ignorés. Les TP sont toujours exportés. Les noms des PDF portent une empreinte pour renouveler leur cache ; le catalogue public fournit leurs titres et URL.

`theme=light` ou `theme=dark` fixe le thème initial. Le parent peut ensuite envoyer `{type: 'exercices:theme', theme: 'dark' | 'light'}` à l'origine de la banque ; le lecteur annonce `{type: 'exercices:ready'}`. Les messages ne sont acceptés que depuis la fenêtre parente et l'origine de son référent.

## Banque privée

Le cadenas permet de se connecter à GitHub puis de charger un dépôt privé. Les ressources rejoignent la recherche avec le badge **Privé**, le filtre **Visibilité** et `tag:privé`.

Le dépôt doit contenir des sources compatibles avec l'API : exercices exportant `ex`, documents utilisant `feuille` et dépendances locales. Ses `lib/`, `templates/` et `load.typ` remplacent les versions publiques dans son moteur ; sinon, le moteur utilise l'API du site. Le verrou Nix privé ne change pas la révision du package public disponible dans le navigateur. `corrections/` est exclu ; les arbres tronqués et ressources de plus de 50 Mo sont refusés.

Les fichiers, brouillons et PDF privés restent en mémoire. Déconnexion, retrait du dépôt ou rechargement les effacent : télécharger les changements à conserver. **Créer un commit sur GitHub** enregistre la source sur la branche par défaut avec les droits du compte ; un changement distant bloque l'opération et conserve le brouillon. Aucune contribution publique n'est proposée pour ces fichiers.

La connexion et les scopes sont décrits dans le [guide du Worker OAuth](../worker/README.md).

## TP et Codespaces

Le bouton **TP** ouvre ou reprend le Codespace `mpi-informatique/tp-environnement` ; sélectionner ensuite le document dans **TP MPI**. Pour publier un TP, partir de [templates/tp.typ](../templates/tp.typ) et déclarer ses ressources dans `feuille.with(type: "tp", tp: ...)`. Le contrat de `tp` est documenté dans [lib/exercice.typ](../lib/exercice.typ).

Le catalogue exporte `tp.ouvrir`, `tp.fichiers` et `tp.corrige`. L'extension suit le marqueur `: cor` du menu pour afficher les corrigés dans le cours, sans reconstruire la banque. Les fichiers publics restent accessibles sur GitHub.

## Code et licences

| Chemin | Rôle |
| --- | --- |
| `scripts/prepare.py`, `scripts/assets.mjs` | Export de la banque, des PDF, packages et ressources npm. |
| `src/compiler/`, `src/hooks/useCompiler.ts` | Moteur WASM, worker et orchestration des compilations. |
| `src/components/`, `src/pages/` | Interface et routes. |
| `../shared/` | Types et lecteur PDF partagés avec les extensions VS Code. |

Les licences des packages, des polices et de PDF.js accompagnent les ressources exportées.
