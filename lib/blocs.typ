#let epaisseur-trait = 0.4pt

#let bloc-solution(body, above: auto, below: auto) = {
  if body != none {
    block(
      width: 100%,
      breakable: true,
      stroke: (left: epaisseur-trait + luma(60%)),
      inset: (left: 10pt, y: 3pt),
      above: above,
      below: below,
      body,
    )
  }
}
