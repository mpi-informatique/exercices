#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une suite bornée dont les termes restent éloignés",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[
  Munir $E = C([0, 2π], CC)$ de la norme $norm(f)_∞ = max_(t ∈ [0, 2π]) abs(f(t))$.
  Pour $n ∈ NN$, poser $u_n (t) = e^(i n t)$.

  #question[Calculer $norm(u_n)_∞$. La suite $(u_n)$ est-elle bornée ?][$abs(e^(i n t)) = 1$ pour tout $t$, donc $norm(u_n)_∞ = 1$. La suite est bornée dans $E$.]

  #question[Pour deux entiers distincts $n$ et $m$, calculer $norm(u_n - u_m)_∞$.
    #linebreak()
    _Indication : trouver un $t ∈ [0, 2π]$ tel que $e^(i(n - m)t) = -1$._][L'inégalité triangulaire donne $norm(u_n - u_m)_∞ ≤ 2$.
    Pour $t = π / abs(n - m) ∈ [0, 2π]$, on a $e^(i(n - m)t) = -1$. Ainsi
    $ abs(u_n (t) - u_m (t)) = abs(e^(i(n - m)t) - 1) = 2. $
    La norme cherchée vaut exactement $2$.]

  #question[Montrer que $(u_n)$ n'a aucune valeur d'adhérence dans $E$.
    #linebreak()
    _Indication : si une sous-suite convergeait vers $f$, comparer la distance entre deux de ses termes à leurs distances à $f$._][Supposons qu'une sous-suite $(u_(n_k))$ converge vers $f ∈ E$ pour la norme uniforme.
    Il existe un rang $K$ tel que $norm(u_(n_k) - f)_∞ < 1 / 2$ pour tout $k ≥ K$.
    Pour deux indices distincts $k, l ≥ K$, l'inégalité triangulaire donnerait alors
    $ norm(u_(n_k) - u_(n_l))_∞ ≤ norm(u_(n_k) - f)_∞ + norm(f - u_(n_l))_∞ < 1, $
    alors que cette norme vaut $2$.
    Aucune sous-suite ne converge. Une suite bornée d'un espace normé de dimension infinie peut donc n'avoir aucune valeur d'adhérence.]
]
