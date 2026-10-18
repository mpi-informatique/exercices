/// Épaisseur commune aux filets et aux bordures des documents.
#let epaisseur-trait = 0.4pt

/// Solution de référence des exercices, des cours et des copies.
/// - above (relative, auto): Espacement avant le bloc.
/// - below (relative, auto): Espacement après le bloc.
/// - body (content): Contenu de la solution.
/// -> content
#let bloc-solution(body, above: auto, below: auto) = block(
  width: 100%,
  breakable: true,
  stroke: (left: epaisseur-trait + luma(60%)),
  inset: (left: 10pt, y: 3pt),
  above: above,
  below: below,
  body,
)
