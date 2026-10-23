#import "/load.typ": feuille
#import "/chapitres/langages/exercices/miroir-langage-non-contextuel.typ": ex as miroir
#import "/chapitres/langages/exercices/construire-grammaires.typ": ex as construire
#import "/chapitres/langages/exercices/langages-engendres-grammaires.typ": ex as langages
#import "/chapitres/langages/exercices/pompage-intersection-complementaire.typ": ex as pompage
#import "/chapitres/langages/exercices/ambiguite-grammaire-reguliere.typ": ex as ambiguite
#import "/chapitres/langages/exercices/forme-normale-chomsky.typ": ex as chomsky
#import "/chapitres/langages/exercices/dyck-grammaires-denombrement.typ": ex as dyck

#let sujet = (
  titre: "TD : Grammaires",
  exercices: (miroir, construire, langages, pompage, ambiguite, chomsky, dyck),
  bareme: none,
)

#show: feuille.with(
  type: "td",
  titre: sujet.titre,
  niveau: "MPI",
  auteur: "Q. Fortier",
  exercices: sujet.exercices,
  bareme: sujet.bareme,
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
