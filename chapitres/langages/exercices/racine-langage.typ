#import "/load.typ": exercice, question

#let ex = exercice(
  meta: (
    titre: "Racine d'un langage",
    chapitres: ("langages-reguliers", "automates-finis"),
    difficulte: 3,
    niveaux: ("MPI",),
  ),
  contenu: (
    [Soit $L$ un langage régulier sur un alphabet $Σ$.
      On définit $sqrt(L)={u ∈ Σ^* | u^2 ∈ L}$ et $L_2={u^2 | u ∈ L}$.],
    question([Est-il toujours vrai que $L^2=L_2$ ?], solution: [
      Non. Pour $L = {a, b}$ sur $Σ = {a, b}$, on a $L^2 = {a a, a b, b a, b b}$, tandis que $L_2 = {a a, b b}$.
      En général, $L_2 ⊆ L^2$, mais les deux facteurs d'un mot de $L^2$ peuvent être différents.
    ]),
    question([Montrer que $sqrt(L)$ est régulier.], solution: [
      Soit $A = (Q, Σ, δ, q_0, F)$ un ADC reconnaissant $L$.
      On note $δ^*$ sa fonction de transition étendue aux mots.
      Pour $p, q ∈ Q$, on pose $K_(p, q) = {u ∈ Σ^* | δ^*(p, u) = q}$.
      Ce langage est régulier : il est reconnu par l'automate obtenu à partir de $A$ en prenant $p$ pour état initial et $q$ pour unique état final.

      Un mot $u$ appartient à $sqrt(L)$ si et seulement s'il existe $q ∈ Q$ et $f ∈ F$ tels que $δ^*(q_0, u) = q$ et $δ^*(q, u) = f$.
      En effet, $δ^*(q_0, u u) = δ^*(δ^*(q_0, u), u)$.
      Ainsi :
      $ sqrt(L) = union.big_(q ∈ Q) union.big_(f ∈ F) (K_(q_0, q) ∩ K_(q, f)). $
      Les langages réguliers étant stables par intersection et union finie, $sqrt(L)$ est régulier.
    ]),
    question([Montrer que $L_2$ n'est pas forcément régulier.], solution: [
      Sur $Σ = {a, b}$, prendre le langage régulier $L = {a^n b | n ∈ ℕ}$, dénoté par $a^* b$.
      Alors $L_2 = {a^n b a^n b | n ∈ ℕ}$.

      Supposons qu'un ADC à $N$ états reconnaisse $L_2$.
      Parmi les $N + 1$ mots $ε, a, …, a^N$, deux mots $a^i$ et $a^j$, avec $i < j$, conduisent au même état.
      En leur ajoutant le même suffixe $b a^i b$, on obtient donc deux mots ayant le même statut d'acceptation.
      Or $a^i b a^i b ∈ L_2$, tandis que $a^j b a^i b ∉ L_2$, puisque $i ≠ j$.
      C'est une contradiction, donc $L_2$ n'est pas régulier.
    ]),
    question([Est-il toujours vrai que $sqrt(L_2)=L$ ?], solution: [
      Oui. Si $u ∈ L$, alors $u^2 ∈ L_2$, donc $u ∈ sqrt(L_2)$.

      Réciproquement, si $u ∈ sqrt(L_2)$, il existe $v ∈ L$ tel que $u^2 = v^2$.
      L'égalité des tailles donne $abs(u) = abs(v)$.
      En prenant les préfixes de cette taille dans $u^2 = v^2$, on obtient $u = v$, donc $u ∈ L$.
      Ainsi $sqrt(L_2) = L$.
    ]),
    question([Est-il toujours vrai que $sqrt(L)^2=L$ ?], solution: [
      Non. Pour $L = {a}$, aucun carré de mot n'appartient à $L$, car la taille d'un carré est paire.
      Ainsi $sqrt(L) = ∅$, puis $sqrt(L)^2 = ∅ ≠ L$.
    ]),
  ),
)
