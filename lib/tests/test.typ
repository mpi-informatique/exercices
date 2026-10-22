#import "/lib/exercice.typ": afficher-exercice, cible-question, exercice, feuille, partie, question, texte-concours, titre-concours
// L'attribution complète le titre, sans mention « écrit » redondante.
#let centrale = (nom: "Centrale", annee: 2017, filiere: "MP", oral: false)
#assert(titre-concours("mots synchronisants", centrale) == "Centrale 2017 MP : mots synchronisants")
#assert(titre-concours("Devoir 1", none) == "Devoir 1")
#assert(texte-concours((nom: "ENS", oral: true)) == "ENS oral")

// Les chapitres de première année restent acceptés en deuxième année.
#for niveaux in (("MPSI",), ("MP2I",), ("MP",), ("MPI",)) {
  let ex = exercice(
    meta: (
      titre: "Chapitres de maths",
      chapitres: ("determinants",),
      matiere: "mathématiques",
      difficulte: 1,
      niveaux: niveaux,
    ),
    contenu: (question([Énoncé]),),
  )
  assert(ex.meta.chapitres == ("determinants",))
  assert(ex.meta.matiere == "mathématiques" and ex.meta.niveaux == niveaux)
}
// SQL doit être accepté pour tous les niveaux, ainsi que sans niveau.
#for niveaux in ((), ("MP2I",), ("MPI",)) {
  let ex = exercice(
    meta: (titre: "Test SQL", chapitres: ("bases-de-donnees",), langages: ("SQL",), difficulte: 1, niveaux: niveaux),
    contenu: (question([Énoncé], solution: [Solution]),),
  )
  assert(ex.meta.langages == ("SQL",))
}
// Le départ est fixé à 1 ; les corrections sont conservées mais jamais affichées.
#let meta = (titre: "Présentation", chapitres: (), difficulte: 1)
#let contenu = (
  question(
    [Première question],
    solution: [Solution],
    notation: [#metadata("question") <notation-test> Consigne locale.],
  ),
  question([Deuxième question], solution: [Solution]),
)
#let ordinaire = exercice(
  meta: meta,
  contenu: contenu,
  notation: [#metadata("epreuve") <notation-test> Consigne globale.],
  corrections: [#metadata("modification") <correction-test> Correction.],
)
#let sujet = exercice(
  meta: (..meta, concours: (nom: "ENS", oral: true)),
  contenu: contenu,
  corrections: ordinaire.corrections,
)
#let unique = exercice(meta: meta, contenu: (question([Question unique], solution: [Solution]),))
#show: feuille.with(exercices: (), corrige: true)
#afficher-exercice(ordinaire, corrige: true)
#afficher-exercice(sujet, corrige: true)
#afficher-exercice(unique, corrige: true)
#afficher-exercice(ordinaire, corrige: false)
#context {
  assert(query(enum).map(q => q.start) == (1, 2, 1, 2, 1, 2))
  assert(query(<correction-test>).len() == 0)
  assert(query(<notation-test>).len() == 0)
}

// L'extraction par nom conserve le code et la présentation, sans balises.
#import "/lib/code.typ": code-extrait, code-texte
#let source-code = "let y = 2\nlet x = 1"
#let extrait = code-extrait(source-code, "x")
#assert(code-texte(source-code, "x") == "let x = 1")
#assert(code-texte(source-code, ("x", "y")) == "let x = 1\n\nlet y = 2")
#assert(code-texte("int f(int x) { return x; }", "f", language: "c") == "int f(int x) { return x; }")
#assert(extrait.text == "let x = 1" and extrait.lang == "ocaml" and extrait.block)

// Seuls les corrigés de devoirs de concours écrits masquent les introductions.
#let cas-contexte = (
  (type: "devoir", concours: none),
  (type: "devoir", concours: (nom: "ENS")),
  (type: "concours", concours: (nom: "ENS", oral: false)),
  (type: "devoir", concours: (nom: "ENS", oral: true)),
  (type: "td", concours: (nom: "ENS", oral: false)),
  (type: "exercice", concours: (nom: "ENS", oral: false)),
)
#for (i, cas) in cas-contexte.enumerate() {
  let ex = exercice(meta: (..meta, concours: cas.concours), contenu: (
    [#metadata(i) <contexte-test> Introduction.],
    partie("I", "Partie", contenu: (
      [#metadata(i) <contexte-partie-test> Définitions.],
      question(
        [#metadata(i) <enonce-test> Question avec sa figure.],
        solution: [#metadata(i) <solution-test> Solution.],
      ),
    )),
  ))
  feuille(type: cas.type, concours: cas.concours, exercices: (ex,), corrige: true, [])
}
#context {
  assert(query(<contexte-test>).map(it => it.value) == (0, 3, 4, 5))
  assert(query(<contexte-partie-test>).map(it => it.value) == (0, 3, 4, 5))
  assert(query(<enonce-test>).map(it => it.value) == (0, 1, 2, 3, 4, 5))
  assert(query(<solution-test>).map(it => it.value) == (0, 1, 2, 3, 4, 5))
}

// Les observations du jury restent distinctes de l'énoncé et des consignes de notation.
#let sujet-jury = exercice(meta: meta, jury: [#metadata("sujet") <jury-test> Observation générale.], contenu: (
  partie("I", "Partie avec jury", jury: [#metadata("partie") <jury-test> Observation de partie.], contenu: (
    question([Énoncé.], jury: [#metadata("question") <jury-test> Observation de question.], solution: [Solution.]),
  )),
))
#afficher-exercice(sujet-jury, corrige: false)
#afficher-exercice(sujet-jury, corrige: true)
#context {
  assert(query(<jury-test>).map(it => it.value) == ("sujet", "partie", "question"))
}

// Un renvoi numéroté conserve l'alignement hérité par le texte.
#for (i, alignement) in (left, center, right).enumerate() {
  let etiquette = label("question-alignement-" + str(i))
  align(alignement, context {
    let attendu = align.alignment
    cible-question(question([], label: etiquette), i + 1, [
      #context assert(align.alignment == attendu, message: "Le label ne doit pas modifier l'alignement de la question.")
      Question avec un renvoi numéroté.
    ])
  })
  [Voir #ref(etiquette).]
}
