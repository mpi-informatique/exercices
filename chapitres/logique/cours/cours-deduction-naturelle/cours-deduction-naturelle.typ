#import "/load.typ": (
  article-only, colonnes-cours, cours-et-presentation, est-corrige, est-presentation, formules-reparties, hp, pause,
  slide, slides-only, solution, taille-presentation, theoremes, uncover,
)
#import "@preview/curryst:0.6.0": prooftree, rule
#import "regles.typ": arbre, tableau-regles
#import "semantique-ouverts.typ": ex as semantique-ouverts
#import theoremes: corollaire, definition, exercice, theoreme

#show: cours-et-presentation.with(titre: "Déduction naturelle", niveau: "MPI")

// TODO : Théorème de compacité
// https://chatgpt.com/share/6aedca09-89bc-83ed-8d0a-6c33ab0c3cb3?ogimg=plain

= Systèmes formels

#definition[Système formel][
  Un _système formel_ est donné par :
  - Des _jugements_, énoncés que l'on cherche à établir
  - Des _règles d'inférence_ permettant de déduire des jugements à partir d'autres jugements
]

#slides-only[== Règles d'inférence]

#colonnes-cours(
  columns: (1.75fr, 1fr),
  [
    #definition[Règle d'inférence][
      Une _règle d'inférence_ contient des _prémisses_ $J_1, …, J_n$ et une _conclusion_ $J$.\
      Une règle sans prémisse est appelée _axiome_.
    ]
  ],
  [
    #figure(
      arbre[#prooftree(rule([$J_1$], [$…$], [$J_n$], [$J$]))],
      caption: [Représentation d'une règle d'inférence],
    )
  ],
)

#underline[Intuitivement] : si les prémisses sont toutes prouvables, alors la conclusion est prouvable.

#slides-only[== Preuves]

#definition[Preuve][
  Dans un système formel, une _preuve_ (ou _arbre de preuve_, _dérivation_) est un arbre fini dont chaque nœud est une application d'une règle d'inférence.

  Les feuilles sont donc des applications d'axiomes. Le jugement à la racine est la _conclusion_ de la preuve. Un jugement est _prouvable_ (ou _dérivable_) s'il possède une preuve.
]

#underline[Remarque] : on dessine habituellement un arbre de preuve avec la racine en bas.

#{
  let exemples = (
    (
      exemple: [Grammaire : $S ⟶ a S b S | ε$],
      jugement: [$S ⇒^* u$ : « $S$ engendre le mot $u$ », avec $u ∈ {a, b}^*$],
      regles: [
        #formules-reparties(
          prooftree(rule([$S ⇒^* ε$])),
          prooftree(rule([$S ⇒^* u$], [$S ⇒^* v$], [$S ⇒^* a u b v$])),
        )
      ],
      preuve: [
        #arbre[#prooftree(rule(
          rule(rule([$S ⇒^* ε$]), rule([$S ⇒^* ε$]), [$S ⇒^* a b$]),
          rule([$S ⇒^* ε$]),
          [$S ⇒^* a a b b$],
        ))]
      ],
    ),
    (
      exemple: [Évaluation d'expressions arithmétiques],
      jugement: [$e ⇓ n$ : « l'expression $e$ s'évalue en $n ∈ ℕ$ »],
      regles: [
        #formules-reparties(
          prooftree(rule([$n ⇓ n$])),
          prooftree(rule([$e_1 ⇓ n_1$], [$e_2 ⇓ n_2$], [$e_1 + e_2 ⇓ n_1 + n_2$])),
          prooftree(rule([$e_1 ⇓ n_1$], [$e_2 ⇓ n_2$], [$e_1 × e_2 ⇓ n_1 n_2$])),
        )
      ],
      preuve: [
        #arbre[#prooftree(rule(
          rule(rule([$2 ⇓ 2$]), rule([$3 ⇓ 3$]), [$2 + 3 ⇓ 5$]),
          rule([$4 ⇓ 4$]),
          [$(2 + 3) × 4 ⇓ 20$],
        ))]
      ],
    ),
  )
  let tableau(exemples) = table(
    columns: (auto,) + (1fr,) * exemples.len(),
    align: center + horizon,
    inset: (x: 0.5em, y: 0.4em),
    stroke: none,
    ..range(1, exemples.len() + 1).map(x => table.vline(x: x, stroke: 0.5pt + gray)),
    table.hline(y: 1, stroke: 0.4pt + luma(190)),
    table.hline(y: 2, stroke: 0.4pt + luma(190)),
    table.hline(y: 3, stroke: 0.4pt + luma(190)),
    [*Exemple*], ..exemples.map(exemple => exemple.exemple),
    [*Jugement*], ..exemples.map(exemple => exemple.jugement),
    [*Règles*], ..exemples.map(exemple => exemple.regles),
    [*Preuve*], ..exemples.map(exemple => exemple.preuve),
  )
  if est-presentation() {
    let titres = ([Exemple : grammaire], [Exemple : évaluation arithmétique])
    for (i, exemple) in exemples.enumerate() {
      heading(depth: 2, titres.at(i))
      let etapes = (
        ..exemple,
        regles: uncover("2-", exemple.regles),
        preuve: uncover("3-", exemple.preuve),
      )
      tableau((etapes,))
      pause
      pause
    }
  } else {
    tableau(exemples)
  }
}

