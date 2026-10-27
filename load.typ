#import "lib/options.typ": est-corrige, est-presentation
#import "lib/exercice.typ": *
#import "lib/document.typ": PP, completer, hp, lien, liste-a-completer, sep, tp, widetilde
#import "lib/blocs.typ": coeur-en-marge, epaisseur-trait, marge
#import "lib/meta.typ" as meta
#import "lib/automate.typ" as automate
#import "lib/code.typ" as code
#import "lib/theoremes.typ" as theoremes
#import "lib/cours.typ": cours, espace-reponse, solution
#import "lib/presentation.typ": (
  article-only, colonnes-cours, cours-et-presentation, equation-slide, item-by-item, only, pause, presentation, slide,
  slides-only, taille-presentation, uncover,
)

/// Charge un contenu de la banque et renvoie son module, notamment ses exports `ex` ou `sujet`.
///
/// - chemin (str): Chemin relatif à la racine du package public.
/// -> module
#let public(chemin) = {
  import chemin as source
  source
}
