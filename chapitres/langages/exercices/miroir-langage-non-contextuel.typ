#import "/load.typ": exercice, question
#import "/load.typ": widetilde

#let ex = exercice(
  meta: (
    titre: "Miroir d'un langage non-contextuel",
    chapitres: ("grammaires-non-contextuelles",),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
  contenu: (
    [On note $widetilde(m) = m_n … m_1$ le miroir d'un mot $m = m_1 … m_n$ et $widetilde(L) = {widetilde(m) | m ∈ L}$ le miroir d'un langage $L$.],
    question([Soit $L$ un langage non-contextuel. Montrer que $widetilde(L)$ est non-contextuel.], solution: [
      Soit $G = (Σ, V, R, S)$ une grammaire engendrant $L$.
      Remplacer chaque règle $X → α$ par $X → widetilde(α)$ donne une grammaire $G'$.
      Si $p X q ⇒ p α q$ dans $G$, alors $widetilde(q) X widetilde(p) ⇒ widetilde(q) widetilde(α) widetilde(p)$ dans $G'$.
      Par récurrence sur la longueur des dérivations, $S ⇒^* m$ dans $G$ implique $S ⇒^* widetilde(m)$ dans $G'$.
      La transformation étant involutive, la réciproque est vraie également.
      Ainsi $L(G') = widetilde(L)$.
    ]),
  ),
)