= Déduction naturelle

La sémantique propositionnelle définit la vérité des formules à l'aide de valuations. \
La déduction naturelle formalise les preuves à l'aide de règles d'inférence.
#pause

Soit $V$ un ensemble de variables propositionnelles et $cal(F)(V)$ l'ensemble des formules logiques sur $V$.\
Les formules de $cal(F)(V)$ sont souvent notées $A, B, C$ ou $X, Y, Z$ en déduction naturelle au lieu de $φ, ψ, χ$ en logique propositionnelle.

#slides-only[== Séquent]


#definition[Séquent][
  Un _séquent_, noté $Γ ⊢ A$ (« $Γ$ thèse $A$ »), est constitué d'un ensemble $Γ$ de formules logiques et d'une formule logique $A$.
]

#underline[Intuitivement] : $Γ ⊢ A$ signifie que sous les hypothèses $Γ$, on peut déduire $A$. \
$Γ$ est l'ensemble des hypothèses actuelles lors d'une preuve.

#pause
#underline[Notation] : on note $Γ ⊬ A$ s'il n'existe pas de preuve du séquent $Γ ⊢ A$ dans le système considéré.

#slides-only[== Contextes d'hypothèses]

On utilise les abréviations :
#formules-reparties(
  empiler-presentation: true,
  $Γ, X = Γ ∪ {X}$,
  $Γ, Γ' = Γ ∪ Γ'$,
  $⊢ X "au lieu de" ∅ ⊢ X$,
)

#slides-only[== Trois systèmes formels]

Les trois systèmes suivants ont pour jugements les mêmes séquents. Ils diffèrent par les règles d'inférence autorisées :

#taille-presentation(0.85em)[
  #table(
    columns: (auto, auto, 1fr),
    align: center + horizon,
    inset: 0.5em,
    stroke: 0.4pt + luma(190),
    table.header([*Système*], [*Dérivabilité*], [*Règles autorisées*]),
    [Logique _minimale_], [$Γ scripts(⊢)_m A$], [Axiome et règles usuelles pour $⊤$, $→$, $∧$, $∨$, $¬$],
    [Logique _intuitionniste_], [$Γ scripts(⊢)_i A$], [Logique minimale + élimination de $⊥$],
    [Logique _classique_], [$Γ scripts(⊢)_c A$], [Logique intuitionniste + raisonnement par l'absurde (ou tiers exclu)],
  )
]

#pause
Suivant le système utilisé, les séquents prouvables ne sont pas les mêmes. On précise la logique utilisée par un indice seulement lorsqu'il est nécessaire de distinguer les systèmes.

#slides-only[== Introduction et élimination]

Les règles d'un connecteur se regroupent en règles d'introduction et d'élimination.\
Pour comprendre plus facilement une preuve, on annote chaque règle avec un symbole.

= Déduction naturelle intuitionniste

#underline[Convention] : Dans les règles, $Γ$ désigne un ensemble quelconque de formules et $X, Y, Z$ des formules quelconques. Dans les preuves, on utilise les lettres $A, B, C$.

