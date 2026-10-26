/// `code-extrait` et `code-texte` sont réexportés du package `@local/code-extract`.
/// Le premier affiche les déclarations nommées, le second renvoie leur texte.
/// Exemple : `code-extrait(read("corrige.ml"), ("regle", "grammaire"))`.
/// Ajouter `language: "c"` pour du C. Les versions sont verrouillées par Nix.

#import "blocs.typ": epaisseur-trait

/// Applique aux blocs de code les bordures communes et l'étiquette de langage.
/// À utiliser comme règle `show`.
///
/// - body (content): Contenu dont les blocs `raw` sont à mettre en forme.
/// -> content
#let configurer-code(body) = {
  let noms = (ocaml: "OCaml", c: "C", cpp: "C++", python: "Python", sql: "SQL", sh: "Shell", typ: "Typst", typst: "Typst")
  show raw.where(block: true): it => block(
    width: 100%, inset: (x: 0.8em, y: 0.7em),
    stroke: (top: epaisseur-trait, bottom: epaisseur-trait),
    {
      if it.lang != none and it.lang not in ("", "text") {
        place(top + right, dy: -1.1em,
          box(fill: white, inset: (x: 0.35em),
            text(size: 0.7em, fill: luma(35%), noms.at(it.lang, default: it.lang)),
          ),
        )
      }
      text(size: 1em, it)
    },
  )
  body
}

// L'analyse et l'affichage sont fournis directement par le package externe.
#import "@local/code-extract:0.2.0": extract as code-extrait, extract-text as code-texte
