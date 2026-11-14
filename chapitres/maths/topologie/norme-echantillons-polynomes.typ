#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Mesurer un polynôme par ses valeurs",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 1,
))[
  Pour un polynôme réel $P$, poser $N(P) = abs(P(0)) + abs(P(1))$.

  #question[Montrer que $N$ définit une norme sur $RR_1 [X]$. Est-ce encore vrai sur $RR_2 [X]$ ?][L'homogénéité et l'inégalité triangulaire proviennent de la valeur absolue.
    Sur $RR_1 [X]$, si $N(P) = 0$ alors $P$ a deux racines distinctes et est de degré au plus $1$, donc est nul.
    Sur $RR_2 [X]$, $P = X(X - 1)$ est non nul et vérifie $N(P) = 0$ : ce n'est plus une norme.]

  #question[Fixer $m ≥ 1$. Quel est le plus petit nombre de points réels distincts $a_1, …, a_r$ qui assure que $P ⟼ ∑_(j = 1)^r abs(P(a_j))$ soit une norme sur $RR_m [X]$ ?][Il faut et il suffit de prendre $r ≥ m + 1$.
    Avec au moins $m + 1$ points, la nullité de toutes les valeurs impose $P = 0$ par le nombre de racines.
    Avec $r ≤ m$ points, le polynôme non nul $∏_(j = 1)^r (X - a_j)$ appartient à $RR_m [X]$ et annule toutes les valeurs mesurées.]
]
