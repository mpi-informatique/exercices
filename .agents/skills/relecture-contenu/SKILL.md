---
name: relecture-contenu
description: Relire, corriger et améliorer un cours, TD, TP ou exercice existant en Typst : exactitude scientifique, conformité au cours et au programme officiel, style naturel sans AI slop, clarté, exemples et questions plus utiles, et pagination sur un multiple de 2 pages.
---

# Relecture et amélioration de contenu

Appliquer ce skill avec [AGENTS.md](../../../AGENTS.md) et le skill commun [redaction-pedagogique](../redaction-pedagogique/SKILL.md).

## 1. Prendre le contexte

- Lire la feuille (TD, TP, cours) et tous les exercices ou fichiers de code importés.
- Lire les cours du thème (`chapitres/<theme>/cours/`), le [programme officiel](../../../docs/programme.md) et les utilitaires concernés dans `lib/` (ex. `lib/logique/regles.typ`).
- Contrôler la branche Git et les modifications locales existantes pour s'inspirer des retouches récentes du professeur et ne pas les écraser.
- Compiler les variantes actuelles (`just c <source>`) pour relever le nombre de pages et repérer les défauts visuels ou de mise en page.

## 2. Auditer le fond et la forme

Examiner chaque exercice et chaque question (énoncé **et** corrigé) selon ces axes :

- **Exactitude et rigueur** : hypothèses manquantes ou implicites, cas limites ($n = 0$, ensemble vide, variables auxiliaires non traitées, contexte supplémentaire dans une récurrence), réciproques, validité des preuves et des arbres de dérivation, complexités, conformité du code aux annexes C/OCaml du programme.
- **Cohérence avec le cours et `lib/`** : mêmes notations, mêmes définitions, mêmes noms de règles (ex. `raa`, `te`, `scripts(→)_e`), même ordre des prémisses, réutilisation des utilitaires de `lib/` (ex. `logique.arbre`, `logique.rappel-regles`, `logique.sequent`) au lieu de helpers locaux redondants.
- **Formulation naturelle (anti-AI-slop)** : corriger fautes d'orthographe, erreurs de mode mathématique Typst, corrigés télégraphiques à l'infinitif, indications parachutées sans `_Indication._`, lourdeurs, répétitions et tics de texte généré.
- **Pertinence pédagogique** : repérer les exemples dégénérés ou peu instructifs et proposer de meilleurs exemples ; améliorer l'ordre des exercices ou des questions ; proposer des remarques éclairantes, des liens entre exercices ou avec le cours, des questions supplémentaires pertinentes ou une `_Autre preuve._` si elle apporte un vrai éclairage.
- **Pagination** : viser un **nombre de pages multiple de 2** (typiquement 4 pour un cours, 2 ou 4 pour un TD) pour le document imprimé (et autant que possible pour le corrigé), sans dégrader le contenu ni tasser la mise en page.

## 3. Appliquer ou demander en cas de doute

- Appliquer directement les corrections, améliorations de formulation/clarté, harmonisations avec le cours ou `lib/`, et ajouts pertinents lorsque l'intention est claire.
- Ne demander l'accord préalable de l'utilisateur qu'en cas de **doute important** (changement majeur de périmètre, suppression d'exercice, choix pédagogique structurant ou ambiguïté réelle).

## 4. Vérifier

- Formater avec Typstyle.
- Exécuter les tests de code associés s'il y en a.
- Recompiler uniquement les fichiers et variantes concernés (`just c <source>`), vérifier le nombre de pages (multiple de 2 visé) et inspecter le rendu PDF des pages modifiées.
- Toujours committer et pousser après vérification (contrôler le diff, intégrer les commits distants puis pousser sans forcer), conformément à [AGENTS.md](../../../AGENTS.md).
- Résumer les changements avec des liens cliquables vers chaque `.typ` et PDF utile.
