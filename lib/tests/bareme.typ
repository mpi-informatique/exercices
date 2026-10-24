#import "/load.typ": est-corrige
#import "/lib/exercice.typ": exercice, question, partie, feuille, afficher-exercice, verifier-bareme

#let meta = (titre: "Barème", chapitres: (), difficulte: 1)
#let ex = exercice(meta: meta, bareme: (0.25, 2.5), contenu: (
  question([Première question], solution: [Solution]),
  partie("I", "Partie imbriquée", contenu: (
    partie("I.A", "Sous-partie", contenu: (
      question([Deuxième question], solution: [Solution]),
    )),
  )),
))
#let sans-bareme = exercice(meta: meta, contenu: (question([Sans points]),))
#assert(sans-bareme.bareme == none)
#verifier-bareme((0.25, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, none), 10)
#let corrige = est-corrige()
#show: feuille.with(exercices: (ex, sans-bareme), corrige: corrige)
// Le barème propre au sujet suit les parties imbriquées.
#afficher-exercice(ex, corrige: corrige)
// Le barème de feuille suit plusieurs exercices, même avec une question sans note.
#feuille(exercices: (ex, sans-bareme), bareme: (none, 3.5, 0.5), corrige: corrige, [])
#context {
  let notes = query(<bareme-question>)
  let attendu = if corrige {
    (
      ((question: 1, points: 0.25), (question: 2, points: 2.5))
      + ((question: 2, points: 3.5), (question: 1, points: 0.5))
      + ((question: 1, points: 0.25), (question: 2, points: 2.5))
    )
  } else { () }
  assert(notes.map(n => n.value) == attendu, message: repr(notes.map(n => n.value)))
}
