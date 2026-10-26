#import "lib/options.typ": est-presentation, est-corrige
#import "lib/exercice.typ": *
#import "lib/document.typ": sep, completer, liste-a-completer, widetilde
#import "lib/blocs.typ": epaisseur-trait
#import "lib/meta.typ" as meta
#import "lib/automate.typ" as automate
#import "lib/code.typ" as code
#import "lib/theoremes.typ" as theoremes
#import "lib/cours.typ": cours, espace-reponse, solution
#import "lib/presentation.typ": presentation, cours-et-presentation, slide, colonnes-cours, taille-presentation, equation-slide, item-by-item, pause, uncover, only, article-only, slides-only

/// Charge un contenu de la banque et renvoie son module, notamment ses exports `ex` ou `sujet`.
///
/// - chemin (str): Chemin relatif à la racine du package public.
/// -> module
#let public(chemin) = {
  import chemin as source
  source
}
