#import "blocs.typ": bloc-solution
#import "meta.typ": (
  algorithmes-programme, chapitres-programme, concours-possibles, filieres-possibles, langages-possibles,
  niveaux-par-chapitre, structures-programme,
)
#import "document.typ": auteur-par-defaut, document-pedagogique, texte-duree

// Les exercices sont des données Typst ordinaires.
#let question(enonce, jury: none, solution: none, bareme: none, notation: none, label: none) = {
  assert(label == none or type(label) == std.label, message: "label doit être une étiquette Typst ou none")
  assert(jury == none or type(jury) == content, message: "jury doit être un contenu Typst ou none")
  assert(notation == none or type(notation) == content, message: "notation doit être un contenu Typst ou none")
  assert(
    bareme == none or bareme in (0.25, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4),
    message: "Points autorisés : 0.25, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4 ou none",
  )
  (type: "question", enonce: enonce, jury: jury, solution: solution, bareme: bareme, notation: notation, label: label)
}

#let cible-question(q, numero, body) = {
  let etiquette = q.at("label", default: none)
  if etiquette == none { return body }
  context {
    let alignement = align.alignment
    // La figure sert de cible au renvoi et ne doit pas centrer le texte de la question.
    show figure.where(kind: "question"): set align(alignement)
    show figure.where(kind: "question"): it => it.body
    [#figure(kind: "question", supplement: [Question], numbering: _ => str(numero), outlined: false, body)#etiquette]
  }
}

#let texte-concours(concours) = (
  (
    concours.at("nom", default: none),
    concours.at("annee", default: none),
    concours.at("filiere", default: none),
    if concours.at("oral", default: false) { "oral" } else { none },
  )
    .filter(valeur => valeur != none)
    .map(valeur => str(valeur))
    .join(" ")
)

// Conserver à la fois l'attribution et le titre du contenu.
#let titre-concours(titre, concours) = {
  if concours == none { titre } else { texte-concours(concours) + " : " + titre }
}

// Titres communs aux exercices et aux parties des sujets.
#let titre-exercice(titre, prefixe, concours: none, niveau: 1) = {
  block(breakable: false, sticky: true)[
    #heading(level: niveau, numbering: none)[
      #grid(
        columns: (1fr, auto),
        column-gutter: 1em,
        align: (left, right),
        [#prefixe -- #titre],
        [#if concours != none {
          text(fill: luma(35%).transparentize(30%))[
            #texte-concours(concours)
          ]
        }],
      )
    ]
  ]
}

// Le contexte contient les rappels à ajouter dans un exercice autonome.
/// `contexte` est conservé pour les extraits autonomes, sans insertion automatique.
#let partie(numero, titre, contenu: (), contexte: (), meta: (:), jury: none) = {
  assert(type(numero) == str and numero != "", message: "Numéro de partie vide")
  assert(type(titre) == str and titre != "", message: "Titre de partie vide")
  assert(type(contenu) == array and type(contexte) == array)
  assert(contexte.all(bloc => type(bloc) == content), message: "Le contexte contient uniquement du texte Typst")
  assert(jury == none or type(jury) == content)
  (jury: jury, type: "partie", numero: numero, titre: titre, contenu: contenu, contexte: contexte, meta: meta)
}

#let est-partie(bloc) = type(bloc) == dictionary and bloc.at("type", default: none) == "partie"

#let aplatir(contenu, niveau: 1, textes: true, jury: false) = {
  let resultat = ()
  for bloc in contenu {
    if est-partie(bloc) {
      resultat.push(titre-exercice(bloc.titre, bloc.numero, niveau: niveau))
      if jury and bloc.jury != none {
        resultat.push(text(style: "italic", bloc.jury))
      }
      resultat += aplatir(bloc.contenu, niveau: niveau + 1, textes: textes, jury: jury)
    } else if textes or type(bloc) != content {
      resultat.push(bloc)
    }
  }
  resultat
}