// Les mêmes exercices sont intercalés dans les slides et regroupés dans le cours.
#let exercices-implication = [
  #if est-presentation() [== Implication – exercices]
  #colonnes-cours(
    columns: if est-corrige() { (1fr,) } else { (1fr, 1.5fr) },
    align: left + top,
    saut-slide: true,
    [
      #exercice[Prouver $⊢ A → A$.]
      #solution[
        #arbre[#prooftree(rule(name: [$scripts(→)_i$], rule(name: [ax], [$A ⊢ A$]), [$⊢ A → A$]))]
      ]
    ],
    [
      #exercice[Prouver $A → B, B → C ⊢ A → C$.]
      #solution[
        Posons $Γ = {A → B, B → C, A}$.
        #arbre[#prooftree(rule(
          name: [$scripts(→)_i$],
          rule(
            name: [$scripts(→)_e$],
            rule(name: [ax], [$Γ ⊢ B → C$]),
            rule(
              name: [$scripts(→)_e$],
              rule(name: [ax], [$Γ ⊢ A → B$]),
              rule(name: [ax], [$Γ ⊢ A$]),
              [$Γ ⊢ B$],
            ),
            [$Γ ⊢ C$],
          ),
          [$A → B, B → C ⊢ A → C$],
        ))]
      ]
    ],
  )
]

#let exercice-conjonction = [
  #exercice[Prouver $A ∧ B ⊢ B ∧ A$.]
  #solution[
    #arbre[#prooftree(rule(
      name: [$∧_i$],
      rule(name: [$∧_e^d$], rule(name: [ax], [$A ∧ B ⊢ A ∧ B$]), [$A ∧ B ⊢ B$]),
      rule(name: [$∧_e^g$], rule(name: [ax], [$A ∧ B ⊢ A ∧ B$]), [$A ∧ B ⊢ A$]),
      [$A ∧ B ⊢ B ∧ A$],
    ))]
  ]
]

#let exercice-conjonction-implication = [
  #exercice[
    + Prouver $(A ∧ B) → C ⊢ A → (B → C)$.
    + Prouver $A → (B → C) ⊢ (A ∧ B) → C$.
  ]
  #solution[
    Pour la première question :
    #arbre[#prooftree(rule(
      name: [$scripts(→)_i$],
      rule(
        name: [$scripts(→)_i$],
        rule(
          name: [$scripts(→)_e$],
          rule(name: [ax], [$(A ∧ B) → C ⊢ (A ∧ B) → C$]),
          rule(
            name: [$∧_i$],
            rule(name: [ax], [$A ⊢ A$]),
            rule(name: [ax], [$B ⊢ B$]),
            [$A, B ⊢ A ∧ B$],
          ),
          [$(A ∧ B) → C, A, B ⊢ C$],
        ),
        [$(A ∧ B) → C, A ⊢ B → C$],
      ),
      [$(A ∧ B) → C ⊢ A → (B → C)$],
    ))]
  ]
  #solution[
    Pour la seconde question, posons $Γ = {A → (B → C), A ∧ B}$.
    #arbre[#prooftree(rule(
      name: [$scripts(→)_i$],
      rule(
        name: [$scripts(→)_e$],
        rule(
          name: [$scripts(→)_e$],
          rule(name: [ax], [$Γ ⊢ A → (B → C)$]),
          rule(name: [$∧_e^g$], rule(name: [ax], [$Γ ⊢ A ∧ B$]), [$Γ ⊢ A$]),
          [$Γ ⊢ B → C$],
        ),
        rule(name: [$∧_e^d$], rule(name: [ax], [$Γ ⊢ A ∧ B$]), [$Γ ⊢ B$]),
        [$Γ ⊢ C$],
      ),
      [$A → (B → C) ⊢ (A ∧ B) → C$],
    ))]
  ]
]

#let exercices-conjonction = [
  #if est-presentation() [== Conjonction – exercices]
  #colonnes-cours(
    saut-slide: true,
    exercice-conjonction,
    exercice-conjonction-implication,
  )
]

#let exercice-disjonction = [
  #exercice[Prouver $A ∨ B ⊢ B ∨ A$.]
  #solution[
    #arbre[#prooftree(rule(
      name: [$∨_e$],
      rule(name: [$∨_i^d$], rule(name: [ax], [$A ∨ B, A ⊢ A$]), [$A ∨ B, A ⊢ B ∨ A$]),
      rule(name: [$∨_i^g$], rule(name: [ax], [$A ∨ B, B ⊢ B$]), [$A ∨ B, B ⊢ B ∨ A$]),
      rule(name: [ax], [$A ∨ B ⊢ A ∨ B$]),
      [$A ∨ B ⊢ B ∨ A$],
    ))]
  ]
]

