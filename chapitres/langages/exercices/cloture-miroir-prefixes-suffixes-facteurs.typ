#import "/load.typ": exercice, question
#import "/load.typ": sep, widetilde

#let ex = exercice(
  meta: (
    titre: "Clôture des langages reconnaissables",
    chapitres: ("automates-finis", "langages-reguliers", "recursivite-et-induction"),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
  corrections: [
    - Question 4 : corriger les formules pour la concaténation avec un second langage vide et pour l'étoile d'un langage vide.
  ],
  contenu: (
    [Si $m=m_1 … m_n$ est un mot, son miroir est $widetilde(m)=m_n … m_1$.
      Le miroir d'un langage $L$ est $widetilde(L)={widetilde(m) | m∈L}$.],
    question([Montrer que le miroir d'un langage reconnaissable est reconnaissable.], solution: [
      Si $A=(Σ,Q,I,F,E)$ reconnaît $L$, l'automate $widetilde(A)=(Σ,Q,F,I,widetilde(E))$, où $widetilde(E)={(p,a,q) | (q,a,p)∈E}$, reconnaît $widetilde(L)$.
      En effet, inverser un chemin acceptant étiqueté $m$ donne un chemin acceptant étiqueté $widetilde(m)$ dans $widetilde(A)$, et réciproquement.
    ]),
    [Pour un langage $L$ sur $Σ$, on définit :
      - $"Pref"(L)={u∈Σ^* | ∃v∈Σ^*, u v∈L}$, l'ensemble des préfixes ;
      - $"Suff"(L)={u∈Σ^* | ∃v∈Σ^*, v u∈L}$, l'ensemble des suffixes ;
      - $"Fact"(L)={u∈Σ^* | ∃v,w∈Σ^*, v u w∈L}$, l'ensemble des facteurs.
    ],
    question([Donner des expressions régulières pour $"Pref"(a^* b)$ et $"Pref"((a b)^*)$.], solution: [
      $"Pref"(a^* b)$ est dénoté par $a^*(ε|b)$ et $"Pref"((a b)^*)$ par $(a b)^*(ε|a)$.
    ]),
    question(
      [Montrer que si $L$ est reconnaissable, alors $"Pref"(L)$, $"Suff"(L)$ et $"Fact"(L)$ le sont aussi.],
      solution: [
        Soit $A=(Σ,Q,I,F,E)$ reconnaissant $L$. Notons $Q'$ les états coaccessibles et $Q''$ les états accessibles.
        Un mot est préfixe d'un mot de $L$ exactement lorsqu'il étiquette un chemin de $I$ vers $Q'$.
        Donc $(Σ,Q,I,Q',E)$ reconnaît $"Pref"(L)$.
        De même, $(Σ,Q,Q'',F,E)$ reconnaît $"Suff"(L)$ et $(Σ,Q,Q'',Q',E)$ reconnaît $"Fact"(L)$ :
        le chemin étiqueté par le suffixe ou le facteur se prolonge en un chemin acceptant de $A$.

        Autre solution : $"Suff"(L)=widetilde("Pref"(widetilde(L)))$ puisque $widetilde(x y)=widetilde(y)widetilde(x)$.
        En effet,
        $ m∈widetilde("Pref"(widetilde(L))) ⟺ ∃v, widetilde(m)v∈widetilde(L) ⟺ ∃v, widetilde(v)m∈L ⟺ m∈"Suff"(L). $
        Enfin $"Fact"(L)="Suff"("Pref"(L))="Pref"("Suff"(L))$ :
        $ m∈"Suff"("Pref"(L)) ⟺ ∃u, u m∈"Pref"(L) ⟺ ∃u,v, u m v∈L ⟺ m∈"Fact"(L). $
      ],
    ),
    question(
      [
        Montrer que si $L$ est régulier, alors $"Pref"(L)$, $"Suff"(L)$ et $"Fact"(L)$ le sont aussi.
        Puisqu'on montrera que régulier et reconnaissable sont équivalents, il s'agit d'une preuve alternative.
      ],
      solution: [
        Pour une expression régulière $e$, construisons par induction une expression $P(e)$ dénotant les préfixes de son langage $cal(L)(e)$ :
        $ P(a)=ε|a, #sep P(ε)=ε, #sep P(∅)=∅, $
        $ P(e_1|e_2)=P(e_1)|P(e_2), $
        $ P(e_1 e_2)=cases(∅ & "si " cal(L)(e_2)=∅, P(e_1)|e_1 P(e_2) & "sinon"), $
        $ P(e_1^*)=ε|e_1^* P(e_1). $
        Pour la concaténation, un préfixe s'arrête dans le premier mot ou continue dans le second ;
        la première possibilité exige que le second langage soit non vide.
        Pour l'étoile, un préfixe est vide, ou constitué de mots complets suivis du préfixe d'un mot.
        La vacuité se décide elle-même par induction : $∅$ est vide, $ε$ et les lettres ne le sont pas, une union est vide si ses deux termes le sont, une concaténation si l'un l'est, et une étoile ne l'est jamais.

        La stabilité des langages réguliers par miroir et les identités de la question 3 donnent alors la régularité de $"Suff"(L)=widetilde("Pref"(widetilde(L)))$ puis de $"Fact"(L)="Suff"("Pref"(L))$.
      ],
    ),
  ),
)
