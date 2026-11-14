#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Une application rigide d'un compact dans lui-même",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[
  Soient $K$ un compact non vide d'un espace vectoriel normé $E$ et $u : K ⟶ K$ telle que
  $ ∀ x, y ∈ K, quad norm(u(x) - u(y)) = norm(x - y). $
  Aucune linéarité de $u$ n'est supposée.

  #question[Dans le cas $K = [0, 1]$, déterminer toutes les applications possibles.][Les images de $0$ et $1$ sont à distance $1$ dans $[0, 1]$, donc sont $0$ et $1$, dans cet ordre ou dans l'ordre inverse.
    Comme $abs(u(x) - u(0)) = x$, on obtient respectivement $u(x) = x$ ou $u(x) = 1 - x$. Ces deux applications conviennent et sont surjectives.]

  #question[Dans le cas général, supposer qu'il existe $a ∈ K - u(K)$. Justifier que $δ = d(a, u(K)) > 0$.
    Poser $a_0 = a$ et $a_(n + 1) = u(a_n)$ pour $n ≥ 0$. Montrer que $norm(a_n - a_m) ≥ δ$ dès que $n > m$.
    #linebreak()
    _Indication : appliquer $m$ fois la conservation des distances._][$u$ est continue, même $1$-lipschitzienne. Son image $u(K)$ est un compact non vide.
    La fonction $y ⟼ norm(a - y)$ y atteint son minimum, strictement positif puisque $a ∉ u(K)$.
    Pour tous entiers $n > m ≥ 0$, appliquer $m$ fois l'égalité des distances donne
    $ norm(a_n - a_m) = norm(a_(n - m) - a_0) ≥ δ, $
    car $n - m ≥ 1$ et donc $a_(n - m) ∈ u(K)$.]

  #question[En déduire que $u$ est surjective. Donner un contre-exemple si l'hypothèse de compacité est supprimée.][La suite $(a_n)$ du compact $K$ possède une sous-suite convergente vers un $b ∈ K$.
    Deux termes distincts assez avancés de cette sous-suite sont à distance au plus
    $norm(a_(n_j) - b) + norm(a_(n_k) - b) < δ$, ce qui contredit la question précédente.
    Ainsi $K - u(K)$ est vide et $u$ est surjective.
    Sur le fermé non compact $[0, +∞[$, l'application $u(x) = x + 1$ conserve les distances et n'est pas surjective.]
]
