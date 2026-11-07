#import "/load.typ": est-corrige
#import "/load.typ": exercice, feuille, question

#let sujet = exercice(meta: (titre: "Titre du TP", chapitres: ("automates-finis",), langages: ("OCaml",), niveaux: ("MPI",), difficulte: 2))[
  #question[Compléter le fichier fourni.][Solution.]
]

// Placer le .typ et ses fichiers associés dans un même dossier.
#show: feuille.with(
  type: "tp",
  titre: sujet.meta.titre,
  niveau: "MPI",
  exercices: (sujet,),
  tp: (
    ouvrir: "main.ml",
    squelette: ((source: "main.ml"),),
    corrige: ((source: "corrige.ml"),),
  ),
  corrige: est-corrige(),
)
