/// Présentation A4 des cours, avec les environnements communs de la banque.
#import "blocs.typ": epaisseur-trait
#import "@preview/touying:0.8.0": slides-only
#import "document.typ": document-pedagogique, auteur-par-defaut

/// Compose un cours continu, utilisable seul ou comme thème article de Touying.
/// - titre (str): Titre du cours.
/// - niveau (str, none): Classe affichée dans l'en-tête.
/// - auteur (str, none): Auteur lié au site dans l'en-tête, défaut « Q. Fortier » ; `none` le masque.
/// - taille (length): Taille du texte, défaut 10pt.
/// - body (content): Contenu du cours.
/// -> content
#let cours(titre: "Cours", niveau: none, auteur: auteur-par-defaut, taille: 10pt, body) = {
  let corrige = sys.inputs.at("corrige", default: "false") == "true"
  show: document-pedagogique.with(titre: titre + if corrige { " — Corrigé" } else { "" }, niveau: niveau, auteur: auteur, taille: taille)
  [#metadata((type: "cours", titre: titre, niveau: niveau, corrige: corrige)) <document-meta>]
  body
}

/// Réserve des lignes de réponse dans un cours imprimé.
/// Dans une source commune, entourer l'appel de `article-only[...]`.
/// - lignes (int): Nombre de lignes, positif ou nul.
/// -> content
#let espace-reponse(lignes) = {
  assert(type(lignes) == int and lignes >= 0)
  for _ in range(lignes) {
    block(width: 100%, above: 1.1em, below: 0pt, line(length: 100%, stroke: epaisseur-trait + luma(65%)))
  }
}

/// Affiche une solution dans le cours corrigé et dans la présentation.
/// Masquée dans le cours normal, précédée de « Solution » dans le corrigé.
/// Les pauses et titres réservés à la projection peuvent rester dans `slides-only[...]`.
/// - body (content): Solution ou preuve.
/// -> content
#let solution(body) = {
  if sys.inputs.at("corrige", default: "false") == "true" {
    [*Solution.* #body]
  } else {
    slides-only(body)
  }
}
