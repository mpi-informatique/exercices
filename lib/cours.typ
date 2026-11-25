#import "options.typ": est-corrige, est-presentation
#import "blocs.typ": composer-solution, epaisseur-trait, solution
#import "document.typ": auteur-par-defaut, document-pedagogique

/// Applique la mise en page d'un cours A4 et publie `<document-meta>`.
/// L'entrée système `corrige=true` active le corrigé et complète le titre.
///
/// - titre (str): Titre du cours.
/// - niveau (str, none): Niveau affiché.
/// - auteur (str, none): Auteur.
/// - taille (length): Taille du texte.
/// - body (content): Contenu du cours.
/// -> content
#let cours(titre: "Cours", niveau: none, auteur: auteur-par-defaut, taille: 10pt, body) = {
  let corrige = est-corrige()
  show: document-pedagogique.with(
    titre: titre + if corrige { " – Corrigé" } else { "" },
    niveau: niveau,
    auteur: auteur,
    taille: taille,
  )
  // Sans Touying, composer directement les solutions encore présentes sous forme de marques.
  show metadata: it => if type(it.value) == dictionary and it.value.at("fn", default: none) == composer-solution {
    composer-solution(..it.value.args)
  } else {
    it
  }
  [#metadata((type: "cours", titre: titre, niveau: niveau, corrige: corrige)) <document-meta>]
  body
}

/// Force un saut de page uniquement dans le cours non corrigé.
/// Sans effet dans le corrigé et dans la présentation.
///
/// -> content, none
#let saut-page-cours() = {
  if not est-presentation() and not est-corrige() { pagebreak() }
}

/// Trace des lignes de réponse. Dans une source commune, entourer l'appel de `article-only[...]`.
///
/// - lignes (int): Nombre de lignes, positif ou nul.
/// -> content
#let espace-reponse(lignes) = {
  assert(type(lignes) == int and lignes >= 0)
  for _ in range(lignes) {
    block(width: 100%, above: 1.1em, below: 0pt, line(length: 100%, stroke: epaisseur-trait + luma(65%)))
  }
}
