#import "@preview/touying:0.8.0" as touying

/// Adapte les diapositives Touying au bandeau Madrid et au marqueur sans titre.
///
/// - config (dictionary): Configuration de la diapositive.
/// - ..args (arguments): Contenus et options Touying.
/// -> content
#let slide-madrid(config: (:), ..args) = touying.touying-slide-wrapper(self => {
  let sans-titre = args.pos().any(body => type(body) == content and touying.utils.tree.find-in-tree(body, it => it.func() == metadata and it.value == "diapositive-sans-titre") != none)
  touying.touying-slide(
    self: self,
    config: if sans-titre {
      touying.utils.merge-dicts(config, touying.config-page(header: none, margin: (top: 0pt)))
    } else { config },
    ..args,
  )
})

/// Installe le format, le bandeau et la typographie du thème Madrid.
///
/// - aspect-ratio (str): Rapport des côtés au format Touying.
/// - couleur (color): Couleur principale.
/// - taille (length): Taille du texte.
/// - police (array, str): Police ou liste de secours.
/// - style (function): Règle de mise en forme du contenu des diapositives.
/// - ..configurations (arguments): Configurations Touying supplémentaires.
/// - body (content): Contenu de la présentation.
/// -> content
#let theme-madrid(aspect-ratio: "16-9", couleur: rgb("#233e6a"), taille: 22pt, police: ("New Computer Modern", "New Computer Modern"), style: body => body, ..configurations, body) = {
  let bandeau(self) = context {
    set text(fill: white, top-edge: "bounds", bottom-edge: "bounds")
    block(
      width: 100%, height: 44pt, fill: couleur, above: 0pt, below: 0pt,
      inset: (x: 32pt, y: 7pt),
      align(horizon, text(size: 1.22em, weight: "bold", touying.utils.display-current-heading(depth: self.slide-level, numbered: false, setting: touying.utils.fit-to-width.with(grow: false, 100%)))),
    )
  }
  show: touying.touying-slides.with(
    touying.config-page(
      ..touying.utils.page-args-from-aspect-ratio(aspect-ratio),
      margin: (x: 32pt, top: 62pt, bottom: 24pt),
      header: bandeau, header-ascent: 18pt, footer: none,
      fill: white,
    ),
    touying.config-colors(primary: couleur),
    touying.config-common(
      slide-fn: slide-madrid,
      slide-level: 2,
      new-section-slide-fn: none,
      zero-margin-header: true,
    ),
    touying.config-methods(init: (self: none, body) => {
      set text(font: police, size: taille, lang: "fr", fill: rgb("#202938"))
      show math.equation: set text(font: "New Computer Modern Math")
      set list(marker: text(fill: couleur)[•])
      set heading(numbering: (..n) => if n.pos().len() == 1 { numbering("I", ..n.pos()) })
      show link: set text(fill: couleur)
      show: style
      body
    }),
    ..configurations,
  )
  body
}

/// Compose la diapositive de titre sans bandeau ni incrément du compteur.
///
/// - titre (content, str): Titre principal.
/// - niveau (content, str, none): Niveau affiché.
/// - auteur (content, str, none): Auteur affiché.
/// - couleur (color): Couleur du cartouche.
/// -> content
#let titre-madrid(titre, niveau: none, auteur: none, couleur: rgb("#233e6a")) = touying.slide(
  config: touying.utils.merge-dicts(
    touying.config-page(header: none, margin: (x: 60pt, y: 40pt)),
    touying.config-common(freeze-slide-counter: true),
  ),
  align(center + horizon)[
    #block(width: 100%, fill: couleur, radius: 6pt, inset: (x: 28pt, y: 25pt),
      text(size: 1.65em, fill: white, weight: "bold", titre),
    )
    #if niveau != none { block(above: 24pt, text(size: 0.9em, fill: couleur, niveau)) }
    #if auteur != none { block(above: 12pt, text(size: 0.7em, auteur)) }
  ],
)
