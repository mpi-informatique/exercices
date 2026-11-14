#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
      titre: "Stabilité des langages réguliers",
      chapitres: ("langages-reguliers", "automates-finis"),
      difficulte: 2,
      niveaux: ("MPI",),
    ),
)[
  Pour chacune des propositions suivantes, expliquer pourquoi elle est vraie ou donner un contre-exemple :

  #question[Si $L$ est régulier et $L ⊂ L'$ alors $L'$ est régulier.][
        Faux avec $L = ∅$ et $L' = {a^n b^n | n ∈ NN}$ sur $Σ = {a,b}$.
      ]

  #question[Si $L'$ est régulier et $L ⊂ L'$ alors $L$ est régulier.][
        Faux avec $L = {a^n b^n | n ∈ NN}$ et $L' = Σ^*$ sur $Σ = {a,b}$.
      ]

  #question[Si $L$ est régulier alors $L^*$ est régulier.][
        Vrai par définition des langages réguliers.
      ]

  #question[Si $L^*$ est régulier alors $L$ est régulier.][
        Faux avec $L = {a^n b^n | n ∈ NN} ∪ {ε,a,b}$ sur $Σ = {a,b}$.
        $L^*$ est alors $Σ^*$, qui est régulier, mais $L$ ne l'est pas.
      ]

  #question[
          Si $L$ est régulier sur un alphabet $Σ$ alors $Σ^* ∖ L$
          (complémentaire de $L$) est régulier.
        ][Vrai comme démontré dans le cours sur les automates.]

  #question[
          Une union finie de langages réguliers est régulière
          ($L_1, …, L_n$ réguliers $==> ⋃_(k=1)^n L_k$ régulier).
        ][
          Vrai par récurrence sur $n$ et la stabilité des langages réguliers par union de deux langages réguliers.
        ]

  #question[
          Une union dénombrable de langages réguliers est régulière
          ($L_1, …, L_n, …$ réguliers $==> ⋃_(k=1)^∞ L_k$ régulier).
        ][Faux avec $L_n = {a^n b^n}$ pour $n ≥ 1$.]

  #question[
          Une intersection finie de langages réguliers est régulière
          ($L_1, …, L_n$ réguliers $==> ⋂_(k=1)^n L_k$ régulier).
        ][
          Vrai par récurrence sur $n$, en utilisant la stabilité des langages réguliers par intersection de deux langages réguliers, vue dans le cours sur les automates.
        ]

  #question[
          Une intersection dénombrable de langages réguliers est régulière
          ($L_1, …, L_n, …$ réguliers $==> ⋂_(k=1)^∞ L_k$ régulier).
        ][
          Faux avec $L_n = Σ^* ∖ {a^n b^n}$ pour $n ≥ 1$, sur $Σ = {a,b}$ : si
          $ ⋂_(n=1)^∞ L_n = Σ^* ∖ {a^n b^n | n ≥ 1} $
          était régulier, son complémentaire ${a^n b^n | n ≥ 1}$ le serait aussi.
        ]
]
