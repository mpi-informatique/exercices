#import "/load.typ": pause, presentation
#import "/load.typ": theoremes
#import theoremes: algorithme, definition, exemple, exercice, theoreme

#show: presentation.with(titre: "Titre de la présentation", niveau: "MPI")

= Première section

== Notion

#definition[
  Définir la notion et ses notations.
]
#pause
#theoreme[
  Énoncer le résultat et ses hypothèses.
]

== Application

#exercice[
  Proposer une application courte du résultat précédent.
]
#pause
#exemple[
  Révéler un exemple ou une indication.
]

== Algorithme

#algorithme[
  Présenter les entrées, la sortie et les étapes de l'algorithme.
]
