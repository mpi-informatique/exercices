#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "La valeur en un point dépend de la norme",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[
  Dans $E = C([0, 1], RR)$, noter $norm(f)_1 = ∫_0^1 abs(f(t)) dif t$ et $norm(f)_∞ = max_(t ∈ [0, 1]) abs(f(t))$.
  Pour $n ≥ 1$, poser $u_n (t) = max(1 - n t, 0)$.

  #question[Calculer les deux normes de $u_n$. Ces normes sont-elles équivalentes sur $E$ ?][$norm(u_n)_∞ = 1$ et $norm(u_n)_1 = ∫_0^(1 / n) (1 - n t) dif t = 1 / (2n)$.
    Il n'existe donc pas de constante $C$ telle que $norm(f)_∞ ≤ C norm(f)_1$ pour tout $f ∈ E$. Les normes ne sont pas équivalentes, bien que $norm(f)_1 ≤ norm(f)_∞$.]

  #question[Étudier la continuité de l'application $f ⟼ f(0)$ pour chacune des deux normes.][Pour la norme uniforme, $abs(f(0) - g(0)) ≤ norm(f - g)_∞$ prouve la continuité.
    Pour la norme intégrale, $u_n ⟶ 0$, mais $u_n (0) = 1$ ne tend pas vers $0$ : l'évaluation n'est pas continue.]

  #question[Poser $H = {f ∈ E : f(0) = 0}$. Déterminer son adhérence pour chacune des deux normes.
    #linebreak()
    _Indication : pour approcher une fonction $f$ dans $H$, modifier seulement sa valeur près de $0$ à l'aide de $u_n$._][Pour la norme uniforme, $H$ est fermé comme image réciproque du fermé ${0}$ par une application continue. Son adhérence est donc $H$.
    Pour la norme intégrale, fixer $f ∈ E$ et poser $h_n = f - f(0) u_n$. Alors $h_n (0) = 0$ et
    $ norm(h_n - f)_1 = abs(f(0)) / (2n) ⟶ 0. $
    Toute fonction de $E$ est adhérente à $H$ : son adhérence est $E$.]
]
