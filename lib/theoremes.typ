/// Environnements Theorion : cadres imprimés ou blocs colorés en présentation.
#import "@preview/theorion:0.6.0" as theorion
#import theorion.cosmos.fancy: *
#import "blocs.typ": epaisseur-trait

#let espacement-cadres = state("exercices-espacement-cadres", none)
#let style-cadres = state("exercices-style-cadres", none)

// Compter une seule fois les cadres répétés par les animations de Touying.
// Sans marqueurs Touying (cours et feuilles), les étapes sont simplement cumulées.
#let compteur-cadres(nom) = {
  let marqueur = label("exercices-compteur-" + nom)
  let at(lieu) = {
    let selection = selector(marqueur).or(selector(<touying-metadata>))
    let evenements = query(if lieu == none { selection } else { selection.before(lieu) })
    let total = 0
    let maximum = 0
    let courant = 0
    for evenement in evenements {
      if evenement.value == nom {
        courant += 1
      } else if type(evenement.value) == dictionary {
        let genre = evenement.value.at("kind", default: none)
        if genre == "exercices-compteur-update" {
          total = evenement.value.numero - courant
        } else if genre == "touying-new-slide" {
          total += calc.max(maximum, courant)
          maximum = 0
          courant = 0
        } else if genre == "touying-new-subslide" {
          maximum = calc.max(maximum, courant)
          courant = 0
        }
      }
    }
    (total + courant,)
  }
  (
    step: () => [#metadata(nom)#marqueur],
    update: numero => {
      assert(numero.len() == 1, message: "Les cadres utilisent un numéro simple")
      [#metadata((kind: "exercices-compteur-update", numero: numero.first()))#marqueur]
    },
    at: at,
    get: () => at(here()),
    final: () => at(none),
  )
}

// Superposer le titre à la bordure, avec un fond blanc mais sans cartouche.
#let rendre-exercice(body, full-title: auto, ..args) = context {
  let frame = args.named().frame
  let titre = box(fill: white, inset: (x: frame.title-inset.x), text(weight: "semibold", full-title))
  let hauteur = measure(titre).height
  let inset = frame.inset
  if full-title != "" { v(hauteur / 2) }
  fancy-box(..args, full-title: "", {
    if full-title != "" {
      place(top + left, dx: 1em - inset.x, dy: -inset.top - hauteur / 2, titre)
      v(0.5em)
    }
    body
  })
}

// Conserver les mêmes environnements, références et compteurs dans les deux formats.
#let rendre-cadre(
  nom,
  body,
  prefix: none,
  title: "",
  full-title: auto,
  coeur: false,
  marge-haute: true,
  ..args,
) = context {
  let palette = style-cadres.get()
  let cadre = if palette == none {
    let rendre = if nom in ("exercise", "problem") { rendre-exercice } else { fancy-box }
    rendre(
      get-symbol: loc => none,
      get-border-color: loc => black,
      get-body-color: loc => white,
      prefix: prefix,
      title: title,
      full-title: full-title,
      frame: (
        thickness: epaisseur-trait,
        radius: get-fancy-radius(here()),
        inset: (x: 1em, top: if full-title != "" { 0.5em } else { 1em }, bottom: 1em),
        border-color: black,
        title-color: white,
        body-color: white,
        title-inset: (x: 1em, y: .5em),
      ),
      title-style: (boxed-style: (anchor: (x: start, y: horizon), radius: 0em), color: black, weight: "semibold"),
      ..args,
      body,
    )
  } else {
    let couleur = palette.at(nom, default: palette.at("theorem", default: rgb("#233e6a")))
    block(width: 100%, breakable: false, {
      if full-title != "" {
        block(width: 100%, fill: couleur, radius: (top: 4pt), above: 0pt, below: 0pt, inset: (x: 0.7em, y: 0.3em), text(
          size: 1em,
          weight: "bold",
          fill: white,
          [#full-title#if coeur {
              h(0.4em)
              [♡]
            }],
        ))
      }
      block(
        width: 100%,
        fill: couleur.lighten(88%),
        radius: (bottom: 4pt),
        above: 0pt,
        below: 0pt,
        inset: (x: 0.7em, y: 0.5em),
        body,
      )
    })
  }
  let espacement = espacement-cadres.get()
  if espacement != none {
    v(espacement, weak: true)
  } else if palette == none and marge-haute {
    // Garder une marge en tête des fragments produits par Touying en mode article.
    v(0.5em)
  }
  if coeur and palette == none {
    grid(
      columns: (0pt, 1fr),
      column-gutter: 0pt,
      align: (left + horizon, left + top),
      box(width: 0pt, move(dx: -1.5em, dy: 0.4em, box[♡])), cadre,
    )
  } else {
    cadre
  }
  if espacement != none { v(espacement, weak: true) }
}

