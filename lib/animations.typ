#import "@preview/touying:0.8.0": utils

// Une pause reconnue par Touying, distinguée des pauses explicites de l'auteur.
#let pause-automatique = [#metadata((
  kind: "touying-jump/pause/meanwhile",
  n: 1,
  relative: true,
  exercices-automatique: true,
)) <touying-temporary-mark>]

// Parcours de droite à gauche : une pause automatique ne sert que si du contenu suit.
// Les arguments des fonctions différées doivent être visités avant leur rendu.
#let nettoyer-pauses(it, suite: false) = {
  let arbre = utils.tree
  if type(it) == array {
    let resultat = ()
    for enfant in it.rev() {
      let (nouveau, apres) = nettoyer-pauses(enfant, suite: suite)
      resultat.push(nouveau)
      suite = apres
    }
    return (resultat.rev(), suite)
  }
  if type(it) != content { return (it, suite) }
  if it in arbre.empty-contents { return (it, suite) }
  if it.func() == pagebreak or arbre.is-heading(it, depth: 2) { return (it, false) }
  if arbre.is-metadata(it) {
    if type(it.value) != dictionary { return (it, suite) }
    let valeur = it.value
    let genre = valeur.at("kind", default: none)
    if valeur.at("exercices-automatique", default: false) {
      return (if suite { it } else { [] }, suite)
    }
    if genre == "touying-article-only" { return (it, suite) }
    if genre in ("touying-slides-only", "touying-article-text") {
      if genre == "touying-article-text" { return (it, suite) }
      let (body, apres) = nettoyer-pauses(valeur.body, suite: suite)
      if body == valeur.body { return (it, apres) }
      valeur.body = body
      return (arbre.relabel(metadata(valeur), it.at("label", default: none)), apres)
    }
    if genre in ("touying-fn-wrapper-raw", "touying-fn-wrapper") {
      let (contenus, _) = nettoyer-pauses(valeur.args.pos(), suite: suite)
      if contenus == valeur.args.pos() { return (it, true) }
      valeur.args = arguments(..contenus, ..valeur.args.named())
      return (arbre.relabel(metadata(valeur), it.at("label", default: none)), true)
    }
    return (it, suite)
  }
  let enfants = arbre.children-of(it)
  // Le titre d'un cadre est dans sa légende, mais ne constitue pas du contenu après son corps.
  if it.func() == figure {
    let (body, _) = nettoyer-pauses(it.body, suite: suite)
    if body == it.body { return (it, true) }
    enfants.at(0) = body
    return (arbre.rebuild(it, enfants), true)
  }
  if enfants.len() == 0 { return (it, true) }
  let (nouveaux, apres) = nettoyer-pauses(enfants, suite: suite)
  (if nouveaux == enfants { it } else { arbre.rebuild(it, nouveaux) }, apres)
}
