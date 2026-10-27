#import "/load.typ": est-corrige
#import "/load.typ": feuille
#import "/chapitres/langages/exercices/langages-locaux-glushkov.typ": ex as locaux
#import "/devoirs/concours/oral/ccinp/ccinp-oral-langages-automates.typ": ex as ccp
#import "/chapitres/langages/exercices/stabilite-langages-reguliers.typ": ex as stabilite
#import "/chapitres/langages/exercices/mcnaughton-yamada/mcnaughton-yamada.typ": ex as dynamique

#show: feuille.with(
  titre: "TD : Théorème de Kleene",
  niveau: "MPI",
  auteur: "Q. Fortier",
  exercices: (locaux, ccp, stabilite, dynamique),
  corrige: est-corrige(defaut: true),
)
