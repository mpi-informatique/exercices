# Conversion du résumé sur les grammaires

Source inchangée : `cours-src/langage/grammaire/resume/poly_grammaire.tex`.
Le TODO « Tree-sitter », les cinq exercices, les espaces à compléter et les figures sont conservés. Aucune solution n'a été ajoutée.

Erreurs corrigées :

- Méthode de preuve : suppression de `|u| = n`, qui confondait taille du mot et nombre d'étapes de dérivation. La propriété porte sur tout mot terminal obtenu en `n` étapes ; elle peut devoir être renforcée aux autres variables.
- Premier exercice : l'expression arithmétique de la question 4 ne relève pas de l'alphabet `{a, b}`. Cette question est explicitement exceptée.
- Analyse postfixe : dépiler le fils droit avant le fils gauche et employer le constructeur OCaml valide `N (B op, a1, a2)`. Une pile insuffisante ou un résultat final différent d'un arbre unique signale une expression mal formée.
- La compilation ne se réduit pas aux analyses lexicale et syntaxique : la phrase introductive porte désormais sur l'analyse du code source. La vérification lexicale est distinguée de la vérification syntaxique.
- Coquille `P` → `R` dans l'exemple de grammaire des formules ; espacement explicite des tokens `3 4 + 5 ×` pour éviter de lire `34 + 5 ×`.

Précisions nécessaires :

- Ensembles des variables et des terminaux disjoints ; domaines de `X`, `Y` et `a` dans les règles régulières explicites.
- Arbres de dérivation ordonnés ; la lecture des feuilles, en ignorant `ε`, doit produire le mot annoncé. La remarque du source est intégrée à la définition.
- Dans le diagramme, « langages linéaires » désigne les langages d'expressions régulières linéaires, et non les langages engendrés par des grammaires linéaires.

Adaptations : notations et terminologie du dépôt (`cal(L)(G)`, « non-contextuel »), cadres communs et figures CeTZ. Vérifications : compilation des deux variantes, contrôle visuel du cours et vérification OCaml du constructeur et de l'ordre de dépilement sur l'exemple donné.
