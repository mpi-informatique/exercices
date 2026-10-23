#import "/load.typ": exercice, feuille, question

#let sujet = exercice(
  meta: (titre: "Titre du TP", chapitres: ("automates-finis",), langages: ("OCaml",), niveaux: ("MPI",), difficulte: 2),
  contenu: (
    question([Compléter le fichier fourni.], solution: [Solution.]),
  ),
)

// Placer les fichiers et tp.json dans un dossier portant le nom du .typ sans extension.
#show: feuille.with(
  type: "tp",
  titre: "Titre du TP",
  niveau: "MPI",
  exercices: (sujet,),
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
