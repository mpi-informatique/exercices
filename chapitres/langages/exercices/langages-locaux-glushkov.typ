#import "/load.typ": automate
#import automate: rayon-etat, rayon-grand-etat, style-automates, unite-automates
#import "/load.typ": exercice, question
#import "/load.typ": sep
#import "@preview/finite:0.5.1" as finite
#import "@preview/cetz:0.4.2" as cetz

#let ex = exercice(
  meta: (
    titre: "Langage local, linéaire et automate de Glushkov",
    chapitres: ("langages-reguliers", "automates-finis"),
    algorithmes: ("berry-sethi",),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    question([Construire l'automate de Glushkov reconnaissant $(a b | b)^* b$.], solution: [
      On linéarise l'expression en $(a_1 b_2 | b_3)^* b_4$.
      On obtient
      $ P = {a_1,b_3,b_4}, $
      $ S = {b_4} $
      $ F = {a_1 b_2, b_2 a_1, b_2 b_3, b_2 b_4, b_3 a_1, b_3 b_3, b_3 b_4}. $
      #align(center, cetz.canvas(length: unite-automates, {
        import finite.draw: state, transition
        cetz.draw.set-style(..style-automates)
        state((0, 0), "0", label: $0$, initial: (label: none))
        state((3, 2), "a1", label: $a_1$)
        state((6, 2), "b2", label: $b_2$)
        state((4.5, -2), "b3", label: $b_3$)
        state((9, 0), "b4", label: $b_4$, final: true)
        transition("0", "a1", label: $a$, curve: 0)
        transition("0", "b3", label: $b$, curve: 0)
        // Passer sous l'état central et sa boucle pour dégager l'étiquette.
        transition("0", "b4", label: (text: $b$, dist: -0.33), curve: -6.2)
        transition("a1", "b2", label: $b$, curve: 0.4)
        transition("b2", "a1", label: $a$, curve: 0.4)
        transition("b2", "b3", label: $b$, curve: 0)
        transition("b2", "b4", label: $b$, curve: 0)
        transition("b3", "a1", label: $a$, curve: 0)
        transition("b3", "b3", label: $b$, anchor: bottom)
        transition("b3", "b4", label: $b$, curve: 0)
      }))
    ]),
    question(
      [
        Montrer que si $L_1$ et $L_2$ sont locaux alors $L_1 ∩ L_2$ est local
        (même si les alphabets ne sont pas disjoints, contrairement à l'union
        et à la concaténation vues en cours).
      ],
      solution: [
        Posons $L = L_1 ∩ L_2$ et travaillons sur l'alphabet $Σ$ obtenu, si nécessaire, en réunissant les deux alphabets.
        Puisque tout mot de $L$ appartient à $L_1$ et à $L_2$, on a
        $ P(L) ⊂ P(L_1) ∩ P(L_2), #sep S(L) ⊂ S(L_1) ∩ S(L_2), $
        $ F(L) ⊂ F(L_1) ∩ F(L_2). $

        Soit $u = u_1 … u_n in Sigma^*$ avec $n ≥ 1$.
        Supposons que $u_1 ∈ P(L)$, $u_n ∈ S(L)$ et que tous les facteurs $u_k u_(k+1)$ de taille deux de $u$ appartiennent à $F(L)$.

        Les inclusions précédentes donnent, pour chaque $i ∈ {1,2}$ :
        $
          u_1 ∈ P(L_i), #sep u_n ∈ S(L_i), #sep
          ∀ k ∈ {1, …, n-1}, u_k u_(k+1) ∈ F(L_i).
        $
        Comme $L_i$ est local, ces conditions entraînent $u ∈ L_i$.
        Ainsi $u ∈ L_1$ et $u ∈ L_2$, donc $u ∈ L$.

        Enfin, $ε ∈ L$ si et seulement si $ε ∈ L_1$ et
        $ε ∈ L_2$. Le langage $L = L_1 ∩ L_2$ est donc local.
      ],
    ),
    question(
      [
        Montrer qu'il existe un nombre fini de langages locaux sur un alphabet fixé.
      ],
      solution: [
        Tout langage local est de la forme
        $ (P Σ^* ∩ Σ^* S) ∖ Σ^* N Σ^* $
        où $P ⊂ Σ$, $S ⊂ Σ$, $N ⊂ Σ × Σ$, en rajoutant éventuellement $ε$.
        Si $n = abs(Σ)$, il y a au plus $2^n$ choix pour $P$, $2^n$ pour $S$ et $2^(n^2)$ pour $N$, car $abs(Σ × Σ) = n^2$.
        Il y a donc au plus $2^n × 2^n × 2^(n^2)$ valeurs différentes pour l'ensemble $(P Σ^* ∩ Σ^* S) ∖ Σ^* N Σ^*$, et au plus $2^(n^2 + 2n + 1)$ langages locaux en tenant compte du choix d'ajouter $ε$.
      ],
    ),
    question(
      [
        Soient $cal(L)_"reg"$, $cal(L)_"loc"$, $cal(L)_"lin"$ les ensembles des langages réguliers, locaux et linéaires (c'est-à-dire décrits par une expression régulière linéaire). Quelles sont les inclusions entre ces trois ensembles ? Ces inclusions sont-elles strictes ?
      ],
      solution: [
        D'après le cours, tout langage décrit par une expression régulière linéaire est local. Tout langage local est reconnaissable, donc régulier par le théorème de Kleene. Ainsi
        $ cal(L)_"lin" ⊂ cal(L)_"loc" ⊂ cal(L)_"reg". $
        Les deux inclusions sont strictes dès que l'alphabet contient une lettre $a$.

        Le langage $L = {a^n | n ≥ 1}$ est local : les premières et dernières lettres sont $a$, le seul facteur autorisé de taille deux est $a a$, et $ε$ est exclu. Il n'est pas linéaire. En effet, dans une expression linéaire produisant $a a$, l'unique occurrence de $a$ doit être répétée par une étoile. Considérons l'étoile la plus extérieure contenant cette
        occurrence. Dans cette production, tout ce qui lui est extérieur produit le mot vide, puisqu'il ne contient aucune autre occurrence
        de $a$. En prenant zéro répétition, on produirait donc aussi $ε$, ce qui est impossible pour $L$.

        Le langage dénoté par $(a a)^*$ est régulier mais pas local : puisque $a a$ appartient au langage, ses ensembles de premières et dernières lettres contiennent $a$. La condition locale accepterait alors aussi le mot $a$ (qui n'a aucun facteur de taille deux), alors que sa taille est impaire.
        Sur l'alphabet vide, les trois familles coïncident avec ${∅, {ε}}$.
      ],
    ),
  ),
)
