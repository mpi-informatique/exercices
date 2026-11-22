#import "@preview/touying:0.8.0": slides-only, touying-fn-wrapper-raw, utils
#import "animations.typ": pause-automatique
#import "options.typ": est-corrige, est-presentation

#let epaisseur-trait = 0.4pt

/// Place une note dans la marge gauche, centrée à côté du contenu, sans réduire sa largeur.
/// Dans la présentation, renvoie directement le contenu, notamment les titres ouvrant une diapositive.
/// Pour un titre, annote son rendu afin de préserver ses marges et son attachement au texte suivant.
/// Le texte utilise par défaut 70 % du corps courant ; passer `taille: 1em` pour un symbole.
/// Le décalage tient compte de la largeur du repère.
/// Exemple : `#marge([TP])[Travail pratique à réaliser.]`.
///
/// - note (content): Repère à afficher dans la marge.
/// - body (content): Contenu à signaler.
/// - dy (length): Décalage vertical supplémentaire du repère.
/// - taille (length): Corps du repère, relatif au texte courant.
/// -> content
#let marge(note, body, dy: 0pt, taille: 0.7em) = {
  if est-presentation() { return body }
  let composer(body) = context {
    let repere = text(size: taille, weight: "regular", top-edge: "bounds", bottom-edge: "bounds", note)
    grid(
      columns: (0pt, 1fr),
      column-gutter: 0pt,
      align: (left + horizon, left + top),
      box(width: 0pt, move(dx: -measure(repere).width - 0.5em, dy: dy, repere)), body,
    )
  }
  if body.func() == heading {
    show heading: composer
    body
  } else {
    composer(body)
  }
}

/// Ajoute un cœur centré à gauche sans réduire la largeur du texte.
///
/// - body (content): Contenu à signaler.
/// - dy (length): Décalage vertical supplémentaire du cœur.
/// -> content
#let coeur-en-marge(body, dy: 0pt) = marge([♡], body, dy: dy, taille: 1em)

/// Compose une solution sécable avec un trait à gauche ; `none` n'affiche rien.
///
/// - body (content, none): Solution.
/// - coeur (bool): Ajouter un cœur dans la marge.
/// - above (length, auto): Espacement supérieur.
/// - below (length, auto): Espacement inférieur.
/// -> content, none
#let bloc-solution(body, coeur: false, above: auto, below: auto) = {
  if body != none {
    let cadre = block(
      width: 100%,
      breakable: true,
      stroke: (left: epaisseur-trait + luma(60%)),
      inset: (left: 10pt, y: 3pt),
      above: if coeur { 0pt } else { above },
      below: if coeur { 0pt } else { below },
      body,
    )
    if coeur {
      block(width: 100%, above: above, below: below, coeur-en-marge(cadre))
    } else {
      cadre
    }
  }
}

/// Résout les marques Touying puis compose le bloc de solution.
/// Utilitaire de rendu différé, appelé par `solution`.
/// - body (content): Solution.
/// - self (dictionary, none): Contexte Touying, s'il existe.
/// - coeur (bool): Ajouter un cœur dans la marge.
/// - encadrer (bool): Utiliser le cadre commun ; sinon, conserver seulement le cœur.
/// -> content
#let composer-solution(body, self: none, coeur: false, encadrer: true) = {
  if self != none {
    let article = self.at("article-mode", default: false)
    body = utils.tree.resolve-marks(body, ("touying-slides-only", "touying-article-only"), marque => {
      if (marque.kind == "touying-article-only") == article { marque.body } else { [] }
    })
  }
  if encadrer { bloc-solution(body, coeur: coeur) } else { coeur-en-marge(body) }
}

/// Affiche par défaut la solution uniquement dans le cours corrigé, jamais dans les diapositives.
/// `presentation: true` permet une projection explicitement demandée.
/// Les marques `article-only` et `slides-only` restent utilisables dans son contenu.
///
/// - cours (bool): Afficher dans les deux versions imprimées, même avec `presentation: true`.
/// - presentation (bool): Afficher dans les diapositives et masquer dans le corrigé, sauf si `cours: true`.
/// - coeur (bool): Ajouter un cœur à gauche, centré sur la solution.
/// - pause (bool): Ajouter une pause après la solution en présentation.
/// - body (content): Solution ou preuve.
/// -> content, none
#let solution(cours: false, presentation: false, coeur: false, pause: true, body) = {
  if est-presentation() and pause { body += pause-automatique }
  if not est-presentation() and ((est-corrige() and not presentation) or cours) {
    // Le filtre article de Touying ne descend pas dans les arguments des fonctions différées.
    body = utils.tree.resolve-marks(body, ("touying-slides-only", "touying-article-only"), marque => {
      if marque.kind == "touying-slides-only" { [] } else { marque.body }
    })
    touying-fn-wrapper-raw(composer-solution, coeur: coeur, body)
  } else if presentation {
    slides-only(if coeur { touying-fn-wrapper-raw(composer-solution, coeur: true, encadrer: false, body) } else { body })
  }
}
