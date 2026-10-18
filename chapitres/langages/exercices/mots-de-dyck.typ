#import "/load.typ": exercice, question
#import "/load.typ": sep
#import "@preview/cetz:0.4.2" as cetz

#let ex = exercice(
  meta: (
    titre: "Mots de Dyck",
    chapitres: ("langages-reguliers", "automates-finis", "recursivite-et-induction", "structures"),
    structures: ("liste", "arbre-binaire"),
    langages: ("OCaml",),
    difficulte: 3,
    niveaux: ("MPI",),
    concours: (nom: "EPITA", annee: 2023),
  ),
  contenu: (
    [On appelle mot de Dyck un mot $m$ sur l'alphabet ${a,b}$ tel que $m$ contient autant de $a$ que de $b$ et tout préfixe de $m$ contient au moins autant de $a$ que de $b$.

      Par exemple, $m=a a b a b b$ est un mot de Dyck, car il possède trois $a$ et trois $b$, et ses préfixes sont $ε$ (le mot vide), $a$, $a a$, $a a b$, $a a b a$, $a a b a b$ et $m$, et aucun ne contient strictement plus de $b$ que de $a$.],
    question(
      [
        Parmi les mots suivants, indiquer ceux qui sont de Dyck.
        On ne demande pas de preuve.
        $ ε quad a a b b b a a b quad a a a b quad a b a b quad a a a b b b $
      ],
      solution: [
        $ε$, $a b a b$ et $a a a b b b$.
        Remarque : en remplaçant $a$ par '(' et $b$ par ')', les mots de Dyck sont les mots bien parenthésés.
      ],
    ),
    [On représente dans la suite en OCaml un mot sur l'alphabet ${a,b}$ par la liste de ses lettres.
      On définit les types suivants :
      ```ocaml
      type lettre = A | B
      type mot = lettre list
      ```
      Le mot $m=a a b a b b$ sera donc représenté par la liste ```ocaml [A; A; B; A; B; B]```.
    ],
    question(
      [
        Écrire une fonction ```ocaml verifie_dyck``` de type ```ocaml mot -> bool``` renvoyant un booléen indiquant si le mot passé en entrée est de Dyck.
      ],
      solution: [
        On utilise un argument pour mémoriser le nombre de 'A' déjà vus moins le nombre de 'B'.
        ```ocaml
        let verifie_dyck m =
          let rec aux n m = match m with
            | [] -> n = 0
            | A::q -> aux (n + 1) q
            | B::q -> n > 0 && aux (n - 1) q in
          aux 0 m
        ```
      ],
    ),
    [On admet la propriété suivante : tout mot $m$ de Dyck non vide se décompose de manière unique sous la forme $m=a u b v$, où $u$ et $v$ sont des mots de Dyck.
      On pourra utiliser sans démonstration la caractérisation suivante : $a u b$ est le plus petit préfixe non vide de $m$ contenant autant de $a$ que de $b$.],
    question(
      [
        Donner sans démonstration la décomposition de chacun des mots de Dyck suivants :
        $ a b quad a a b a b b quad a b a b a b quad a a b b a b $
      ],
      solution: [
        - $a b=a u b v$ avec $u=v=ε$.
        - $a a b a b b=a u b v$ avec $u=a b a b$ et $v=ε$.
        - $a b a b a b=a u b v$ avec $u=ε$ et $v=a b a b$.
        - $a a b b a b=a u b v$ avec $u=a b$ et $v=a b$.
      ],
    ),
    question(
      [
        Écrire une fonction ```ocaml decompo_dyck``` de type ```ocaml mot -> mot * mot```, prenant en entrée un mot $m$ supposé non vide et de Dyck (il est inutile de le vérifier), et renvoyant le couple $(u,v)$ tel que $m=a u b v$.
      ],
      solution: [
        On fait le même comptage qu'en question 2 et l'on s'arrête au premier préfixe contenant autant de ```ocaml A``` que de ```ocaml B```.
        La fonction ```ocaml List.tl``` renvoie la queue d'une liste non vide ; elle retire ici le 'A' initial.
        ```ocaml
        let decompo_dyck m =
          let rec aux n m = match m with
            | [] -> failwith "decompo_dyck"
            | A::q ->
              let uq, vq = aux (n + 1) q in
              A::uq, vq
            | B::q ->
              if n = 1 then [], q
              else
                let uq, vq = aux (n - 1) q in
                B::uq, vq in
          let u, v = aux 0 m in
          List.tl u, v
        ```
      ],
    ),
    [Il existe une bijection naturelle entre les arbres binaires stricts (tout nœud possède $0$ ou $2$ fils) et les mots de Dyck, basée sur cette décomposition :
      - au mot vide est associé l'arbre réduit à une feuille ;
      - à un mot non vide $a u b v$, où $u$ et $v$ sont de Dyck, on associe l'arbre dont les sous-arbres gauche et droit sont associés respectivement à $u$ et $v$.
    ],
    question(
      [
        Dessiner l'arbre associé au mot de Dyck $m=a a b a b b$.
        Les nœuds ne portent pas d'étiquettes.
      ],
      solution: [
        #align(center, cetz.canvas({
          import cetz.draw: circle, line
          // Arbre N(N(F, N(F, F)), F), associé au mot aababb.
          let sommets = ((0, 0), (-1.4, -1.2), (1.4, -1.2), (-2.2, -2.4), (-0.6, -2.4), (-1.2, -3.6), (0, -3.6))
          for (parent, enfant) in ((0, 1), (0, 2), (1, 3), (1, 4), (4, 5), (4, 6)) {
            line(sommets.at(parent), sommets.at(enfant))
          }
          for sommet in sommets {
            circle(sommet, radius: 0.08, fill: white)
          }
        }))
      ],
    ),
    [On définit le type suivant :
      ```ocaml
      type arbre = F | N of arbre * arbre
      ```],
    question(
      [
        Écrire une fonction ```ocaml mot_a_arbre``` de type ```ocaml mot -> arbre``` renvoyant l'arbre binaire strict associé à un mot de Dyck (on ne vérifiera pas que le mot passé en entrée est bien de Dyck).
      ],
      solution: [
        ```ocaml
        let rec mot_a_arbre m = match m with
          | [] -> F
          | _ ->
            let u, v = decompo_dyck m in
            N(mot_a_arbre u, mot_a_arbre v)
        ```
      ],
    ),
    question(
      [Écrire une fonction ```ocaml arbre_a_mot``` de type ```ocaml arbre -> mot``` faisant l'inverse.],
      solution: [
        ```ocaml
        let rec arbre_a_mot a = match a with
          | F -> []
          | N(u, v) -> A::(arbre_a_mot u)@(B::(arbre_a_mot v))
        ```
      ],
    ),
    question([Montrer que le langage $L$ des mots de Dyck n'est pas régulier.], solution: [
      Supposons $L$ régulier et soit $n ≥ 1$ donné par le lemme de l'étoile.
      Le mot $m=a^n b^n$ appartient à $L$ et vérifie $abs(m) ≥ n$.
      Il existe donc $x,y,z$ tels que $abs(x y) ≤ n$, $y ≠ ε$, $m=x y z$ et $x y^* z ⊂ L$.
      Comme $abs(x y) ≤ n$, $y$ ne contient que des $a$, et au moins un puisque $y ≠ ε$.
      Alors $x y^2 z$ contient strictement plus de $a$ que de $b$, ce qui contredit son appartenance à $L$.
    ]),
    question(
      [
        Soit $C(n)$ le nombre de mots de Dyck de taille $2n$.
        Trouver une équation de récurrence sur $C(n)$, puis montrer que $C(n)=1/(n+1) binom(2n, n)$.
      ],
      solution: [
        Pour $n ≥ 1$, la décomposition unique $a u b v$, avec $abs(u)=2k$ et $abs(v)=2(n-k-1)$, donne $C(k)C(n-k-1)$ mots pour chaque $0 ≤ k < n$.
        Ainsi
        $ C(0)=1, #sep C(n)=sum_(k=0)^(n-1) C(k)C(n-k-1). $

        Pour établir la formule explicite, comptons parmi les $binom(2n, n)$ mots ayant $n$ lettres de chaque sorte ceux qui ne sont pas de Dyck.
        Pour $n ≥ 1$, un tel mot possède un premier préfixe où le nombre de $b$ dépasse celui des $a$ de $1$.
        Échanger $a$ et $b$ dans ce préfixe donne un mot ayant $n+1$ lettres $a$ et $n-1$ lettres $b$.
        Réciproquement, dans un tel mot, on échange les lettres du premier préfixe où le nombre de $a$ dépasse celui des $b$ de $1$.
        Ces opérations sont inverses : les mots non Dyck sont donc au nombre de $binom(2n, n-1)$.
        Par conséquent,
        $ C(n)=binom(2n, n)-binom(2n, n-1)=1/(n+1) binom(2n, n). $
        La formule vaut aussi pour $n=0$.
      ],
    ),
  ),
)
