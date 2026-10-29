/// Cadres disponibles : `theoreme`, `lemme`, `corollaire`, `axiome`, `postulat`,
/// `definition`, `proposition`, `hypothese`, `propriete`, `conjecture`, `remarque`,
/// `note`, `exemple`, `exercice`, `probleme` et `algorithme`.
/// Le bloc `methode` met en valeur une démarche sans numérotation, avec une double barre latérale.
///
/// Chaque famille expose `compteur-<nom>`, `<nom>`, `<nom>-sans-numero` et
/// `afficher-<nom>`. Utiliser `configurer-theoremes` pour installer leurs rendus.
/// Les appels acceptent un contenu et les options communes `title`, `coeur` et
/// `marge` ; le suffixe `-sans-numero` désactive la numérotation.
/// En présentation, une pause suit chaque cadre si du contenu reste sur la diapositive ; `pause: false` la désactive.
/// Les références `@etiquette` suivent le type et le numéro, y compris pendant
/// les animations. Dans `algorithme`, les listes imbriquées décrivent le pseudocode.

#import "@preview/lovelace:0.3.1": pseudocode-list
#import "@preview/theorion:0.6.0" as theorion
#import "@preview/touying:0.8.0": touying-fn-wrapper-raw, utils
#import "animations.typ": pause-automatique
#import theorion.cosmos.fancy: (
  fancy-box, get-fancy-radius, set-primary-body-color, set-primary-border-color, set-quaternary-body-color,
  set-quaternary-border-color, set-secondary-body-color, set-secondary-border-color, set-tertiary-body-color,
  set-tertiary-border-color,
)
#import "blocs.typ": epaisseur-trait, coeur-en-marge
#import "options.typ": est-presentation

#let espacement-cadres = state("exercices-espacement-cadres", none)
#let style-cadres = state("exercices-style-cadres", none)

/// Crée un compteur indépendant qui compte une seule fois les cadres animés.
/// Expose `step`, `update`, `at`, `get` et `final` pour le rendu et les renvois.
///
/// - nom (str): Identifiant du type de cadre.
/// -> dictionary
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

/// Rend le titre d'un exercice sur sa bordure avec un fond blanc.
///
/// - body (content): Énoncé.
/// - full-title (content, str, auto): Titre complet fourni par Theorion.
/// - ..args (arguments): Options du cadre Theorion.
/// -> content
#let rendre-exercice(body, full-title: auto, ..args) = context {
  let frame = args.named().frame
  let titre = box(fill: white, inset: frame.title-inset, text(weight: "semibold", full-title))
  let hauteur = measure(titre).height
  let inset = frame.inset
  // Réserver la place du titre sans cumuler cet espace avec la marge du bloc précédent.
  if full-title != "" { v(hauteur / 2, weak: true) }
  fancy-box(..args, full-title: "", {
    if full-title != "" {
      place(top + left, dx: 1em - inset.x, dy: -inset.top - hauteur / 2, titre)
      v(hauteur / 2)
    }
    body
  })
}

/// Compose le cadre A4 ou coloré après résolution des marques Touying.
/// Les listes des algorithmes sont rendues par Lovelace.
///
/// - body (content): Corps du cadre.
/// - nom (str, none): Type anglais du cadre.
/// - self (dictionary, none): Contexte Touying éventuel.
/// - prefix (content, str, none): Préfixe numéroté.
/// - title (content, str): Titre court.
/// - full-title (content, str, auto): Titre complet ou composition automatique.
/// - coeur (bool): Signaler un résultat à connaître.
/// - marge (bool): Ajouter la marge supérieure du cadre A4.
/// - ..args (arguments): Options transmises à Theorion.
/// -> content
#let composer-cadre(
  body,
  nom: none,
  self: none,
  prefix: none,
  title: "",
  full-title: auto,
  coeur: false,
  marge: true,
  ..args,
) = {
  if self != none {
    let article = self.at("article-mode", default: false)
    body = utils.tree.resolve-marks(body, ("touying-slides-only", "touying-article-only"), marque => {
      if (marque.kind == "touying-article-only") == article { marque.body } else { [] }
    })
  }
  if nom == "algorithm" {
    body = context pseudocode-list(
      indentation: 1.5em,
      line-gap: par.leading,
      line-numbering: none,
      stroke: epaisseur-trait + luma(65%),
      line-number-supplement: [Ligne],
      body,
    )
  }
  context {
    let palette = style-cadres.get()
    let cadre = if nom == "method" {
      let couleur = if palette == none { black } else {
        palette.at("method", default: palette.at("theorem", default: rgb("#233e6a")))
      }
      block(
        width: 100%,
        breakable: palette == none,
        stroke: (left: epaisseur-trait + couleur),
        fill: if palette == none { none } else { couleur.lighten(94%) },
        inset: (left: 0.18em),
        block(
          width: 100%,
          breakable: palette == none,
          above: 0pt,
          below: 0pt,
          stroke: (left: epaisseur-trait + couleur),
          inset: (left: 0.8em, right: 0.5em, y: 0.4em),
          {
            set text(style: "normal", weight: "regular")
            full-title
            body
          },
        ),
      )
    } else if palette == none {
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
          block(
            width: 100%,
            fill: couleur,
            radius: (top: 4pt),
            above: 0pt,
            below: 0pt,
            inset: (x: 0.7em, y: 0.3em),
            text(
              size: 1em,
              weight: "bold",
              fill: white,
              [#full-title#if coeur {
                  h(0.4em)
                  [♡]
                }],
            ),
          )
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
    } else if palette == none and marge {
      // Garder une marge en tête des fragments produits par Touying en mode article.
      v(0.5em)
    }
    if coeur and palette == none {
      coeur-en-marge(cadre, dy: 0.4em)
    } else {
      cadre
    }
    if espacement != none { v(espacement, weak: true) }
  }
}