#let exercice-distributivite = [
  #exercice[
    + Prouver $A ∨ (B ∧ C) ⊢ A ∨ B$.
    + On admet aussi $A ∨ (B ∧ C) ⊢ A ∨ C$. En déduire $⊢ A ∨ (B ∧ C) → (A ∨ B) ∧ (A ∨ C)$.
  ]
  #solution[
    Pour la première question, posons $Γ = {A ∨ (B ∧ C)}$.
    #arbre[#prooftree(rule(
      name: [$∨_e$],
      rule(name: [$∨_i^g$], rule(name: [ax], [$Γ, A ⊢ A$]), [$Γ, A ⊢ A ∨ B$]),
      rule(
        name: [$∨_i^d$],
        rule(name: [$∧_e^g$], rule(name: [ax], [$Γ, B ∧ C ⊢ B ∧ C$]), [$Γ, B ∧ C ⊢ B$]),
        [$Γ, B ∧ C ⊢ A ∨ B$],
      ),
      rule(name: [ax], [$Γ ⊢ A ∨ (B ∧ C)$]),
      [$Γ ⊢ A ∨ B$],
    ))]
  ]
  #solution[
    Pour la seconde question, les deux séquents ont le même contexte $Γ = {A ∨ (B ∧ C)}$.
    La règle $∧_i$ donne $Γ ⊢ (A ∨ B) ∧ (A ∨ C)$.
    En déchargeant l'hypothèse $A ∨ (B ∧ C)$ avec $scripts(→)_i$, on obtient
    $ ⊢ A ∨ (B ∧ C) → (A ∨ B) ∧ (A ∨ C). $
  ]
]

#let exercices-disjonction = [
  #if est-presentation() [== Disjonction – exercices]
  #colonnes-cours(
    saut-slide: true,
    exercice-disjonction,
    exercice-distributivite,
  )
]

// Adapté de mpi_gluher/Exercices/Preuves_fausses.tex (banque ups-mpi).
#let exercice-fausse-preuve = [
  #if est-presentation() [== Preuve ou fausse preuve ?]
  #exercice[
    L'arbre suivant est-il une preuve ? Identifier les applications incorrectes.
    #arbre[#prooftree(rule(
      name: [$scripts(→)_i$],
      rule(
        name: [$∧_i$],
        rule(name: [$∨_e$], rule(name: [ax], [$A ∨ B ⊢ A ∨ B$]), [$A ∨ B ⊢ A$]),
        rule(name: [$∨_e$], rule(name: [ax], [$A ∨ B ⊢ A ∨ B$]), [$A ∨ B ⊢ B$]),
        [$A ∨ B ⊢ A ∧ B$],
      ),
      [$⊢ (A ∨ B) → (A ∧ B)$],
    ))]
  ]
  #solution[
    Les deux applications étiquetées $∨_e$ sont incorrectes : cette règle demande deux preuves par cas ayant la même conclusion. Elle ne permet pas d'extraire un membre d'une disjonction.

    Pour des variables propositionnelles distinctes $A$ et $B$, la valuation $v(A) = 1$, $v(B) = 0$ rend la formule finale fausse.
  ]
]

#let exercices-negation = [
  #if est-presentation() [== Négation – exercice]
  #colonnes-cours(
    columns: (1fr, 1fr),
    [
      #exercice[Prouver $A ⊢ ¬ ¬ A$.]
      #solution[
        #arbre[#prooftree(rule(
          name: [$¬_i$],
          rule(
            name: [$¬_e$],
            rule(name: [ax], [$A, ¬ A ⊢ A$]),
            rule(name: [ax], [$A, ¬ A ⊢ ¬ A$]),
            [$A, ¬ A ⊢ ⊥$],
          ),
          [$A ⊢ ¬ ¬ A$],
        ))]
      ]
    ],
    [
      #underline[Remarque] : pour $x ∈ V$, on a $¬ ¬ x scripts(⊢)_c x$, mais $¬ ¬ x scripts(⊬)_i x$.
    ],
  )

]