#let nombre-questions(contenu) = aplatir(contenu).filter(bloc => type(bloc) == dictionary).len()

// Un barème suit les questions dans l'ordre, y compris dans les parties imbriquées.
#let verifier-bareme(bareme, nombre) = {
  if bareme != none {
    assert(type(bareme) == array, message: "bareme doit être un tableau ou none")
    assert(bareme.len() == nombre, message: "bareme doit contenir une valeur par question")
    for points in bareme {
      assert(
        points == none or points in (0.25, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4),
        message: "Points autorisés : 0.25, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4 ou none",
      )
    }
  }
}

/// `corrections` et `notation` sont conservées dans les données, sans affichage.
/// Le barème global est conservé pour compatibilité ; préférer celui de chaque question.
#let exercice(meta: (:), contenu: (), colonnes: 1, jury: none, corrections: none, notation: none, bareme: none) = {
  assert(type(colonnes) == int and colonnes > 0, message: "colonnes doit être un entier strictement positif")
  let champs = ("titre", "chapitres", "difficulte")
  for champ in champs {
    assert(champ in meta, message: "Métadonnée manquante : " + champ)
  }
  assert(not ("id" in meta), message: "id est déduit du nom du fichier .typ")
  assert(type(meta.titre) == str and meta.titre != "", message: "titre doit être une chaîne non vide")
  let meta = (algorithmes: (), structures: (), langages: (), ..meta)
  for champ in ("chapitres", "algorithmes", "structures", "langages") {
    assert(type(meta.at(champ)) == array, message: champ + " doit être un tableau")
    for valeur in meta.at(champ) {
      assert(type(valeur) == str, message: champ + " doit contenir des chaînes")
    }
  }
  for (champ, valeurs) in (
    ("chapitres", chapitres-programme),
    ("algorithmes", algorithmes-programme),
    ("structures", structures-programme),
  ) {
    for valeur in meta.at(champ) {
      assert(valeur in valeurs, message: champ + " : étiquette absente du programme : " + valeur)
    }
  }
  assert(
    type(meta.difficulte) == int and meta.difficulte >= 1 and meta.difficulte <= 5,
    message: "difficulte doit être un entier de 1 à 5",
  )
  let niveaux = meta.at("niveaux", default: ())
  assert(type(niveaux) == array, message: "niveaux doit être un tableau")
  for niveau in niveaux {
    assert(type(niveau) == str, message: "niveaux doit contenir des chaînes")
  }
  for chapitre in meta.chapitres {
    for niveau in niveaux {
      assert(
        niveau in niveaux-par-chapitre.at(chapitre),
        message: "chapitres : " + chapitre + " n'est pas au programme du niveau " + niveau,
      )
    }
  }
  // Convention de la banque pour la programmation en MP2I–MPI.
  if "MP2I" in niveaux or "MPI" in niveaux {
    for langage in meta.langages {
      assert(
        langage in langages-possibles,
        message: "langages : en MP2I–MPI, utiliser C, OCaml, Python ou SQL : " + langage,
      )
    }
  }
  let duree = meta.at("duree", default: none)
  if duree != none {
    assert(type(duree) == array and duree.len() == 2, message: "duree doit être un couple (heures, minutes) ou none")
    let (heures, minutes) = duree
    assert(type(heures) == int and type(minutes) == int, message: "heures et minutes doivent être des entiers")
    assert(
      heures >= 0 and minutes >= 0 and minutes < 60 and heures + minutes > 0,
      message: "duree doit être positive, avec 0 ≤ minutes < 60",
    )
  }
  assert(not ("reference" in meta), message: "Utiliser concours au lieu de reference")
  let concours = meta.at("concours", default: none)
  let concours-normalise = if concours != none {
    assert(type(concours) == dictionary, message: "concours doit être un dictionnaire ou none")
    if "nom" in concours {
      assert(
        type(concours.nom) == str and concours.nom in concours-possibles,
        message: "nom doit être un concours connu",
      )
    }
    if "annee" in concours {
      assert(
        type(concours.annee) == int and concours.annee > 0,
        message: "L'année du concours doit être un entier strictement positif",
      )
    }
    if "filiere" in concours {
      assert(
        type(concours.filiere) == str and concours.filiere in filieres-possibles,
        message: "filiere doit être une filière connue",
      )
    }
    if "oral" in concours {
      assert(type(concours.oral) == bool, message: "oral doit être un booléen")
    }
    concours
  } else {
    none
  }
  let verifier(blocs) = {
    assert(type(blocs) == array, message: "contenu doit être un tableau de textes, questions et parties")
    for bloc in blocs {
      if est-partie(bloc) {
        verifier(bloc.contenu)
      } else if type(bloc) != content {
        assert(type(bloc) == dictionary, message: "Utiliser [texte libre], question(…) ou partie(…) dans contenu")
        assert(bloc.at("type", default: none) == "question", message: "Bloc inconnu dans contenu")
        assert("enonce" in bloc and "solution" in bloc, message: "Construire les questions avec question(…)")
      }
    }
  }
  verifier(contenu)
  verifier-bareme(bareme, nombre-questions(contenu))
  assert(corrections == none or type(corrections) == content, message: "corrections doit être un contenu Typst ou none")
  assert(notation == none or type(notation) == content, message: "notation doit être un contenu Typst ou none")
  assert(jury == none or type(jury) == content, message: "jury doit être un contenu Typst ou none")
  assert(nombre-questions(contenu) > 0, message: "Un exercice doit contenir au moins une question")
  (
    meta: (niveaux: (), duree: none, ..meta, concours: concours-normalise),
    contenu: contenu,
    colonnes: colonnes,
    jury: jury,
    corrections: corrections,
    notation: notation,
    bareme: bareme,
  )
}

