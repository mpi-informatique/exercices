#import "/load.typ": colonnes-cours, est-corrige, est-presentation, formules-reparties, only, pause, uncover
#import "@preview/curryst:0.6.0": prooftree, rule

// Convertit la formule affichée ; les indices de logique du symbole ⊢ sont ignorés.
// `contexte` donne les hypothèses lorsque l'affichage utilise l'abréviation Γ.
#let sequent(body, contexte: none) = {
  let convertir(contenu) = {
    let champs = contenu.fields()
    if contenu == [ ] {
      ""
    } else if champs.keys().contains("text") {
      contenu.text
    } else if contenu.func() == math.attach {
      let base = convertir(contenu.base)
      assert(base == "⊢", message: "Seul le symbole ⊢ peut porter un indice dans un lien de séquent.")
      base
    } else if champs.keys().contains("children") {
      contenu.children.map(convertir).join()
    } else if contenu.func() in (math.equation, math.lr, math.scripts) {
      convertir(contenu.body)
    } else {
      panic("Notation non prise en charge dans un lien de séquent : " + repr(contenu))
    }
  }
  let cible = convertir(body)
  if cible.contains("Γ") {
    assert(contexte != none, message: "Préciser le contexte Γ du séquent.")
    cible = cible.replace("Γ", convertir(contexte))
  }
  for (symbole, ascii) in (("⊢", "|-"), ("→", "->"), ("∧", "&"), ("∨", "|"), ("¬", "!"), ("⊥", "0")) {
    cible = cible.replace(symbole, ascii)
  }
  cible = cible.replace(regex("\\s+"), "").replace("&", "%26").replace("|", "%7C").replace(">", "%3E")
  link("https://mpi-informatique.github.io/deduction-naturelle/?sequent=" + cible, body)
}

#let arbre(body) = block(width: 100%, context layout(size => {
  let largeur = measure(body).width
  align(center, if largeur > size.width { scale(x: size.width / largeur * 100%, reflow: true, body) } else { body })
}))

// Les mêmes règles alimentent le tableau imprimé et les diapositives.
#let cases-regles(regles, rempli: est-presentation() or est-corrige()) = {
  let arbres = regles.map(regle => {
    // Masquer les séquents conserve la longueur de la barre et la position du nom.
    let schema = if rempli { regle } else {
      regle + (premises: regle.premises.map(hide), conclusion: hide(regle.conclusion))
    }
    prooftree(schema)
  })
  context layout(size => {
    let largeur = (
      arbres.fold(0pt, (somme, arbre) => somme + measure(arbre).width) + (arbres.len() - 1) * 0.8em.to-absolute()
    )
    let lignes = if largeur <= size.width { (formules-reparties(..arbres),) } else { arbres.map(arbre) }
    for ligne in lignes {
      block(width: 100%, height: 3.4em, above: 0pt, below: 0pt)[
        #align(horizon, ligne)
      ]
    }
  })
}

#let tableau-regles(lignes, axiome: none, rempli: est-presentation() or est-corrige()) = {
  if est-presentation() {
    if axiome != none {
      heading(depth: 2)[Axiome]
      only(1, cases-regles((axiome,), rempli: false))
      pause
      only("2-", cases-regles((axiome,), rempli: rempli))
    }
    for ligne in lignes {
      heading(depth: 2, ligne.titre)
      colonnes-cours(
        empiler-presentation: false,
        separation: true,
        align: center + top,
        [
          *Introduction*

          #text(size: 0.75em, ligne.at("condition-introduction", default: []))
          #only(1, cases-regles(ligne.introduction, rempli: false))
          #only("2-", cases-regles(ligne.introduction, rempli: rempli))
          #uncover("2-")[
            #text(size: 0.75em, ligne.at("intuition-introduction", default: []))
          ]
        ],
        [
          *Élimination*

          #text(size: 0.75em, ligne.at("condition-elimination", default: []))
          #only(1, cases-regles(ligne.elimination, rempli: false))
          #only("2-", cases-regles(ligne.elimination, rempli: rempli))
          #uncover("2-")[
            #text(size: 0.75em, ligne.at("intuition-elimination", default: []))
          ]
        ],
      )
      // Une seule pause révèle simultanément les deux colonnes.
      pause
      ligne.at("remarque", default: [])
      ligne.at("applications", default: [])
    }
  } else {
    let cellules = ()
    if axiome != none {
      cellules += ([*Axiome*], table.cell(colspan: 2, cases-regles((axiome,), rempli: rempli)))
    }
    for ligne in lignes {
      cellules += (
        [*#ligne.titre*],
        [
          #cases-regles(ligne.introduction, rempli: rempli)
          #text(size: 0.85em, ligne.at("condition-introduction", default: []))
        ],
        [
          #cases-regles(ligne.elimination, rempli: rempli)
          #text(size: 0.85em, ligne.at("condition-elimination", default: []))
        ],
      )
    }
    block(breakable: false, table(
      columns: (auto, 1fr, 1fr),
      align: center + horizon,
      inset: (x: 0.6em, y: 0.8em),
      stroke: 0.4pt + luma(190),
      fill: (x, y) => if y == 0 { rgb("#e9eef5") } else if x == 0 { luma(96%) },
      table.header([*Opérateur*], [*Introduction*], [*Élimination*]),
      ..cellules,
    ))
    for ligne in lignes {
      let intuitions = (
        ligne.at("intuition-introduction", default: []),
        ligne.at("intuition-elimination", default: []),
      ).filter(body => body != [])
      if intuitions.len() > 0 {
        block(above: 0.8em)[*#ligne.titre*]
        for intuition in intuitions { block(intuition) }
      }
    }
  }
}

// Schémas communs au cours et au TP. Le TP omet les constantes.
#let axiome = rule(name: [ax], [$Γ, X ⊢ X$])
#let regles = (
  constantes: (
    titre: [Vrai $⊤$ et faux $⊥$],
    introduction: (rule(name: [$⊤_i$], [$Γ ⊢ ⊤$]),),
    elimination: (rule(name: [$⊥_e$], [$Γ ⊢ ⊥$], [$Γ ⊢ X$]),),
  ),
  implication: (
    titre: [Implication $→$],
    introduction: (rule(name: [$scripts(→)_i$], [$Γ, X ⊢ Y$], [$Γ ⊢ X → Y$]),),
    elimination: (rule(name: [$scripts(→)_e$], [$Γ ⊢ X → Y$], [$Γ ⊢ X$], [$Γ ⊢ Y$]),),
  ),
  conjonction: (
    titre: [Conjonction $∧$],
    introduction: (rule(name: [$∧_i$], [$Γ ⊢ X$], [$Γ ⊢ Y$], [$Γ ⊢ X ∧ Y$]),),
    elimination: (
      rule(name: [$∧_e^g$], [$Γ ⊢ X ∧ Y$], [$Γ ⊢ X$]),
      rule(name: [$∧_e^d$], [$Γ ⊢ X ∧ Y$], [$Γ ⊢ Y$]),
    ),
  ),
  disjonction: (
    titre: [Disjonction $∨$],
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
  negation: (
    titre: [Négation $¬$],
    introduction: (rule(name: [$¬_i$], [$Γ, X ⊢ ⊥$], [$Γ ⊢ ¬ X$]),),
    elimination: (rule(name: [$¬_e$], [$Γ ⊢ X$], [$Γ ⊢ ¬ X$], [$Γ ⊢ ⊥$]),),
  ),
)
