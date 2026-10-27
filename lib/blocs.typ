#import "options.typ": est-presentation

#let epaisseur-trait = 0.4pt

/// Place une note dans la marge gauche, centrée à côté du contenu, sans réduire sa largeur.
/// La note conserve le corps courant ; son décalage tient compte de sa largeur et du format.
/// Exemple : `#note-en-marge([TP])[Travail pratique à réaliser.]`.
///
/// - note (content): Repère à afficher dans la marge.
/// - body (content): Contenu à signaler.
/// - dy (length): Décalage vertical supplémentaire du repère.
/// -> content
#let note-en-marge(note, body, dy: 0pt) = context {
  let repere = text(weight: "regular", top-edge: "bounds", bottom-edge: "bounds", note)
  let ecart = if est-presentation() { 0.02em } else { 0.5em }
  grid(
    columns: (0pt, 1fr),
    column-gutter: 0pt,
    align: (left + horizon, left + top),
    box(width: 0pt, move(dx: -measure(repere).width - ecart, dy: dy, repere)),
    body,
  )
}

/// Ajoute un cœur centré à gauche sans réduire la largeur du texte.
///
/// - body (content): Contenu à signaler.
/// - dy (length): Décalage vertical supplémentaire du cœur.
/// -> content
#let coeur-en-marge(body, dy: 0pt) = note-en-marge([♡], body, dy: dy)

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
