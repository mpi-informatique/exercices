/// Notation de l’ensemble des langages réguliers.
/// -> content
#let Lreg = $cal(L)_("reg")$

// Échelle commune proportionnelle au texte : 0.8cm à 10pt, agrandie en présentation.
#let unite-automates = (0.8cm / 10pt) * 1em
#let rayon-etat = 0.6
#let rayon-grand-etat = 0.9
#let dist-lettre = 0.33
#let style-automates = (
  state: (radius: rayon-etat),
  transition: (label: (angle: 0deg, dist: dist-lettre)),
)

#import "@preview/cetz:0.4.2" as cetz
#import "@preview/finite:0.5.1" as finite

/// Dessine un automate centré à partir de ses états et arcs explicites.
/// - etats (array): Entrées `(nom, position, initial, final)` ; `nom` est une chaîne mathématique Typst.
/// - arcs (array): Entrées `(départ, arrivée, étiquette, style)` ; étiquette mathématique et style finite.
///   Les étiquettes des transitions droites sont placées au-dessus par défaut, celles des arcs courbes à l'extérieur. `inverser: true` place l'étiquette de l'autre côté ; `label: (dist: ...)` permet de régler sa distance explicitement.
/// - echelle (array): Facteurs horizontal et vertical des positions, défaut `(1, 1)`.
/// - rayon (function): Rayon d'un état selon son nom, dans l'unité commune.
/// -> content
#let dessiner-automate(etats, arcs, echelle: (1, 1), rayon: nom => rayon-etat) = align(center, cetz.canvas(length: unite-automates, {
  import finite.draw: state, transition
  cetz.draw.set-style(..style-automates)
  let distance = style-automates.transition.label.dist
  let positions = (:)
  for (nom, position, initial, final) in etats {
    positions.insert(nom, (position.at(0) * echelle.at(0), position.at(1) * echelle.at(1)))
    state((position.at(0) * echelle.at(0), position.at(1) * echelle.at(1)), nom,
      radius: rayon(nom), label: math.equation(eval(nom, mode: "math")),
      initial: if initial { (label: none) } else { false }, final: final)
  }
  for (p, q, etiquette, style) in arcs {
    let style-etiquette = style.remove("label", default: (:))
    let autre-cote = style.remove("inverser", default: false)
    let courbure = style.at("curve", default: 1)
    // Pour une transition droite, finite calcule la normale à l'opposé du sens de lecture.
    let inverser = courbure < 0 or (courbure == 0 and positions.at(q).at(0) > positions.at(p).at(0))
    transition(p, q, label: (text: math.equation(eval(etiquette, mode: "math")),
      dist: if inverser != autre-cote { -distance } else { distance }) + style-etiquette, ..style)
  }
}))
