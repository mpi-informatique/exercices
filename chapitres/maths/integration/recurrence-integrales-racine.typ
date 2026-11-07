#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Une famille d'intégrales sans primitive à chercher",
    chapitres: ("integration-sur-un-intervalle-quelconque",),
    matiere: "mathématiques",
    niveaux: ("MP",),
    difficulte: 3,
  ),
)[
  Pour $n ∈ NN$, on pose $I_n = ∫_0^1 (1 - t)^n / sqrt(t) dif t$.

  #question[Justifier la convergence de $I_n$ et calculer $I_0$.][L'intégrande est positive, continue sur $]0, 1]$ et équivalente à $1 / sqrt(t)$ en $0$.
    Cette intégrale de référence converge. Ainsi $I_n$ existe et $I_0 = [2 sqrt(t)]_0^1 = 2$.]

  #question[Pour $n ≥ 1$, trouver par intégration par parties une relation entre $I_n$ et $I_(n - 1)$.
    En déduire $I_1$ et $I_2$.

    _Indication :_ prendre $2 sqrt(t)$ pour primitive de $1 / sqrt(t)$.][Sur $[ε, 1]$, intégrer par parties puis faire tendre $ε$ vers $0$.
    Le terme de bord $2 sqrt(ε)(1 - ε)^n$ tend vers $0$, donc
    $ I_n = 2n ∫_0^1 sqrt(t)(1 - t)^(n - 1) dif t = 2n(I_(n - 1) - I_n). $
    La dernière égalité utilise $t = 1 - (1 - t)$ et la linéarité d'intégrales convergentes.
    Ainsi $(2n + 1)I_n = 2n I_(n - 1)$, d'où $I_1 = 4 / 3$ et $I_2 = 16 / 15$.]

  #question[Montrer que $I_n → 0$, sans utiliser de formule explicite pour $I_n$.

    _Indication :_ couper l'intégrale en un point $δ ∈ ]0, 1[$ et majorer séparément les deux morceaux.][Pour tout $δ ∈ ]0, 1[$,
    $ 0 ≤ I_n ≤ ∫_0^δ 1 / sqrt(t) dif t + (1 - δ)^n ∫_δ^1 1 / sqrt(t) dif t ≤ 2 sqrt(δ) + 2(1 - δ)^n. $
    Pour $η > 0$, choisir d'abord $δ$ tel que $2 sqrt(δ) < η / 2$, puis $n$ assez grand pour que $2(1 - δ)^n < η / 2$.
    Alors $0 ≤ I_n < η$, ce qui prouve la limite.]
]
