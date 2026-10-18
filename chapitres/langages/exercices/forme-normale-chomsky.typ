#import "/load.typ": exercice, question
#import "/load.typ": sep

#let ex = exercice(
  meta: (
    titre: "Forme normale de Chomsky et reconnaissance",
    chapitres: ("grammaires-non-contextuelles", "automates-finis", "algorithmique"),
    algorithmes: ("programmation-dynamique",),
    structures: ("tableau",),
    difficulte: 4,
    niveaux: ("MPI",),
  ),
  contenu: (
    [Cet exercice introduit un prolongement du cours.
      Une grammaire $G = (Σ,V,R,S)$ est en forme normale de Chomsky si ses règles sont $X → Y Z$, avec $Y,Z ∈ V$, ou $X → a$, avec $a ∈ Σ$.
      On autorise aussi $S → ε$, à condition que $S$ n'apparaisse dans aucun membre droit.],
    question(
      [
        Soit $G$ une grammaire non-contextuelle telle que $ε ∉ L(G)$.
        Montrer qu'il existe une grammaire en forme normale de Chomsky engendrant $L(G)$.
        Commencer par supprimer les règles d'effacement $X → ε$, puis les règles unitaires $X → Y$.
      ],
      solution: [
        Calculer l'ensemble des variables annulables : partir des $X$ tels que $X → ε$, puis ajouter une variable dès qu'une de ses règles ne contient que des variables déjà annulables.
        Cette procédure termine, car l'ensemble croît dans l'ensemble fini $V$.
        Par induction sur les arbres d'analyse, elle donne exactement les $X$ tels que $X ⇒^* ε$.

        Pour chaque règle, ajouter tous les membres droits non vides obtenus en supprimant un choix quelconque d'occurrences de variables annulables, puis supprimer les règles d'effacement.
        Tout arbre produisant un mot non vide se transforme en supprimant ses sous-arbres de rendement vide.
        Réciproquement, chaque suppression peut être remplacée par une dérivation de $ε$.
        Le langage de l'axiome est donc préservé, puisque $ε ∉ L(G)$.

        Pour chaque $X$, calculer les variables $Y$ accessibles par zéro ou plusieurs règles unitaires.
        Pour chacune, reporter sur $X$ toutes les règles non unitaires de $Y$, puis supprimer les règles unitaires. Un parcours avec marquage traite aussi les cycles.
        Contracter ou développer les chaînes unitaires prouve l'égalité des langages.

        Dans les membres droits de taille au moins $2$, remplacer chaque terminal $a$ par une variable nouvelle $T_a$ et ajouter $T_a → a$.
        Conserver les règles déjà de la forme $X → a$.
        Enfin, remplacer chaque règle $X → X_1 … X_k$, pour $k > 2$, par
        $
          X → X_1 Y_1, #sep Y_1 → X_2 Y_2, #sep …, #sep
          Y_(k-2) → X_(k-1) X_k,
        $
        avec des variables nouvelles propres à cette règle.
        Ces chaînes simulent exactement les règles remplacées.
        Il ne reste que les deux formes requises.
      ],
    ),
    question(
      [
        Donner une grammaire en forme normale de Chomsky pour ${a^n b^n | n ≥ 1}$.
        Combien d'applications de règles comporte une dérivation terminale d'un mot de taille $n ≥ 1$ dans une grammaire en forme normale de Chomsky sans règle d'effacement ?
      ],
      solution: [
        Prendre $S → A B ∣ A C$, $C → S B$, $A → a$ et $B → b$.
        Le choix $S → A B$ termine par $a b$ ; le choix $S → A C$ simule $S → a S b$.
        Cela engendre exactement le langage demandé.

        Pour un mot de taille $n$, il y a $n$ règles terminales.
        Partant d'une variable, chaque règle binaire augmente de $1$ le nombre de variables, et chaque règle terminale le diminue de $1$.
        Il y a donc $n-1$ règles binaires et $2n-1$ applications au total.
      ],
    ),
    question(
      [
        On fixe une grammaire en forme normale de Chomsky sans règle d'effacement, et un mot $w=w_0 … w_(n-1)$, avec $n ≥ 1$.
        Pour $0 ≤ i < j ≤ n$, noter $T(i,j)$ l'ensemble des variables engendrant le facteur $w[i:j]$.
        Donner une récurrence permettant de calculer ces ensembles par tailles croissantes.
        En déduire un algorithme de reconnaissance et justifier ses complexités pour une grammaire fixée.
      ],
      solution: [
        Pour les facteurs d'une lettre,
        $ T(i,i+1) = {X ∈ V | X → w_i ∈ R}. $
        Pour $j-i ≥ 2$,
        $
          T(i,j) = ⋃_(i<k<j)
          {X ∈ V | ∃(X → Y Z) ∈ R, Y ∈ T(i,k), Z ∈ T(k,j)}.
        $
        La première règle d'un arbre produisant un facteur de taille au moins $2$ est binaire.
        Ses deux sous-arbres produisent des facteurs non vides séparés par un indice $k$.
        Réciproquement, toute telle règle et deux dérivations des facteurs donnent une dérivation du facteur entier.
        Une récurrence sur la taille prouve donc la formule.

        Remplir la table par tailles croissantes et tester $S ∈ T(0,n)$.
        Il y a $O(n^2)$ intervalles, $O(n)$ coupures par intervalle, et un nombre constant de règles pour une grammaire fixée.
        Avec des ensembles représentés par des tableaux booléens indexés par les variables, le temps est $O(n^3)$ et l'espace $O(n^2)$.
        Le mot vide est rejeté immédiatement dans ce cas.
      ],
    ),
    question(
      [
        Prolongement : montrer que l'intersection d'un langage non-contextuel avec un langage régulier
        est non-contextuel. Utiliser un automate déterministe et une grammaire en forme normale de Chomsky pour les mots non vides. Une variable $(p,X,q)$ devra engendrer les mots produits par $X$ qui mènent l'automate de $p$ à $q$.
      ],
      solution: [
        Soit l'automate d'états $Q$, d'état initial $q_0$, d'états finaux $F$ et de transition $δ$.
        Pour chaque règle $X → Y Z$ et tous $p,r,q ∈ Q$, ajouter
        $ (p,X,q) → (p,Y,r) (r,Z,q) $
        Pour chaque règle $X → a$ et chaque transition $δ(p,a)=q$, ajouter $(p,X,q) → a$.
        Une induction sur les arbres prouve que $(p,X,q)$ engendre exactement les mots engendrés par $X$ qui conduisent de $p$ à $q$.
        En effet, une concaténation passe par un état intermédiaire $r$, et une lettre correspond à une transition de l'automate.

        Prendre un nouvel axiome $A$ et les règles $A → (q_0,S,f)$ pour $f ∈ F$.
        Elles engendrent exactement les mots non vides de l'intersection.
        Si le mot vide appartient aux deux langages, ajouter $A → ε$.
        La grammaire obtenue est non-contextuelle, même si ses règles d'axiome ne sont pas en forme normale.
      ],
    ),
  ),
)
