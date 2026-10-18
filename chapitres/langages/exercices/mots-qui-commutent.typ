#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Mots qui commutent",
    chapitres: ("langages-reguliers",),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    question(
      [
        Soient $u$ et $v$ deux mots *non vides*.
        Montrer que les trois conditions suivantes sont équivalentes :
        + $u v = v u$
        + Il existe un mot $w$ et des entiers $k, p in NN$ tels que $u = w^k$ et $v = w^p$.
        + Il existe $m, n in NN^*$ tels que $u^m = v^n$.
      ],
      solution: [
        *$2 ==> 1$.* On a $u v = w^k w^p = w^(k+p) = w^p w^k = v u$.

        *$1 ==> 2$.* On raisonne par récurrence forte sur $abs(u)+abs(v)$.
        Si $abs(u)=abs(v)$, les premières lettres de $u v = v u$ donnent $u=v$ ; on prend $w=u$ et $k=p=1$.
        Cela traite notamment le cas initial $abs(u)+abs(v)=2$.

        Sinon, supposons $abs(u)<abs(v)$, l'autre cas étant symétrique.
        Comme $u v = v u$, le mot $u$ est préfixe de $v$ : il existe un mot non vide $v'$ tel que $v=u v'$.
        Ainsi $u^2 v'=u v' u$, puis $u v'=v' u$ par simplification du préfixe $u$.
        Comme $abs(u)+abs(v')<abs(u)+abs(v)$, l'hypothèse de récurrence donne $u=w^k$ et $v'=w^p$, avec $k,p>=1$.
        Alors $v=w^(k+p)$.

        *$2 ==> 3$.* Puisque $u$ et $v$ ne sont pas vides, $k,p>=1$.
        Avec $m=p$ et $n=k$, on obtient $u^m=w^(k p)=v^n$.

        *$3 ==> 2$.* Posons $d=gcd(abs(u), abs(v))$, $abs(u)=d p$ et $abs(v)=d q$,
        avec $gcd(p, q)=1$.
        On découpe $u=U_0 dots U_(p-1)$ et $v=V_0 dots V_(q-1)$ en blocs de taille $d$.
        La taille commune $N=m abs(u)=n abs(v)$ est un multiple commun de $abs(u)$ et $abs(v)$, donc $N>=d p q$.
        Les $p q$ premiers blocs de $u^m$ et de $v^n$ coïncident :
        $ U_(t mod p) = V_(t mod q) quad (0 <= t < p q). $
        Le théorème des restes chinois assure que, pour tous $0<=i<p$ et $0<=j<q$, il existe $0<=t<p q$ avec $t equiv i (mod p)$ et $t equiv j (mod q)$.
        Donc $U_i=V_j$ pour tout couple $(i,j)$ : tous les blocs sont égaux, et $u=U_0^p$, $v=U_0^q$.
      ],
    ),
  ),
)
