#import "theoremes.typ": configurer-theoremes, pb
#import "code.typ": configurer-code
#import "blocs.typ": bloc-solution, epaisseur-trait, marge
#import "options.typ": est-presentation

#let sep = h(0.5em)
#let PP = $cal(P)$

#let couleur-liens = rgb("#233e6a")

/// Affiche les liens en bleu foncé, sans symbole ajouté par défaut.
/// Les références sont également affichées en bleu foncé.
/// À utiliser comme règle `show` ; les modèles A4 et Madrid l'installent automatiquement.
///
/// - body (content): Contenu à mettre en forme.
/// -> content
#let configurer-liens(body) = {
  show link: set text(fill: couleur-liens)
  show ref: set text(fill: couleur-liens)
  body
}

/// Crée un lien bleu vers un fichier à télécharger.
/// Exemple : `#telecharger("https://exemple.fr/tp-automates.ml")[Fichier OCaml]`.
///
/// - url (str): Adresse du fichier à télécharger.
/// - body (content): Texte cliquable.
/// -> content
#let telecharger(url, body) = link(url, text(fill: couleur-liens, body))

/// Signale un complément ou un contenu hors programme par « HP » dans la marge.
/// Le repère utilise 70 % du corps courant.
/// Exemple : `#hp[Théorème de Myhill-Nerode]`.
///
/// - body (content): Titre ou contenu à signaler.
/// -> content
#let hp(body) = marge([HP], body)

/// Crée un lien bleu vers une ressource du site Exercices MPI ou une étiquette du document.
/// Exemples : `#lien("tp-automates")[TP sur les automates]`, `#lien(<resultat>)[ce résultat]`.
///
/// - id (str, label): Identifiant de la ressource dans l'URL du site, sans barres obliques, ou étiquette interne.
/// - body (content): Texte cliquable.
/// -> content
#let lien(id, body) = link(
  if type(id) == label { id } else { "https://mpi-informatique.github.io/exercices/" + id + "/" },
  text(fill: couleur-liens, body),
)

/// Signale un travail pratique par « TP » dans la marge, au même corps que « HP ».
/// Avec `id`, le repère devient un lien bleu vers la ressource correspondante.
/// Exemple : `#tp(id: "tp-automates")[Implémenter la déterminisation d'un automate.]`.
///
/// - id (str, none): Identifiant de la ressource ; `none` conserve un repère sans lien.
/// - body (content): Contenu à signaler.
/// -> content
#let tp(id: none, body) = marge(if id == none { [TP] } else { lien(id)[TP] }, body)

/// Introduit un exemple, une remarque ou un autre passage par un titre souligné suivi de deux-points.
/// Avec `trait: true`, le cours A4 utilise le même trait vertical sécable que les solutions.
/// En présentation, le trait est omis. Le contenu est toujours visible.
/// Exemple : `#paragraphe([Exemple], trait: true)[Un exemple développé sur plusieurs paragraphes.]`.
///
/// - titre (content, str): Libellé, par exemple « Exemple », « Remarque » ou « Attention ».
/// - trait (bool): Ajouter un trait vertical à gauche dans le cours et le corrigé.
/// - body (content): Contenu du passage.
/// -> content
#let paragraphe(titre, trait: false, body) = {
  let contenu = [#underline(titre) : #body]
  if trait and not est-presentation() { bloc-solution(contenu) } else { contenu }
}

/// Trace des pointillés sur la largeur restante de la ligne, sauf en présentation.
///
/// - taille (relative, fraction): Largeur des pointillés ; `1fr` occupe l'espace restant par défaut.
/// -> content
#let completer(taille: 1fr) = if not est-presentation() {
  box(width: taille, move(dy: 0.2em, text(fill: rgb(0%, 0%, 0%, 25%), repeat[.])))
}

/// Construit une liste numérotée avec des pointillés après chaque élément.
///
/// - start (int): Premier numéro.
/// - ..items (arguments): Contenus des éléments.
/// -> content
#let liste-a-completer(start: 1, ..items) = enum(start: start, ..items.pos().map(item => [#item #completer()]))

