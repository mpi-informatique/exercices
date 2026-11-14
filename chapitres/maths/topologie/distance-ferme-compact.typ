#import "/load.typ": exercice, question

#let ex = exercice(meta: (
  titre: "Deux fermés peuvent se rapprocher sans se toucher",
  chapitres: ("topologie-des-espaces-vectoriels-normes",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 3,
))[
  Pour une partie non vide $F$ d'un espace vectoriel normé $E$, noter $d(x, F) = inf_(y ∈ F) norm(x - y)$.

  #question[Dans $RR^2$ euclidien, poser $A = {(t, 1 / t) : t > 0}$ et $F = RR × {0}$. Montrer que ces deux ensembles sont fermés et disjoints, puis calculer $inf_(a ∈ A) d(a, F)$.][On a $A = {(x, y) : x y = 1} ∩ {(x, y) : x ≥ 0}$, intersection de deux fermés. L'axe $F$ est fermé et ne rencontre pas $A$.
    Or $d((t, 1 / t), F) = 1 / t$, donc l'infimum demandé est $0$. Il n'est atteint en aucun point de $A$.]

  #question[Dans le cas général, montrer que $abs(d(x, F) - d(z, F)) ≤ norm(x - z)$. Si $F$ est fermé, montrer que $d(x, F) = 0$ équivaut à $x ∈ F$.][Pour tout $y ∈ F$, $d(x, F) ≤ norm(x - z) + norm(z - y)$. Prendre l'infimum en $y$, puis échanger $x$ et $z$, donne l'inégalité.
    Si $d(x, F) = 0$, choisir pour chaque $n ≥ 1$ un $y_n ∈ F$ tel que $norm(x - y_n) < 1 / n$. Alors $y_n ⟶ x$ et la fermeture donne $x ∈ F$. La réciproque est immédiate.]

  #question[Soient maintenant $K$ un compact non vide et $F$ un fermé non vide disjoint de $K$. Montrer qu'il existe $δ > 0$ tel que $norm(k - y) ≥ δ$ pour tous $k ∈ K$ et $y ∈ F$. Expliquer ce qui échoue dans l'exemple initial.][La deuxième question montre que $x ⟼ d(x, F)$ est continue et strictement positive sur $K$.
    Elle atteint son minimum $δ$ sur le compact $K$. Ce minimum est strictement positif et $norm(k - y) ≥ d(k, F) ≥ δ$.
    Dans l'exemple initial, $A$ est fermé mais non borné, donc non compact. Le minimum de la distance à $F$ n'y est pas atteint.]
]
