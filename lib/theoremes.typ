/// Environnements Theorion : cadres imprimés ou blocs colorés en présentation.
#import "@preview/theorion:0.6.0" as theorion
#import "@preview/touying:0.8.0": touying-fn-wrapper-raw, utils
#import theorion.cosmos.fancy: (
  fancy-box, get-fancy-radius,
  set-primary-border-color, set-primary-body-color,
  set-secondary-border-color, set-secondary-body-color,
  set-tertiary-border-color, set-tertiary-body-color,
  set-quaternary-border-color, set-quaternary-body-color,
)
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
  let francais(cadre, titre: "", ..args) = cadre(title: titre, ..args)
  (
    compteur,
    francais.with(numerote.with(get-full-title: titre-cadre)),
    francais.with(sans-numero.with(get-full-title: titre-cadre)),
    afficher,
  )
}

#let (compteur-theoreme, theoreme, theoreme-sans-numero, afficher-theoreme) = creer-environnement("theorem")
#let (compteur-lemme, lemme, lemme-sans-numero, afficher-lemme) = creer-environnement("lemma")
#let (compteur-corollaire, corollaire, corollaire-sans-numero, afficher-corollaire) = creer-environnement("corollary")
#let (compteur-axiome, axiome, axiome-sans-numero, afficher-axiome) = creer-environnement("axiom")
#let (compteur-postulat, postulat, postulat-sans-numero, afficher-postulat) = creer-environnement("postulate")
#let (compteur-definition, definition, definition-sans-numero, afficher-definition) = creer-environnement("definition")
#let (compteur-proposition, proposition, proposition-sans-numero, afficher-proposition) = creer-environnement("proposition")
#let (compteur-hypothese, hypothese, hypothese-sans-numero, afficher-hypothese) = creer-environnement("assumption")
#let (compteur-propriete, propriete, propriete-sans-numero, afficher-propriete) = creer-environnement("property")
#let (compteur-conjecture, conjecture, conjecture-sans-numero, afficher-conjecture) = creer-environnement("conjecture")
#let (compteur-remarque, remarque, remarque-sans-numero, afficher-remarque) = creer-environnement("remark")
#let (compteur-note, note, note-sans-numero, afficher-note) = creer-environnement("note")
#let (compteur-exemple, exemple, exemple-sans-numero, afficher-exemple) = creer-environnement("example")
#let (compteur-exercice, exercice, exercice-sans-numero, afficher-exercice) = creer-environnement("exercise")
#let (compteur-probleme, probleme, probleme-sans-numero, afficher-probleme) = creer-environnement("problem")
#let (compteur-algorithme, algorithme, algorithme-sans-numero, afficher-algorithme) = creer-environnement("algorithm")

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
  show: afficher-theoreme
  show: afficher-lemme
  show: afficher-corollaire
  show: afficher-axiome
  show: afficher-postulat
  show: afficher-definition
  show: afficher-proposition
  show: afficher-hypothese
  show: afficher-propriete
  show: afficher-conjecture
  show: afficher-remarque
  show: afficher-note
  show: afficher-exemple
  show: afficher-exercice
  show: afficher-probleme
  show: afficher-algorithme
  body
}
