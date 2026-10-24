#import "/load.typ": est-corrige
#import "/lib/exercice.typ": feuille, exercice, question, partie

#let meta = (titre: "Points par question", chapitres: (), difficulte: 1)
#let premier = exercice(meta: meta, contenu: (
  question([Question A], bareme: 0.5, solution: [Réponse A]),
  partie("I", "Partie", contenu: (
    question([Question B], bareme: 2, solution: [Réponse B]),
    question([Question sans barème], solution: [Réponse]),
  )),
))
#let second = exercice(meta: meta, contenu: (
  question([Question C], bareme: 1.5, solution: [Réponse C]),
))
#let corrige = est-corrige()
#show: feuille.with(type: "devoir", titre: "Devoir : barème par question",
  exercices: (second, premier), corrige: corrige)

#context {
  let points = query(<bareme-question>).map(it => it.value.points)
  assert(points == if corrige { (1.5, 0.5, 2) } else { () })
  assert(query(<document-meta>).first().value.type == "devoir")
}
