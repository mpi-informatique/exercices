# Consignes communes (`exercices` et `exercices-prive`)

Ces consignes s'appliquent aux deux dépôts (liens relatifs au dépôt public). Le `AGENTS.md` de `exercices-prive` les complète pour la confidentialité, les copies et les colles.

## Skills et documentation

| Besoin | Référence |
| --- | --- |
| Règles communes de rédaction, pédagogie, pagination, code, figures et notations | Skill `redaction-pedagogique` (`.agents/skills/redaction-pedagogique/SKILL.md`) |
| Créer, adapter ou transférer un exercice, TD, TP ou concours | Skill `creation-exercice` (`.agents/skills/creation-exercice/SKILL.md`) |
| Relire, corriger ou améliorer un cours, TD, TP ou exercice existant | Skill `relecture-contenu` (`.agents/skills/relecture-contenu/SKILL.md`) |
| Créer ou convertir un cours / une présentation | Skill `conversion-cours` (`.agents/skills/conversion-cours/SKILL.md`) |
| Syntaxe, packages ou compilation Typst générique | Skill `typst` (`.agents/skills/typst/SKILL.md`) |
| Commandes, Nix, utilisation du package | [Guide utilisateur](docs/utilisation.md) |
| Périmètre officiel MP2I–MPI | [Programme](docs/programme.md) |
| API Typst de la banque | Commentaires `///` dans `lib/` et modèles de `templates/` |

## Règles transversales

- **Sources** : avant de créer un contenu, consulter les cours du thème (ex. `chapitres/langages/cours/`), `/Volumes/T7 Shield/ups-mpi` et `../rc/`. Compléter si besoin par des sources originales ou universitaires en ligne. Archiver les nouvelles sources utiles dans le sous-dossier thématique de `rc/` sans doublon et renseigner titre, auteur, URL et passages utiles dans l'index de liens voisin. Signaler une source locale inaccessible plutôt que supposer son contenu.
- **Style** : s'inspirer du style du professeur en lisant des passages comparables des cours et corrigés existants (formulations, notations, concision, niveau de détail).
- **Dialogue et accord préalable** : poser les questions nécessaires en cas d'ambiguïté et expliquer brièvement les choix importants. Lors d'une modification d'un contenu pédagogique existant, ne pas demander systématiquement avant d'agir : demander l'accord préalable uniquement s'il y a un doute important (changement de périmètre, suppression de contenu, choix pédagogique structurant ou ambiguïté). Cette règle ne s'applique pas aux modifications de la bibliothèque.
- **Documentation et bibliothèque** : garder les Markdown concis (une information à un seul endroit, avec des liens). Documenter les fonctions Typst dans les commentaires `///` de `lib/` sans recopier leur fonctionnement dans les consignes. Réutiliser les utilitaires existants de `lib/` (`colonnes-cours`, `formules-reparties`, `liste-cours`…) et préférer des noms courts et explicites sans suffixe de contexte inutile (`commentaire` plutôt que `commentaire-algorithme`). Lors de l'ajout ou modification d'une commande Typst utile à la rédaction, actualiser son snippet dans `../vscode-mpi-exercices/snippets/typst.json` et le README de l'extension selon [../vscode-mpi-exercices/AGENTS.md](../vscode-mpi-exercices/AGENTS.md).
- **Mise en forme** : aucune longueur maximale imposée aux lignes de code, couper selon la structure et la lisibilité.
- **Git et branches** : vérifier avant toute modification que la branche correspond au travail demandé (prévenir en cas de décalage). Utiliser un worktree séparé pour travailler sur une autre branche sans changer la branche ni toucher aux modifications locales de l'espace initial.

## Vérification et livraison

- **Vérifications ciblées** : pour du contenu pédagogique, compiler uniquement les fichiers et variantes concernés et tester le code modifié. Pour de la documentation ou des consignes seules, contrôler le diff et les liens. Adapter les vérifications au comportement modifié pour `lib/` et l'outillage ; réserver `just check` aux changements transversaux ou sur demande explicite. Annoncer les vérifications effectuées et n'inspecter les PDF que si utile.
- **Tests minimaux** : couvrir les comportements essentiels sans doublonner les compilations ni dépendre d'un exercice précis de la banque. Pas de test de détail visuel pour un simple réglage de présentation.
- **Site web** : pour tout changement du site, de l'export ou de la compilation navigateur, relancer avec `just web-stop` puis `just web` et vérifier dans le navigateur intégré.
- **Réponse de livraison** : résumer les modifications, indiquer explicitement s'il reste du code maladroit (« clunky »), fragile ou inutilement complexe, fournir des liens cliquables vers chaque fichier `.typ` créé ou modifié (même si un PDF est fourni), vers les PDF utiles et vers les lignes de code importantes.
- **Commit et push** : après vérification, contrôler le diff, committer sur la branche adaptée (`main` par défaut), récupérer et intégrer les commits distants puis pousser sans forcer, en préservant les modifications locales de l'utilisateur.

Les commandes se lancent depuis la racine du dépôt (`nix develop . -c just …` si Just manque, `just --list` pour la liste).
