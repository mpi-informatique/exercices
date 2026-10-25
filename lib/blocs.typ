#let epaisseur-trait = 0.4pt

// Le cœur reste hors de la largeur réservée au texte.
#let coeur-en-marge(body) = grid(
  columns: (0pt, 1fr),
  column-gutter: 0pt,
  align: (left + horizon, left + top),
  box(width: 0pt, move(dx: -1.2em, text(top-edge: "bounds", bottom-edge: "bounds")[♡])),
  body,
)

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
