#import "/load.typ": est-corrige, exercice, feuille, question, sujet-colle

#let cours = (
  (
    nom: [Théorème de convergence uniforme d'une série normalement convergente.],
    reponse: [Soit $∑ u_n$ une série de fonctions de $A$ dans $RR$ ou $CC$. Si chaque $u_n$ est bornée et si $∑ norm(u_n)_∞$ converge alors $∑ u_n$ converge uniformément sur $A$.
      En effet, pour tout $x ∈ A$, $∑ abs(u_n (x)) ≤ ∑ norm(u_n)_∞ < +∞$. La série converge donc simplement vers une somme $S$.
      Pour tout entier $N$ et tout $x ∈ A$, l'inégalité triangulaire sur les sommes finies, puis le passage à la limite, donnent
      $ abs(S(x) - ∑_(n = 0)^N u_n (x)) ≤ ∑_(n = N + 1)^(+∞) norm(u_n)_∞. $
      Le membre de droite tend vers $0$ indépendamment de $x$. Les restes tendent donc uniformément vers $0$, ce qui est la convergence uniforme de la série.],
  ),
  (
    nom: [Théorème de convergence dominée.],
    reponse: [Soit $I$ un intervalle et $(f_n)$ une suite de fonctions continues par morceaux sur $I$, à valeurs réelles ou complexes, convergeant simplement vers une fonction $f$ continue par morceaux sur $I$.
      Supposons qu'il existe une fonction $φ : I ⟶ RR_+$ intégrable telle que, pour tout $n$ et tout $t ∈ I$, $abs(f_n (t)) ≤ φ(t)$.
      Alors les fonctions $f_n$ et $f$ sont intégrables sur $I$ et
      $ lim_(n ⟶ +∞) ∫_I f_n (t) dif t = ∫_I f(t) dif t. $
      _Énoncé seulement, conformément au programme de cette semaine._],
  ),
  (
    nom: [Théorème d'intégration terme à terme.],
    reponse: [*Fonctions positives.* Soient $u_n : I ⟶ RR_+$ des fonctions continues par morceaux et intégrables sur un intervalle $I$. Supposons que $∑ u_n$ converge simplement vers une fonction $S$ continue par morceaux.
      Alors $S$ est intégrable si et seulement si $∑ ∫_I u_n$ converge. Dans ce cas,
      $ ∫_I S(t) dif t = ∑_(n = 0)^(+∞) ∫_I u_n (t) dif t. $
      Si la série des intégrales diverge, l'intégrale positive de $S$ diverge vers $+∞$.

      *Cas général.* Soient $u_n : I ⟶ RR$ ou $CC$ des fonctions continues par morceaux et intégrables. Supposons que $∑ u_n$ converge simplement vers une fonction $S$ continue par morceaux et que $∑ ∫_I abs(u_n (t)) dif t$ converge.
      Alors $S$ est intégrable, la série des intégrales converge absolument et la même égalité d'intégration terme à terme est valable.
      _Énoncés seulement, conformément au programme de cette semaine._],
  ),
)
#let cours = cours.map(c => exercice(meta: (
  titre: "Question de cours",
  chapitres: ("suites-et-series-de-fonctions",),
  matiere: "mathématiques",
  niveaux: ("MP",),
  difficulte: 1,
))[
  #question(c.nom, c.reponse)
])

#import "/chapitres/maths/suites-fonctions/serie-geometrique-integration.typ": ex as e1

#import "/chapitres/maths/suites-fonctions/serie-logarithme-alternee.typ": ex as e2

#import "/chapitres/maths/suites-fonctions/serie-harmonique-parametre.typ": ex as e3

#import "/chapitres/maths/suites-fonctions/serie-trigonometrique-moyenne.typ": ex as e4

#import "/chapitres/maths/suites-fonctions/serie-exponentielle-logarithme.typ": ex as e5

#import "/chapitres/maths/suites-fonctions/serie-arctangente-compensee.typ": ex as e6

#import "/chapitres/maths/suites-fonctions/serie-telescopique-logarithmes.typ": ex as e7

#import "/chapitres/maths/suites-fonctions/serie-alternee-parametre.typ": ex as e8

#import "/chapitres/maths/suites-fonctions/serie-exponentielle-integrable.typ": ex as e9

#let sujets = ((cours.at(0), e1, e2, e3), (cours.at(1), e4, e5, e6), (cours.at(2), e7, e8, e9))
#let sujet = (titre: "Colle MP — Semaine 9", exercices: sujets.flatten())
#let corrige = est-corrige()
#show: feuille.with(
  type: "colle",
  titre: sujet.titre,
  niveau: "MP",
  exercices: sujet.exercices,
  corrige: corrige,
  afficher-exercices: false,
)
#for (i, exercices) in sujets.enumerate(start: 1) { sujet-colle(i, exercices, corrige: corrige) }
