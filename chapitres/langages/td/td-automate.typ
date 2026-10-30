#import "/load.typ": est-corrige
#import "/load.typ": automate
#import automate: dessiner-automate, rayon-grand-etat
#import "/load.typ": exercice, feuille, question
#import "/chapitres/langages/exercices/cloture-miroir-prefixes-suffixes-facteurs.typ": ex as cloture
#import "/chapitres/langages/exercices/reconnaissable-ou-non.typ": ex as reconnaissable
#import "/chapitres/langages/exercices/reciproque-lemme-etoile.typ": ex as reciproque-etoile
#import "/chapitres/langages/exercices/algorithmes-automates.typ": ex as algorithmes
#import "/chapitres/langages/exercices/longueur-discriminante-automates.typ": ex as taille
#import "/chapitres/langages/exercices/residuels-minimisation.typ": ex as myhill-nerode, introduction, ensembles-distinguants
#import "/devoirs/concours/oral/ens/ens-oral-mp-automates-palindromes.typ": ex as palindromes

#let determinisation = exercice(
  meta: (
    titre: "Algorithme de déterminisation",
    chapitres: ("automates-finis", "langages-reguliers"),
    algorithmes: ("determinisation",),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
  contenu: (
    question(
      [
        Déterminiser l'automate suivant en utilisant l'algorithme du cours :
        #dessiner-automate(
          (("1", (0, 0), true, false), ("2", (3, 0), false, true), ("3", (0, -2.5), false, false), ("4", (3, -2.5), false, false)),
          (
            ("1", "2", "a", (:)),
            ("1", "3", "a", (:)),
            ("2", "4", "a", (:)),
            ("3", "4", "b", (:)),
            ("4", "1", "b", (inverser: true)),
            ("4", "4", "b", (anchor: right)),
          ),
        )
      ],
      solution: [
        L'état initial est ${1}$ ; les états finaux sont les ensembles contenant $2$.
        Pour chaque ensemble $X$, la transition sur $c$ mène à $⋃_(q∈X)δ(q,c)$.
        Les seuls ensembles accessibles sont ${1}$, ${2,3}$, ${4}$, ${1,4}$ et $∅$ :
        #dessiner-automate(
          (
            ("{1}", (0, 0), true, false),
            ("{2, 3}", (3, 0), false, true),
            ("{4}", (6, 0), false, false),
            ("{1, 4}", (9, 0), false, false),
            ("∅", (3, -3), false, false),
          ),
          (
            ("{1}", "{2, 3}", "a", (:)),
            ("{1}", "∅", "b", (:)),
            ("{2, 3}", "{4}", "a, b", (:)),
            ("{4}", "∅", "a", (:)),
            ("{4}", "{1, 4}", "b", (:)),
            ("{1, 4}", "{2, 3}", "a", (curve: -2.2)),
            ("{1, 4}", "{1, 4}", "b", (anchor: right)),
            ("∅", "∅", "a, b", (anchor: bottom)),
          ),
          rayon: nom => rayon-grand-etat,
        )
      ],
    ),
  ),
)

#let distinguant = exercice(
  meta: (..myhill-nerode.meta, titre: "Ensembles distinguants"),
  contenu: (introduction, ensembles-distinguants),
)

#show: feuille.with(
  titre: "TD : Automates",
  niveau: "MPI",
  auteur: "Q. Fortier",
  exercices: (determinisation, cloture, reconnaissable, reciproque-etoile, algorithmes, taille, distinguant, palindromes),
  corrige: est-corrige(),
)
