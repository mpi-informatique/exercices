#import "/load.typ": exercice, feuille, question

#let sujet = exercice(
  meta: (titre: "Titre du TP", chapitres: ("automates-finis",), langages: ("OCaml",), niveaux: ("MPI",), difficulte: 2),
  contenu: (
    question([Compléter le fichier fourni.], solution: [Solution.]),
  ),
)

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
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
