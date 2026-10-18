#import "/load.typ": exercice, question
#import "/load.typ": sep, widetilde

#let ex = exercice(
  meta: (
    titre: "Mots de Fibonacci",
    chapitres: ("langages-reguliers",),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [Les *mots de Fibonacci* sur l'alphabet $Sigma={a,b}$ sont définis par
      $ f_0=a, #sep f_1=b, #sep f_(n+2)=f_(n+1) f_n " pour " n>=0. $],
    question(
      [
        Montrer que pour $n>=2$, le suffixe de taille $2$ de $f_n$ est $b a$ si $n$ est pair, $a b$ si $n$ est impair.
      ],
      solution: [
        On procède par récurrence double.
        On a $f_2=b a$ et $f_3=b a b$.
        Pour $n>=4$, le mot $f_(n-2)$ est un suffixe de $f_n$ et a au moins deux lettres.
        Puisque $n$ et $n-2$ ont la même parité, l'hypothèse de récurrence donne le suffixe annoncé.
      ],
    ),
    question(
      [
        Pour $n>=2$, on note $g_n$ le préfixe de $f_n$ obtenu en supprimant ses deux dernières lettres.
        Montrer que $g_n$ est un palindrome, c'est-à-dire que $g_n=widetilde(g_n)$, où $widetilde(g_n)$ est le mot obtenu en inversant ses lettres.
      ],
      solution: [
        On procède par récurrence forte.
        Les mots $g_2=epsilon$, $g_3=b$ et $g_4=b a b$ sont des palindromes.

        Soit $n>=5$.
        Si $n$ est pair, la question précédente donne
        $
          f_n = f_(n-2) f_(n-3) f_(n-2)
          = g_(n-2) b a g_(n-3) a b g_(n-2) b a.
        $
        Donc $g_n=g_(n-2) b a g_(n-3) a b g_(n-2)$, qui est un palindrome puisque $g_(n-2)$ et $g_(n-3)$ le sont par hypothèse de récurrence.
        Si $n$ est impair, on obtient de même
        $ g_n=g_(n-2) a b g_(n-3) b a g_(n-2), $
        qui est aussi un palindrome.
      ],
    ),
  ),
)
