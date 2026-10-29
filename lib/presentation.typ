#import "options.typ": est-presentation
#import "@preview/touying:0.8.0" as touying
#import touying: article-only, item-by-item, only, pause, slide, slides-only, uncover
#import "cours.typ": cours, espace-reponse
#import "document.typ": auteur-par-defaut, configurer-figures, configurer-formules, titre-lie
#import "theoremes.typ": configurer-theoremes
#import "code.typ": configurer-code
#import "themes/madrid.typ": theme-madrid, titre-madrid

/// Ouvre une diapositive en conservant le titre courant ; sans effet dans le cours.
/// Après un titre, `slide(titre: false, saut: false)` masque le bandeau sans créer de page vide.
///
/// - titre (bool): Conserver le bandeau du titre courant.
/// - saut (bool): Commencer une nouvelle diapositive.
/// -> content
#let slide(titre: true, saut: true) = slides-only({
  if saut { pagebreak() }
  if not titre { metadata("diapositive-sans-titre") }
})

/// Change la taille du texte seulement lorsque l'entrée `format` vaut `presentation`.
///
/// - taille (length): Taille à appliquer.
/// - body (content): Contenu concerné.
/// -> content
#let taille-presentation(taille, body) = {
  if est-presentation() {
    text(size: taille, body)
  } else {
    body
  }
}

/// Compose une formule en bloc dans la présentation et en ligne dans le cours.
///
/// - body (content): Expression mathématique.
/// -> content
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

/// Compose des diapositives Touying avec le thème Madrid.
/// Les titres `=` structurent les sections et `==` ouvre une diapositive.
/// `pause`, `item-by-item`, `only`, `uncover`, `article-only` et `slides-only` sont réexportés de Touying.
///
/// - titre (str): Titre de la présentation.
/// - niveau (str, none): Niveau sur la page de titre.
/// - auteur (str, none): Auteur.
/// - aspect-ratio (str): Format Touying, par exemple `16-9`.
/// - taille (length): Taille du texte projeté.
/// - couleur (color): Couleur principale et des résultats.
/// - palette (dictionary): Surcharges des couleurs de cadres par nom anglais (`exercise`, `definition`…).
/// - police (array, str): Police ou liste de polices de secours.
/// - animations (bool): Conserver les étapes ; sinon produire le mode handout.
/// - article (bool): Produire le cours A4 avec les règles de Touying.
/// - body (content): Contenu commun ou projeté.
/// -> content
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
      show: configurer-figures
      show: configurer-formules
      body
    },
    touying.config-info(title: titre, author: auteur, date: none),
    touying.config-common(
      export-mode: if article { "article" } else if animations { "presentation" } else { "handout" },
      article-theme: body => {
        // Touying encadre les paragraphes vides entre titres : leurs marges s'ajouteraient à celles des titres.
        show block: it => {
          if type(it.body) != content { return it }
          let enfants = it.body.fields().at("children", default: (it.body,))
          if enfants.len() > 0 and enfants.all(enfant => enfant == parbreak() or enfant == [ ]) { [] } else { it }
        }
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
      #titre-lie(titre)
    ],
    niveau: niveau,
    auteur: auteur,
    couleur: couleur,
  ))
  body
}

/// Produit un cours et une présentation à partir de la même source.
///
/// - format (str): `cours` ou `presentation`, issu de l'entrée système si omis.
/// - ..args (arguments): Options transmises à `presentation`.
/// - body (content): Source commune.
/// -> content
#let cours-et-presentation(format: sys.inputs.at("format", default: "cours"), ..args, body) = {
  assert(format in ("cours", "presentation"), message: "format doit valoir cours ou presentation")
  presentation(..args, article: format == "cours", body)
}

/// Dispose les contenus en colonnes dans le cours et à la suite dans la présentation.
/// Le contenu commence à la ligne, sans marge supérieure supplémentaire.
/// Passer le cadre via `encadrer`, plutôt qu'entourer l'appel, pour que Touying résolve les variantes.
///
/// - columns (array, int): Nombre de colonnes de même largeur, ou tableau de largeurs explicites comme pour `grid`.
/// - column-gutter (length): Espacement entre colonnes.
/// - align (alignment): Alignement dans la grille.
/// - saut-slide (bool): Séparer les contenus par des diapositives.
/// - encadrer (function): Cadre commun, ou un cadre par contenu avec `saut-slide`.
/// - ..contenus (arguments): Contenus à disposer.
/// -> content
#let colonnes-cours(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  align: left + horizon,
  saut-slide: false,
  encadrer: body => body,
  ..contenus,
) = {
  if type(columns) == int {
    assert(columns > 0, message: "columns doit être un entier strictement positif")
    columns = (1fr,) * columns
  }
  // Résoudre les solutions et animations avant de les enfermer dans la grille ou le cadre.
  // Garder l'interligne normal, sans l'espacement de paragraphe ajouté par défaut avant une grille.
  let composer-colonnes(self: none, ..cellules) = context encadrer(block(above: par.leading, grid(columns: columns, column-gutter: column-gutter, align: align, ..cellules)))
  if not est-presentation() {
    return touying.touying-fn-wrapper-raw(composer-colonnes, ..contenus)
  }
  slides-only(if saut-slide {
    contenus.pos().map(encadrer).join(slide() + parbreak())
  } else {
    encadrer(contenus.pos().join(parbreak()))
  })
}

/// Répartit une liste numérotée en colonnes dans le cours et la garde continue en présentation.
/// La liste commence à la ligne, sans marge supérieure supplémentaire.
/// Exemple : `#liste-cours([Premier élément.], [Deuxième élément.], [Troisième élément.])`.
///
/// - columns (int): Nombre de colonnes du cours, de même largeur et remplies de haut en bas.
/// - column-gutter (length): Espacement entre colonnes.
/// - start (int): Premier numéro.
/// - encadrer (function): Cadre commun autour de la liste.
/// - ..items (arguments): Contenus des éléments de la liste.
/// -> content
#let liste-cours(columns: 2, column-gutter: 1.5em, start: 1, encadrer: body => body, ..items) = {
  assert(type(columns) == int and columns > 0, message: "columns doit être un entier strictement positif")
  let items = items.pos()
  if est-presentation() {
    encadrer(enum(start: start, ..items))
  } else {
    let taille = calc.max(1, calc.ceil(items.len() / columns))
    let listes = items.chunks(taille).enumerate().map(((i, elements)) => enum(start: start + i * taille, ..elements))
    colonnes-cours(columns: columns, column-gutter: column-gutter, align: left + top, encadrer: encadrer, ..listes)
  }
}
