#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Intégration par convergence dominée des sommes partielles",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 4,
))[
  Pour $x ∈ RR$, on pose $F(x) = ∫_0^(+∞) cos(x t) / (e^t + 1) dif t$.

  #question[Justifier la définition de $F$ sur $RR$ et montrer que pour tout $x ∈ RR$,
    $ F(x) = ∑_(n = 1)^(+∞) ((-1)^(n - 1) n) / (n^2 + x^2). $
    _Indication : le théorème d'intégration terme à terme ne s'applique pas directement. Appliquer le théorème de convergence dominée aux sommes partielles._][La fonction $t ⟼ cos(x t) / (e^t + 1)$ est continue sur $[0, +∞[$ et dominée par $e^(-t)$, qui est intégrable sur $[0, +∞[$. Ainsi $F(x)$ est bien définie pour tout $x ∈ RR$.

    Pour tout $t > 0$, la somme géométrique donne $1 / (e^t + 1) = e^(-t) / (1 + e^(-t)) = ∑_(n = 1)^(+∞) (-1)^(n - 1) e^(-n t)$. En posant $u_n (t) = (-1)^(n - 1) e^(-n t) cos(x t)$, le théorème d'intégration terme à terme ne s'applique pas : comme $abs(cos(x t)) ≥ cos^2 (x t) = (1 + cos(2 x t)) / 2$, on a
    $ ∫_0^(+∞) abs(u_n (t)) dif t ≥ 1 / (2 n) + n / (2 (n^2 + 4 x^2)) ≥ 1 / (2 n), $
    dont la série diverge.

    Considérons plutôt les sommes partielles $S_N (t) = ∑_(n = 1)^N u_n (t) = e^(-t) (1 - (-e^(-t))^N) / (1 + e^(-t)) cos(x t)$. Pour tout $t > 0$, $S_N (t) ⟶ cos(x t) / (e^t + 1)$, et pour tout $N ≥ 1$ et tout $t ≥ 0$,
    $ abs(S_N (t)) ≤ (1 + e^(-N t)) e^(-t) / (1 + e^(-t)) ≤ 2 e^(-t), $
    fonction intégrable sur $[0, +∞[$ indépendante de $N$. Le théorème de convergence dominée donne alors
    $ F(x) = lim_(N ⟶ +∞) ∑_(n = 1)^N (-1)^(n - 1) ∫_0^(+∞) e^(-n t) cos(x t) dif t. $
    Or $∫_0^(+∞) e^(-n t) cos(x t) dif t = Re(∫_0^(+∞) e^(-(n - i x) t) dif t) = Re(1 / (n - i x)) = n / (n^2 + x^2)$, d'où l'égalité.]

  #question[Étudier la convergence normale, puis la convergence uniforme sur $RR$ de la série obtenue.][Notons $v_n (x) = (-1)^(n - 1) a_n (x)$ avec $a_n (x) = n / (n^2 + x^2)$. Comme $abs(v_n (0)) = 1 / n$, on a $norm(v_n)_∞ ≥ 1 / n$, dont la série diverge : la convergence n'est pas normale sur $RR$.

    Montrons la convergence uniforme sur $RR$. Par parité, il suffit de majorer le reste $R_N (x) = ∑_(n = N + 1)^(+∞) (-1)^(n - 1) a_n (x)$ pour $x ≥ 0$. La fonction $t ⟼ t / (t^2 + x^2)$ croît sur $[0, x]$, décroît sur $[x, +∞[$ et vérifie $a_n (x) ≤ 1 / (2 x)$ pour $x > 0$ (car $n^2 + x^2 ≥ 2 n x$).

    Si $0 ≤ x ≤ N$, la suite $(a_n (x))_(n ≥ N + 1)$ est positive, décroissante et tend vers $0$. Le critère spécial des séries alternées donne $abs(R_N (x)) ≤ a_(N + 1) (x) ≤ 1 / (N + 1) < 1 / N$.

    Si $x > N$, posons $M = floor(x) ≥ N$ et découpons le reste en
    $ R_N (x) = ∑_(n = N + 1)^M (-1)^(n - 1) a_n (x) + ∑_(n = M + 1)^(+∞) (-1)^(n - 1) a_n (x). $
    Dans la première somme (vide si $M = N$), les termes $a_n (x)$ sont positifs et croissants. En la lisant à rebours depuis l'indice $M$, le regroupement par paires montre que sa valeur absolue est majorée par son plus grand terme $a_M (x) ≤ 1 / (2 x)$. Dans la seconde somme, les termes décroissent vers $0$, donc le critère spécial majore sa valeur absolue par $a_(M + 1) (x) ≤ 1 / (2 x)$. On obtient $abs(R_N (x)) ≤ 1 / (2 x) + 1 / (2 x) = 1 / x < 1 / N$.

    Dans tous les cas, $norm(R_N)_∞ ≤ 1 / N ⟶ 0$, donc la série converge uniformément sur $RR$.]

  #question[En déduire $lim_(x ⟶ +∞) F(x)$, puis déterminer un équivalent de $F(x)$ lorsque $x ⟶ +∞$.][La convergence uniforme sur $RR$ autorise le théorème de la double limite : comme $v_n (x) ⟶ 0$ lorsque $x ⟶ +∞$ pour chaque $n ≥ 1$, on a $lim_(x ⟶ +∞) F(x) = 0$.

    Posons $g(t) = 1 / (e^t + 1)$. La fonction $g$ est de classe $C^3$ sur $[0, +∞[$, avec
    $ g'(t) = -e^t / (e^t + 1)^2, quad g''(t) = (e^t (e^t - 1)) / (e^t + 1)^3, $
    d'où $g'(0) = -1 / 4$ et $g''(0) = 0$. De plus, $g$, $g'$, $g''$ et $g'''$ sont toutes en $O(e^(-t))$ en $+∞$, donc tendent vers $0$ et sont intégrables sur $[0, +∞[$.

    Pour $x > 0$, deux intégrations par parties successives sur $[0, +∞[$ donnent
    $ F(x) = [sin(x t) / x g(t)]_0^(+∞) - 1 / x ∫_0^(+∞) sin(x t) g'(t) dif t = -1 / x ∫_0^(+∞) sin(x t) g'(t) dif t, $
    puis
    $ F(x) = [cos(x t) / x^2 g'(t)]_0^(+∞) - 1 / x^2 ∫_0^(+∞) cos(x t) g''(t) dif t = 1 / (4 x^2) - 1 / x^2 ∫_0^(+∞) cos(x t) g''(t) dif t. $
    Une troisième intégration par parties, en utilisant $g''(0) = 0$, fournit
    $ ∫_0^(+∞) cos(x t) g''(t) dif t = -1 / x ∫_0^(+∞) sin(x t) g'''(t) dif t = O(1 / x) $
    car $g'''$ est intégrable sur $[0, +∞[$. Ainsi $F(x) ∼ 1 / (4 x^2)$ lorsque $x ⟶ +∞$.]
]
