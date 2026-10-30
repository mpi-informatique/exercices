/// Cadres disponibles : `theoreme`, `lemme`, `corollaire`, `axiome`, `postulat`,
/// `definition`, `proposition`, `hypothese`, `propriete`, `conjecture`, `remarque`,
/// `note`, `exemple`, `exercice`, `probleme` et `algorithme`.
/// Le bloc `methode` met en valeur une démarche sans numérotation, avec une double barre latérale.
///
/// Chaque famille expose `compteur-<nom>`, `<nom>`, `<nom>-sans-numero` et
/// `afficher-<nom>`. Utiliser `configurer-theoremes` pour installer leurs rendus.
/// Les appels acceptent un contenu et les options communes `title`, `coeur`, `hp` et
/// `marge` ; le suffixe `-sans-numero` désactive la numérotation.
/// `hp: true` signale un contenu hors programme dans la marge A4 ou dans le titre en présentation.
/// En présentation, une pause suit chaque cadre si du contenu reste sur la diapositive ; `pause: false` la désactive.
/// Les références `@etiquette` affichent le type et le titre s'il existe, sinon
/// le numéro, y compris pendant les animations. `reference-cadre` permet de choisir
/// le numéro et/ou le titre. Dans `algorithme`, les listes imbriquées décrivent le pseudocode.

