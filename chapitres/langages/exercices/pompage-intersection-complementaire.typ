#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
    titre: "Lemme d'Ogden",
    chapitres: ("grammaires-non-contextuelles",),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [On admet le lemme de pompage suivant pour les langages non-contextuels :
      si $L$ est non-contextuel, il existe un entier $p ≥ 1$ tel que tout mot $t ∈ L$ de taille au moins $p$ s'écrit $t = u v w x y$, avec :
      - $abs(v w x) ≤ p$
      - $v x ≠ ε$
      - $∀i ∈ ℕ, #sep u v^i w x^i y ∈ L$

      On considère $L_1 = {a^n b^n c^k | n,k ∈ ℕ}$ et $L_2 = {a^n b^n c^n | n ∈ ℕ}$.],
    question([Montrer que $L_1$ est non-contextuel.], solution: [
      Prendre $S → A C$, $A → a A b ∣ ε$ et $C → c C ∣ ε$.
      $A$ engendre exactement les $a^n b^n$ et $C$ les $c^k$ : leur concaténation est $L_1$.
    ]),
    question([Montrer que $L_2$ n'est pas non-contextuel.], solution: [
      Supposer $L_2$ non-contextuel et prendre $p$ fourni par le lemme.
      Le mot $a^p b^p c^p$ possède alors une décomposition satisfaisant ses conditions.
      Puisque $abs(v w x) ≤ p$, ce facteur ne peut contenir à la fois un $a$ et un $c$ :
      un tel facteur aurait pour taille au moins $p+2$.
      Une des trois lettres est donc absente de $v x$.
      Pour $i=0$, on retire au moins une lettre puisque $v x ≠ ε$, tandis que le nombre d'occurrences de la lettre absente reste $p$.
      Les trois nombres ne sont plus égaux, donc $u w y ∉ L_2$ : contradiction.
    ]),
    question(
      [
        Montrer que les langages non-contextuels sont stables par union.
        En déduire qu'ils ne sont stables ni par intersection ni par passage au complémentaire.
        Les complémentaires sont pris dans ${a,b,c}^*$.
      ],
      solution: [
        Pour l'union, renommer les variables de deux grammaires afin qu'elles soient disjointes, puis ajouter un nouvel axiome $S$ et les règles $S → S_1 ∣ S_2$.
        Les dérivations choisissent l'une des deux grammaires, d'où exactement l'union.

        Le langage $K = {a^k b^n c^n | k,n ∈ ℕ}$ est non-contextuel :
        prendre $S → A B$, $A → a A ∣ ε$, $B → b B c ∣ ε$.
        Or $L_1 ∩ K = L_2$, qui n'est pas non-contextuel.

        Si le passage au complémentaire préservait les langages non-contextuels, la stabilité par union et l'identité de De Morgan
        $ L_1 ∩ K = overline(overline(L_1) ∪ overline(K)) $
        impliqueraient la stabilité par intersection : contradiction.
      ],
    ),
  ),
)
