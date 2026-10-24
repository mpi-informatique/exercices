#import "blocs.typ": bloc-solution, epaisseur-trait
#import "@preview/touying:0.8.0": slides-only, touying-fn-wrapper-raw, utils
#import "document.typ": auteur-par-defaut, document-pedagogique

// Touying résout les marques imbriquées avant d'appliquer la mise en forme commune.
#let composer-solution(body, self: none) = bloc-solution(body)

#let cours(titre: "Cours", niveau: none, auteur: auteur-par-defaut, taille: 10pt, body) = {
  let corrige = sys.inputs.at("corrige", default: "false") == "true"
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

/// Dans une source commune, entourer l’appel de `article-only[...]`.
#let espace-reponse(lignes) = {
  assert(type(lignes) == int and lignes >= 0)
  for _ in range(lignes) {
    block(width: 100%, above: 1.1em, below: 0pt, line(length: 100%, stroke: epaisseur-trait + luma(65%)))
  }
}

#let solution(cours: false, presentation: false, body) = {
  if sys.inputs.at("corrige", default: "false") == "true" or (cours and sys.inputs.at("format", default: "cours") == "cours") {
    // Le filtre article de Touying ne descend pas dans les arguments des fonctions différées.
    body = utils.tree.resolve-marks(body, ("touying-slides-only", "touying-article-only"), marque => {
      if marque.kind == "touying-slides-only" { [] } else { marque.body }
    })
    touying-fn-wrapper-raw(composer-solution, body)
  } else if presentation {
    slides-only(body)
  }
}
