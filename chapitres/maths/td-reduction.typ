#import "/load.typ": est-corrige
#import "/load.typ": feuille
#import "reduction/spectre-endomorphisme-suites.typ": ex as ex1
#import "reduction/commutation-stabilite-sous-espaces-propres.typ": ex as ex2
#import "reduction/puissances-matrice-trois-diagonalisable.typ": ex as ex3
#import "reduction/nilpotence-commutateur.typ": ex as ex4
#import "reduction/diagonalisation-simultanee.typ": ex as ex5
#import "reduction/diagonalisabilite-rang-un-trace.typ": ex as ex6

#show: feuille.with(
  type: "td",
  titre: "Réduction",
  niveau: "MP",
  exercices: (ex1, ex2, ex3, ex4, ex5, ex6),
  corrige: est-corrige(),
  nouvelle-page: false,
)
