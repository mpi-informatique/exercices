/// Environnements Theorion : cadres imprimés ou blocs colorés en présentation.
#import "@preview/theorion:0.6.0" as theorion
#import "@preview/touying:0.8.0": touying-fn-wrapper-raw, utils
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
#let composer-cadre(
  body,
  nom: none,
  self: none,
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

// Touying traite le contenu du cadre avant son rendu contextuel.
#let rendre-cadre(nom, body, ..options) = {
  if not utils.tree.has-touying-mark(body) {
    composer-cadre(body, nom: nom, ..options)
  } else {
    touying-fn-wrapper-raw(composer-cadre, body, nom: nom, ..options)
  }
}

// Séparer le titre du préfixe numéroté par deux-points, sans parenthèses.
#let titre-cadre(prefix, title) = {
  let avec-titre = (type(title) == str and title != "") or (type(title) == content and title != [] and title != [#""])
  [#prefix#if avec-titre { [ : #title] }]
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
  (compteur, numerote.with(get-full-title: titre-cadre), sans-numero.with(get-full-title: titre-cadre), afficher)
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

// API française ; les noms historiques restent disponibles pour les documents existants.
#let cadre-francais(cadre, titre: none, ..args) = {
  if titre == none { cadre(..args) } else { cadre(title: titre, ..args) }
}

#let (theoreme, theoreme-sans-numero) = (cadre-francais.with(theorem), cadre-francais.with(theorem-box))
#let (lemme, lemme-sans-numero) = (cadre-francais.with(lemma), cadre-francais.with(lemma-box))
#let (corollaire, corollaire-sans-numero) = (cadre-francais.with(corollary), cadre-francais.with(corollary-box))
#let (axiome, axiome-sans-numero) = (cadre-francais.with(axiom), cadre-francais.with(axiom-box))
#let (postulat, postulat-sans-numero) = (cadre-francais.with(postulate), cadre-francais.with(postulate-box))
#let (definition, definition-sans-numero) = (cadre-francais.with(definition), cadre-francais.with(definition-box))
#let (proposition, proposition-sans-numero) = (cadre-francais.with(proposition), cadre-francais.with(proposition-box))
#let (hypothese, hypothese-sans-numero) = (cadre-francais.with(assumption), cadre-francais.with(assumption-box))
#let (propriete, propriete-sans-numero) = (cadre-francais.with(property), cadre-francais.with(property-box))
#let (conjecture, conjecture-sans-numero) = (cadre-francais.with(conjecture), cadre-francais.with(conjecture-box))
#let (remarque, remarque-sans-numero) = (cadre-francais.with(remark), cadre-francais.with(remark-box))
#let (note, note-sans-numero) = (cadre-francais.with(note), cadre-francais.with(note-box))
#let (exemple, exemple-sans-numero) = (cadre-francais.with(example), cadre-francais.with(example-box))
#let (exercice, exercice-sans-numero) = (cadre-francais.with(exercise), cadre-francais.with(exercise-box))
#let (probleme, probleme-sans-numero) = (cadre-francais.with(problem), cadre-francais.with(problem-box))
#let (algorithme, algorithme-sans-numero) = (cadre-francais.with(algorithm), cadre-francais.with(algorithm-box))

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
  // Hors de Touying, composer directement les cadres encore sous forme de marques.
  show metadata: it => if type(it.value) == dictionary and it.value.at("fn", default: none) == composer-cadre {
    composer-cadre(..it.value.args)
  } else {
    it
  }
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
