#import "/load.typ": est-corrige
#import "/load.typ": exercice, feuille, partie, question

#let ex = exercice(
  meta: (
      titre: "Titre du sujet de concours",
      chapitres: ("langages-reguliers", "automates-finis"),
      difficulte: 2,
      niveaux: ("MPI",),
      duree: (4, 0),
      // concours: (nom: "ENS", annee: 2019, filiere: "MP", oral: false),
    ),
  // Corrections conservées dans les données, sans affichage. Remarques du jury en italique.
    corrections: none,
  // Exemple : [- Question 1 : ajouter l'hypothèse de finitude.]
    jury: none,
  notation: none,
)[
  Les réponses doivent être justifiées.
  On fixe un alphabet $Σ$.

  #partie(
    "Langages",
    jury: none,
  )[
    #partie(
      "Langages finis",
      contexte: ([On fixe un alphabet $Σ$.],),
    )[
      #question(
        jury: none,
        bareme: none,
        notation: none,
      )[Montrer qu'un langage fini sur $Σ$ est régulier.][Un mot est décrit par la concaténation de ses lettres
                    (par $ε$ pour le mot vide).
                    Une union finie de telles expressions décrit tout langage fini ; $∅$ décrit le langage vide.]
    ]

    #partie(
      "Miroir",
      contexte: ([On fixe un alphabet $Σ$.],),
    )[
      #question[Le miroir d'un langage fini est-il régulier ?][Il est fini, donc régulier.]
    ]
  ]
]

#show: feuille.with(
  type: "devoir", // Un concours est un devoir avec une attribution.
  titre: ex.meta.titre,
  niveau: ex.meta.niveaux.join(" / "),
  concours: ex.meta.concours,
  exercices: (ex,),
  corrige: est-corrige(),
)
