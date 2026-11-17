#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "L'équivalence des normes dépend du degré",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[
  Pour $P ∈ RR[X]$, on pose $N_1 (P) = ∫_0^1 abs(P(t)) dif t$ et $N_∞ (P) = max_(t ∈ [0, 1]) abs(P(t))$.

  #question[Montrer que $N_1$ et $N_∞$ sont des normes sur $RR[X]$ et que $N_1 (P) ≤ N_∞ (P)$.][La positivité, l'homogénéité et les inégalités triangulaires résultent de celles de la valeur absolue.
    Si $N_1 (P) = 0$, la fonction continue positive $abs(P)$ est nulle sur $[0, 1]$. Le polynôme $P$ possède alors une infinité de racines et est nul. Il en va de même si $N_∞ (P) = 0$.
    Enfin, intégrer $abs(P(t)) ≤ N_∞ (P)$ sur un intervalle de longueur $1$ donne $N_1 (P) ≤ N_∞ (P)$.]

  #question[On fixe un entier $m ≥ 1$. Justifier l'existence d'une constante $C_m > 0$ telle que $N_∞ (P) ≤ C_m N_1 (P)$ pour tout $P ∈ RR_m [X]$. En déduire un contrôle de $abs(P(0))$ par $N_1 (P)$.][Les restrictions de $N_1$ et $N_∞$ à $RR_m [X]$ sont des normes sur un espace de dimension finie. Elles sont donc équivalentes, ce qui fournit $C_m$.
    En particulier, $abs(P(0)) ≤ N_∞ (P) ≤ C_m N_1 (P)$.]

  #question[Peut-on choisir une même constante pour tous les degrés ? Obtenir aussi une minoration de toute constante $C_m$ possible.
    #linebreak()
    _Indication : chercher un polynôme égal à $1$ en $0$ et de plus en plus petit sur $]0, 1]$ quand son degré augmente._][Pour $P_m (X) = (1 - X)^m$, on a $N_∞ (P_m) = 1$ et
    $ N_1 (P_m) = ∫_0^1 (1 - t)^m dif t = 1 / (m + 1). $
    L'inégalité de la question précédente impose donc $C_m ≥ m + 1$.
    Aucune constante indépendante du degré n'est possible. Les normes $N_1$ et $N_∞$ ne sont donc pas équivalentes sur $RR[X]$, bien qu'elles le soient sur chaque $RR_m [X]$.]
]
