#import "/load.typ": est-presentation, formules-reparties

#set page(width: 360pt, height: 160pt, margin: 30pt)
#assert(formules-reparties(empiler-presentation: true) == [])

#block(width: 300pt)[
  #metadata(none) <origine>
  #formules-reparties(
    empiler-presentation: true,
    box(width: 10pt, height: 10pt)[#metadata(10pt) <formule>],
    box(width: 40pt, height: 10pt)[#metadata(40pt) <formule>],
  )
]

#context {
  let origine = query(<origine>).first().location().position()
  let formules = query(<formule>)
  for (i, formule) in formules.enumerate() {
    let position = formule.location().position()
    let centre = position.x + formule.value / 2
    let attendu = origine.x + if est-presentation() { 150pt } else {
      (300pt - 10pt - 40pt) / 3 * (i + 1) + if i == 0 { 5pt } else { 10pt + 20pt }
    }
    assert(calc.abs(centre - attendu) < 0.01pt)
  }
  let premier = formules.first().location().position()
  let second = formules.last().location().position()
  assert(premier.page == second.page)
  if est-presentation() {
    assert(second.y > premier.y)
  } else {
    assert(calc.abs(second.y - premier.y) < 0.01pt)
  }
}
