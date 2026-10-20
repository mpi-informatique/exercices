#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Titre de l'exercice",
    chapitres: ("graphes",), // doivent apparaître dans lib/meta.typ
    algorithmes: ("parcours-en-profondeur",), // doivent apparaître dans lib/meta.typ
    structures: ("graphe",), // doivent apparaître dans lib/meta.typ
    difficulte: 2, // Entre 1 et 5, 1 étant le plus facile
    niveaux: ("MPI",),
    duree: (0, 20), // (Heures, minutes) ; none si non estimée.
    // concours: (nom: "ENS", annee: 2019, filiere: "MP", oral: true),
    // Les champs supplémentaires (auteur, mots-clés…) sont libres.
  ),
  contenu: (
    [On considère un graphe orienté fini $G = (S, A)$.],
    question(
      [Proposer un algorithme qui détecte un cycle dans $G$.],
      solution: [Effectuer un parcours en profondeur avec trois couleurs.
        Une arête vers un sommet gris révèle un cycle.
        La complexité est $O(abs(S) + abs(A))$ avec des listes d'adjacence.],
    ),
    [On suppose désormais que le graphe est représenté par des listes d'adjacence.],
    question(
      [Quel est l'espace auxiliaire utilisé par cet algorithme ?],
      solution: [Les couleurs et la pile du parcours occupent $O(abs(S))$ cases.],
    ),
    [Préciser toujours si le stockage du graphe est compté dans l'espace annoncé.],
  ),
)
