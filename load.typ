#import "lib/exercice.typ": *
#import "lib/document.typ": sep, completer, liste-a-completer, widetilde
#import "lib/blocs.typ": epaisseur-trait
#import "lib/meta.typ" as meta
#import "lib/automate.typ" as automate
#import "lib/code.typ" as code
#import "lib/theoremes.typ" as theoremes
#import "lib/cours.typ": cours, espace-reponse, solution
#import "lib/presentation.typ": presentation, cours-et-presentation, slide, colonnes-cours, taille-presentation, equation-slide, item-by-item, pause, uncover, only, article-only, slides-only

#let public(chemin) = {
  import chemin as source
  source
}
