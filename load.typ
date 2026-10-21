/// API et contenus du package mpi-informatique/exercices.
#import "lib/exercice.typ": *
#import "lib/document.typ": sep, completer, widetilde
#import "lib/blocs.typ": epaisseur-trait
#import "lib/meta.typ" as meta
#import "lib/automate.typ" as automate
#import "lib/code.typ" as code
#import "lib/theoremes.typ" as theoremes
#import "lib/cours.typ": cours, espace-reponse, solution
#import "lib/presentation.typ": presentation, cours-et-presentation, colonnes-cours, taille-presentation, item-by-item, pause, uncover, only, slide, article-only, slides-only

/// Importe un exercice ou un sujet depuis le package.
/// - chemin (str): Chemin relatif à la banque, par exemple "devoirs/concours/19/mines-ponts-2019-mp-informatique/mines-ponts-2019-mp-informatique.typ".
/// -> module
#let public(chemin) = {
  import chemin as source
  source
}
