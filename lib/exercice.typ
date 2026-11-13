#import "blocs.typ": bloc-solution
#import "meta.typ": (
  algorithmes-programme, chapitres-programme, concours-possibles, filieres-possibles, langages-possibles,
  niveaux-par-chapitre, structures-programme,
)
#import "document.typ": auteur-par-defaut, document-pedagogique, texte-duree

// Les blocs de rédaction sont convertis en données avant la mise en page.
#let marquer-bloc(bloc) = metadata((exercices-bloc: true, bloc: bloc))
#let est-bloc(it) = (
  type(it) == content
    and it.func() == metadata
    and type(it.value) == dictionary
    and it.value.at("exercices-bloc", default: false)
)
#let contient-bloc(it) = {
  if type(it) == content {
    if est-bloc(it) { return true }
    return contient-bloc(it.fields())
  }
  if type(it) == dictionary { return it.values().any(contient-bloc) }
  if type(it) == array { return it.any(contient-bloc) }
  false
}
#let texte-bloc(enfants) = {
  let blancs = ([], [ ], parbreak())
  while enfants.len() > 0 and enfants.first() in blancs { let _ = enfants.remove(0) }
  while enfants.len() > 0 and enfants.last() in blancs { let _ = enfants.pop() }
  if enfants.len() == 0 { [] } else { enfants.join([]) }
}
#let lire-blocs(body) = {
  assert(type(body) in (content, array), message: "Le corps doit être un bloc Typst ou un tableau de données")
  let sequence = [a#metadata(none)].func()
  let enfants = if type(body) == array { body } else if body.func() == sequence { body.children } else { (body,) }
  let resultat = ()
  let texte = ()
  for enfant in enfants {
    assert(type(enfant) in (content, dictionary), message: "Un corps contient des textes, questions et parties")
    if type(enfant) == content and not est-bloc(enfant) {
      assert(
        not contient-bloc(enfant),
        message: "Placer question et partie directement dans le corps ; appliquer les styles locaux dans l'énoncé ou la solution, et le style général dans le modèle.",
      )
    }
    if est-bloc(enfant) or type(enfant) == dictionary or type(body) == array {
      let avant = texte-bloc(texte)
      if avant != [] { resultat.push(avant) }
      texte = ()
      resultat.push(if est-bloc(enfant) { enfant.value.bloc } else { enfant })
    } else {
      texte.push(enfant)
    }
  }
  let apres = texte-bloc(texte)
  if apres != [] { resultat.push(apres) }
  resultat
}

/// Construit une question dans le corps d'un exercice ou d'une partie.
/// `label` permet les renvois `@etiquette` ; `notation` est réservée au correcteur.
/// Écrire `#question(bareme: 1)[Énoncé.][Solution.]` ; le second bloc est facultatif.
///
/// - enonce (content): Question posée.
/// - jury (content, none): Observation affichée dans le corrigé.
/// - ..suite (arguments): Second bloc facultatif contenant la solution ; son absence ne produit aucun bloc de corrigé.
/// - bareme (float, int, none): Points attribués, parmi les valeurs validées par l'API.
/// - notation (content, none): Critères de correction conservés sans affichage.
/// - label (label, none): Étiquette unique dans le document.
/// -> content
#let question(enonce, jury: none, bareme: none, notation: none, label: none, ..suite) = {
  assert(suite.named().len() == 0, message: "La solution s'écrit dans le second bloc : question[Énoncé][Solution]")
  assert(suite.pos().len() <= 1, message: "Une question reçoit un énoncé et une solution facultative")
  let solution = suite.pos().at(0, default: none)
  assert(type(enonce) == content and (solution == none or type(solution) == content))
  assert(
    not contient-bloc(enonce) and not contient-bloc(solution),
    message: "Une question ne contient pas d'autre question ni de partie",
  )
  assert(label == none or type(label) == std.label, message: "label doit être une étiquette Typst ou none")
  assert(jury == none or type(jury) == content, message: "jury doit être un contenu Typst ou none")
  assert(notation == none or type(notation) == content, message: "notation doit être un contenu Typst ou none")
  assert(
    bareme == none or bareme in (0.25, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4),
    message: "Points autorisés : 0.25, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4 ou none",
  )
  marquer-bloc((
    type: "question",
    enonce: enonce,
    jury: jury,
    solution: solution,
    bareme: bareme,
    notation: notation,
    label: label,
  ))
}

/// Associe une étiquette à l'énoncé en préservant son alignement et son numéro.
///
/// - q (dictionary): Question contenant éventuellement `label`.
/// - numero (int): Numéro utilisé par les renvois.
/// - body (content): Énoncé mis en forme.
/// -> content
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

