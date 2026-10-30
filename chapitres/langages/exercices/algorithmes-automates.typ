#import "/load.typ": automate
#import automate: LA
#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Algorithmes sur les automates",
    chapitres: ("automates-finis", "langages-reguliers"),
    algorithmes: ("parcours-en-profondeur", "parcours-en-largeur", "determinisation"),
    structures: ("graphe",),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
  contenu: (
    [Soit $A = (Sigma, Q, I, F, E)$ un automate à $n = |Q|$ états et $p = |E|$ transitions. \
      Décrire un algorithme pour résoudre chacun des problèmes suivants en précisant représentation et complexité.],
    question(
      [
        #grid(
          columns: (1fr, 1fr),
          column-gutter: 1.5em,
          align: top,
          [
            + $LA = emptyset$ ?
            + Plus petit mot de $LA$ ?
          ],
          [
            #set enum(start: 3)
            + $LA$ fini ?
            + Pour deux automates $A_1, A_2$ : $cal(L)(A_1) = cal(L)(A_2)$ ?
          ],
        )
      ],
      solution: [
        + Il est vide si et seulement s'il n'existe aucun chemin de $I$ vers $F$.
          Faire un parcours (profondeur ou largeur) depuis $I$ et tester si un état final est atteint.
          Avec une représentation par liste d'adjacence, chaque état est visité au plus une fois et chaque transition examinée au plus une fois : temps $O(n + p)$, espace auxiliaire $O(n)$.
        + Faire un parcours en largeur depuis $I$ et mémoriser pour chaque état visité le mot le plus court pour l'atteindre. Le plus petit mot de $LA$ est le plus court parmi ceux menant à un état final.
        + $LA$ est infini exactement lorsqu'il existe un cycle accessible et coaccessible.

          Émonder $A$ puis réaliser un parcours en profondeur depuis $I$ : $A$ possède un cycle orienté si et seulement si un arc arrière (revenant sur un sommet en cours d'appel récursif) est trouvé.
          Avec une représentation par liste d'adjacence, le temps et l'espace total, émondage compris, sont $O(n + p)$.
        + - Déterminiser et compléter les automates : $O(|Sigma| 2^(n_1))$ + $O(|Sigma| 2^(n_2))$.
          - Construire l'automate produit $A_1 times A_2$ pour reconnaître la différence symétrique $L_1 Delta L_2 = L_1 union L_2 \\ L_1 inter L_2$ (avec $F = F_1 times (Q_2 \\ F_2) union (Q_1 \\ F_1) times F_2$) : $O(n_1 n_2)$.
          - Tester si $cal(L)(A_1 times A_2) = emptyset$ avec Q1 : $O(n_1 n_2 + p_1 p_2)$.
      ],
    ),
  ),
)
