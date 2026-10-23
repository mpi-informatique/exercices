#import "/load.typ": exercice, feuille, question, code, automate
#import automate: dessiner-automate
#import code: code-extrait
#let corrige = read("corrige.ml")
#let squelette = read("tp2.ml")

#let sujet = exercice(
  meta: (
    titre: "TP Automates",
    chapitres: ("automates-finis", "langages-reguliers"),
    algorithmes: ("parcours-en-profondeur",),
    langages: ("OCaml",),
    niveaux: ("MPI",),
    difficulte: 2,
  ),
  contenu: (
    [Ce TP est à effectuer en OCaml, sous Visual Studio Code, dans Codespaces ou sur un ordinateur personnel.
      Compléter le fichier `tp2.ml` fourni. Pour exécuter les définitions dans utop, sélectionner les lignes puis appuyer sur Maj + Entrée.
      Ajouter `;;` pour terminer une saisie dans utop. Interrompre une boucle infinie avec Ctrl + C.],
    [= Automate déterministe
      On représente un automate fini déterministe complet par le type suivant :
      #code-extrait(squelette, "afdc")
      Les états sont numérotés de $0$ à $n - 1$ et les lettres sont des entiers : $a$ est représenté par $0$, $b$ par $1$, etc.
      Pour un automate `a`, `a.delta.(i).(j)` est l'état atteint depuis l'état $i$ en lisant la lettre $j$.
      Le nombre d'états est `Array.length a.delta`.],
    question([
      Définir en OCaml les automates `a1` et `a2` suivants :
      #grid(columns: (1fr, 1fr), align: center + horizon,
        figure(dessiner-automate(
          (("0", (0, 0), true, false), ("1", (3, 0), false, true)),
          (
            ("0", "0", "1", (:)),
            ("1", "1", "1", (:)),
            ("0", "1", "0", (curve: 0.5)),
            ("1", "0", "0", (curve: 0.5)),
          ),
        ), caption: [`a1`]),
        figure(dessiner-automate(
          (("0", (0, 0), true, false), ("1", (2.5, 2.5), false, false), ("2", (5, 0), false, true)),
          (
            ("0", "0", "0", (anchor: bottom)),
            ("1", "1", "0", (:)),
            ("2", "2", "0", (anchor: bottom)),
            ("0", "1", "1", (curve: 0)),
            ("1", "2", "1", (curve: 0)),
            ("2", "0", "1", (curve: 0)),
          ),
        ), caption: [`a2`]),
      )
    ], solution: [#code-extrait(corrige, ("a1", "a2"))]),
    question([
      Définir `delta_etoile : afdc -> int -> int list -> int` telle que `delta_etoile a q u` renvoie l'état atteint depuis `q` après lecture de `u`, c'est-à-dire $δ^*(q, u)$. Vérifier avec `a1`.
    ], solution: [#code-extrait(corrige, "delta_etoile")]),
    question([
      Définir `accepte : afdc -> int list -> bool` telle que `accepte a u` détermine si `u` est reconnu par `a`. Vérifier avec `a1`. Quelle est sa complexité ?
    ], solution: [
      #code-extrait(corrige, "accepte")
      La lecture du mot coûte $O(abs(u))$ et la recherche de l'état final coûte $O(abs(F))$.
      La complexité totale est $O(abs(u) + abs(F))$.
    ]),
    question([
      Définir `complementaire : afdc -> afdc` qui construit un automate reconnaissant le complémentaire du langage reconnu par `a`. Vérifier avec `a1`.
      L'automate est supposé déterministe et complet.
    ], solution: [#code-extrait(corrige, "complementaire")]),
    question([
      Définir `accessibles : afdc -> int list` qui détermine les états accessibles de `a` par un parcours en profondeur. Vérifier sur des exemples.

      _Indication._ Utiliser un tableau `vus`, puis visiter récursivement chaque successeur non encore visité depuis l'état initial.
    ], solution: [#code-extrait(corrige, "accessibles")]),
    question([
      En déduire `vide : afdc -> bool` qui détermine si le langage reconnu par `a` est vide.
    ], solution: [#code-extrait(corrige, "vide")]),
    [= Automate produit],
    question([
      Écrire `inter : afdc -> afdc -> afdc` pour construire un automate reconnaissant l'intersection des langages reconnus par `a` et `b`, sur le même alphabet.
      Construire l'automate produit à $n p$ états, où $n$ et $p$ sont les nombres d'états de `a` et `b`.
      Numéroter l'état $(i, j)$ par $i × p + j$. Vérifier avec `a1` et `a2`.
    ], solution: [#code-extrait(corrige, "inter")]),
    question([
      En déduire `inclus : afdc -> afdc -> bool` qui teste l'inclusion des langages reconnus par `a` et `b`.
    ], solution: [
      On utilise $cal(L)(A) ⊂ cal(L)(B) ⟺ cal(L)(A) ∩ overline(cal(L)(B)) = ∅$.
      #code-extrait(corrige, "inclus")
    ]),
    question([
      En déduire `equivalent : afdc -> afdc -> bool` qui teste l'égalité des langages reconnus par `a` et `b`.
    ], solution: [#code-extrait(corrige, "equivalent")]),
  ),
)

#show: feuille.with(
  type: "tp",
  titre: sujet.meta.titre,
  niveau: "MPI",
  exercices: (sujet,),
  tp: (
    ouvrir: "tp2.ml",
    squelette: ((source: "tp2.ml"),),
    corrige: ((source: "corrige.ml"),),
  ),
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