/// Réunit les champs présents du concours : nom, année, filière et mention orale.
///
/// - concours (dictionary): Attribution du sujet.
/// -> str
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

/// Préfixe le titre par l'attribution du concours lorsqu'elle existe.
///
/// - titre (str): Titre du contenu.
/// - concours (dictionary, none): Attribution facultative.
/// -> str
#let titre-concours(titre, concours) = {
  if concours == none { titre } else { texte-concours(concours) + " : " + titre }
}

/// Compose un titre insécable avec son préfixe et l'attribution à droite.
///
/// - titre (str): Intitulé.
/// - prefixe (content, str): Numéro ou nom précédant le titre.
/// - concours (dictionary, none): Attribution facultative.
/// - niveau (int): Niveau de titre Typst.
/// -> content
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

/// Regroupe des textes, questions et sous-parties sans les afficher.
/// `contexte` conserve les rappels à reprendre explicitement dans un extrait autonome.
///
/// - titre (str): Titre non vide.
/// - numero (str, auto): Numéro imposé ; sinon I, I.A, I.A.1 selon la hiérarchie.
/// - body (content, array): Textes Typst, questions et sous-parties.
/// - contexte (array): Rappels sous forme de contenus Typst.
/// - meta (dictionary): Métadonnées propres à la partie.
/// - jury (content, none): Observation générale du jury.
/// -> content
#let partie(titre, numero: auto, contexte: (), meta: (:), jury: none, body) = {
  assert(numero == auto or (type(numero) == str and numero != ""), message: "Numéro de partie vide")
  assert(type(titre) == str and titre != "", message: "Titre de partie vide")
  assert(type(contexte) == array)
  assert(contexte.all(bloc => type(bloc) == content), message: "Le contexte contient uniquement du texte Typst")
  assert(jury == none or type(jury) == content)
  marquer-bloc((
    jury: jury,
    type: "partie",
    numero: numero,
    titre: titre,
    contenu: lire-blocs(body),
    contexte: contexte,
    meta: meta,
  ))
}

// Les numéros sont fixés avant le filtrage des corrections de copies.
#let numeroter-parties(blocs, prefixe: none, niveau: 1) = {
  let resultat = ()
  let indice = 0
  for bloc in blocs {
    if type(bloc) == dictionary and bloc.at("type", default: none) == "partie" {
      indice += 1
      let numero = if bloc.numero != auto { bloc.numero } else if prefixe == none { numbering("I", indice) } else {
        prefixe + "." + numbering(if niveau == 2 { "A" } else { "1" }, indice)
      }
      resultat.push((
        ..bloc,
        numero: numero,
        contenu: numeroter-parties(bloc.contenu, prefixe: numero, niveau: niveau + 1),
      ))
    } else { resultat.push(bloc) }
  }
  resultat
}

/// Extrait les données d'une question ou d'une partie pour une réutilisation explicite.
///
/// - body (content): Un unique bloc produit par `question` ou `partie`.
/// -> dictionary
#let donnees(body) = {
  let blocs = numeroter-parties(lire-blocs(body))
  assert(
    blocs.len() == 1 and type(blocs.first()) == dictionary,
    message: "donnees attend une question ou une partie unique",
  )
  blocs.first()
}

/// Indique si le bloc est une partie construite par `partie`.
///
/// - bloc (any): Valeur à examiner.
/// -> bool
#let est-partie(bloc) = type(bloc) == dictionary and bloc.at("type", default: none) == "partie"

/// Parcourt les parties dans l'ordre et remplace leurs niveaux par des titres.
///
/// - contenu (array): Textes, questions et parties.
/// - niveau (int): Niveau initial des titres.
/// - textes (bool): Conserver les textes libres.
/// - jury (bool): Insérer les observations du jury des parties.
/// -> array
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

/// Compte les questions, y compris dans les parties imbriquées.
///
/// - contenu (array): Contenu d'un exercice.
/// -> int
#let nombre-questions(contenu) = aplatir(contenu).filter(bloc => type(bloc) == dictionary).len()

/// Valide une valeur par question dans l'ordre du sujet ; `none` omet le barème.
///
/// - bareme (array, none): Points, avec `none` pour masquer une question.
/// - nombre (int): Nombre de questions attendu.
/// -> none
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

