#import "theoremes.typ": configurer-theoremes
#import "code.typ": configurer-code
#import "blocs.typ": epaisseur-trait

#let sep = h(0.5em)

#let completer() = box(width: 1fr, move(dy: 0.2em, text(fill: rgb(0%, 0%, 0%, 25%), repeat[.])))

#let liste-a-completer(start: 1, ..items) = enum(start: start, ..items.pos().map(item => [#item #completer()]))

#let widetilde(body) = math.accent(body, sym.tilde, size: 150%)

#let auteur-par-defaut = "Q. Fortier"

#let texte-duree(duree) = {
  let (heures, minutes) = duree
  if heures == 0 { str(minutes) + " min" } else if minutes == 0 { str(heures) + " h" } else {
    str(heures) + " h " + str(minutes) + " min"
  }
}

#let document-pedagogique(
  titre: "Document",
  niveau: none,
  auteur: auteur-par-defaut,
  duree: none,
  attribution: none,
  titre-entete: none,
  contenu-entete: none,
  repeter-entete: false,
  taille: 10pt,
  body,
) = {
  set document(title: titre)
  set document(author: auteur) if auteur != none
  show: configurer-theoremes
  show: configurer-code
  set text(font: "New Computer Modern", size: taille, lang: "fr")
  set par(justify: true)
  set heading(numbering: "I.1.1 –")
  show heading: set block(below: 0.7em)
  show heading.where(level: 1): set text(size: 1.1 * taille)
  show heading.where(level: 2): set text(size: 1.05 * taille)
  show heading.where(level: 3): set text(size: taille)
  set page(paper: "a4", margin: 10mm, header: none, footer: none, numbering: none)
  let entete = if contenu-entete != none { contenu-entete } else {
    context block(above: 0pt, below: 0.5em, sticky: true, {
      set block(above: 0pt, below: 0pt)
      stack(
        dir: ttb,
        spacing: 0.6em,
        grid(
          columns: (24mm, 1fr, if attribution == none { 24mm } else { auto }),
          column-gutter: 1em,
          align: (left, center, right),
          if niveau != none { niveau },
          text(size: 1.2em, weight: "bold")[
            #if titre-entete == none { titre } else { titre-entete }#if duree != none [ (#texte-duree(duree))]
          ],
          if attribution != none { attribution } else if auteur != none {
            link("https://mpi-informatique.github.io", auteur)
          },
        ),
        line(length: 100%, stroke: epaisseur-trait),
      )
    })
  }
  if repeter-entete {
    set page(margin: (top: 23mm, rest: 12mm), header: entete)
    body
  } else {
    // L'en-tête dans le flux ne réduit que la première page.
    entete
    body
  }
}
