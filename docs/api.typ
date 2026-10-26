#import "@preview/tidy:0.4.3"
#import "/lib/meta.typ"

#set text(font: "New Computer Modern", lang: "fr", size: 10pt)
#set page(paper: "a4", margin: 18mm)
#set heading(numbering: "1.1")
= API des ressources pédagogiques
Guide utilisateur : `docs/utilisation.md`. Cette référence est générée depuis les commentaires du code.

#for (titre, fichier) in (
  ("Exercices et feuilles", "/lib/exercice.typ"),
  ("Document A4 et compléments", "/lib/document.typ"),
  ("Cours et solutions", "/lib/cours.typ"),
  ("Présentations et source commune", "/lib/presentation.typ"),
  ("Cadres de théorèmes", "/lib/theoremes.typ"),
  ("Blocs de solution", "/lib/blocs.typ"),
  ("Code et extraction", "/lib/code.typ"),
  ("Automates", "/lib/automate.typ"),
  ("Options de compilation", "/lib/options.typ"),
  ("Thème Madrid", "/lib/themes/madrid.typ"),
  ("Chargement du package", "/load.typ"),
) {
  heading(level: 2, titre)
  let api = tidy.parse-module(read(fichier), old-syntax: true, label-prefix: fichier + "-")
  if api.description != none { eval(api.description, mode: "markup") }
  tidy.show-module(api, style: tidy.styles.default)
}

== Métadonnées : vocabulaires autorisés
Les valeurs de `lib/meta.typ` classent les contenus et valident leurs métadonnées.

// Les valeurs sont lues dans le module, jamais recopiées dans la documentation.
#for (nom, valeurs) in (
  ("chapitres (informatique)", meta.chapitres-informatique),
  ("chapitres (mathématiques)", meta.chapitres-maths),
  ("structures", meta.structures-programme),
  ("algorithmes", meta.algorithmes-programme),
  ("concours.nom", meta.concours-possibles),
  ("concours.filiere", meta.filieres-possibles),
  ("langages", meta.langages-possibles),
) {
  heading(level: 3, nom)
  valeurs.map(valeur => raw(valeur)).join([, ])
}
