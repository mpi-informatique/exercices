#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Distance de Hamming",
    chapitres: ("langages-reguliers", "recursivite-et-induction"),
    langages: ("OCaml",),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [On fixe un alphabet fini $Sigma$.
      Si $u=u_1 dots u_n$ et $v=v_1 dots v_n$ sont deux mots de même taille, leur distance de Hamming est
      $ d(u,v)=abs({i in {1,dots,n} | u_i != v_i}). $],
    question(
      [
        Montrer que, pour tout $n in NN$, la distance de Hamming est une distance sur $Sigma^n$.
      ],
      solution: [
        La distance est positive ou nulle, symétrique, et $d(u,v)=0$ si et seulement si $u=v$.
        Pour l'inégalité triangulaire, soient $u,v,w in Sigma^n$.
        Si $u_i != w_i$, alors $u_i != v_i$ ou $v_i != w_i$.
        Ainsi,
        $ {i | u_i != w_i} subset.eq {i | u_i != v_i} union {i | v_i != w_i}. $
        En prenant les cardinaux, on obtient $d(u,w)<=d(u,v)+d(v,w)$.
      ],
    ),
    [Étant donné un langage $L$ sur $Sigma$, on définit son voisinage de Hamming par
      $ cal(H)(L)={u in Sigma^* | exists v in L, abs(u)=abs(v) " et " d(u,v)<=1}. $],
    question(
      [
        Sur l'alphabet ${0,1}$, donner une expression régulière pour $cal(H)(cal(L)(0^* 1^*))$.
      ],
      solution: [
        On peut conserver le mot, changer un $0$ en $1$, ou changer un $1$ en $0$.
        On obtient l'expression
        $ 0^* 1^* | 0^* 1 0^* 1^* | 0^* 1^* 0 1^*. $
      ],
    ),
    question(
      [
        Montrer que si $L$ est un langage régulier, alors $cal(H)(L)$ est régulier.
      ],
      solution: [
        On raisonne par induction structurelle sur les expressions régulières.
        Si $L$ est fini, $cal(H)(L)$ est fini : pour un mot $u$, il y a $1+abs(u)(abs(Sigma)-1)$ mots à distance au plus $1$ de $u$.

        Pour l'union et la concaténation, on utilise les identités
        $ cal(H)(L_1 union L_2)=cal(H)(L_1) union cal(H)(L_2), $
        $ cal(H)(L_1 L_2)=cal(H)(L_1)L_2 union L_1 cal(H)(L_2). $
        Une modification d'au plus une lettre d'un mot $u_1 u_2$ se situe dans l'un des deux facteurs.
        Les membres de droite sont réguliers par hypothèse d'induction et stabilité par union et concaténation.

        Enfin,
        $ cal(H)(L^*)={epsilon} union L^* cal(H)(L) L^*. $
        Le mot vide est toujours présent.
        Pour une concaténation non vide de facteurs de $L$, on peut modifier au plus une lettre dans l'un d'entre eux, ou ne rien modifier.
        Cette identité reste vraie pour $L=emptyset$ et achève l'induction.
      ],
    ),
    question(
      [
        Sur l'alphabet $Sigma={0,1}$, écrire une fonction `f : int regexp -> int regexp` renvoyant une expression régulière du voisinage de Hamming d'un langage, en utilisant le type suivant.
        Les lettres de l'expression d'entrée valent $0$ ou $1$.
        #block(breakable: false)[
          ```ocaml
          type 'a regexp =
            | Vide | Epsilon | L of 'a (* L a est la lettre a *)
            | Union of 'a regexp * 'a regexp
            | Concat of 'a regexp * 'a regexp
            | Etoile of 'a regexp
          ```
        ]
      ],
      solution: [
        On traduit les identités de la question précédente :
        #block(breakable: false)[
          ```ocaml
          let rec f = function
            | Vide -> Vide
            | Epsilon -> Epsilon
            | L _ -> Union (L 0, L 1)
            | Union (e1, e2) -> Union (f e1, f e2)
            | Concat (e1, e2) ->
                Union (Concat (f e1, e2), Concat (e1, f e2))
            | Etoile e ->
                Union (Epsilon, Concat (Etoile e, Concat (f e, Etoile e)))
          ```
        ]
        L'union avec `Epsilon` est nécessaire, notamment pour `Etoile Vide`.
      ],
    ),
  ),
)