#let contextes-differents = [
  == Contextes différents

  #theoreme[Affaiblissement][
    Si $Γ ⊆ Γ'$ et $Γ ⊢ A$ alors $Γ' ⊢ A$.
  ]
  #solution[
    On raisonne par induction sur l'arbre de preuve de $Γ ⊢ A$, en ajoutant toutes les formules de $Γ'$ à chacun de ses contextes.
    Les axiomes restent des axiomes et chaque application d'une règle reste valide.
    À la racine, le contexte devient $Γ ∪ Γ' = Γ'$.
  ]

  #if est-presentation() [== Variantes des règles]
  L'affaiblissement permet de ramener plusieurs contextes à leur union. On peut donc utiliser :

  #colonnes-cours(
    empiler-presentation: false,
    encadrer: block.with(breakable: false, above: 0.6em, below: 0pt),
    align: center + horizon,
    [
      #arbre[#prooftree(rule(
        name: [$scripts(→)_e$],
        [$Γ ⊢ X → Y$],
        [$Γ' ⊢ X$],
        [$Γ, Γ' ⊢ Y$],
      ))]
    ],
    [
      #if est-presentation() { pause }
      #arbre[#prooftree(rule(name: [$∧_i$], [$Γ ⊢ X$], [$Γ' ⊢ Y$], [$Γ, Γ' ⊢ X ∧ Y$]))]
    ],
  )
]

#tableau-regles(
  axiome: rule(name: [ax], [$Γ, X ⊢ X$]),
  (
    (
      titre: [Vrai $⊤$ et faux $⊥$],
      introduction: (rule(name: [$⊤_i$], [$Γ ⊢ ⊤$]),),
      elimination: (rule(name: [$⊥_e$], [$Γ ⊢ ⊥$], [$Γ ⊢ X$]),),
    ),
    (
      titre: [Implication $→$],
      applications: exercices-implication,
      introduction: (rule(name: [$scripts(→)_i$], [$Γ, X ⊢ Y$], [$Γ ⊢ X → Y$]),),
      elimination: (rule(name: [$scripts(→)_e$], [$Γ ⊢ X → Y$], [$Γ ⊢ X$], [$Γ ⊢ Y$]),),
    ),
    (
      titre: [Conjonction $∧$],
      applications: [#contextes-differents #exercices-conjonction],
      introduction: (rule(name: [$∧_i$], [$Γ ⊢ X$], [$Γ ⊢ Y$], [$Γ ⊢ X ∧ Y$]),),
      elimination: (
        rule(name: [$∧_e^g$], [$Γ ⊢ X ∧ Y$], [$Γ ⊢ X$]),
        rule(name: [$∧_e^d$], [$Γ ⊢ X ∧ Y$], [$Γ ⊢ Y$]),
      ),
    ),
    (
      titre: [Disjonction $∨$],
      remarque: [Il y a deux règles d'élimination pour $∧$ et deux règles d'introduction pour $∨$ : on peut utiliser l'une ou l'autre.],
      applications: [#exercices-disjonction #exercice-fausse-preuve],
      introduction: (
        rule(name: [$∨_i^g$], [$Γ ⊢ X$], [$Γ ⊢ X ∨ Y$]),
        rule(name: [$∨_i^d$], [$Γ ⊢ Y$], [$Γ ⊢ X ∨ Y$]),
      ),
      elimination: (
        rule(
          name: [$∨_e$],
          [$Γ, X ⊢ Z$],
          [$Γ, Y ⊢ Z$],
          [$Γ ⊢ X ∨ Y$],
          [$Γ ⊢ Z$],
        ),
      ),
    ),
    (
      titre: [Négation $¬$],
      applications: exercices-negation,
      introduction: (rule(name: [$¬_i$], [$Γ, X ⊢ ⊥$], [$Γ ⊢ ¬ X$]),),
      elimination: (rule(name: [$¬_e$], [$Γ ⊢ X$], [$Γ ⊢ ¬ X$], [$Γ ⊢ ⊥$]),),
    ),
  ),
)

#if not est-presentation() [
  #contextes-differents

  == Exercices

  #exercices-implication
  #colonnes-cours(
    columns: (1fr, 1.5fr),
    align: left + top,
    exercice-conjonction,
    exercice-disjonction,
    exercice-conjonction-implication,
    exercice-distributivite,
  )
  #exercice-fausse-preuve
  #exercices-negation
]

= Déduction naturelle classique