#import "@preview/lovelace:0.3.1": pseudocode-list
#import "@preview/theorion:0.6.0" as theorion
#import "@preview/touying:0.8.0": touying-fn-wrapper-raw, utils
#import "animations.typ": pause-automatique
#import theorion.cosmos.fancy: (
  fancy-box, get-fancy-radius, set-primary-body-color, set-primary-border-color, set-quaternary-body-color,
  set-quaternary-border-color, set-secondary-body-color, set-secondary-border-color, set-tertiary-body-color,
  set-tertiary-border-color,
)
#import "blocs.typ": epaisseur-trait, coeur-en-marge, marge as note-en-marge
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
  // Le titre fait partie de la hauteur du cadre, y compris dans une cellule de grille.
  if full-title != "" { v(hauteur / 2) }
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
/// - hp (bool): Signaler un contenu hors programme.
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
  hp: false,
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
    let titre-annote = if palette == none or full-title == "" { full-title } else {
      [#full-title#if coeur { h(0.4em); [♡] }#if hp { h(0.4em); text(size: 0.7em)[HP] }]
    }
    let cadre = if nom == "method" {
      let couleur = if palette == none { black } else {
        palette.at("method", default: palette.at("theorem", default: rgb("#233e6a")))
      }
      block(
        width: 100%,
        spacing: if palette == none { 0pt } else { auto },
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
            titre-annote
            h(0.3em)
            body
          },
        ),
      )
    } else if palette == none {
      let rendre = if nom in ("exercise", "problem") { rendre-exercice } else { fancy-box }
      rendre(
        spacing: 0pt,
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
              titre-annote,
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
    let contenu = if hp and palette == none {
      let note = if coeur { [♡ #text(size: 0.7em)[HP]] } else { text(size: 0.7em)[HP] }
      note-en-marge(box(width: measure(note).width, note), cadre, dy: 0.4em, taille: 1em)
    } else if coeur and palette == none {
      coeur-en-marge(cadre, dy: 0.4em)
    } else {
      cadre
    }
    if palette == none or espacement != none {
      // Une seule marge extérieure : les marges des blocs voisins fusionnent.
      // Les réserves des titres restent à l'intérieur, même dans les colonnes ou les notes en marge.
      let espace = if espacement == none { par.spacing } else { espacement }
      block(width: 100%, above: if marge { espace } else { 0pt }, below: espace, contenu)
    } else {
      contenu
    }
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

/// Rend un renvoi à un cadre en conservant les références natives aux autres éléments.
/// Les raccourcis Theorion `@etiquette[-]` et `@etiquette[!!]` restent disponibles.
///
/// - it (content): Référence native.
/// - numero (bool, auto): Afficher le numéro ; `auto` l'affiche seulement sans titre.
/// - titre (bool): Afficher le titre lorsqu'il existe.
/// -> content
#let rendre-reference-cadre(it, numero: auto, titre: true) = {
  let el = it.element
  let familles = ("theorem", "lemma", "corollary", "axiom", "postulate", "definition", "proposition", "assumption", "property", "conjecture", "remark", "note", "example", "exercise", "problem", "algorithm")
  if el == none or el.func() != figure or el.kind not in familles or it.supplement in ([-], [!!]) {
    return it
  }
  let titre-court = if el.caption == none { [] } else { el.caption.body }
  let avec-titre = titre and titre-court not in ("", [], [#""])
  let avec-numero = el.numbering != none and if numero == auto { not avec-titre } else { numero }
  let supplement = if it.supplement == auto { el.supplement } else { it.supplement }
  link(el.location(), {
    if supplement != none { supplement }
    if avec-numero {
      if supplement != none { [ ] }
      // Le compteur est incrémenté avant la métadonnée interne du cadre.
      let lieu = query(selector(<theorion-frame-metadata>).after(el.location())).first().location()
      let valeur = (el.numbering)(get-loc: () => lieu)
      if type(valeur) == dictionary { valeur.value } else { numbering(valeur) }
    }
    if avec-titre {
      if avec-numero {
        [ (#titre-court)]
      } else {
        if supplement != none { [ ] }
        titre-court
      }
    }
  })
}

/// Renvoie à un cadre en choisissant le numéro et/ou le titre.
/// Par défaut, affiche le type et le titre, ou le numéro si le titre est absent.
/// Exemples : `reference-cadre(<algo>, numero: true, titre: false)` pour le numéro,
/// `reference-cadre(<algo>, numero: true)` pour le numéro et le titre.
///
/// - cible (label): Étiquette du cadre.
/// - numero (bool, auto): Afficher le numéro ; `auto` l'affiche seulement sans titre.
/// - titre (bool): Afficher le titre lorsqu'il existe.
/// - supplement (content, auto, none): Type du cadre ; `none` le masque.
/// -> content
#let reference-cadre(cible, numero: auto, titre: true, supplement: auto) = {
  show ref: it => rendre-reference-cadre(it, numero: numero, titre: titre)
  ref(cible, supplement: supplement)
}

/// Met en valeur une méthode sans numéro, avec une double barre latérale.
/// Seul « Méthode : » est souligné ; le titre facultatif reste en caractères ordinaires.
/// Le texte est droit et les listes conservent leur numérotation habituelle.
/// Le rendu A4 est monochrome ; la présentation utilise la couleur `method` de la palette,
/// ou celle des théorèmes par défaut. Les animations Touying sont prises en charge.
///
/// - title (content, str): Titre facultatif après « Méthode ».
/// - coeur (bool): Signaler une méthode à connaître.
/// - hp (bool): Signaler une méthode hors programme.
/// - marge (bool): Ajouter la marge supérieure du bloc A4.
/// - pause (bool): Ajouter une pause après la méthode en présentation.
/// - body (content): Démarche, éventuellement sous forme d'étapes numérotées.
/// -> content
#let methode(title: "", coeur: false, hp: false, marge: true, pause: true, body) = {
  // Le filtre de Touying ne descend pas dans les arguments des fonctions différées.
  body = utils.tree.resolve-marks(body, ("touying-slides-only", "touying-article-only"), marque => {
    if (marque.kind == "touying-slides-only") == est-presentation() { marque.body } else { [] }
  })
  rendre-cadre(
    "method",
    body,
    full-title: [#underline[Méthode] :#if title != "" and title != [] { [ #title] }],
    coeur: coeur,
    hp: hp,
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
/// - espacement (length, none): Espacement commun ; `none` utilise `par.spacing` en A4 et conserve celui du rendu coloré.
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
  show ref: rendre-reference-cadre
  body
}
