#import "/load.typ": est-corrige
#import "/load.typ": feuille
#import "/templates/exercice.typ": ex

#show: feuille.with(
  type: "devoir",
  titre: "Devoir",
  niveau: "MPI",
  duree: (4, 0),
  // concours: (nom: "ENS", annee: 2019, filiere: "MPI", oral: false),
  exercices: (ex,),
  corrige: est-corrige(),
  nouvelle-page: false,
)
