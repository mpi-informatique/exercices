#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Fonction de Takagi",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 5,
))[
  Pour tout réel $t$, on note $d(t) = inf_(k ∈ ZZ) abs(t - k)$ la distance de $t$ à $ZZ$, et on pose $f(x) = ∑_(n = 0)^(+∞) d(2^n x) / 2^n$ pour $x ∈ RR$.

  #question[Montrer que $f$ est définie, continue et $1$-périodique sur $RR$.][La fonction $d$ est $1$-périodique, continue (elle est $1$-lipschitzienne) et vérifie $0 ≤ d(t) ≤ 1 / 2$ pour tout $t ∈ RR$. Pour tout $n ∈ NN$ et tout $x ∈ RR$, on a donc
    $ 0 ≤ d(2^n x) / 2^n ≤ 1 / 2^(n + 1). $
    La série converge normalement sur $RR$. Chaque terme $x ⟼ d(2^n x) / 2^n$ étant continu et $1$-périodique, la somme $f$ est continue et $1$-périodique sur $RR$.]

  #question[Montrer que $f(x) = d(x) + 1 / 2 f(2 x)$ pour tout $x ∈ RR$, et calculer $∫_0^1 f(x) dif x$.][En isolant le terme $n = 0$ puis en posant $m = n - 1$, on obtient
    $ f(x) = d(x) + ∑_(m = 0)^(+∞) d(2^(m + 1) x) / 2^(m + 1) = d(x) + 1 / 2 f(2 x). $
    Par convergence uniforme sur $[0, 1]$ de fonctions continues, on peut intégrer terme à terme :
    $ ∫_0^1 f(x) dif x = ∑_(n = 0)^(+∞) 1 / 2^n ∫_0^1 d(2^n x) dif x. $
    Le changement de variable $u = 2^n x$ et la $1$-périodicité de $d$ donnent $∫_0^1 d(2^n x) dif x = 1 / 2^n ∫_0^(2^n) d(u) dif u = ∫_0^1 d(u) dif u = 1 / 4$. Ainsi
    $ ∫_0^1 f(x) dif x = 1 / 4 ∑_(n = 0)^(+∞) 1 / 2^n = 1 / 2. $
    On retrouve aussi ce résultat en intégrant directement l'équation fonctionnelle sur $[0, 1]$.]

  #question[Fixons $x ∈ RR$. Pour tout $k ∈ NN$, on pose $m_k = floor(2^k x)$, $a_k = m_k / 2^k$ et $b_k = (m_k + 1) / 2^k$. Montrer que
    $
      (f(b_k) - f(a_k)) / (b_k - a_k) = ∑_(n = 0)^(k - 1) (-1)^(floor(2^(n + 1) x)).
    $][On a $b_k - a_k = 2^(-k)$ et $a_k ≤ x < b_k$. Pour tout $n ≥ k$, les nombres $2^n a_k = 2^(n - k) m_k$ et $2^n b_k = 2^(n - k) (m_k + 1)$ sont entiers, donc $d(2^n a_k) = d(2^n b_k) = 0$.

    Fixons $0 ≤ n ≤ k - 1$ et posons $q = floor(2^(n + 1) x)$. Comme $q ≤ 2^(n + 1) x < q + 1$, en multipliant par l'entier $2^(k - n - 1)$ on obtient $q ⋅ 2^(k - n - 1) ≤ 2^k x < (q + 1) 2^(k - n - 1)$, d'où $q ⋅ 2^(k - n - 1) ≤ m_k < m_k + 1 ≤ (q + 1) 2^(k - n - 1)$. En divisant par $2^(k - n)$, il vient
    $ q / 2 ≤ 2^n a_k < 2^n b_k ≤ (q + 1) / 2. $
    Or sur $[q / 2, (q + 1) / 2]$, la fonction $d$ est affine de pente $+1$ si $q$ est pair et $-1$ si $q$ est impair, soit de pente $(-1)^q$. Par conséquent,
    $ (d(2^n b_k) - d(2^n a_k)) / (2^n (b_k - a_k)) = (-1)^q = (-1)^(floor(2^(n + 1) x)). $
    En sommant sur $n ∈ {0, …, k - 1}$, on obtient l'égalité annoncée.]

  #question[En déduire que $f$ n'est dérivable en aucun point de $RR$.][Supposons par l'absurde que $f$ soit dérivable en un point $x ∈ RR$, et notons $τ_k = (f(b_k) - f(a_k)) / (b_k - a_k)$. Fixons $ε > 0$. Il existe $δ > 0$ tel que, pour tout $y ∈ RR$ vérifiant $abs(y - x) ≤ δ$,
    $ abs(f(y) - f(x) - f'(x) (y - x)) ≤ ε abs(y - x). $
    Dès que $2^(-k) ≤ δ$, on a $0 ≤ x - a_k ≤ 2^(-k) ≤ δ$ et $0 < b_k - x ≤ 2^(-k) ≤ δ$. L'inégalité triangulaire donne alors
    $ abs(f(b_k) - f(a_k) - f'(x) (b_k - a_k)) ≤ ε (b_k - x) + ε (x - a_k) = ε (b_k - a_k), $
    soit $abs(τ_k - f'(x)) ≤ ε$. La suite $(τ_k)$ convergerait donc vers $f'(x)$.

    Or d'après la question précédente, $τ_(k + 1) - τ_k = (-1)^(floor(2^(k + 1) x)) ∈ {-1, 1}$, ce qui contredit $τ_(k + 1) - τ_k ⟶ 0$. Ainsi $f$ n'est dérivable en aucun point de $RR$.]
]
