#import "/load.typ": est-corrige
#import "/load.typ": feuille
#import "/chapitres/langages/exercices/construire-grammaires.typ": ex as construire
#import "/chapitres/langages/exercices/langages-engendres-grammaires.typ": ex as langages
#import "/chapitres/langages/exercices/forme-normale-chomsky.typ": ex as chomsky
#import "/chapitres/langages/exercices/intersection-grammaire-ogden.typ": ex as intersections
#import "/chapitres/langages/exercices/automates-pile.typ": ex as pile
#import "/chapitres/langages/exercices/ambiguite-grammaire-reguliere.typ": ex as ambiguite
#import "/chapitres/langages/exercices/dyck-grammaires-denombrement.typ": ex as dyck

#let sujet = (
  titre: "TD : Grammaires",
  exercices: (construire, langages, chomsky, intersections, pile, dyck),
  bareme: none,
)

#show: feuille.with(
  type: "td",
  titre: sujet.titre,
  niveau: "MPI",
  auteur: "Q. Fortier",
  exercices: sujet.exercices,
  bareme: sujet.bareme,
  corrige: est-corrige(),
)
