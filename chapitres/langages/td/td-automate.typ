#import "/load.typ": est-corrige
#import "/load.typ": automate
#import automate: dist-lettre, rayon-etat, rayon-grand-etat, style-automates, unite-automates
#import "/load.typ": exercice, feuille, question
#import "@preview/finite:0.5.1" as finite
#import "@preview/cetz:0.4.2" as cetz
#import "/chapitres/langages/exercices/cloture-miroir-prefixes-suffixes-facteurs.typ": ex as cloture
#import "/chapitres/langages/exercices/reconnaissable-ou-non.typ": ex as reconnaissable
#import "/chapitres/langages/exercices/algorithmes-automates.typ": ex as algorithmes
#import "/chapitres/langages/exercices/longueur-discriminante-automates.typ": ex as taille
#import "/chapitres/langages/exercices/ensembles-distinguants-automates.typ": ex as distinguant
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
        #align(center, cetz.canvas(length: unite-automates, {
          import finite.draw: state, transition
          cetz.draw.set-style(..style-automates, state: (radius: rayon-etat))
          state((0, 0), "1", label: $1$, initial: (label: none))
          state((3, 0), "2", label: $2$, final: true)
          state((0, -2.5), "3", label: $3$)
          state((3, -2.5), "4", label: $4$)
          transition("1", "2", label: $a$, curve: 0)
          transition("1", "3", label: (text: $a$, dist: dist-lettre), curve: 0)
          transition("2", "4", label: $a$, curve: 0)
          transition("3", "4", label: (text: $b$, dist: dist-lettre), curve: 0)
          transition("4", "1", label: (text: $b$, dist: -dist-lettre), curve: 0)
          transition("4", "4", label: $b$, anchor: right)
        }))
      ],
      solution: [
        L'état initial est ${1}$ ; les états finaux sont les ensembles contenant $2$.
        Pour chaque ensemble $X$, la transition sur $c$ mène à $⋃_(q∈X)δ(q,c)$.
        Les seuls ensembles accessibles sont ${1}$, ${2,3}$, ${4}$, ${1,4}$ et $∅$ :
        #align(center, cetz.canvas(length: unite-automates, {
          import finite.draw: state, transition
          cetz.draw.set-style(..style-automates, state: (radius: rayon-grand-etat))
          state((0, 0), "1", label: ${1}$, initial: (label: none))
          state((3, 0), "23", label: ${2,3}$, final: true)
          state((6, 0), "4", label: ${4}$)
          state((9, 0), "14", label: ${1,4}$)
          state((3, -3), "vide", label: $∅$)
          transition("1", "23", label: $a$, curve: 0)
          transition("1", "vide", label: (text: $b$, dist: -dist-lettre), curve: 0)
          transition("23", "4", label: $a,b$, curve: 0)
          transition("4", "vide", label: $a$, curve: 0)
          transition("4", "14", label: $b$, curve: 0)
          transition("14", "23", label: (text: $a$, dist: -dist-lettre), curve: -2.2)
          transition("14", "14", label: $b$, anchor: right)
          transition("vide", "vide", label: $a,b$, anchor: bottom)
        }))
      ],
    ),
  ),
)

#show: feuille.with(
  titre: "TD : Automates",
  niveau: "MPI",
  auteur: "Q. Fortier",
  exercices: (determinisation, cloture, reconnaissable, algorithmes, taille, distinguant, palindromes),
  corrige: est-corrige(),
)
