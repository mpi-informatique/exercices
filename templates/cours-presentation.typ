#import "/load.typ": article-only, cours-et-presentation, pause, slides-only, solution
#import "/load.typ": theoremes
#import theoremes: definition, exercice, theoreme

#show: cours-et-presentation.with(titre: "Titre du cours", niveau: "MPI")

= Première section

== Notion

#definition[
  Le contenu est rédigé une seule fois pour les deux formats.
]
#pause
#theoreme[
  Les pauses disparaissent dans le cours A4.
]

== Application

#exercice[
  Appliquer le résultat précédent.
]
#slides-only[
  #pause
  Indication à révéler pendant la présentation.
]

#solution[
  Justifier les étapes de la résolution.
]
