#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
    titre: "Mots de Dyck : grammaires et dénombrement",
    chapitres: (
      "grammaires-non-contextuelles",
      "langages-reguliers",
      "recursivite-et-induction",
      "structures",
      "algorithmique",
    ),
    structures: ("pile", "arbre-binaire"),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [Sur $Σ = {a,b}$, un mot $w$ est un mot de Dyck, ou mot bien parenthésé, si :
      - il contient autant de $a$ que de $b$ ;
      - chacun de ses préfixes contient au moins autant de $a$ que de $b$.

      On note $D$ le langage de ces mots et $h(u)=abs(u)_a-abs(u)_b$ la hauteur d'un mot $u$.
      La lettre $a$ représente une parenthèse ouvrante et $b$ une parenthèse fermante.],
    question([Montrer que $D$ n'est pas régulier.], solution: [
      Supposer $D$ régulier et prendre $p ≥ 1$ donné par le lemme de l'étoile.
      Le mot $a^p b^p ∈ D$ s'écrit $x y z$, avec $abs(x y) ≤ p$, $y ≠ ε$ et $x y^i z ∈ D$ pour tout $i ∈ ℕ$.
      Le facteur $y$ ne contient que des $a$ et au moins un.
      Ainsi $x y^2 z$ possède plus de $a$ que de $b$ : contradiction.
    ]),
    question(
      [
        Montrer que tout mot de Dyck non vide se décompose de manière unique sous la forme $a u b v$, où $u,v ∈ D$.
      ],
      solution: [
        Soit $k$ le premier indice strictement positif où la hauteur d'un préfixe redevient nulle.
        Cet indice existe, car la hauteur finale est nulle.
        La première lettre est $a$, la $k$-ième est $b$, et les hauteurs des préfixes de tailles $1$ à $k-1$ sont au moins $1$.
        Poser $u=w_2 … w_(k-1)$ et $v=w_(k+1) … w_(abs(w))$.
        La hauteur totale de $u$ est nulle et ses hauteurs de préfixes sont celles du mot initial diminuées de $1$, donc non négatives. Les préfixes de $v$ reprennent après une hauteur nulle.
        Ainsi $u,v ∈ D$.

        Dans toute décomposition $w=a u b v$ avec $u,v ∈ D$, les préfixes non vides stricts de $a u b$ ont hauteur au moins $1$.
        Le $b$ séparateur se trouve donc au premier retour à zéro : sa position est imposée, ce qui impose $u$ et $v$.
      ],
    ),
    question(
      [
        Soit $G$ la grammaire $S → S S ∣ a S b ∣ ε$. Montrer que $L(G)=D$.
      ],
      solution: [
        $ε$ est de Dyck, et la concaténation de deux mots de Dyck ainsi que l'ajout d'un $a$ au début et d'un $b$ à la fin préservent cette propriété.
        Une induction sur les arbres d'analyse donne donc $L(G) ⊂ D$.

        Réciproquement, raisonner par récurrence forte sur la taille.
        Le mot vide est engendré. Un mot non vide s'écrit $a u b v$, avec $u,v ∈ D$ strictement plus courts. Ils sont engendrés par hypothèse, et
        $ S ⇒ S S ⇒ a S b S ⇒^* a u b v. $
        Ainsi $D ⊂ L(G)$.
      ],
    ),
    question([Montrer que $G$ est ambiguë.], solution: [
      Le mot vide possède les deux dérivations gauches $S ⇒ ε$ et $S ⇒ S S ⇒ S ⇒ ε$.
      Leurs arbres sont différents : la racine a respectivement une règle d'effacement et une règle de concaténation. Cela suffit à établir l'ambiguïté.
    ]),
    question([Donner une grammaire non ambiguë engendrant $D$.], solution: [
      Prendre $S → a S b S ∣ ε$.
      La décomposition unique établie précédemment montre par récurrence sur la taille que chaque mot non vide possède un unique arbre, dont les deux sous-arbres engendrent $u$ et $v$. Le mot vide utilise nécessairement $S → ε$.
      La même décomposition montre que tous les mots de Dyck sont engendrés, et l'induction sur les arbres prouve l'inclusion réciproque.
    ]),
    question(
      [
        Donner une bijection entre les mots de Dyck et les arbres binaires stricts ordonnés, dont chaque nœud possède zéro ou deux fils. Préciser le lien entre la taille du mot et les nombres de nœuds internes et de feuilles.
      ],
      solution: [
        Noter $F$ une feuille et $N(g,d)$ un nœud interne de sous-arbres gauche $g$ et droit $d$.
        Définir
        $ f(ε)=F, #sep f(a u b v)=N(f(u),f(v)). $
        Cette définition est bien fondée grâce à la décomposition unique.
        Son inverse est
        $ g(F)=ε, #sep g(N(t_1,t_2))=a g(t_1) b g(t_2). $
        Des inductions sur les mots et les arbres prouvent que les deux compositions sont l'identité.
        Une paire de lettres correspond à un nœud interne : un mot de taille $2n$ correspond à un arbre de $n$ nœuds internes et de $n+1$ feuilles.
        Le mot vide correspond à une feuille, et non à un arbre vide.
      ],
    ),
    question(
      [
        Soit $C_n$ le nombre de mots de Dyck de taille $2n$.
        Donner $C_0$ et une relation de récurrence. Calculer $C_1,C_2,C_3,C_4$.
      ],
      solution: [
        $C_0=1$. Pour un mot de taille $2(n+1)$, la décomposition $a u b v$ donne $abs(u)=2k$ et $abs(v)=2(n-k)$, avec $0 ≤ k ≤ n$.
        Les choix de $u$ et $v$ sont indépendants et la décomposition est unique, donc
        $ C_(n+1)=sum_(k=0)^n C_k C_(n-k). $
        On obtient $C_1=1$, $C_2=2$, $C_3=5$ et $C_4=14$.
      ],
    ),
    question(
      [
        Après le cours de mathématiques sur les séries entières, montrer que $C_n=1/(n+1) binom(2n, n)$ en utilisant la série génératrice $F(x)=sum_(n=0)^∞ C_n x^n$.
      ],
      solution: [
        Comme $C_n ≤ 4^n$, la série converge au moins pour $abs(x)<1/4$.
        La récurrence et le produit de Cauchy donnent
        $ F(x)=1+x sum_(n=0)^∞ C_(n+1) x^n = 1+x F(x)^2. $
        Pour $x ≠ 0$ assez proche de zéro, la continuité et $F(0)=1$ imposent
        $ F(x)=(1-sqrt(1-4x))/(2x). $
        La formule de Taylor appliquée à $sqrt(1-4x)$ donne
        $
          sqrt(1-4x)=1+sum_(k=1)^∞
          ((-4)^k/k! ∏_(j=0)^(k-1)(1/2-j)) x^k.
        $
        En identifiant le coefficient de $x^n$ dans $F(x)$, on obtient
        $
          C_n=-(-4)^(n+1)/(2(n+1)!) ∏_(j=0)^n(1/2-j)
          =2^n/(n+1)! ∏_(j=1)^n(2j-1).
        $
        Le produit vide vaut $1$ lorsque $n=0$.
        Comme $∏_(j=1)^n(2j-1)=(2n)!/(2^n n!)$, il vient
        $ C_n=(2n)!/(n!(n+1)!)=1/(n+1) binom(2n, n). $
      ],
    ),
    question(
      [
        Variante sans séries entières : parmi les mots contenant $n$ lettres $a$ et $n$ lettres $b$, transformer ceux qui ne sont pas de Dyck en échangeant $a$ et $b$ dans leur premier préfixe de hauteur $-1$.
        Montrer que cette transformation est une bijection avec les mots contenant $n+1$ lettres $a$ et $n-1$ lettres $b$, puis retrouver la formule de $C_n$.
      ],
      solution: [
        Pour $n ≥ 1$, tout mot équilibré qui n'est pas de Dyck atteint la hauteur $-1$.
        Son premier préfixe de hauteur $-1$ contient un $b$ de plus que de $a$.
        L'échange ajoute donc un $a$ et retire un $b$ dans le mot entier.
        Les hauteurs des préfixes stricts de la partie échangée étaient non négatives :
        après échange, elles sont non positives, et la fin de cette partie est le premier passage à $1$.

        Réciproquement, un mot avec $n+1$ lettres $a$ et $n-1$ lettres $b$ finit à hauteur $2$
        et possède donc un premier préfixe de hauteur $1$.
        Échanger les lettres dans ce préfixe redonne un mot équilibré dont le premier passage à $-1$ termine ce préfixe. Les deux opérations sont inverses.
        Il y a donc $binom(2n, n-1)$ mots équilibrés non Dyck, d'où
        $ C_n=binom(2n, n)-binom(2n, n-1)=1/(n+1) binom(2n, n). $
        Pour $n=0$, la formule donne également $C_0=1$.
      ],
    ),
    question(
      [
        On autorise plusieurs sortes de parenthèses, par exemple `()`, `[]` et `{}`.
        Décrire un algorithme en temps linéaire pour reconnaître les mots bien parenthésés.
        Pourquoi un simple compteur ne suffit-il plus ?
      ],
      solution: [
        Parcourir le mot en maintenant une pile des parenthèses ouvrantes non encore refermées.
        Empiler chaque ouvrante. Pour une fermante, rejeter si la pile est vide ou si son sommet est d'un autre type, sinon dépiler.
        Accepter à la fin exactement si la pile est vide.
        La pile mémorise dans leur ordre d'imbrication les ouvertures en attente :
        chaque fermante doit correspondre à la dernière ouverture.
        Cet invariant prouve la correction.

        Chaque lettre effectue un nombre constant d'opérations de pile, donc le temps est $O(n)$ et l'espace auxiliaire $O(n)$ dans le pire cas.
        Un compteur perd les types : `([)]` ne devient jamais négatif et finit à zéro, mais n'est pas bien parenthésé.
      ],
    ),
    question(
      [
        Décrire un algorithme en temps linéaire pour trouver la taille du plus long facteur bien parenthésé d'un mot sur ${a,b}$. La réponse vaut zéro si aucun facteur non vide ne convient.
      ],
      solution: [
        Numéroter les lettres de $0$ à $n-1$.
        Maintenir une pile d'indices, initialement réduite à $[-1]$, et un maximum initialement nul.
        Sa base est l'indice de la dernière fermante impossible à apparier, ou $-1$ au départ.
        Au-dessus figurent les indices des ouvrantes encore en attente.

        À l'indice $i$, si la lettre est $a$, empiler $i$.
        Si c'est $b$, dépiler une fois.
        Si la pile devient vide, remettre $i$ comme nouvelle base : cette fermante ne peut être appariée.
        Sinon, noter $j$ le sommet et actualiser le maximum avec $i-j$.

        Dans le dernier cas, l'ouverture appariée vient d'être retirée et le facteur entre $j+1$ et $i$ est bien parenthésé.
        Il est le plus long facteur bien parenthésé finissant à $i$ : le prolonger vers la gauche ferait franchir soit une fermante non appariée, soit une ouvrante encore non refermée.
        Tout facteur non vide de Dyck finit par $b$ : le maximum calculé est donc celui demandé.
        Chaque indice est empilé et dépilé au plus une fois, d'où un temps $O(n)$ et un espace $O(n)$.
        Pour le mot vide, le parcours n'effectue rien et renvoie zéro.
      ],
    ),
  ),
)
