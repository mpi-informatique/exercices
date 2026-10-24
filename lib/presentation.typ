#import "options.typ": est-presentation
#import "@preview/touying:0.8.0" as touying
#import touying: article-only, item-by-item, only, pause, slide, slides-only, uncover
#import "cours.typ": cours, espace-reponse
#import "document.typ": auteur-par-defaut
#import "theoremes.typ": configurer-theoremes
#import "code.typ": configurer-code
#import "themes/madrid.typ": theme-madrid, titre-madrid

/// Conserve le titre courant et ne provoque aucun saut dans le cours.
#let slide(titre: true, saut: true) = slides-only({
  if saut { pagebreak() }
  if not titre { metadata("diapositive-sans-titre") }
})

#let taille-presentation(taille, body) = {
  if est-presentation() {
    text(size: taille, body)
  } else {
    body
  }
}

/// Formule en bloc dans la présentation, en ligne dans le cours et le corrigé.
#let equation-slide(body) = math.equation(block: est-presentation(), body)

#let couleurs-blocs = (
  theorem: rgb("#233e6a"),
  lemma: rgb("#233e6a"),
  corollary: rgb("#233e6a"),
  proposition: rgb("#233e6a"),
  property: rgb("#233e6a"),
  definition: rgb("#16716b"),
  assumption: rgb("#16716b"),
  axiom: rgb("#16716b"),
  postulate: rgb("#16716b"),
  exercise: rgb("#8b1e2d"),
  problem: rgb("#a13f4b"),
  algorithm: rgb("#16716b"),
  conjecture: rgb("#65509a"),
  example: rgb("#47733d"),
  remark: rgb("#586475"),
  note: rgb("#586475"),
)

/// Titres de section `=`, titres de diapositive `==`.
#let presentation(
  titre: "Présentation",
  niveau: none,
  auteur: "Q. Fortier",
  aspect-ratio: "16-9",
  taille: 22pt,
  couleur: rgb("#233e6a"),
  palette: (:),
  police: ("New Computer Modern Sans", "New Computer Modern"),
  animations: true,
  article: false,
  body,
) = {
  show: configurer-theoremes
  set text(font: "New Computer Modern", lang: "fr")
  set align(if article { top } else { horizon })
  show: theme-madrid.with(
    aspect-ratio: aspect-ratio,
    couleur: couleur,
    taille: taille,
    police: police,
    style: body => {
      show: configurer-theoremes.with(
        palette: couleurs-blocs
          + (theorem: couleur, lemma: couleur, corollary: couleur, proposition: couleur, property: couleur)
          + palette,
      )
      show: configurer-code
      body
    },
    touying.config-info(title: titre, author: auteur, date: none),
    touying.config-common(
      export-mode: if article { "article" } else if animations { "presentation" } else { "handout" },
      article-theme: body => {
        // Touying encadre les paragraphes vides entre titres : leurs marges s'ajouteraient à celles des titres.
        show block.where(body: parbreak()): it => []
        cours(titre: titre, niveau: niveau, auteur: auteur, body)
      },
      breakable: false,
      detect-overflow: true,
    ),
    touying.config-article(wrap: false, linearize: false),
  )
  touying.slides-only(titre-madrid(
    [
      #metadata((type: "presentation", titre: titre, niveau: niveau)) <document-meta>
      #titre
    ],
    niveau: niveau,
    auteur: auteur,
    couleur: couleur,
  ))
  body
}

#let cours-et-presentation(format: sys.inputs.at("format", default: "cours"), ..args, body) = {
  assert(format in ("cours", "presentation"), message: "format doit valoir cours ou presentation")
  presentation(..args, article: format == "cours", body)
}

/// `encadrer` crée un cadre par contenu si `saut-slide` vaut true, un cadre commun sinon.
#let colonnes-cours(columns: (1fr, 1fr), column-gutter: 1.5em, align: top, saut-slide: false, encadrer: body => body, ..contenus) = {
  article-only(encadrer(grid(columns: columns, column-gutter: column-gutter, align: align, ..contenus)))
  slides-only(if saut-slide {
    contenus.pos().map(encadrer).join(slide() + parbreak())
  } else {
    encadrer(contenus.pos().join(parbreak()))
  })
}
