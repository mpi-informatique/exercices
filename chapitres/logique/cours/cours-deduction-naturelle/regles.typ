#import "/load.typ": colonnes-cours, est-corrige, est-presentation, formules-reparties, only, pause, uncover
#import "@preview/curryst:0.6.0": prooftree

// Le séquent ASCII est transmis à l'outil ; le contenu conserve les notations du cours.
#let sequent(enonce, body) = {
  let cible = enonce.replace(" ", "").replace("&", "%26").replace("|", "%7C").replace(">", "%3E")
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

#let tableau-regles(lignes, axiome: none) = {
  if est-presentation() {
    if axiome != none {
      heading(depth: 2)[Axiome]
      only(1, cases-regles((axiome,), rempli: false))
      pause
      only("2-", cases-regles((axiome,)))
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
          #only("2-", cases-regles(ligne.introduction))
          #uncover("2-")[
            #text(size: 0.75em, ligne.at("intuition-introduction", default: []))
          ]
        ],
        [
          *Élimination*

          #text(size: 0.75em, ligne.at("condition-elimination", default: []))
          #only(1, cases-regles(ligne.elimination, rempli: false))
          #only("2-", cases-regles(ligne.elimination))
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
      cellules += ([*Axiome*], table.cell(colspan: 2, cases-regles((axiome,))))
    }
    for ligne in lignes {
      cellules += (
        [*#ligne.titre*],
        [
          #cases-regles(ligne.introduction)
          #text(size: 0.85em, ligne.at("condition-introduction", default: []))
        ],
        [
          #cases-regles(ligne.elimination)
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
