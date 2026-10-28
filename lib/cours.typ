#import "options.typ": est-corrige, est-presentation
#import "blocs.typ": bloc-solution, coeur-en-marge, epaisseur-trait
#import "@preview/touying:0.8.0": slides-only, touying-fn-wrapper-raw, utils
#import "animations.typ": pause-automatique
#import "document.typ": auteur-par-defaut, document-pedagogique

/// Résout les marques Touying puis compose le bloc de solution.
/// Utilitaire de rendu différé, appelé par `solution`.
///
/// - body (content): Solution.
/// - self (dictionary, none): Contexte Touying, s'il existe.
/// - coeur (bool): Ajouter un cœur dans la marge.
/// - encadrer (bool): Utiliser le cadre commun ; sinon, conserver seulement le cœur.
/// -> content
#let composer-solution(body, self: none, coeur: false, encadrer: true) = {
  if self != none {
    let article = self.at("article-mode", default: false)
    body = utils.tree.resolve-marks(body, ("touying-slides-only", "touying-article-only"), marque => {
      if (marque.kind == "touying-article-only") == article { marque.body } else { [] }
    })
  }
  if encadrer { bloc-solution(body, coeur: coeur) } else { coeur-en-marge(body) }
}

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
    titre: titre + if corrige { " — Corrigé" } else { "" },
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

/// Affiche la solution dans le corrigé et, sur demande, dans les autres sorties.
/// Les marques `article-only` et `slides-only` restent utilisables dans son contenu.
///
/// - cours (bool): Afficher aussi dans le cours non corrigé.
/// - presentation (bool): Afficher aussi dans les diapositives.
/// - coeur (bool): Ajouter un cœur à gauche, centré sur la solution.
/// - pause (bool): Ajouter une pause après la solution en présentation.
/// - body (content): Solution ou preuve.
/// -> content, none
#let solution(cours: false, presentation: false, coeur: false, pause: true, body) = {
  if est-presentation() and pause { body += pause-automatique }
  if est-corrige() or (cours and sys.inputs.at("format", default: "cours") == "cours") {
    // Le filtre article de Touying ne descend pas dans les arguments des fonctions différées.
    body = utils.tree.resolve-marks(body, ("touying-slides-only", "touying-article-only"), marque => {
      if marque.kind == "touying-slides-only" { [] } else { marque.body }
    })
    touying-fn-wrapper-raw(composer-solution, coeur: coeur, body)
  } else if presentation {
    slides-only(if coeur { touying-fn-wrapper-raw(composer-solution, coeur: true, encadrer: false, body) } else { body })
  }
}
