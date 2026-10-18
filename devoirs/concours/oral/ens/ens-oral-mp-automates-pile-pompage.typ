#import "/load.typ": automate
#import automate: dessiner-automate as dessiner
#import "/load.typ": exercice, partie, question
#import "/load.typ": sep
#let anbn = dessiner(
  (
    ("q_0", (0, 0), true, false),
    ("q_1", (3, 0), false, false),
    ("q_2", (6, 0), false, false),
    ("q_3", (9, 0), false, true),
  ),
  (
    ("q_0", "q_1", "a:γ_0→γ_0", (:)),
    ("q_1", "q_1", "a:γ→γ α", (anchor: top)),
    ("q_1", "q_2", "b:α→ε", (:)),
    ("q_2", "q_2", "b:α→ε", (anchor: top)),
    ("q_2", "q_3", "b:γ_0→γ_0", (:)),
  ),
)
#let equilibre = dessiner(
  (("q_0", (0, 2), true, true), ("q_a", (-3, -1), false, false), ("q_b", (3, -1), false, false)),
  (
    ("q_0", "q_a", "a:γ_0→γ_0", (curve: 0.25)),
    ("q_a", "q_0", "b:γ_0→γ_0", (curve: 0.25)),
    ("q_0", "q_b", "b:γ_0→γ_0", (curve: 0.25)),
    ("q_b", "q_0", "a:γ_0→γ_0", (curve: 0.25)),
    ("q_a", "q_a", "a:γ→γ α", (anchor: left)),
    ("q_a", "q_a", "b:α→ε", (anchor: bottom)),
    ("q_b", "q_b", "b:γ→γ α", (anchor: right)),
    ("q_b", "q_b", "a:α→ε", (anchor: bottom)),
  ),
)

