#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
    titre: "Clôture par sur-mot",
    chapitres: ("langages-reguliers", "automates-finis"),
    difficulte: 4,
    niveaux: ("MPI",),
    concours: (nom: "ENS", filiere: "MP", oral: true),
  ),
  contenu: (
    [On fixe un alphabet fini non vide $Sigma$.
      Étant donnés deux mots $w,w' in Sigma^*$, on dit que $w'$ est un *sur-mot* de $w$, noté $w ≼ w'$, s'il existe une fonction strictement croissante $phi$ de ${1,dots,abs(w)}$ dans ${1,dots,abs(w')}$ telle que $w_i=w'_(phi(i))$ pour tout $1<=i<=abs(w)$.
      Étant donné un langage $L$, on note $overline(L)$ le langage des sur-mots de mots de $L$ :
      $ overline(L)={w' in Sigma^* | exists w in L, w ≼ w'}. $],
    question(
      [
        On pose $L_0=cal(L)(a b^* a)$ et $L_1=cal(L)((a b)^*)$, sur un alphabet contenant $a$ et $b$.
        Donner une expression régulière pour $overline(L_0)$ et $overline(L_1)$.
      ],
      solution: [
        $overline(L_0)$ est le langage des mots contenant au moins deux $a$, soit $Sigma^* a Sigma^* a Sigma^*$.
        En effet, tout sur-mot d'un mot de $L_0$ contient deux $a$ et, réciproquement, un mot contenant deux $a$ est un sur-mot de $a a in L_0$.
        On a $overline(L_1)=Sigma^*$ puisque $epsilon in L_1$.
      ],
    ),
    question(
      [
        Montrer que, pour tout langage $L$, on a $overline(overline(L))=overline(L)$.
      ],
      solution: [
        La relation $≼$ est réflexive et transitive : pour la transitivité, on compose les fonctions strictement croissantes témoignant de $w ≼ w'$ et $w' ≼ w''$.
        Leur composition témoigne de $w ≼ w''$.

        Par réflexivité, $overline(L) subset.eq overline(overline(L))$.
        Réciproquement, si $u'' in overline(overline(L))$, il existe $u' in overline(L)$ tel que $u' ≼ u''$, puis $u in L$ tel que $u ≼ u'$.
        Par transitivité, $u ≼ u''$, donc $u'' in overline(L)$.
      ],
    ),
    question(
      [
        Existe-t-il des langages $L'$ pour lesquels il n'existe aucun langage $L$ tel que $overline(L)=L'$ ?
      ],
      solution: [
        Oui : tout langage fini non vide convient.
        Si $L$ est non vide et $u in L$, alors $u Sigma^* subset.eq overline(L)$, donc $overline(L)$ est infini puisque l'alphabet est non vide.
        Si $L=emptyset$, sa clôture est vide.

        On peut aussi prendre $L'=L_0$ : si $overline(L)=L_0$, l'idempotence donnerait $L_0=overline(L_0)$, ce qui est faux d'après la question 1.
      ],
    ),
    question(
      [
        Montrer que, pour tout langage régulier $L$, le langage $overline(L)$ est régulier.
      ],
      solution: [
        Soit $A$ un automate fini non déterministe reconnaissant $L$.
        On construit $A'$ en ajoutant, à chaque état, une boucle pour chaque lettre de $Sigma$.
        Les états initiaux et finaux restent inchangés.

        Si $u$ est accepté par $A$ et $u ≼ u'$, un chemin acceptant pour $u'$ suit les transitions de $A$ aux positions correspondant aux lettres de $u$, et les boucles ajoutées aux autres positions.
        Réciproquement, d'un chemin acceptant dans $A'$, on retire les passages par les boucles ajoutées : les transitions restantes forment un chemin acceptant dans $A$, portant un sous-mot du mot initial.
        Ainsi $cal(L)(A')=overline(L)$.

        Une autre preuve procède par induction structurelle avec les identités
        $
          overline(emptyset)=emptyset, #sep overline({epsilon})=Sigma^*,
          #sep overline({a})=Sigma^* a Sigma^*,
        $
        $
          overline(L_1 L_2)=overline(L_1) overline(L_2), #sep
          overline(L_1 union L_2)=overline(L_1) union overline(L_2),
        $
        $ overline(L^*)=Sigma^*. $
        La dernière identité vient de $epsilon in L^*$ ; en revanche, $overline(L^*)=overline(L)^*$ est faux en général (prendre $Sigma={a,b}$ et $L={a}$).
      ],
    ),
    question(
      [
        On admet pour cette question le résultat suivant : pour toute suite $(w_n)_(n in NN)$ de mots de $Sigma^*$, il existe $i<j$ tels que $w_i ≼ w_j$.

        Montrer que, pour tout langage $L$, non nécessairement régulier, il existe un langage fini $F subset.eq L$ tel que $overline(F)=overline(L)$.
      ],
      solution: [
        Si $L=emptyset$, prendre $F=emptyset$.
        Sinon, on énumère les mots de $L$ dans une suite infinie $(w_n)$, éventuellement avec des répétitions.
        Une position $i$ est dite *innovante* s'il n'existe aucun $j<i$ avec $w_j ≼ w_i$.
        On prend $F={w_i | i " est innovante"}$.

        Il n'y a qu'un nombre fini de positions innovantes : sinon, la sous-suite des mots situés à ces positions contredirait le résultat admis.
        Ainsi $F$ est fini, et $F subset.eq L$ donne $overline(F) subset.eq overline(L)$.

        Par récurrence sur $i$, on montre que $w_i in overline(F)$.
        Si $i$ est innovante, $w_i in F$.
        Sinon, il existe $j<i$ tel que $w_j ≼ w_i$ ; l'hypothèse de récurrence et la transitivité donnent encore $w_i in overline(F)$.
        Ainsi $L subset.eq overline(F)$ et, par monotonie et par la question 2, $overline(L) subset.eq overline(overline(F))=overline(F)$.
      ],
    ),
    question(
      [
        Un langage $L$ est *clos par sur-mots* si, pour tout $u in L$ et tout $v in Sigma^*$ tel que $u ≼ v$, on a $v in L$.
        Déduire de la question précédente que tout langage clos par sur-mots est régulier.
      ],
      solution: [
        Par définition, $L=overline(L)$.
        La question 5 fournit un langage fini $F subset.eq L$ tel que $overline(F)=overline(L)=L$.
        Le langage $F$ est régulier car fini ; sa clôture est régulière par la question 4.
      ],
    ),
    question(
      [
        On admet que les langages réguliers sont stables par complémentaire.
        Un langage $L$ est *clos par sous-mots* si, pour tout $u in L$ et tout $v in Sigma^*$ tel que $v ≼ u$, on a $v in L$.
        Montrer que tout langage clos par sous-mots est régulier.
      ],
      solution: [
        Son complémentaire $L'=Sigma^* without L$ est clos par sur-mots.
        En effet, si $u in L'$ et $u ≼ v$, on ne peut avoir $v in L$, car la clôture par sous-mots donnerait $u in L$, contradiction.
        Par la question 6, $L'$ est régulier.
        Son complémentaire $L$ est donc régulier.
      ],
    ),
    question(
      [
        Démontrer le résultat admis à la question 5.
      ],
      solution: [
        C'est le lemme de Higman pour un alphabet fini.
        Appelons *mauvaise* une suite $(w_n)$ pour laquelle il n'existe aucun $i<j$ tel que $w_i ≼ w_j$.
        Supposons qu'une telle suite existe.

        Construisons une mauvaise suite minimale : $w_0$ est de taille minimale parmi les mots pouvant commencer une mauvaise suite ; une fois $w_0,dots,w_(n-1)$ fixés, on choisit $w_n$ de taille minimale parmi les mots permettant de prolonger ce préfixe en une mauvaise suite.
        La suite obtenue est mauvaise, car chaque préfixe possède un prolongement mauvais.

        Aucun $w_n$ n'est vide, puisque $epsilon$ est sous-mot de tout mot suivant.
        Comme $Sigma$ est fini, une lettre $a$ commence une infinité de mots de la suite.
        Écrivons $w_(i_j)=a v_j$, où $i_0<i_1<dots$ sont les indices correspondants.
        Considérons la nouvelle suite
        $ w_0,dots,w_(i_0-1),v_0,v_1,v_2,dots. $
        Elle est encore mauvaise :
        - deux mots du préfixe ne sont pas comparables dans cet ordre, par hypothèse ;
        - si $w_r ≼ v_j$ avec $r<i_0$, alors $w_r ≼ w_(i_j)$, contradiction ;
        - si $v_j ≼ v_k$ avec $j<k$, alors $a v_j ≼ a v_k$, donc $w_(i_j) ≼ w_(i_k)$, contradiction.

        Cette suite coïncide avec la suite minimale jusqu'à l'indice $i_0-1$, puis contient $v_0$, plus court d'une lettre que $w_(i_0)$.
        Elle contredit le choix minimal de $w_(i_0)$.
        Il n'existe donc pas de mauvaise suite.
      ],
    ),
  ),
)
