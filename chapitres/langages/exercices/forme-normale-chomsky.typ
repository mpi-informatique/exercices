#import "/load.typ": exercice, question, theoremes, tp
#import "/load.typ": sep
#import theoremes: algorithme, commentaire

#let definition = [Une grammaire $G = (Σ, V, R, S)$ est en forme normale de Chomsky si toutes ses règles sont de la forme $X ⟶ Y Z$, $X ⟶ a$ ou $S ⟶ ε$, où $X, Y, Z ∈ V$, $Y ≠ S$, $Z ≠ S$ et $a ∈ Σ$.]

#let ex = exercice(
  meta: (
    titre: "Forme normale de Chomsky",
    chapitres: ("grammaires-non-contextuelles", "automates-finis", "algorithmique"),
    algorithmes: ("programmation-dynamique",),
    structures: ("tableau",),
    difficulte: 4,
    niveaux: ("MPI",),
  ),
  contenu: (
    definition,
    question(
      [
        Soit $G$ une grammaire non-contextuelle.
        Décrire un algorithme pour construire une grammaire en forme normale de Chomsky équivalente à $G$.
      ],
      solution: [
        - Suppression des $X → ε$ pour $X ≠ S$ :
          - Calculer l'ensemble $E = {X ∈ V | X ⇒^* ε}$ des variables engendrant $ε$ :#v(-0.5em)
            #algorithme[
              - $E$ ← ∅ #commentaire[Invariant : $E ⊆ {X ∈ V | X ⇒^* ε}$]
              - *Tant que* $E$ croît : #commentaire[$|E|$ est un variant strictement croissant, majoré par $|V|$]
                - Pour chaque règle $X → α$ :
                  - *Si* $α ∈ E^*$ : ajouter $X$ à $E$.
            ]
          - Pour chaque règle $X → α$, ajouter toutes les règles possibles de la forme $X → β$ où $β$ est obtenu à partir de $α$ en supprimant un nombre quelconque de variables de $E$.
          - Supprimer toutes les règles $X → ε$ sauf éventuellement $S → ε$.
        - Suppression des règles unitaires $X → Y$ :
          - Pour chaque $X ∈ V$, un parcours donne l'ensemble $U(X)$ des variables accessibles par des règles unitaires.
          - Remplacer les règles unitaires par les règles $X → α$ telles que $Y → α$ est non unitaire et $Y ∈ U(X)$.

        - Isolement des terminaux :
          Dans les membres droits de taille au moins $2$, remplacer chaque terminal $a$ par une variable nouvelle $T_a$, avec la règle $T_a → a$.
          Conserver les règles de la forme $X → a$.
        - Réduction aux règles binaires :
          Remplacer chaque règle $X → X_1 … X_k$, avec $k > 2$, par :
          $
            X → X_1 Y_1, #sep Y_1 → X_2 Y_2, #sep …, #sep
            Y_(k-2) → X_(k-1) X_k,
          $
          où les $Y_i$ sont des nouvelles variables.
      ],
    ),
    question(
      [
        Donner une grammaire en forme normale de Chomsky pour $L = {a^n b^n | n ≥ 1}$.
      ],
      solution: [
        $L$ est engendré par : $S → A B ∣ A C, #sep C → S B, #sep A → a, #sep B → b$.
      ],
    ),
    question(
      [
        Soit $G$ une grammaire en forme normale de Chomsky dérivant $S ⇒^p m$.
        Exprimer $p$ en fonction de $n = abs(m)$.
      ],
      solution: [
        Pour un mot de taille $n$, il y a $n$ règles terminales.
        Partant d'une variable, chaque règle binaire augmente de $1$ le nombre de variables, et chaque règle terminale le diminue de $1$.
        Il y a donc $n-1$ règles binaires et $p = 2n-1$.
      ],
    ),
    tp[#underline[Remarque] : L'algorithme CYK permet de tester par programmation dynamique si un mot $m$ est engendré par une grammaire en forme normale de Chomsky, en temps $O(|m|^3)$.],
  ),
)