#let ex = exercice(
  meta: (
    titre: "Automates à pile et lemme de pompage",
    chapitres: ("langages-reguliers", "automates-finis"),
    structures: ("pile",),
    difficulte: 5,
    niveaux: ("MPI", "MP"),
    duree: (1, 0),
    concours: (nom: "ENS", annee: 2017, filiere: "MP", oral: true),
  ),
  corrections: [
    - Numérotation : commencer à 1 et décaler les renvois d'une unité.
    - Définitions : préciser que les ensembles de transitions sont finis, afin que $G$ existe, et parler de couples de configurations et de triplets d'états de base.
    - Questions 6 et 7, corrigé : une transition peut remplacer le sommet initial, qui n'est donc pas nécessairement conservé au retour. Renforcer le choix des montagnes en imposant aussi le même sommet de sortie.
    - Question 6, corrigé : sélectionner les hauteurs par minima successifs à rebours ; une montée peut sauter des hauteurs.
  ],
  jury: [
    - Expliquer les pistes envisagées et les difficultés rencontrées afin de permettre le dialogue avec le jury.
  ],
  contenu: (
    [
      Soient $Σ$ un alphabet fini et $Γ$ un alphabet fini de pile.
      Un automate à pile est un quintuplet $A=(Q,q_0,γ_0,δ,F)$, où $Q$ est fini, $q_0∈Q$, $γ_0∈Γ$, $F⊂Q$, et $δ(q,a,γ)$ est une partie finie de $Q×Γ^*$ pour chaque $(q,a,γ)∈Q×Σ×Γ$.
      Une configuration est un couple $(q,z)$ avec $z∈Γ^*$ non vide. La configuration initiale est $(q_0,γ_0)$ ; une configuration est acceptante si $q∈F$.
      À la lecture de $a$, écrire $z=z'γ$, où $γ$ est le sommet de pile (à droite), choisir $(q',g)∈δ(q,a,γ)$ tel que $z'g≠ε$, et passer à $(q',z'g)$.
      Un mot est accepté s'il existe un calcul qui lit toutes ses lettres et termine dans une configuration acceptante.
      Ces notions sont introduites par le sujet ; aucune théorie préalable des automates à pile n'est supposée.
    ],
    question(
      [
        Étant donné un automate fini sans pile sur $Σ$, construire un automate à pile reconnaissant le même langage.
      ],
      jury: [« Un automate fini n'est pas nécessairement déterministe ! »],
      solution: [
        On peut d'abord déterminiser l'automate pour disposer d'un unique état initial.
        Prendre $Γ={γ_0}$, garder états et finaux, et remplacer chaque transition $q arrow(a)q'$ par $(q',γ_0)∈δ'(q,a,γ_0)$.
        La pile reste toujours $γ_0$ ; les calculs et les acceptations sont exactement ceux de l'automate fini.
      ],
    ),
    question(
      [
        Sur $Σ={a,b}$, proposer un automate à pile reconnaissant ${a^n b^n | n≥2}$. Qu'en déduire ?
      ],
      solution: [
        Prendre $Γ={γ_0,α}$ et l'automate ci-dessous. Une étiquette $a:γ→g$ signifie que lire $a$ remplace le sommet $γ$ par $g$ ; sur la boucle de $q_1$, $γ$ parcourt $Γ$.
        Toute transition non dessinée est absente.
        #anbn
        Le premier $a$ change seulement d'état ; les $n-1$ suivants empilent chacun un $α$.
        Le premier $b$ impose qu'un $α$ soit présent, donc $n≥2$. Les $n-1$ premiers $b$ dépilent les $α$, puis le dernier lit le fond $γ_0$ et termine en $q_3$.
        Réciproquement, toute exécution acceptante suit nécessairement ce schéma, donc lit exactement $a^n b^n$ avec $n≥2$.
        Ce langage n'est pas régulier : pomper un facteur non vide du premier bloc de $a^p b^p$, pour une taille de pompage $p≥2$, détruit l'égalité des comptes.
        Les automates à pile reconnaissent donc strictement plus de langages que les automates finis.
      ],
    ),
    question(
      [
        Toujours sur $Σ={a,b}$, reconnaître ${w | abs(w)_a=abs(w)_b}$ par un automate à pile.
      ],
      solution: [
        Utiliser $Γ={γ_0,α}$ et les transitions suivantes, où $γ$ parcourt $Γ$ sur les boucles d'empilement.
        #equilibre
        Pour un préfixe $u$, posons $d=abs(u)_a-abs(u)_b$.
        L'invariant est : la configuration est $(q_0,γ_0)$ si $d=0$, $(q_a,γ_0 α^(d-1))$ si $d>0$, et $(q_b,γ_0 α^(-d-1))$ si $d<0$.
        Les transitions vérifient cet invariant par récurrence, en distinguant le signe de $d$ et les cas $abs(d)=1$.
        Seul $q_0$ est final : les mots acceptés sont exactement les mots équilibrés, y compris $ε$.
      ],
    ),
    [
      Pour $η∈NN^*$, une configuration $η$-tronquée est un couple $(q,z)$ avec $1≤abs(z)≤η$.
      Un calcul $η$-tronqué suit les mêmes règles, mais remplace toute nouvelle pile de taille supérieure à $η$ par son suffixe de taille $η$ ; une pile vide reste interdite.
      On note $cal(L)_(≤η)(A)$ le langage des calculs $η$-tronqués acceptants.
    ],
    question(
      [
        Quelle est la relation entre $cal(L)_(≤η)(A)$ et $cal(L)(A)$ ? Montrer que le premier langage est régulier et construire un automate fini qui le reconnaît.
      ],
      solution: [
        On a $cal(L)_(≤η)(A)⊂cal(L)(A)$ : reproduire un calcul tronqué avec la pile entière.
        À chaque instant, la pile tronquée est un suffixe non vide de la pile entière et possède donc le même sommet. Chaque transition choisie reste légale dans le calcul entier et conduit au même état.
        L'inclusion peut être stricte : dans l'automate de la question 2, le mot $a a b b$ ne peut être accepté pour $η=1$, car le premier $b$ viderait la pile tronquée.

        Prendre comme états les configurations tronquées, initial $(q_0,γ_0)$, finaux celles dont l'état appartient à $F$, et les transitions définies ci-dessus.
        Leur nombre est $abs(Q)∑_(j=1)^η abs(Γ)^j$, donc fini. Cet automate reconnaît précisément $cal(L)_(≤η)(A)$.
      ],
    ),
    [
      Dans un calcul $χ=(q_0,z_0),…,(q_p,z_p)$, posons $h_i=abs(z_i)$.
      Une $η$-montagne est un triplet $0≤l<m<r≤p$ tel que $h_l=h_r$, $h_m-h_l≥η$ et $h_j>h_l$ pour tout $l<j<r$.
      Une montagne est une $η$-montagne pour un $η≥1$.
      Soit $G$ la taille maximale d'un mot de pile figurant dans une transition, avec $G=0$ s'il n'y a aucune transition.
    ],
    question(
      [
        Montrer que, si $η>G$ et $w∈cal(L)(A)∖cal(L)_(≤η)(A)$, tout calcul acceptant de $w$ possède une $(η-G)$-montagne.
      ],
      solution: [
        Fixons un calcul acceptant. Sa simulation tronquée doit se bloquer en tentant de dépiler son dernier symbole ; sinon elle accepterait aussi $w$.
        Depuis la dernière troncature ayant supprimé un préfixe, on a donc une position $m$ de hauteur $h_m$ et une position ultérieure $r_0$ de hauteur $h_m-η≥1$.
        La descente enlève au plus un symbole par étape. Quitte à choisir $r_0$ minimal après $m$, aucune hauteur entre $m$ et $r_0$ n'est inférieure ou égale à $h_m-η$ avant $r_0$.
        Posons $H=h_(r_0)$. Puisque $h_0=1≤H$ et que la montée augmente la hauteur d'au plus $G-1$, elle rencontre une hauteur de $[H,H+G]$ avant $m$.
        Choisissons $l<m$ maximal dont la hauteur appartient à cet intervalle. Après $l$ et jusqu'à $m$, les hauteurs sont toutes supérieures à $H+G$ : une descente sous $H$ obligerait à recroiser cet intervalle pour atteindre $h_m>H+G$.
        La descente depuis $m$ passe par $h_l$ ; soit $r$ son premier passage.
        Alors $h_j>h_l$ entre $l$ et $r$, et $h_m-h_l≥η-G$ : c'est la montagne cherchée.
      ],
    ),
    [
      L'état de base d'une montagne est le triplet $β(l,r)=(q_l,q_r,γ)$, où $γ$ est le sommet de $z_l$.
    ],
    question(
      [
        Montrer qu'il existe $η_0≥1$, ne dépendant que de $A$, tel que toute $η_0$-montagne $(l,m,r)$ contienne deux montagnes $(l',m,r')$ et $(l'',m,r'')$ vérifiant
        $ l<l'<l''<m<r''<r'<r, #sep β(l',r')=β(l'',r''). $
      ],
      solution: [
        Montrons une propriété légèrement plus forte : on peut aussi imposer l'égalité des sommets de pile aux deux sorties.
        Il y a au plus $K=abs(Q)^2 abs(Γ)^2$ quadruplets (état d'entrée, état de sortie, sommet d'entrée, sommet de sortie).
        Prendre $η_0=(K+2)(G+1)$.

        Pour trouver des montagnes imbriquées, parcourir les hauteurs à rebours depuis $m$ : à partir d'un indice $t$, choisir le dernier indice antérieur dont la hauteur est strictement inférieure à $h_t$.
        Jusqu'à rejoindre $l$, ces indices existent. Entre deux hauteurs ainsi retenues, l'écart est au plus $G-1$ : la transition juste après l'indice précédent rejoint au moins la hauteur supérieure.
        De plus, après chaque indice retenu et jusqu'à $m$, la hauteur reste strictement supérieure à sa hauteur.
        Si $G≤1$, aucune montagne n'existe ; sinon la borne $η_0$ garantit au moins $K+1$ indices strictement entre $l$ et $m$.
        Ranger ces indices par ordre croissant. Pour chacun, prendre comme sortie le premier indice après $m$ de même hauteur ; il existe car la descente enlève au plus un symbole à la fois.
        Les sorties sont strictement décroissantes et situées avant $r$. On obtient $K+1$ montagnes imbriquées.
        Deux ont le même quadruplet, par le principe des tiroirs ; elles ont notamment le même $β$, comme demandé.
      ],
    ),
    question(
      [
        Déduire des trois questions précédentes le lemme de pompage affaibli : pour tout langage $L$ reconnu par un automate à pile, il existe $p∈NN$ tel que tout $w∈L$ avec $abs(w)>p$ s'écrive $w=u v x y z$, avec $abs(v y)≥1$ et
        $ ∀n∈NN, #sep u v^n x y^n z∈L. $
      ],
      solution: [
        Prendre $η=η_0+G$ et comme $p$ le nombre d'états de l'automate fini de la question 4.
        Si $w∈cal(L)_(≤η)(A)$, le lemme de l'étoile fournit $w=u v z$, avec $v≠ε$ et $u v^n z∈cal(L)_(≤η)(A)⊂L$. Poser $x=y=ε$.

        Sinon, les questions 5 et 6 donnent deux montagnes imbriquées avec mêmes états d'entrée et de sortie, mêmes sommets d'entrée $γ$ et mêmes sommets de sortie $ρ$.
        Découper $w$ aux positions $l',l'',r'',r'$ en $u,v,x,y,z$.
        Écrivons la pile extérieure d'entrée $P γ$. Comme la pile ne descend jamais à sa hauteur de base à l'intérieur d'une montagne, le préfixe situé strictement sous son sommet reste intact.
        Les quatre piles aux coupures sont donc
        $ P γ, #sep P T γ, #sep P T ρ, #sep P ρ $
        pour un mot non vide $T$ (les hauteurs des deux bases sont distinctes).
        Le segment $v$ transforme un sommet $γ$ en $T γ$ et revient au même état ; $x$ transforme $γ$ en $ρ$ ; $y$ transforme $T ρ$ en $ρ$ et revient au même état de sortie.
        Ces calculs ne consultent pas le préfixe situé en dessous : ils peuvent être réutilisés avec $P T^j$ pour tout $j≥0$.
        Répéter $v$ et $y$ chacun $n$ fois construit donc le calcul
        $ P γ → P T^n γ → P T^n ρ → P ρ, $
        valable aussi pour $n=0$. Les parties $u$ et $z$ restent inchangées, donc le mot obtenu est accepté.
        Enfin $l'<l''$ donne $abs(v)>0$.
      ],
    ),
  ),
)

#import "/load.typ": feuille
#show: feuille.with(
  type: "concours",
  titre: ex.meta.titre,
  niveau: ex.meta.niveaux.join(" / "),
  concours: ex.meta.concours,
  exercices: (ex,),
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