On obtient le système _classique_ en ajoutant aux règles intuitionnistes le _raisonnement par l'absurde_ (raa) ou, de manière équivalente, le _tiers exclu_ (te).

#pause
Toute preuve intuitionniste est aussi une preuve classique : $Γ scripts(⊢)_i A ==> Γ scripts(⊢)_c A$. La réciproque est fausse : pour une variable propositionnelle $p$, $¬ ¬ p scripts(⊬)_i p$, alors que $¬ ¬ p scripts(⊢)_c p$.

== Raisonnement par l'absurde et tiers-exclu

#colonnes-cours(
  empiler-presentation: false,
  encadrer: block.with(breakable: false, above: 0.6em, below: 0pt),
  align: center + horizon,
  [
    #arbre[#prooftree(rule(name: [raa], [$Γ, ¬ X ⊢ ⊥$], [$Γ ⊢ X$]))]
  ],
  [
    #pause
    #arbre[#prooftree(rule(name: [te], [$Γ ⊢ X ∨ ¬ X$]))]
  ],
)

#slides-only[== De raa au tiers exclu]
#exercice[
  On ajoute raa à la logique intuitionniste et on veut prouver te.
  + Prouver $¬ (A ∨ ¬ A) scripts(⊢)_i ¬ A$.
  + Prouver $scripts(⊢)_c A ∨ ¬ A$.
]

#solution[
  Pour la première question, posons $Γ = {¬ (A ∨ ¬ A)}$.
  #arbre[#prooftree(rule(
    name: [$¬_i$],
    rule(
      name: [$¬_e$],
      rule(name: [ax], [$Γ, A ⊢ ¬ (A ∨ ¬ A)$]),
      rule(name: [$∨_i^g$], rule(name: [ax], [$Γ, A ⊢ A$]), [$Γ, A ⊢ A ∨ ¬ A$]),
      [$Γ, A ⊢ ⊥$],
    ),
    [$¬ (A ∨ ¬ A) scripts(⊢)_i ¬ A$],
  ))]
]
#solution[
  Pour la seconde question, on conserve $Γ = {¬ (A ∨ ¬ A)}$.
  #arbre[#prooftree(rule(
    name: [raa],
    rule(
      name: [$¬_e$],
      rule(name: [ax], [$Γ ⊢ ¬ (A ∨ ¬ A)$]),
      rule(
        name: [$∨_i^d$],
        rule(
          name: [$¬_i$],
          rule(
            name: [$¬_e$],
            rule(name: [ax], [$Γ, A ⊢ ¬ (A ∨ ¬ A)$]),
            rule(name: [$∨_i^g$], rule(name: [ax], [$Γ, A ⊢ A$]), [$Γ, A ⊢ A ∨ ¬ A$]),
            [$Γ, A ⊢ ⊥$],
          ),
          [$Γ ⊢ ¬ A$],
        ),
        [$Γ ⊢ A ∨ ¬ A$],
      ),
      [$Γ ⊢ ⊥$],
    ),
    [$scripts(⊢)_c A ∨ ¬ A$],
  ))]
]

#slides-only[== Du tiers exclu à raa]
#article-only[== Comparer les deux systèmes]

#exercice[
  Prouver $¬ ¬ A scripts(⊢)_c A$ en utilisant le tiers exclu. En déduire que l'on peut retrouver la règle raa à partir des règles intuitionnistes et de te.
]
#solution[
  Posons $Γ = {¬ ¬ A}$. On raisonne par cas sur $A ∨ ¬ A$ :
  #arbre[#prooftree(rule(
    name: [$∨_e$],
    rule(name: [ax], [$Γ, A ⊢ A$]),
    rule(
      name: [$⊥_e$],
      rule(
        name: [$¬_e$],
        rule(name: [ax], [$Γ, ¬ A ⊢ ¬ A$]),
        rule(name: [ax], [$Γ, ¬ A ⊢ ¬ ¬ A$]),
        [$Γ, ¬ A ⊢ ⊥$],
      ),
      [$Γ, ¬ A ⊢ A$],
    ),
    rule(name: [te], [$Γ ⊢ A ∨ ¬ A$]),
    [$¬ ¬ A ⊢ A$],
  ))]

  #pause
  Si $Γ, ¬ A ⊢ ⊥$, l'introduction de $¬$ donne $Γ ⊢ ¬ ¬ A$. La construction précédente permet alors de déduire $Γ ⊢ A$ : on retrouve raa.
]

