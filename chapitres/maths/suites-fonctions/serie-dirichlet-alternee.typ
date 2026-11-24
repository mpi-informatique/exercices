#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Fonction êta de Dirichlet",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 4,
))[
  Pour $x > 0$, on pose $η(x) = ∑_(n = 1)^(+∞) (-1)^(n - 1) / n^x$.

  #question[Montrer que $η$ est définie et de classe $C^∞$ sur $]0, +∞[$.][Pour chaque $x > 0$, la suite $(1 / n^x)_(n ≥ 1)$ est positive, décroissante et tend vers $0$. Le critère spécial des séries alternées (CSSA) assure la convergence simple sur $]0, +∞[$.

    Chaque terme $u_n : x ⟼ (-1)^(n - 1) n^(-x)$ est de classe $C^∞$ sur $]0, +∞[$, avec $u_n^((k)) (x) = (-1)^(n - 1 + k) (ln n)^k / n^x$ pour tout $k ∈ NN$.
    Fixons $k ∈ NN$ et $a > 0$. Pour $k ≥ 1$, la fonction $t ⟼ (ln t)^k / t^x$ a pour dérivée $(ln t)^(k - 1) (k - x ln t) / t^(x + 1)$, qui est négative dès que $t ≥ e^(k / x)$. En posant $N_0 = ceil(e^(k / a))$ (et $N_0 = 1$ si $k = 0$), la suite $((ln n)^k / n^x)_(n ≥ N_0)$ est positive, décroissante et tend vers $0$ pour tout $x ∈ [a, +∞[$.

    Le CSSA majore alors le reste après le rang $N ≥ N_0$ uniformément sur $[a, +∞[$ :
    $ abs(∑_(n = N + 1)^(+∞) u_n^((k)) (x)) ≤ (ln(N + 1))^k / (N + 1)^x ≤ (ln(N + 1))^k / (N + 1)^a ⟶ 0. $
    La série $∑ u_n^((k))$ converge donc uniformément sur tout intervalle $[a, +∞[$ avec $a > 0$ (bien qu'elle ne converge pas normalement lorsque $a ≤ 1$). Le théorème de dérivation terme à terme montre par récurrence que $η$ est de classe $C^∞$ sur $]0, +∞[$.]

  #question[Pour $x > 1$, exprimer $η(x)$ en fonction de $ζ(x) = ∑_(n = 1)^(+∞) 1 / n^x$. En déduire un équivalent de $ζ(x)$ lorsque $x ⟶ 1^+$, puis la valeur de $η(1)$.][Pour $x > 1$, la série de Riemann $∑_(n ≥ 1) 1 / n^x$ converge. Pour tout $N ≥ 1$, en séparant les indices impairs et pairs dans les sommes partielles d'ordre $2 N$, on a
    $
      ∑_(n = 1)^(2 N) (-1)^(n - 1) / n^x &= ∑_(k = 0)^(N - 1) 1 / (2 k + 1)^x - ∑_(k = 1)^N 1 / (2 k)^x, \
      ∑_(n = 1)^(2 N) 1 / n^x &= ∑_(k = 0)^(N - 1) 1 / (2 k + 1)^x + ∑_(k = 1)^N 1 / (2 k)^x.
    $
    En soustrayant la seconde égalité à la première, on obtient
    $
      ∑_(n = 1)^(2 N) (-1)^(n - 1) / n^x
      = ∑_(n = 1)^(2 N) 1 / n^x - 2 ∑_(k = 1)^N 1 / (2 k)^x
      = ∑_(n = 1)^(2 N) 1 / n^x - 2 / 2^x ∑_(k = 1)^N 1 / k^x.
    $
    Les deux séries $∑ (-1)^(n - 1) / n^x$ et $∑ 1 / n^x$ étant convergentes pour $x > 1$, le passage à la limite lorsque $N ⟶ +∞$ donne
    $ η(x) = ζ(x) - 2^(1 - x) ζ(x) = (1 - 2^(1 - x)) ζ(x). $
    La fonction $t ⟼ t^(-x)$ étant décroissante sur $[1, +∞[$, une comparaison série-intégrale donne
    $ 1 / (x - 1) = ∫_1^(+∞) t^(-x) dif t ≤ ζ(x) ≤ 1 + ∫_1^(+∞) t^(-x) dif t = 1 + 1 / (x - 1). $
    Ainsi $ζ(x) ∼ 1 / (x - 1)$ lorsque $x ⟶ 1^+$. Comme $1 - 2^(1 - x) = 1 - e^(-(x - 1) ln 2) ∼ (x - 1) ln 2$ en $1^+$, il vient $η(x) ⟶ ln 2$ lorsque $x ⟶ 1^+$. Par continuité de $η$ en $1$, on obtient $η(1) = ln 2$.]

  #question[Montrer que pour tout $x > 0$,
    $ 2 η(x) = 1 + ∑_(n = 1)^(+∞) (-1)^(n - 1) (1 / n^x - 1 / (n + 1)^x), $
    puis déterminer la limite de $η(x)$ lorsque $x ⟶ 0^+$.][Pour $N ≥ 1$, en notant $S_N (x) = ∑_(n = 1)^N (-1)^(n - 1) / n^x$, on vérifie par regroupement des termes consécutifs que
    $ 2 S_N (x) = 1 + ∑_(n = 1)^(N - 1) (-1)^(n - 1) (1 / n^x - 1 / (n + 1)^x) + (-1)^(N - 1) / N^x. $
    Comme $1 / N^x ⟶ 0$ quand $N ⟶ +∞$, on obtient l'identité annoncée.

    Pour $x ∈ ]0, 1]$ et $n ≥ 1$, posons $a_n (x) = 1 / n^x - 1 / (n + 1)^x = x ∫_n^(n + 1) t^(-x - 1) dif t$. Par décroissance de $t ⟼ t^(-x - 1)$, la suite $(a_n (x))_(n ≥ 1)$ est positive, décroissante et tend vers $0$. De plus, pour tout $x ∈ ]0, 1]$,
    $ 0 ≤ a_n (x) ≤ x / n^(x + 1) ≤ 1 / n. $
    Le CSSA majore donc le reste après le rang $N$ par $a_(N + 1) (x) ≤ 1 / (N + 1)$ uniformément sur $]0, 1]$. La série $∑ (-1)^(n - 1) a_n$ converge uniformément sur $]0, 1]$.

    Chaque terme $(-1)^(n - 1) a_n (x)$ tend vers $0$ lorsque $x ⟶ 0^+$. Le théorème de la double limite donne $lim_(x ⟶ 0^+) (2 η(x) - 1) = 0$, c'est-à-dire $lim_(x ⟶ 0^+) η(x) = 1 / 2$.]
]
