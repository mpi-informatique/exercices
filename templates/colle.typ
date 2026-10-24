#import "/load.typ": est-corrige
#import "/load.typ": feuille, sujet-colle
#import "/templates/exercice.typ": ex

// Importer les exercices sous des alias, puis composer chaque sujet ci-dessous.
#let sujets = (
  (ex,), // Sujet 1
  (ex,), // Sujet 2
  (ex,), // Sujet 3
)
#let corrige = est-corrige()

#show: feuille.with(
  type: "colle",
  titre: "Colle 1",
  niveau: "MPI",
  exercices: sujets.flatten(),
  corrige: corrige,
  afficher-exercices: false,
)

#for (i, exercices) in sujets.enumerate(start: 1) {
  sujet-colle(i, exercices, corrige: corrige)
}
