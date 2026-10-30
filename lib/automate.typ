#let LL = $cal(L)$
#let LA = $LL(A)$
#let Le = $LL(e)$
#let Lreg = $LL_("reg")$
#let Lrec = $LL_("rec")$
#let Lloc = $cal(L)_("loc")$
#let Ereg = $cal(R)$

// Échelle commune proportionnelle au texte : 0.8cm à 10pt, agrandie en présentation.
#let unite-automates = (0.8cm / 10pt) * 1em
#let rayon-etat = 0.5
#let rayon-grand-etat = 0.9
#let dist-lettre = 0.33
#let style-automates = (
  state: (radius: rayon-etat),
  transition: (curve: 0, label: (angle: 0deg, dist: dist-lettre)),
)

#import "@preview/cetz:0.4.2" as cetz
#import "@preview/finite:0.5.1" as finite

/// Dessine un automate centré avec le style commun CeTZ/finite.
/// Noms et étiquettes utilisent la syntaxe mathématique Typst.
/// La courbure des transitions vaut `0` par défaut ; chaque arc peut définir `curve`.
///
/// - etats (array): Tuples `(nom, position, initial, final)` ; `initial` accepte un booléen ou un alignement.
/// - arcs (array): Tuples `(départ, arrivée, étiquette, style)` ; `inverser: true` change le côté de l'étiquette et `label: (dist: ...)` sa distance.
/// - echelle (array): Facteurs horizontal et vertical des positions, sans changer les rayons.
/// - rayon (function): Rayon de chaque état à partir de son nom.
/// -> content
#let dessiner-automate(etats, arcs, echelle: (1, 1), rayon: nom => rayon-etat) = align(center, cetz.canvas(
  length: unite-automates,
  {
    import finite.draw: state, transition
    cetz.draw.set-style(..style-automates)
    let distance = style-automates.transition.label.dist
    let positions = (:)
    for (nom, position, initial, final) in etats {
      positions.insert(nom, (position.at(0) * echelle.at(0), position.at(1) * echelle.at(1)))
      state(
        (position.at(0) * echelle.at(0), position.at(1) * echelle.at(1)),
        nom,
        radius: rayon(nom),
        label: math.equation(eval(nom, mode: "math")),
        initial: if initial == false { false } else if initial == true { (label: none) } else {
          (anchor: initial, label: none)
        },
        final: final,
      )
    }
    for (p, q, etiquette, style) in arcs {
      let style-etiquette = style.remove("label", default: (:))
      let autre-cote = style.remove("inverser", default: false)
      let courbure = style.at("curve", default: style-automates.transition.curve)
      // Pour une transition droite, finite calcule la normale à l'opposé du sens de lecture.
      let inverser = courbure < 0 or (courbure == 0 and positions.at(q).at(0) > positions.at(p).at(0))
      transition(
        p,
        q,
        label: (
          text: math.equation(eval(etiquette, mode: "math")),
          dist: if inverser != autre-cote { -distance } else { distance },
        )
          + style-etiquette,
        ..style,
      )
    }
  },
))
