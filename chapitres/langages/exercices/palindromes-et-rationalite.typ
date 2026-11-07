#import "/load.typ": exercice, donnees
#import "/devoirs/concours/22/centrale-2022-mp-informatique/centrale-2022-mp-informatique.typ": palindromes

#let partie-palindromes = donnees(palindromes)

// La partie est partagée avec le sujet ; seuls ses rappels sont ajoutés ici.
#let ex = exercice(meta: (..partie-palindromes.meta, titre: partie-palindromes.titre, niveaux: ("MPI", "MP")), partie-palindromes.contexte + partie-palindromes.contenu)