#let marge-droite(body) = place(top + left, dx: 100% + 5mm, block(width: 15mm, {
  set align(left)
  body
}))

#let afficher-exercice(
  ex,
  numero: none,
  corrige: false,
  afficher-titre: true,
  afficher-contexte: true,
  bareme: none,
  espacement: auto,
) = {
  let bareme = if bareme == none { ex.bareme } else { bareme }
  let nombre = nombre-questions(ex.contenu)
  verifier-bareme(bareme, nombre)
  // Conserver les titres et numéros explicites du contenu des exercices.
  set heading(numbering: none)
  show strong: it => it.body
  show heading: set text(weight: "bold")
  [#metadata(ex.meta) <exercice-meta>]
  if afficher-titre {
    let prefixe = if numero == none { "I" } else { numbering("I", numero) }
    titre-exercice(ex.meta.titre, prefixe, concours: ex.meta.concours)
  }
  if corrige and ex.jury != none {
    block(width: 100%, above: espacement, below: espacement)[
      #text(style: "italic")[
        #ex.jury
      ]
    ]
  }
  let i = 1
  let colonnes = if corrige { 1 } else { ex.at("colonnes", default: 1) }
  let questions = ()
  let afficher-questions(questions) = context grid(columns: (1fr,)
      * colonnes, column-gutter: 1.5em, row-gutter: if espacement == auto { par.spacing } else {
      espacement
    }, ..questions)
  for q in aplatir(ex.contenu, textes: not corrige or afficher-contexte, jury: corrige) {
    if type(q) == content {
      if questions.len() > 0 {
        afficher-questions(questions)
        questions = ()
      }
      block(width: 100%, above: espacement, below: espacement, q)
      continue
    }
    // Chaque énoncé est un paragraphe distinct ; les longues questions restent sécables.
    let enonce = cible-question(q, i, block(width: 100%, above: espacement, below: espacement, {
      let points = if bareme == none { q.at("bareme", default: none) } else { bareme.at(i - 1) }
      if corrige and points != none {
        // Placement hors du corps : la note suit le début de la question sans réserver de hauteur.
        marge-droite[
          #metadata((question: i, points: points)) <bareme-question>
          #text(size: 9pt, weight: "regular", fill: black.transparentize(50%), str(points))
        ]
      }
      if nombre == 1 { q.enonce } else {
        enum(start: i, numbering: "1.", indent: 0pt, body-indent: 0.5em, q.enonce)
      }
    }))
    if colonnes == 1 { enonce } else { questions.push(enonce) }
    if corrige {
      if q.jury != none {
        block(width: 100%, above: espacement, below: espacement, text(style: "italic", q.jury))
      }
      bloc-solution(q.solution, above: espacement, below: espacement)
    }
    i += 1
  }
  if questions.len() > 0 { afficher-questions(questions) }
}

