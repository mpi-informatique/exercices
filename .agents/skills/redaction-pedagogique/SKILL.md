---
name: redaction-pedagogique
description: Règles communes de rédaction, pédagogie, style naturel (anti-AI-slop), pagination multiple de 2, Typst, code, figures, tests et notations pour tout contenu pédagogique (exercices, TD, TP, cours, devoirs, colles) de la banque mpi-informatique.
---

# Rédaction pédagogique commune

Skill socle appliqué par `creation-exercice`, `relecture-contenu`, `conversion-cours`, `colle-mpi` et `colle-mp`, en complément de [AGENTS.md](../../../AGENTS.md).

## Sources, cours et programme

- Consulter les cours du thème et le [programme officiel](../../../docs/programme.md) avant de rédiger ou de modifier un contenu.
- Reprendre les définitions, notations, noms de règles et méthodes des cours du thème.
- Réinvestir les notions du programme MP2I–MPI lorsque cela sert la progression, sans rapprochement artificiel. Introduire ou rappeler toute notion, règle ou fonction de bibliothèque non exigible (annexes A.2/B.2).

## Pédagogie et rigueur

- Poser toutes les notations avant usage (objets, ensembles, fonctions, composantes), par exemple $A = (Σ, Q, q_0, F, δ)$ ou $G = (Σ, V, R, S)$.
- Construire une progression claire : exemples parlants, résultats intermédiaires, caractérisation, applications. Demander de trouver puis justifier sans donner systématiquement le résultat attendu.
- Rédiger ou relire le corrigé en même temps que l'énoncé. Vérifier hypothèses, cas limites, réciproques, dépendances entre questions, renvois, barème et durée. Distinguer les deux sens d'une équivalence et les étapes d'un algorithme.
- Pour une récurrence ou une induction, expliciter la propriété démontrée, le paramètre ou la structure, l'hypothèse, les cas de base et l'hérédité.
- **Mathématiques** : dans les corrigés, détailler les étapes intermédiaires non triviales des calculs et démonstrations sans sauter de grosse étape.
- Justifier les complexités sauf évidence. Pour une déterminisation, dessiner l'automate plutôt que donner seulement une table.
- Ajouter une variante `_Autre preuve._` ou une courte remarque lorsqu'elle éclaire vraiment la notion ou fait un lien utile avec le cours.

## Français naturel (éviter le « AI slop »)

- Écrire un français direct, naturel et concis, dans le ton des cours du professeur.
- Pas de points-virgules dans la prose. Pas de virgule avant « alors » dans « si … alors … ». Nouveaux termes en italique.
- **Modes verbaux** : infinitif pour les tâches demandées à l'élève (« Donner… », « Montrer… ») ; verbes conjugués pour introduire objets, hypothèses ou notations (« On pose… », « Soit… », « On associe… ») et pour rédiger les preuves et corrigés (« On choisit… », « Supposons… » — jamais de corrigé télégraphique à l'infinitif).
- Placer les aides dans un paragraphe `_Indication._` plutôt que d'accoler une phrase impérative en fin de question.
- Chasser les tics d'écriture générée : formules creuses ou grandiloquentes, lourdeurs, répétitions, transitions mécaniques, précautions inutiles, paraphrases évidentes du code.

## Pagination

- Pour les documents imprimés, viser de préférence un **nombre de pages multiple de 2** (typiquement **4 pages** pour un cours, **2 ou 4 pages** pour un TD).
- Ne jamais altérer la qualité pédagogique ni tasser artificiellement la mise en page pour atteindre ce nombre : jouer plutôt sur la concision des formulations, l'équilibre des exercices/questions ou une mise en page propre.

## Typst, code, figures et tests

