/// Mise en page A4 commune aux feuilles et aux cours.
#import "theoremes.typ": configurer-theoremes
#import "code.typ": configurer-code
#import "blocs.typ": epaisseur-trait

/// Espace horizontal de 0,5 em, utilisable dans une formule avec `#sep`.
/// -> content
#let sep = h(0.5em)

/// Complète la ligne courante par des pointillés semi-transparents légèrement abaissés.
/// -> content
#let completer() = box(width: 1fr, move(dy: 0.2em, text(fill: rgb(0%, 0%, 0%, 50%), repeat[.])))

/// Tilde élargi, y compris au-dessus d'une seule lettre.
/// - body (content): Expression à surmonter d'un tilde.
/// -> content
#let widetilde(body) = math.accent(body, sym.tilde, size: 150%)

/// Auteur utilisé par défaut dans les documents pédagogiques.
#let auteur-par-defaut = "Q. Fortier"

#let texte-duree(duree) = {
  let (heures, minutes) = duree
  if heures == 0 { str(minutes) + " min" } else if minutes == 0 { str(heures) + " h" } else {
    str(heures) + " h " + str(minutes) + " min"
  }
}

/// Compose la base A4 des documents pédagogiques.
/// - titre (str): Titre du document.
/// - niveau (str, none): Classe affichée à gauche.
/// - auteur (str, none): Auteur lié au site en haut à droite ; `none` le masque.
/// - duree (array, none): Couple heures/minutes, affiché entre parenthèses après le titre.
/// - attribution (str, none): Texte affiché à droite à la place de l'auteur.
/// - titre-entete (content, none): Titre dynamique ; `none` reprend `titre`.
/// - contenu-entete (content, none): En-tête personnalisé ; `none` utilise la composition commune.
/// - repeter-entete (bool): Répéter l'en-tête sur chaque page.
/// - taille (length): Taille du texte, défaut 10pt.
/// - body (content): Contenu du document.
/// -> content
#let document-pedagogique(
  titre: "Document",
  niveau: none,
  auteur: auteur-par-defaut,
  duree: none,
  attribution: none,
  titre-entete: none,
  contenu-entete: none,
  repeter-entete: false,
  taille: 10pt,
  body,
) = {
  set document(title: titre)
  set document(author: auteur) if auteur != none
  show: configurer-theoremes
  show: configurer-code
  set text(font: "New Computer Modern", size: taille, lang: "fr")
  set par(justify: true)
  set heading(numbering: "I.1.1 –")
  show heading.where(level: 1): set text(size: 1.1 * taille)
  show heading.where(level: 2): set text(size: 1.05 * taille)
  show heading.where(level: 3): set text(size: taille)
  set page(paper: "a4", margin: 10mm, header: none, footer: none, numbering: none)
  let entete = if contenu-entete != none { contenu-entete } else {
    context block(above: 0pt, below: 1em, sticky: true, {
      set block(above: 0pt, below: 0pt)
      stack(
        dir: ttb,
        spacing: 0.6em,
        grid(
          columns: (24mm, 1fr, if attribution == none { 24mm } else { auto }),
          column-gutter: 1em,
          align: (left, center, right),
          if niveau != none { niveau },
          text(size: 1.2em, weight: "bold")[
            #if titre-entete == none { titre } else { titre-entete }#if duree != none [ (#texte-duree(duree))]
          ],
          if attribution != none { attribution } else if auteur != none {
            link("https://mpi-informatique.github.io", auteur)
          },
        ),
        line(length: 100%, stroke: epaisseur-trait),
      )
    })
  }
  if repeter-entete {
    set page(margin: (top: 23mm, rest: 12mm), header: entete)
    body
  } else {
    // L'en-tête dans le flux ne réduit que la première page.
    entete
    body
  }
}