/// Diffère le rendu seulement si le contenu porte des marques Touying.
///
/// - nom (str): Type du cadre.
/// - body (content): Contenu à résoudre.
/// - pause (bool): Ajouter une pause après le cadre en présentation.
/// - ..options (arguments): Options de `composer-cadre`.
/// -> content
#let rendre-cadre(nom, body, pause: true, ..options) = {
  if est-presentation() and pause { body += pause-automatique }
  if not utils.tree.has-touying-mark(body) {
    composer-cadre(body, nom: nom, ..options)
  } else {
    touying-fn-wrapper-raw(composer-cadre, body, nom: nom, ..options)
  }
}

/// Réunit le préfixe et le titre par deux-points lorsque le titre est non vide.
///
/// - prefix (content, str): Nom et numéro du cadre.
/// - title (content, str): Titre facultatif.
/// -> content
#let titre-cadre(prefix, title) = {
  let avec-titre = (type(title) == str and title != "") or (type(title) == content and title != [] and title != [#""])
  [#prefix#if avec-titre { [ : #title] }]
}

/// Met en valeur une méthode sans numéro, avec une double barre latérale.
/// Seul « Méthode : » est souligné ; le titre facultatif reste en caractères ordinaires.
/// Le texte est droit et les listes conservent leur numérotation habituelle.
/// Le rendu A4 est monochrome ; la présentation utilise la couleur `method` de la palette,
/// ou celle des théorèmes par défaut. Les animations Touying sont prises en charge.
///
/// - title (content, str): Titre facultatif après « Méthode ».
/// - coeur (bool): Signaler une méthode à connaître.
/// - marge (bool): Ajouter la marge supérieure du bloc A4.
/// - pause (bool): Ajouter une pause après la méthode en présentation.
/// - body (content): Démarche, éventuellement sous forme d'étapes numérotées.
/// -> content
#let methode(title: "", coeur: false, marge: true, pause: true, body) = {
  // Le filtre de Touying ne descend pas dans les arguments des fonctions différées.
  body = utils.tree.resolve-marks(body, ("touying-slides-only", "touying-article-only"), marque => {
    if (marque.kind == "touying-slides-only") == est-presentation() { marque.body } else { [] }
  })
  rendre-cadre(
    "method",
    body,
    full-title: [#underline[Méthode] :#if title != "" and title != [] { [ #title] }],
    coeur: coeur,
    marge: marge,
    pause: pause,
  )
}

/// Crée une famille `(compteur, numerote, sans-numero, afficher)` avec titre français.
/// Les familles exportées et leurs options communes sont décrites en tête du module.
///
/// - nom (str): Type anglais reconnu par Theorion.
/// -> array
#let creer-environnement(nom) = {
  let (compteur, sans-numero, numerote, afficher) = theorion.make-frame(
    nom,
    if nom == "algorithm" { [Algorithme] } else { theorion.theorion-i18n-map.at(nom) },
    counter: compteur-cadres(nom),
    numbering: "1",
    render: rendre-cadre.with(nom),
  )
  (
    compteur,
    numerote.with(get-full-title: titre-cadre),
    sans-numero.with(get-full-title: titre-cadre),
    afficher,
  )
}

#let (compteur-theoreme, theoreme, theoreme-sans-numero, afficher-theoreme) = creer-environnement("theorem")
#let (compteur-lemme, lemme, lemme-sans-numero, afficher-lemme) = creer-environnement("lemma")
#let (compteur-corollaire, corollaire, corollaire-sans-numero, afficher-corollaire) = creer-environnement("corollary")
#let (compteur-axiome, axiome, axiome-sans-numero, afficher-axiome) = creer-environnement("axiom")
#let (compteur-postulat, postulat, postulat-sans-numero, afficher-postulat) = creer-environnement("postulate")
#let (compteur-definition, definition, definition-sans-numero, afficher-definition) = creer-environnement("definition")
#let (compteur-proposition, proposition, proposition-sans-numero, afficher-proposition) = creer-environnement(
  "proposition",
)
#let (compteur-hypothese, hypothese, hypothese-sans-numero, afficher-hypothese) = creer-environnement("assumption")
#let (compteur-propriete, propriete, propriete-sans-numero, afficher-propriete) = creer-environnement("property")
#let (compteur-conjecture, conjecture, conjecture-sans-numero, afficher-conjecture) = creer-environnement("conjecture")
#let (compteur-remarque, remarque, remarque-sans-numero, afficher-remarque) = creer-environnement("remark")
#let (compteur-note, note, note-sans-numero, afficher-note) = creer-environnement("note")
#let (compteur-exemple, exemple, exemple-sans-numero, afficher-exemple) = creer-environnement("example")
#let (compteur-exercice, exercice, exercice-sans-numero, afficher-exercice) = creer-environnement("exercise")
#let (compteur-probleme, probleme, probleme-sans-numero, afficher-probleme) = creer-environnement("problem")
#let (compteur-algorithme, algorithme, algorithme-sans-numero, afficher-algorithme) = creer-environnement("algorithm")

/// Installe les rendus et les compteurs des cadres dans le document.
/// À utiliser comme règle `show`.
///
/// - espacement (length, none): Espacement commun ; `none` conserve celui du rendu.
/// - palette (dictionary, none): Couleurs par type anglais ; `none` utilise les cadres A4 monochromes.
/// - body (content): Document contenant les cadres.
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
