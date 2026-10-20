#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Taille discriminante",
    chapitres: ("automates-finis", "langages-reguliers"),
    algorithmes: ("parcours-en-largeur",),
    structures: ("graphe", "file"),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
  contenu: (
    [Les automates sont sans transitions $ε$.],
    question(
      [Soit $A$ un automate. Décrire un algorithme pour déterminer la plus petite taille d'un mot reconnu par $A$ et préciser sa complexité.],
      solution: [
        Effectuer un parcours en largeur depuis tous les états initiaux, à distance $0$.
        La première distance d'un état final est la taille cherchée ; si aucun n'est atteint, le langage est vide.
        Avec des listes d'adjacence, chaque état et chaque transition sont traités au plus une fois :
        temps $O(n+p)$ pour $n$ états et $p$ transitions, espace auxiliaire $O(n)$.
      ],
    ),
    question(
      [Soit $A$ un automate à $n$ états et de langage $cal(L)(A)$.
        Montrer que $cal(L)(A)=∅$ si et seulement si $cal(L)(A)$ ne contient aucun mot de taille strictement inférieure à $n$.],
      solution: [
        $==>$ : immédiat.

        $⇐$ : supposons $cal(L)(A)≠∅$ et choisissons un mot accepté $u$ de taille minimale.
        Si $abs(u)≥n$, son chemin acceptant passe par au moins $n+1$ occurrences d'états.
        Deux sont égales par le principe des tiroirs. Supprimer le cycle entre elles donne un chemin acceptant de longueur strictement plus petite, contradiction.
        Ainsi $abs(u)<n$. Si $n=0$, il n'existe aucun chemin acceptant et le résultat reste valable.
      ],
    ),
    question(
      [
        Soient $A_1=(Σ,Q_1,i_1,F_1,δ_1)$ et $A_2=(Σ,Q_2,i_2,F_2,δ_2)$ deux automates déterministes complets à $n_1$ et $n_2$ états, de langages $L_1≠L_2$.
        Notons $l(L_1,L_2)$ la plus petite taille d'un mot appartenant à l'un des deux langages mais pas à l'autre.
        Montrer que $l(L_1,L_2)<n_1 n_2$.
      ],
      solution: [
        Le produit d'états $Q_1×Q_2$, initial $(i_1,i_2)$, de transition $δ((q_1,q_2),a)=(δ_1(q_1,a),δ_2(q_2,a))$ et de finaux $(F_1×(Q_2∖F_2))∪((Q_1∖F_1)×F_2)$ reconnaît $L_1 △ L_2$.
        Ce langage est non vide et le produit possède $n_1 n_2$ états.
        La question 2 donne un mot distinguant de taille strictement inférieure à $n_1 n_2$.
      ],
    ),
  ),
)