#slides-only[== Contraposée]
#exercice[Contraposée][
  + Prouver $A → B scripts(⊢)_i ¬ B → ¬ A$.
  + Prouver $¬ B → ¬ A scripts(⊢)_i A → ¬ ¬ B$, puis en déduire $¬ B → ¬ A scripts(⊢)_c A → B$.
]
#solution[
  Pour la première question, posons $C = A → B$ et $Γ = {C, ¬ B, A}$ :
  #arbre[#prooftree(rule(
    name: [$scripts(→)_i$],
    rule(
      name: [$¬_i$],
      rule(
        name: [$¬_e$],
        rule(
          name: [$scripts(→)_e$],
          rule(name: [ax], [$Γ ⊢ C$]),
          rule(name: [ax], [$Γ ⊢ A$]),
          [$Γ ⊢ B$],
        ),
        rule(name: [ax], [$Γ ⊢ ¬ B$]),
        [$Γ ⊢ ⊥$],
      ),
      [$C, ¬ B ⊢ ¬ A$],
    ),
    [$A → B ⊢ ¬ B → ¬ A$],
  ))]
]
#solution[
  Pour la seconde question, posons $C = ¬ B → ¬ A$ et $Γ = {C, A, ¬ B}$ :
  #arbre[#prooftree(rule(
    name: [$scripts(→)_i$],
    rule(
      name: [$¬_i$],
      rule(
        name: [$¬_e$],
        rule(name: [ax], [$Γ ⊢ A$]),
        rule(
          name: [$scripts(→)_e$],
          rule(name: [ax], [$Γ ⊢ C$]),
          rule(name: [ax], [$Γ ⊢ ¬ B$]),
          [$Γ ⊢ ¬ A$],
        ),
        [$Γ ⊢ ⊥$],
      ),
      [$C, A ⊢ ¬ ¬ B$],
    ),
    [$¬ B → ¬ A ⊢ A → ¬ ¬ B$],
  ))]

  #pause
  Cette preuve est aussi classique. Dans le contexte ${C, A}$, l'élimination de la double négation donne alors $B$. En introduisant $→$, on obtient $¬ B → ¬ A scripts(⊢)_c A → B$.
]

= Correction et complétude de la déduction naturelle en logique classique

#slides-only[== Théorème de correction]

#theoreme(
  coeur: true,
)[Correction][Si $Γ scripts(⊢)_c A$ alors $Γ ⊨ A$. En particulier, si $Γ scripts(⊢)_i A$ alors $Γ ⊨ A$.]
#solution[
  Soit $P(h)$ : « pour tout arbre de dérivation $T$ de hauteur au plus $h$ et de conclusion $Γ ⊢ A$, on a $Γ ⊨ A$ ».

  $P(0)$ est vraie : un arbre de hauteur $0$ est une application de ax, de $⊤_i$ ou de te. Dans le premier cas, $A ∈ Γ$, donc $Γ ⊨ A$. Dans les deux autres cas, la conclusion est une tautologie.

  Supposons $P(h)$ vraie. Un arbre de hauteur au plus $h + 1$ est soit de hauteur au plus $h$, auquel cas on conclut par $P(h)$, soit de hauteur $h + 1$. Dans ce dernier cas, ses sous-arbres sont de hauteur au plus $h$.

  #underline[Cas $∧_i$] : supposons $T$ de la forme :
  #arbre[#prooftree(rule(name: [$∧_i$], rule([$T_1$], [$Γ ⊢ A$]), rule([$T_2$], [$Γ ⊢ B$]), [$Γ ⊢ A ∧ B$]))]

  Par $P(h)$, on a $Γ ⊨ A$ et $Γ ⊨ B$. Toute valuation satisfaisant $Γ$ satisfait donc $A ∧ B$.

  #underline[Cas $scripts(→)_i$] : supposons $T$ de la forme :
  #arbre[#prooftree(rule(name: [$scripts(→)_i$], rule([$T_1$], [$Γ, A ⊢ B$]), [$Γ ⊢ A → B$]))]

  Par $P(h)$, on a $Γ, A ⊨ B$. Soit $v$ une valuation satisfaisant $Γ$.
  Si $v(A) = 0$, alors $v(A → B) = 1$.
  Si $v(A) = 1$, alors $v$ satisfait $Γ$ et $A$, donc $v(B) = 1$ et $v(A → B) = 1$.
  Ainsi $Γ ⊨ A → B$.

  Les autres cas sont similaires. On obtient $P(h + 1)$, puis la correction par récurrence.
]
#underline[Remarque] : La réciproque est fausse dans le système intuitionniste : si $x ∈ V$, $⊨ x ∨ ¬ x$, mais on peut montrer $scripts(⊬)_i x ∨ ¬ x$.

