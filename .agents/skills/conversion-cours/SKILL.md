---
name: conversion-cours
description: Créer ou convertir un cours (`cours-<nom>.typ`) et sa présentation Touying associée en Typst. Couvre les solutions, `#completer()`, les cadres de théorèmes, la mise en page cours/diapositives et les différences polycopié/présentation.
---

# Cours et présentations

Appliquer ce skill avec [AGENTS.md](../../../AGENTS.md) et le skill `creation-exercice` pour la rédaction, les notations, le code et les figures. Partir des modèles `templates/cours.typ`, `templates/presentation.typ` ou `templates/cours-presentation.typ`.

## Source commune cours / présentation

- Nommer les sources `cours-<nom>.typ` : elles produisent le cours, son corrigé et la présentation `presentation-<nom>.pdf`.
- `=` structure les parties, `==` ouvre une diapositive. Réserver les sous-sections du polycopié aux regroupements utiles.
- Isoler les contenus propres à un format avec `article-only` et `slides-only`.
- Réutiliser les fonctions utilitaires existantes de `lib/` (consulter les commentaires `///` de `lib/cours.typ` et `lib/presentation.typ`), notamment `colonnes-cours`, `formules-reparties` et `liste-cours`, en tenant compte de leur comportement dans les trois variantes (cours, corrigé, présentation).
- Pour les arbres `tdtr`, régler `text-size: 1em` afin de suivre la taille du texte du cours ou des diapositives.

## Solutions, preuves et trous à compléter

- **Jamais de corrigé projeté** : réserver les corrigés et démonstrations au document corrigé imprimé, y compris lors d'une conversion. N'activer `presentation: true` que sur demande explicite de l'utilisateur, sans créer de fonction qui force la projection des corrections.
- Dans un cours, intégrer la solution au cadre `exercice` ou utiliser `#solution[...]` pour une démonstration ou une correction autonome, **sans ajouter de titre « Preuve »**.
- Pour un exercice de cours à plusieurs questions, regrouper les réponses numérotées dans un même bloc de solution.
- Utiliser `#completer()` uniquement si la réponse tient sur une seule ligne dans le document rendu. Pour une réponse plus longue, utiliser `#solution[...]` sans réserver plusieurs lignes vides.

## Cadres et titres

- Utiliser les cadres numérotés de `theoremes` et marquer les résultats à connaître avec `coeur: true`.
- Pour un titre déjà numéroté ou une introduction sans numéro, utiliser `heading(numbering: none)` ou une règle `set heading(numbering: none)` limitée au bloc concerné.