- Utiliser `#question(bareme: 1)[Énoncé][Solution]` (second bloc facultatif) et `#partie("Titre")[...]` (`numero:` pour forcer un repère). Étiquettes stables pour les renvois (`label: <q-nom>`, puis `@q-nom`).
- Formater avec Typstyle (via Tinymist). Syntaxe native pour le contenu fixe, blocs écrits à leur emplacement d'utilisation. Apostrophe ASCII `'`, extraits délimités par accents graves avec langage indiqué, pas de point final dans les courtes listes de conditions.
- **Code** : C, OCaml, Python, SQL ou pseudocode selon le programme. Noms courts, commentaires limités aux choix ou invariants non évidents. En OCaml : indentation de 2 espaces, enregistrements et tableaux ouverts sur la ligne de déclaration (un élément par ligne si multilignes), variants et signatures courts sur une ligne (couper avant `->` si besoin). Quand un bloc de code comporte deux parties courtes (par exemple deux définitions de types), les placer côte à côte dans un `#grid(columns: (1fr, 1fr), column-gutter: 1.5em, align: left + top, ...)` (adapter les proportions en `fr`, ex. `(2fr, 3fr)`, jamais `auto` car les blocs de code ont `width: 100%`) si cela tient sans retour à la ligne gênant. Garder les blocs de code insécables (`breakable: false` par défaut dans `lib/code.typ` jusqu'à 35 lignes ; utiliser `#block(breakable: false, ...)` autour d'une grille si besoin). Garder les blocs de code insécables quand ils tiennent sur une page (géré automatiquement dans `lib/code.typ` jusqu'à 35 lignes ; utiliser `#block(breakable: false, ...)` pour garder un assemblage insécable si besoin). Les blocs de code courts sont insécables automatiquement par `lib/code.typ` ; éviter les blocs trop longs qui forceraient une coupure ou un grand blanc en fin de page. Éviter de casser un bloc de code entre deux pages (`lib/code.typ` rend insécables les blocs jusqu'à 35 lignes ; utiliser `#block(breakable: false, ...)` autour d'une grille de code si besoin).
- **Tests** : `sujet.ml` (squelette), `sujet-cor.ml` (corrigé + tests OCaml dans un module `Tests`, appels du corrigé hors de `Tests`), `sujet-test.ml` ou `sujet-test.py` si séparés. Tester quelques cas ciblés (une dizaine au besoin). Pas de `test.typ` dans les sujets de concours.
- **Figures et utilitaires de `lib/`** : dessiner en Typst avec des versions de packages fixées (`CeTZ`, `finite`, `lib/automate.typ` avec boucles et étiquettes vers l'extérieur, sans croisements).
  - Arbres : `@preview/tdtr` en liste à puces imbriquée (étiquettes d'arêtes en liste numérotée avant les fils), `text-size: 1em`.
  - Déduction naturelle : `@preview/curryst:0.6.0` (`rule` imbriqués, prémisses avant conclusion, `name:` pour la règle, `prooftree`) et utilitaires de `lib/logique/regles.typ` (`arbre`, `axiome`, `regles`, `rappel-regles`, `tableau-regles`, `sequent`) plutôt que des helpers locaux.

## Notations

| Objet | Convention |
| --- | --- |
| Mot | « taille » (préfixes, suffixes, facteurs inclus). `m` pour un mot seul, `u`, `v` pour plusieurs mots/facteurs (sans collision). |
| Langage | `cal(L)(A)`, `cal(L)(e)`, « régulier », « non-contextuel », union d'expressions par `\|`. |
| Composition | `∘`, sans juxtaposition. |
| Formules | Espaces autour des opérateurs et après les virgules (indices et légendes inclus). En mode mathématique, utiliser `thick` (jamais `\;` de LaTeX) pour ajouter un espace après une virgule (ex. `$∃ c ∈ Σ^*, thick V(i, c)$`). Ensembles en compréhension avec `mid(\|)`. Parenthéser les indices et espacer l'argument : `δ_(B) (·, σ)`, `RR_n [X]`. |
| Conditions successives | `#sep` après la virgule (espacement ordinaire dans arguments, tuples, ensembles, indices). |
| Flèches | `⟶`, `⟼`, `==>` (implication), `<==>` (équivalence ; `↔` réservé au connecteur logique d'une formule dans les cours de logique). Préserver la syntaxe des langages de programmation. |
| Symboles | Unicode (`Σ`, `ε`, `∀`, `∃`…), `union.big` / `inter.big` (indexés), `∪` / `∩` (binaires). |
| Automate déterministe complet | ADC, type `adc` en code. |
| Graphe | `G = (S, A)`. |
| Déterminant / combinaison | Taille par accolade à droite seulement si utile, `binom(n, k)`. |
