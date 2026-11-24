#import "/load.typ": exercice, question, sep, widetilde

#let ex = exercice(
  meta: (
    titre: "Grammaires linéaires à droite et à gauche",
    chapitres: ("grammaires-non-contextuelles", "langages-reguliers", "automates-finis"),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
)[
  Une grammaire non-contextuelle $G = (Σ, V, R, S)$ est dite _linéaire à droite_ si chacune de ses règles est de la forme $X ⟶ u Y$ ou $X ⟶ u$, avec $X, Y ∈ V$ et $u ∈ Σ^*$. Elle est dite _linéaire à gauche_ si chacune de ses règles est de la forme $X ⟶ Y u$ ou $X ⟶ u$.

  #question[
    On fixe $Σ = {a, b}$ et la grammaire linéaire à droite $G_1$ d'axiome $S$ et de règles $S ⟶ a a S ∣ b$. Déterminer le langage $L = cal(L)(G_1)$ en justifiant les deux inclusions, puis donner une expression régulière et une grammaire linéaire à droite pour son complémentaire $Σ^* ∖ L$.
  ][
    Montrons que $L = (a a)^* b$.
    - *Inclusion $cal(L)(G_1) ⊂ (a a)^* b$* : montrons par récurrence sur $k ≥ 1$ que si $S ⇒^k w$ avec $w ∈ Σ^*$ alors $w ∈ (a a)^* b$. Pour $k = 1$, la seule dérivation terminale est $S ⇒ b ∈ (a a)^* b$. Si $S ⇒^(k + 1) w$, la première règle est $S ⟶ a a S$, donc $w = a a u$ avec $S ⇒^k u$. Par hypothèse de récurrence, $u ∈ (a a)^* b$, d'où $w ∈ (a a)^* b$.
    - *Inclusion $(a a)^* b ⊂ cal(L)(G_1)$* : pour tout $n ∈ NN$, appliquer $n$ fois $S ⟶ a a S$ puis $S ⟶ b$ produit $(a a)^n b$.

    Tout mot de $Σ^*$ appartient soit à $a^*$, soit s'écrit de manière unique $a^k b w$ avec $k ∈ NN$ et $w ∈ Σ^*$. Il appartient à $L$ exactement lorsque $k$ est pair et $w = ε$. Son complémentaire $Σ^* ∖ L$ est donc dénoté par l'expression régulière :
    $ a^* ∣ a (a a)^* b (a ∣ b)^* ∣ (a a)^* b (a ∣ b) (a ∣ b)^*. $

    On peut aussi construire l'ADC reconnaissant $L$ (quatre états : $q_0$ initial pour un nombre pair de $a$, $q_1$ pour un nombre impair de $a$, $q_2$ final après un premier $b$ depuis $q_0$, et $q_3$ puits), puis inverser les états finaux pour reconnaître $Σ^* ∖ L$ avec les états finaux ${q_0, q_1, q_3}$. On en déduit la grammaire linéaire à droite d'axiome $Q_0$ :
    $
      Q_0 & ⟶ a Q_1 ∣ b Q_2 ∣ ε \
      Q_1 & ⟶ a Q_0 ∣ b Q_3 ∣ ε \
      Q_2 & ⟶ a Q_3 ∣ b Q_3 \
      Q_3 & ⟶ a Q_3 ∣ b Q_3 ∣ ε
    $
    (ou, plus directement, $S ⟶ a a S ∣ ε ∣ a ∣ a b P ∣ b a P ∣ b b P$ et $P ⟶ a P ∣ b P ∣ ε$).
  ]

  #question[
    Montrer que tout langage engendré par une grammaire linéaire à droite est régulier.
  ][
    Soit $G = (Σ, V, R, S)$ une grammaire linéaire à droite. Construisons un automate fini avec $ε$-transitions $A$ d'état initial $S$, contenant les états de $V$ ainsi qu'un nouvel état final $f ∉ V$ :
    - Pour chaque règle $X ⟶ a_1 … a_k Y$ avec $k ≥ 1$, on ajoute $k - 1$ états intermédiaires neufs $p_1, …, p_(k - 1)$ propres à cette règle et les transitions $(X, a_1, p_1), (p_1, a_2, p_2), …, (p_(k - 1), a_k, Y)$ (ou simplement $(X, a_1, Y)$ si $k = 1$).
    - Pour chaque règle $X ⟶ Y$ (cas $u = ε$), on ajoute une $ε$-transition $(X, ε, Y)$.
    - Pour chaque règle $X ⟶ a_1 … a_k$ avec $k ≥ 1$, on relie de même $X$ à $f$ par une chaîne de $k$ transitions étiquetées $a_1, …, a_k$.
    - Pour chaque règle $X ⟶ ε$, on ajoute une $ε$-transition $(X, ε, f)$ (ou l'on rend $X$ final).

    Chaque chemin acceptant de $S$ vers $f$ correspond exactement à une succession de règles menant de $S$ à un mot terminal, et réciproquement. Ainsi $cal(L)(A) = cal(L)(G)$, et par le théorème de Kleene (après élimination des $ε$-transitions), le langage $cal(L)(G)$ est régulier.
  ]

  #question[
    En déduire qu'un langage est régulier si et seulement s'il est engendré par une grammaire linéaire à droite.
  ][
    Le sens réciproque est établi à la question 2. Réciproquement, tout langage régulier est reconnu par un automate fini, donc engendré par une grammaire régulière à droite (règles $X ⟶ a Y$, $X ⟶ a$ ou $X ⟶ ε$), qui est en particulier linéaire à droite.
  ]

  #question[
    Montrer que les langages engendrés par les grammaires linéaires à gauche sont également exactement les langages réguliers.
  ][
    Soit $G = (Σ, V, R, S)$ une grammaire linéaire à gauche. Notons $G'$ la grammaire obtenue en remplaçant chaque règle $X ⟶ α$ par $X ⟶ widetilde(α)$, où $widetilde(α)$ désigne le miroir du mot $α$.
    - Chaque règle $X ⟶ Y u$ devient $X ⟶ widetilde(u) Y$ et chaque règle $X ⟶ u$ devient $X ⟶ widetilde(u)$, donc $G'$ est linéaire à droite.
    - Comme établi en cours, $cal(L)(G') = widetilde(cal(L)(G))$.
    - D'après la question 3, $cal(L)(G')$ est régulier. Les langages réguliers étant stables par miroir (en inversant les transitions d'un automate et en échangeant états initiaux et finaux), $cal(L)(G) = widetilde(cal(L)(G'))$ est régulier.

    Réciproquement, si $L$ est régulier, alors $widetilde(L)$ est régulier, donc engendré par une grammaire linéaire à droite $G'$ d'après la question 3. En renversant les membres droits des règles de $G'$, on obtient une grammaire linéaire à gauche engendrant $widetilde(widetilde(L)) = L$.
  ]

  #question[
    Montrer sur un exemple qu'une grammaire contenant à la fois des règles linéaires à droite et des règles linéaires à gauche peut engendrer un langage non régulier.
  ][
    Sur $Σ = {a, b}$, considérons la grammaire d'axiome $S$ et de règles :
    $ S ⟶ a T ∣ ε, #sep T ⟶ S b. $
    Toute dérivation terminale alterne des paires $S ⇒ a T ⇒ a S b$, puis termine par $S ⟶ ε$, ce qui engendre exactement $L = {a^n b^n ∣ n ∈ NN}$.

    Si $L$ était régulier, le lemme de l'étoile fournirait un entier $p ≥ 1$ et une décomposition $a^p b^p = x y z$ avec $abs(x y) ≤ p$, $abs(y) ≥ 1$ et $x y^k z ∈ L$ pour tout $k ∈ NN$. Alors $y = a^t$ avec $t ≥ 1$, donc $x z = a^(p - t) b^p ∉ L$, contradiction. Ainsi $L$ n'est pas régulier.
  ]
]
