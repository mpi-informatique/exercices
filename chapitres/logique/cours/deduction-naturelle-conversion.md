# Conversion de Déduction naturelle

Source inchangée : `cours-src/logique/deduction/cours/poly_deduction.tex`.
Les deux TODO, les 16 exercices, les espaces de réponse et les corrigés présents sont conservés. Les formules masquées par `\w` restent masquées dans le cours et apparaissent dans le corrigé. Aucune solution manquante n'a été ajoutée.

Corrections nécessaires :

- Induction : ajout du cas de l'implication, présente dans la grammaire.
- Formes normales : une FND est une disjonction de conjonctions de littéraux, une FNC une conjonction de disjonctions. La remarque sur la dualité est limitée aux formes normales négatives sans constantes, pour lesquelles la transformation décrite est valide.
- Preuves : indices des contextes rétablis dans la définition inductive ; contextes communs conservés dans les arbres corrigés conformément aux règles énoncées. Les trois corrigés regroupés après l'exercice sur le tiers exclu sont replacés après les exercices correspondants.
- Correction : remplacement du séquent sémantique par le séquent syntaxique dans le cas initial ; prise en compte des règles sans prémisse `ax`, introduction du vrai et tiers exclu.
- Complétude et complexité : portée classique explicite ; hypothèses finies pour le problème algorithmique `DNAT`.
- Premier ordre : distinction entre occurrences libres et liées, et suppression d'une parenthèse surnuméraire dans l'exemple ensembliste.
- Dernier exercice, question 1 : `∀ x ∃ y, x ∨ y` n'est pas une formule du premier ordre, car `x` et `y` sont des termes. Remplacement par `∀ x ∃ y, P(x) → P(y)`, avec `P` unaire, et adaptation de la preuve avec le témoin `y = x`.

Adaptations Typst : cadres du cours existants, arbres de preuve natifs et tableaux récapitulatifs. Les répétitions internes aux macros de masquage sont supprimées. Les deux réécritures syntaxiques du dernier arbre restent présentées comme dans le source.
