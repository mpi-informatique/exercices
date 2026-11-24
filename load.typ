#import "lib/options.typ": est-corrige, est-presentation
#import "lib/exercice.typ": (
  afficher-exercice, aplatir, cible-question, donnees, est-partie, exercice, feuille, marge-droite,
  nombre-questions, partie, question, sujet-colle, texte-concours, titre-concours, titre-exercice, verifier-bareme,
)
#import "lib/document.typ": (
  PP, auteur-par-defaut, completer, document-pedagogique, hp, lien, liste-a-completer, paragraphe, pb, sep,
  substituer, tableau, telecharger, texte-duree, tp, widetilde,
)
#import "lib/blocs.typ": bloc-solution, coeur-en-marge, epaisseur-trait, marge
#import "lib/meta.typ" as meta
#import "lib/automate.typ" as automate
#import "lib/logique/regles.typ" as logique
#import "lib/code.typ" as code
#import "lib/theoremes.typ" as theoremes
#import "lib/cours.typ": cours, espace-reponse, saut-page-cours, solution
#import "lib/presentation.typ": (
  article-only, colonnes-cours, cours-et-presentation, equation-slide, formules-reparties, item-by-item, liste-cours,
  only, pause, presentation, slide, slides-only, taille-presentation, uncover,
)

/// Charge un contenu de la banque et renvoie son module, notamment ses exports `ex` ou `sujet`.
///
/// - chemin (str): Chemin relatif à la racine du package public.
/// -> module
#let public(chemin) = {
  import chemin as source
  source
}