/// Valide et regroupe un exercice réutilisable, sans le mettre en page.
/// Les vocabulaires des métadonnées sont définis dans `meta.typ`.
///
/// - meta (dictionary): `titre`, `chapitres` et `difficulte` requis ; niveaux, outils, durée et concours facultatifs.
/// - body (content, array): Textes Typst, questions et parties ; au moins une question. Un tableau permet les compositions calculées.
/// - colonnes (int): Colonnes de l'énoncé ; le corrigé utilise une seule colonne.
/// - jury (content, none): Observation générale affichée dans le corrigé.
/// - corrections (content, none): Erreurs corrigées du sujet, conservées sans affichage.
/// - notation (content, none): Consignes générales de correction, conservées sans affichage.
/// - bareme (array, none): Barème global de compatibilité ; préférer celui des questions.
/// -> dictionary
#let exercice(meta: (:), colonnes: 1, jury: none, corrections: none, notation: none, bareme: none, body) = {
  let contenu = numeroter-parties(lire-blocs(body))
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

/// Place une annotation dans la marge droite sans réserver de hauteur.
///
/// - body (content): Annotation, notamment les points d'une question.
/// -> content
#let marge-droite(body) = place(top + left, dx: 100% + 5mm, block(width: 15mm, {
  set align(left)
  body
}))

/// Affiche un exercice et publie ses métadonnées sous `<exercice-meta>`.
/// Le corrigé ajoute solutions, observations du jury et points dans la marge.
/// Les titres ordinaires héritent de la numérotation du document ; les titres
/// d'exercice et de `partie` portent leur propre numéro explicite.
///
/// - ex (dictionary): Données produites par `exercice`.
/// - numero (int, none): Numéro d'exercice ; `none` utilise le préfixe I.
/// - corrige (bool): Afficher les éléments du corrigé.
/// - afficher-titre (bool): Afficher le titre et l'attribution.
/// - afficher-contexte (bool): Conserver les textes libres dans le corrigé.
/// - bareme (array, none): Remplacer le barème global ; `none` conserve celui de l'exercice.
/// - espacement (length, auto): Espacement vertical entre les blocs.
/// -> content
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

/// Commence un sujet de colle sur une nouvelle page et le signale à l'en-tête.
///
/// - numero (int, str): Repère du sujet.
/// - exercices (array): Exercices du sujet.
/// - corrige (bool): Afficher leurs solutions.
/// -> content
#let sujet-colle(numero, exercices, corrige: false) = {
  pagebreak(weak: true)
  counter(heading).update(0)
  [#metadata((numero: numero, corrige: corrige)) <colle-sujet>]
  for (i, ex) in exercices.enumerate(start: 1) {
    afficher-exercice(ex, numero: i, corrige: corrige)
  }
}

/// Compose une feuille à partir d'exercices et publie `<document-meta>`.
/// Le barème suit toutes les questions dans l'ordre, y compris les parties imbriquées.
/// Pour un TP, `tp` contient `ouvrir`, `squelette`, `ressources` facultatif et `corrige`.
/// Chaque fichier déclare `source` relative au `.typ`, `destination` facultative et
/// `extraire` facultatif pour un ZIP. Ces ressources sont exportées sans modifier le PDF.
///
/// - type (str): Type de document, notamment `td`, `devoir`, `concours`, `colle` ou `tp`.
/// - titre (str): Titre du document.
/// - niveau (str, none): Niveau affiché, remplacé par la filière d'un concours.
/// - auteur (str, none): Auteur et attribution de secours.
/// - duree (array, none): Couple `(heures, minutes)` pour un devoir ou concours ; reprise d'un exercice unique si omise.
/// - concours (dictionary, none): Attribution générale.
/// - exercices (array): Exercices à composer dans l'ordre.
/// - tp (dictionary, none): Fichiers du TP et fichier à ouvrir.
/// - corrige (bool): Afficher les solutions, observations et points.
/// - nouvelle-page (bool): Séparer les exercices par une page, sauf en colle.
/// - afficher-exercices (bool): Composer les exercices après `body`.
/// - espacement (length, auto): Espacement des blocs d'exercice.
/// - bareme (array, none): Remplacer les points des exercices ; une entrée `none` masque les points.
/// - body (content): Introduction placée avant les exercices.
/// -> content
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
  assert(
    tp == none or (type == "tp" and std.type(tp) == dictionary),
    message: "tp doit être un dictionnaire réservé aux documents de type tp",
  )
  verifier-bareme(bareme, exercices.map(ex => nombre-questions(ex.contenu)).sum(default: 0))
  let titre-affiche = titre + if corrige { " (corrigé)" } else { "" }
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
  [#metadata((
    type: type,
    titre: titre,
    niveau: niveau,
    concours: concours,
    ..if tp == none { (:) } else { (tp: tp) },
  )) <document-meta>]
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