/// Place un tilde large au-dessus du contenu mathématique, notamment pour le miroir.
///
/// - body (content): Mot, langage ou autre expression à accentuer.
/// -> content
#let widetilde(body) = math.accent(body, sym.tilde, size: 150%)

/// Note la substitution de toutes les occurrences d'une variable dans une formule.
/// Exemple en mode mathématique : `substituer(φ, x, ψ)` affiche φ[x := ψ].
///
/// - formule (content): Formule dans laquelle effectuer la substitution.
/// - variable (content): Variable à remplacer.
/// - valeur (content): Formule substituée à la variable.
/// -> content
#let substituer(formule, variable, valeur) = $formule[variable := valeur]$

/// Désactive par défaut la numérotation des figures dans les documents et les présentations.
/// Un argument `numbering` explicite reste prioritaire.
///
/// - body (content): Contenu à mettre en forme.
/// -> content
#let configurer-figures(body) = {
  set figure(numbering: none)
  body
}

/// Applique l'espacement commun des formules centrées aux documents et aux présentations.
/// À utiliser comme règle `show`.
///
/// - body (content): Contenu à mettre en forme.
/// -> content
#let configurer-formules(body) = {
  show math.equation.where(block: true): set block(spacing: 0.8em)
  body
}

/// Crée un tableau avec un en-tête bleu pâle, une première colonne grisée et des traits fins.
/// La première ligne est à fournir avec `table.header` ; les titres restent à mettre en gras.
/// Accepte les arguments de `table`, qui permettent de remplacer les réglages par défaut.
/// Exemple : `#tableau(columns: 2, table.header([*Nom*], [*Valeur*]), [Exemple], [42])`.
///
/// - ..args (arguments): Colonnes, cellules et options de la table native Typst.
/// -> content
#let tableau(..args) = {
  set table(
    align: center + horizon,
    inset: (x: 0.6em, y: 0.5em),
    stroke: 0.4pt + luma(190),
    fill: (x, y) => if x * y == 0 { luma(95%) },
  )
  table(..args)
}

#let auteur-par-defaut = "Q. Fortier"

/// Rend un titre cliquable vers sa page sur le site, avec la couleur commune des liens.
/// L'entrée système `url-document` est renseignée par les outils de compilation de la banque.
/// Sans cette entrée, le titre reste du texte simple.
///
/// - body (content, str): Titre affiché.
/// -> content
#let titre-lie(body) = {
  let url = sys.inputs.at("url-document", default: "")
  if url == "" { body } else { link(url, body) }
}

/// Formate le couple `(heures, minutes)` en durée lisible.
///
/// - duree (array): Couple de deux entiers.
/// -> str
#let texte-duree(duree) = {
  let (heures, minutes) = duree
  if heures == 0 { str(minutes) + " min" } else if minutes == 0 { str(heures) + " h" } else {
    str(heures) + " h " + str(minutes) + " min"
  }
}

/// Applique la mise en page A4 commune, les styles de code et de cadres.
/// À utiliser comme règle `show` ; les modèles spécialisés ajoutent leurs métadonnées.
///
/// - titre (str): Titre du document et des métadonnées PDF.
/// - niveau (str, none): Niveau affiché à gauche de l'en-tête.
/// - auteur (str, none): Auteur du PDF et attribution de secours.
/// - duree (array, none): Couple `(heures, minutes)` affiché après le titre.
/// - attribution (content, str, none): Attribution remplaçant l'auteur dans l'en-tête.
/// - titre-entete (content, str, none): Titre affiché à la place de `titre`.
/// - contenu-entete (content, none): En-tête complet remplaçant sa composition standard.
/// - repeter-entete (bool): Répéter l'en-tête sur chaque page, notamment pour les colles.
/// - taille (length): Taille du texte.
/// - body (content): Corps du document.
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
  show: configurer-figures
  show: configurer-liens
  set text(font: "New Computer Modern", size: taille, lang: "fr")
  set par(justify: true)
  show: configurer-formules
  set heading(numbering: "I.1.1 –")
  show heading: set block(below: 0.8em)
  show heading.where(level: 2): set block(above: 0.8em)
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
            #titre-lie([#if titre-entete == none { titre } else { titre-entete }#if duree != none [ -- #texte-duree(duree)]])
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
