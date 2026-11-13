# TP : Preuve automatique en déduction naturelle

Conversion de `rc/tp/11_tp_deduction_naturelle/11_tp_deduction_naturelle.mdx`, avec son corrigé OCaml et le support `dnat.ml` inchangé. Le squelette `main.ml` correspond aux neuf questions de programmation, désormais numérotées de 1 à 9. L'entraînement final reste proposé après les questions.

Les corrections et le filtrage des éliminations validé par le professeur sont consignés dans le champ `corrections` du fichier Typst. La difficulté 3/5 est une estimation. La recherche reste bornée et limitée aux règles proposées à partir des sous-formules du contexte : son échec ne prouve pas l'impossibilité d'une dérivation.

Depuis la racine du dépôt, dans `nix develop .` :

```sh
just c chapitres/logique/tp/tp-deduction-naturelle/tp-deduction-naturelle.typ
just w chapitres/logique/tp/tp-deduction-naturelle/tp-deduction-naturelle.typ
ocaml -I chapitres/logique/tp/tp-deduction-naturelle chapitres/logique/tp/tp-deduction-naturelle/corrige.ml
```

Le corrigé charge `dnat.ml` avec `#mod_use` pour fonctionner dans l'interpréteur OCaml utilisé par les tests de la banque. Pour le travail des élèves, compiler `dnat.ml` avec `main.ml` comme indiqué dans l'énoncé.

Les tests sont fournis à la fin de `main.ml`, dans le module `Tests`, et exécutés par `Tests.executer ()`. Ils échouent tant que les fonctions nécessaires restent à compléter. Les mêmes tests sont conservés dans `corrige.ml` pour vérifier les solutions.