#slides-only[== Preuve et contre-modèle]
#exercice[
  Soit $Γ = {A ∨ B, A → C, B → C}$.
  + Prouver $Γ ⊢ C$.
  + Donner un contre-modèle à $Γ ⊨ A$. En déduire $Γ scripts(⊬)_c A$.
]
#solution[
  Pour la première question, on raisonne par cas sur $A ∨ B$ :
  #arbre[#prooftree(rule(
    name: [$∨_e$],
    rule(
      name: [$scripts(→)_e$],
      rule(name: [ax], [$Γ, A ⊢ A → C$]),
      rule(name: [ax], [$Γ, A ⊢ A$]),
      [$Γ, A ⊢ C$],
    ),
    rule(
      name: [$scripts(→)_e$],
      rule(name: [ax], [$Γ, B ⊢ B → C$]),
      rule(name: [ax], [$Γ, B ⊢ B$]),
      [$Γ, B ⊢ C$],
    ),
    rule(name: [ax], [$Γ ⊢ A ∨ B$]),
    [$Γ ⊢ C$],
  ))]
]
#solution[
  La valuation $v(A) = 0$, $v(B) = 1$, $v(C) = 1$ satisfait les trois formules de $Γ$ et ne satisfait pas $A$. Donc $Γ ⊭ A$.
  #pause
  Si $Γ scripts(⊢)_c A$, la correction donnerait $Γ ⊨ A$, ce qui contredit ce contre-modèle. Ainsi $Γ scripts(⊬)_c A$.
]

#slides-only[== Cohérence]
#theoreme[Cohérence][
  La déduction naturelle en logique classique est _cohérente_ : $scripts(⊬)_c ⊥$.
]

#solution[
  La valuation qui associe $0$ à toute variable satisfait le contexte vide et ne satisfait pas $⊥$. Donc $⊭ ⊥$.
  #pause
  Par correction, si $scripts(⊢)_c ⊥$ alors $⊨ ⊥$, ce qui est impossible. Ainsi $scripts(⊬)_c ⊥$.
]

#slides-only[== Complétude]

#theoreme(hp: true)[Complétude][Si $Γ ⊨ A$ alors $Γ scripts(⊢)_c A$.]

On a donc $Γ scripts(⊢)_c A ⟺ Γ ⊨ A$.

#slides-only[== Remplacement de formules équivalentes]

#corollaire(hp: true)[Remplacement de formules équivalentes][
  Si $A ≡ B$ alors, pour tout ensemble de formules $Γ$ :
  $ Γ scripts(⊢)_c A quad ⟺ quad Γ scripts(⊢)_c B. $
  Plus généralement, remplacer une sous-formule par une formule sémantiquement équivalente dans les hypothèses ou la conclusion d'un séquent ne change pas sa dérivabilité en logique classique.
]<cor-remplacement-equivalents>

#solution[
  Par correction et complétude, et puisque $A ≡ B$ :
  $ Γ scripts(⊢)_c A quad ⟺ quad Γ ⊨ A quad ⟺ quad Γ ⊨ B quad ⟺ quad Γ scripts(⊢)_c B. $
  Pour les sous-formules, on utilise la compatibilité de l'équivalence sémantique avec les connecteurs. Remplacer une hypothèse par une formule équivalente conserve l'ensemble des modèles du contexte, donc ses conséquences logiques et, par correction et complétude, les séquents dérivables.
]

#if not est-presentation() [
  = Sémantique des ouverts

  #exercice(hp: true)[
    #for bloc in semantique-ouverts.contenu {
      if type(bloc) == content { bloc } else { enum.item(bloc.enonce) }
    }
  ]

  #solution[
    #enum(..semantique-ouverts.contenu.filter(bloc => type(bloc) == dictionary).map(bloc => bloc.solution))
  ]
]
