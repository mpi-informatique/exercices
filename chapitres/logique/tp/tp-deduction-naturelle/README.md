# TP : Preuve automatique en déduction naturelle

Conversion de `rc/tp/11_tp_deduction_naturelle/11_tp_deduction_naturelle.mdx`, avec son corrigé OCaml et le support `dnat.ml` inchangé. Le squelette `main.ml` correspond aux neuf questions de programmation, désormais numérotées de 1 à 9. L'entraînement final reste proposé après les questions.

Les corrections et le filtrage des éliminations validé par le professeur sont consignés dans le champ `corrections` du fichier Typst. La difficulté 3/5 est une estimation. La recherche reste bornée et limitée aux règles proposées à partir des sous-formules du contexte : son échec ne prouve pas l'impossibilité d'une dérivation.

Depuis la racine du dépôt, dans `nix develop .` :

```sh
just c chapitres/logique/tp/tp-deduction-naturelle/tp-deduction-naturelle.typ
just w chapitres/logique/tp/tp-deduction-naturelle/tp-deduction-naturelle.typ
ocaml -I chapitres/logique/tp/tp-deduction-naturelle chapitres/logique/tp/tp-deduction-naturelle/corrige.ml
```

Pour les élèves : lancer `utop` depuis le dossier du TP et exécuter `#use "main.ml";;`. Le fichier charge lui-même `dnat.ml`. Recharger après chaque modification, puis appeler le test de la question, par exemple `test_seq ();;`. Les neuf fonctions `test_…` sont placées après les fonctions à compléter et affichées dans le sujet par extraction, sans copie du code ni exécution automatique.

Le corrigé conserve ses vérifications plus complètes (règles, validité des arbres, profondeur minimale) pour les tests automatiques de la banque.
