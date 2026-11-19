#import "/load.typ": automate, exercice, question
#import automate: dessiner-automate

#let ex = exercice(meta: (titre: "Automates de valuations et ordre des variables", chapitres: ("logique", "automates-finis"), difficulte: 3, niveaux: ("MPI",)))[
  On fixe un ordre $x_1, …, x_n$ sur les variables d'une formule $φ$. À une valuation $v$, on associe le mot $v(x_1) … v(x_n)$ sur ${0, 1}$. Un _automate de valuations_ reconnaît exactement les mots de taille $n$ associés aux modèles de $φ$.

  #question[
        Construire un automate déterministe de valuations pour $φ = (x_1 ∧ x_3) ∨ x_2$, dans l'ordre $x_1, x_2, x_3$. Les transitions peuvent être partielles.
      ][
        #dessiner-automate(
          (("q_0", (0, 0), true, false), ("a", (2.5, 1), false, false), ("b", (2.5, -1), false, false),
            ("c", (5, 1), false, false), ("d", (5, -1), false, false), ("f", (7.5, 0), false, true)),
          (("q_0", "a", "0", (:)), ("q_0", "b", "1", (:)),
            ("a", "c", "1", (:)), ("b", "c", "1", (:)), ("b", "d", "0", (:)),
            ("c", "f", "0, 1", (:)), ("d", "f", "1", (:))),
        )
        L'état $c$ signifie que la formule est déjà vraie et qu'il reste une lettre à lire. L'état $d$ impose que cette dernière lettre soit $1$. Aucun mot de taille différente de $3$ n'est accepté.
      ]

  #question[
        Pour $k ≥ 1$, poser $L_k = {u u ∣ u ∈ {0, 1}^k}$. Montrer que tout automate reconnaissant $L_k$, même non déterministe, possède au moins $2^k$ états. Choisir un calcul acceptant pour chaque mot $u u$ et considérer l'état atteint après la première copie de $u$.
      ][
        Pour chaque $u$, choisir cet état $q_u$. Si $q_u = q_v$ avec $u ≠ v$, le début du calcul de $u u$ jusqu'à cet état suivi de la fin du calcul de $v v$ accepterait $u v$, qui n'appartient pas à $L_k$.
        Les $2^k$ mots $u$ fournissent donc $2^k$ états distincts.
      ]

  #question[
        Construire une formule $Φ_k$ de taille $O(k)$ dont tout automate de valuations, pour l'ordre $x_1, …, x_k, y_1, …, y_k$, a au moins $2^k$ états. Peut-on toujours construire un automate de valuations de taille polynomiale en la taille de la formule ?
      ][
        Prendre $Φ_k = and.big_(i=1)^k (x_i ↔ y_i)$. Sa taille est $O(k)$, même en développant $↔$. Les mots de ses modèles sont exactement les mots de $L_k$.
        La sortie à matérialiser peut donc avoir une taille exponentielle en celle de la formule. Une construction de taille polynomiale n'est pas toujours possible, même si tous ces langages sont finis et donc réguliers.
      ]

  #question[
        Reprendre $Φ_k$ avec l'ordre $x_1, y_1, x_2, y_2, …, x_k, y_k$. Donner une expression régulière du langage des modèles, puis un automate déterministe de taille $O(k)$.
      ][
        Le langage est $cal(L)((0 0 | 1 1)^k)$. Chaîner $k$ fois le motif suivant, avec $q_0$ initial et $q_k$ seul final :
        #dessiner-automate(
          (("q_(i - 1)", (0, 0), false, false), ("r_i^0", (2.5, 1), false, false),
            ("r_i^1", (2.5, -1), false, false), ("q_i", (5, 0), false, false)),
          (("q_(i - 1)", "r_i^0", "0", (:)), ("q_(i - 1)", "r_i^1", "1", (:)),
            ("r_i^0", "q_i", "0", (:)), ("r_i^1", "q_i", "1", (:))),
        )
        L'automate partiel a $3k + 1$ états. Le compléter demande un seul état puits supplémentaire. L'ordre des variables peut donc changer une taille exponentielle en une taille linéaire.
      ]
]