// Chaque type possède un compteur indépendant, sans héritage des sections.
#let creer-environnement(nom) = {
  let (compteur, sans-numero, numerote, afficher) = theorion.make-frame(
    nom,
    if nom == "algorithm" { [Algorithme] } else { theorion.theorion-i18n-map.at(nom) },
    counter: compteur-cadres(nom),
    numbering: "1",
    render: rendre-cadre.with(nom),
  )
  (compteur, numerote, sans-numero, afficher)
}

#let (theorem-counter, theorem, theorem-box, show-theorem) = creer-environnement("theorem")
#let (lemma-counter, lemma, lemma-box, show-lemma) = creer-environnement("lemma")
#let (corollary-counter, corollary, corollary-box, show-corollary) = creer-environnement("corollary")
#let (axiom-counter, axiom, axiom-box, show-axiom) = creer-environnement("axiom")
#let (postulate-counter, postulate, postulate-box, show-postulate) = creer-environnement("postulate")
#let (definition-counter, definition, definition-box, show-definition) = creer-environnement("definition")
#let (proposition-counter, proposition, proposition-box, show-proposition) = creer-environnement("proposition")
#let (assumption-counter, assumption, assumption-box, show-assumption) = creer-environnement("assumption")
#let (property-counter, property, property-box, show-property) = creer-environnement("property")
#let (conjecture-counter, conjecture, conjecture-box, show-conjecture) = creer-environnement("conjecture")
#let (remark-counter, remark, remark-box, show-remark) = creer-environnement("remark")
#let (note-counter, note, note-box, show-note) = creer-environnement("note")
#let (example-counter, example, example-box, show-example) = creer-environnement("example")
#let (exercise-counter, exercise, exercise-box, show-exercise) = creer-environnement("exercise")
#let (problem-counter, problem, problem-box, show-problem) = creer-environnement("problem")
#let (algorithm-counter, algorithm, algorithm-box, show-algorithm) = creer-environnement("algorithm")

/// Active les règles Theorion ; `palette: none` conserve les cadres noirs imprimables.
/// - espacement (length, none): Espacement supplémentaire autour des cadres.
/// - palette (dictionary, none): Couleurs des environnements, indexées par leur nom anglais.
/// - body (content): Document à mettre en forme.
/// -> content
#let configurer-theoremes(espacement: none, palette: none, body) = {
  espacement-cadres.update(espacement)
  style-cadres.update(palette)
  set-primary-border-color(black)
  set-primary-body-color(white)
  set-secondary-border-color(black)
  set-secondary-body-color(white)
  set-tertiary-border-color(black)
  set-tertiary-body-color(white)
  set-quaternary-border-color(black)
  set-quaternary-body-color(white)
  show: show-theorem
  show: show-lemma
  show: show-corollary
  show: show-axiom
  show: show-postulate
  show: show-definition
  show: show-proposition
  show: show-assumption
  show: show-property
  show: show-conjecture
  show: show-remark
  show: show-note
  show: show-example
  show: show-exercise
  show: show-problem
  show: show-algorithm
  body
}