#let sujet-colle(numero, exercices, corrige: false) = {
  pagebreak(weak: true)
  counter(heading).update(0)
  [#metadata((numero: numero, corrige: corrige)) <colle-sujet>]
  for (i, ex) in exercices.enumerate(start: 1) {
    afficher-exercice(ex, numero: i, corrige: corrige)
  }
}

/// Les ressources `tp` sont relatives au fichier source et exportées sans effet sur le PDF.
/// Le barème de la feuille remplace ceux des exercices ; une entrée `none` masque les points.
#let feuille(
  type: "td",
  titre: "Feuille d'exercices",
  niveau: none,
  auteur: auteur-par-defaut,
  duree: none,
  concours: none,
  exercices: (),
  tp: none,
  corrige: false,
  nouvelle-page: false,
  afficher-exercices: true,
  espacement: 1em,
  bareme: none,
  body,
) = {
  assert(type == str(type) and type != "", message: "Le type de document doit être une chaîne non vide")
  assert(tp == none or (type == "tp" and std.type(tp) == dictionary), message: "tp doit être un dictionnaire réservé aux documents de type tp")
  verifier-bareme(bareme, exercices.map(ex => nombre-questions(ex.contenu)).sum(default: 0))
  let titre-affiche = titre + if corrige { " : corrigé" } else { "" }
  let duree = if type not in ("devoir", "concours") { none } else if duree != none { duree } else if (
    exercices.len() == 1
  ) { exercices.first().meta.duree } else { none }
  let titre-entete = if type == "colle" {
    context {
      // Inclure le repère du début de page, même s'il suit l'en-tête dans le flux.
      let sujets = query(<colle-sujet>).filter(sujet => sujet.location().page() <= here().page())
      titre-affiche
      if sujets.len() > 0 {
        let sujet = sujets.last().value
        [ -- Sujet #sujet.numero#if sujet.corrige [ (corrigé)]]
      }
    }
  } else { none }
  show: document-pedagogique.with(
    titre: titre-affiche,
    niveau: if concours == none { niveau } else { concours.at("filiere", default: none) },
    auteur: auteur,
    duree: duree,
    attribution: if concours == none { none } else { texte-concours((..concours, filiere: none)) },
    titre-entete: titre-entete,
    repeter-entete: type == "colle",
  )
  [#metadata((type: type, titre: titre, niveau: niveau, concours: concours, ..if tp == none { (:) } else { (tp: tp) })) <document-meta>]
  body
  let afficher-contexte = type not in ("devoir", "concours") or concours == none or concours.at("oral", default: false)
  let debut-bareme = 0
  for (i, ex) in if afficher-exercices { exercices.enumerate(start: 1) } else { () } {
    if i > 1 and type != "colle" and nouvelle-page { pagebreak() }
    let fin-bareme = debut-bareme + nombre-questions(ex.contenu)
    afficher-exercice(
      ex,
      bareme: if bareme == none { none } else { bareme.slice(debut-bareme, fin-bareme) },
      numero: if exercices.len() > 1 { i } else { none },
      corrige: corrige,
      afficher-titre: exercices.len() > 1 or titre != ex.meta.titre,
      afficher-contexte: afficher-contexte,
      espacement: espacement,
    )
    debut-bareme = fin-bareme
  }
}
