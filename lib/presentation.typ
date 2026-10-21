/// Présentations Touying et cours issus d'une même source.
#import "@preview/touying:0.8.0" as touying
#import touying: article-only, item-by-item, only, pause, slide, slides-only, uncover
#import "cours.typ": cours, espace-reponse
#import "document.typ": auteur-par-defaut
#import "theoremes.typ": configurer-theoremes
#import "code.typ": configurer-code
#import "themes/madrid.typ": theme-madrid, titre-madrid

/// Couleurs sémantiques des blocs projetés, surchargeables dans `presentation`.
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

/// Compose une présentation Touying Madrid, ou sa version article avec le thème du dépôt.
/// Bandeau de titre et blocs colorés, sans pied de page ni navigation ; cadres noirs en article.
/// - titre (str): Titre du document.
/// - niveau (str, none): Classe.
/// - auteur (str, none): Auteur, défaut « Q. Fortier » ; `none` le masque.
/// - aspect-ratio (str): Format Touying, défaut "16-9".
/// - taille (length): Taille du texte des diapositives, défaut 22pt.
/// - couleur (color): Couleur des titres, défaut bleu foncé.
/// - palette (dictionary): Surcharges des couleurs de `couleurs-blocs`, indexées par nom d'environnement.
/// - police (str, array): Police des diapositives, défaut New Computer Modern Sans avec repli New Computer Modern.
/// - animations (bool): Produire toutes les étapes, défaut true.
/// - article (bool): Utiliser le thème A4, défaut false.
/// - body (content): Titres de section `=`, titres de diapositive `==` et contenu partagé.
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

/// Génère le cours A4 ou la présentation à partir du même contenu.
/// - format (str): "cours" ou "presentation", choisi par `--input format=...` (défaut "cours").
/// - ..args (arguments): Options de `presentation`, dont `titre`, `niveau` et `auteur`.
/// - body (content): Contenu commun, avec `pause`, `article-only` et `slides-only` si nécessaire.
/// -> content
#let cours-et-presentation(format: sys.inputs.at("format", default: "cours"), ..args, body) = {
  assert(format in ("cours", "presentation"), message: "format doit valoir cours ou presentation")
  presentation(..args, article: format == "cours", body)
}

/// Dispose les contenus en colonnes dans le cours et à la suite dans la présentation.
/// - columns (int, array): Colonnes de la grille du cours, deux par défaut.
/// - column-gutter (relative): Espacement entre les colonnes du cours.
/// - align (alignment, array, auto): Alignement des cellules dans le cours.
/// - encadrer (function): Fonction appliquée à l'ensemble dans chaque format, par exemple `theoremes.exercise`.
/// - ..contenus (arguments): Contenus dans l'ordre de lecture ; options supplémentaires de `grid`.
/// -> content
#let colonnes-cours(columns: (1fr, 1fr), column-gutter: 1.5em, align: top, encadrer: body => body, ..contenus) = {
  article-only(encadrer(grid(columns: columns, column-gutter: column-gutter, align: align, ..contenus)))
  slides-only(encadrer(contenus.pos().join(parbreak())))
}
