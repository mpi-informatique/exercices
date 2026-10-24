#import "/load.typ": est-corrige
#import "/load.typ": exercice, question, feuille, sujet-colle

#let corrige = est-corrige()
#let mode = sys.inputs.at("mode", default: "feuille")
#let exercices = range(3).map(i => exercice(
  meta: (titre: "Exercice " + str(i), chapitres: (), difficulte: 1),
  contenu: (question([#metadata(i) <pagination-exercice> Question courte.], solution: [Solution courte.]),),
))

#if mode == "sujet" {
  feuille(type: "colle", corrige: corrige, afficher-exercices: false, [
    #sujet-colle(1, exercices, corrige: corrige)
    #sujet-colle(2, exercices, corrige: corrige)
  ])
} else {
  // La règle des colles prime sur l'option générique, dans les deux variantes.
  feuille(type: "colle", exercices: exercices, corrige: corrige, nouvelle-page: corrige, [])
}

#context {
  let pages = query(<pagination-exercice>).map(it => it.location().page())
  if mode == "sujet" {
    assert(pages == (1, 1, 1, 2, 2, 2), message: "Chaque sujet commence sur une nouvelle page et enchaîne ses exercices, dans les deux variantes.")
  } else {
    assert(pages == (1, 1, 1), message: "Une colle doit enchaîner les exercices, dans les deux variantes.")
  }
}
