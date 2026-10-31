"""Compiler un document externe avec les ressources du package installé."""
from pathlib import Path
import os
import subprocess
import sys
from tempfile import TemporaryDirectory

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'scripts'))
from package import installer

with TemporaryDirectory() as dossier:
    racine = Path(dossier)
    package = installer(racine / 'packages')
    previews = os.environ.get('TYPST_PACKAGE_PATH')
    if previews:
        (racine / 'packages/preview').symlink_to(Path(previews) / 'preview', target_is_directory=True)
    assert not (package / 'lib/tests').exists()
    assert not (package / 'ressources').exists()
    assert (racine / 'packages/local/code-extract/0.2.0/dist/code-extract.wasm').is_file()
    # Une réinstallation élimine aussi les anciens tests et ressources installés.
    (package / 'lib/tests').mkdir()
    (package / 'lib/tests/ancien.typ').write_text('Ancien test')
    (package / 'ressources').mkdir()
    (package / 'ressources/ancien.ml').write_text('Ancienne ressource')
    # Les installations provenant du store Nix ont des dossiers en lecture seule.
    for dossier in (package, *package.rglob('*')):
        if dossier.is_dir() and not dossier.is_symlink():
            dossier.chmod(dossier.stat().st_mode & ~0o222)
    installer(racine / 'packages')
    assert not (package / 'lib/tests').exists()
    assert not (package / 'ressources').exists()
    assert all(dossier.stat().st_mode & 0o200 for dossier in package.rglob('*') if dossier.is_dir() and not dossier.is_symlink())
    source = racine / 'document.typ'
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": feuille, public, theoremes, exercice, question, partie, afficher-exercice
#let sujet = public("devoirs/concours/19/mines-ponts-2019-mp-informatique/mines-ponts-2019-mp-informatique.typ").sujet
#let td = public("chapitres/langages/td/td-grammaire.typ")
#assert(td.sujet.exercices.len() > 0)
#assert(public("chapitres/langages/exercices/grammaires-lineaires/grammaires-lineaires.typ").ex.meta.titre != "")
#assert(public("chapitres/maths/determinants/binomiaux.typ").ex.meta.matiere == "mathématiques")
#show: feuille.with(titre: sujet.titre, exercices: sujet.exercices,
  corrige: sys.inputs.at("corrige", default: "false") == "true")
#let cible = question([Une question à déplacer.], label: <question-mobile>, solution: [Voir @question-mobile.])
#let autre = question([Une autre question.])
#let inverse = sys.inputs.at("corrige", default: "false") == "true"
#let questions = if inverse { (cible, autre) } else { (autre, cible) }
Voir @question-mobile avant son énoncé.
#afficher-exercice(exercice(
  meta: (titre: "Renvois", chapitres: (), difficulte: 1),
  contenu: (partie("I", "Questions", contenu: questions),),
  colonnes: 2,
), corrige: inverse)
#context {
  let cible = query(<question-mobile>).first()
  assert(cible.func() == figure and cible.supplement == [Question])
  assert((cible.numbering)(0) == if inverse { "1" } else { "2" })
}
''', encoding='utf-8')
    for variante in ('false', 'true'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'corrige=' + variante,
                        str(source), str(racine / (variante + '.pdf'))], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, colonnes-cours, liste-cours, taille-presentation, pause, article-only, slides-only, solution, theoremes
#show: cours-et-presentation.with(titre: "Cours externe", niveau: "MPI", animations: false)
#show text.where(text: "♡"): it => [#metadata("coeur") <coeur-solution-test>#it]
= Section
== Notion
#text(size: 20pt)[#taille-presentation(0.5em)[#context {
  assert(text.size == if sys.inputs.at("format") == "presentation" { 10pt } else { 20pt })
}]]
#theoremes.definition[
  - Un contenu commun.
  #pause
  - Un détail révélé ensuite.
] <definition-commune>
#pause
#theoremes.algorithme[
  + Initialiser $s ← 0$.
  #pause
  + *Pour chaque* $x ∈ X$ :
    + $s ← s + x$
  + *Renvoyer* $s$.
]
== Méthode
#theoremes.methode(title: [Construire une preuve])[
  #context { assert(text.style == "normal") }
  + Fixer les hypothèses.
  #pause
  + Établir la conclusion. #article-only[Version imprimée.] #slides-only[Version projetée.]
]
== Application
#theoremes.exercice(title: [Monoïdes et taille])[
  Un exercice. #slides-only[#linebreak()#metadata("presentation") <retour-exercice-test>]
  Une suite commune. #article-only[#metadata("cours") <retour-exercice-test>]
]
#context {
  let marques = query(<retour-exercice-test>)
  assert(marques.len() == 1)
  assert(marques.first().value == if sys.inputs.at("format") == "presentation" { "presentation" } else { "cours" })
}
#theoremes.theoreme[Un théorème.] <theoreme-commun>
#article-only[#theoremes.definition-sans-numero[Une définition sans numéro.]]
== Autre notion
#theoremes.definition[Une deuxième définition.]
#theoremes.theoreme[Un deuxième théorème.] <theoreme-suivant>
Voir @definition-commune, @theoreme-commun et @theoreme-suivant.
== Renvois
#theoremes.algorithme(title: [Berry-Sethi])[Un algorithme.] <algorithme-reference>
#theoremes.lemme-sans-numero(title: [Sans numéro])[Un lemme.] <lemme-reference>
#[
  #show text: it => [#metadata(it.text) <texte-reference-test>#it]
  @algorithme-reference;
  #theoremes.reference-cadre(<algorithme-reference>, numero: true, titre: false)#text(";")
  #theoremes.reference-cadre(<algorithme-reference>, numero: true)#text(";")
  #theoremes.reference-cadre(<algorithme-reference>, supplement: none)#text(";")
  @lemme-reference;
  @theoreme-suivant.
]
#context {
  let rendu = query(<texte-reference-test>).map(it => it.value).join("")
  assert(rendu.replace(regex("\\s+"), "") == "Algorithme:Berry-Sethi;Algorithme2;Algorithme2(Berry-Sethi);Berry-Sethi;Lemme:Sansnuméro;Théorème2.", message: rendu)
}
#context {
  for cible in (<definition-commune>, <theoreme-commun>, <theoreme-suivant>) {
    assert(query(cible).len() == 1 and query(cible).first().func() == figure)
  }
}
#article-only[Un détail du polycopié.]
#solution(presentation: true, coeur: true)[
  #slides-only[== Solution projetée]
  #metadata("solution") <solution-cours-test> Une solution réservée aux diapositives.
  #pause
  #block[#slides-only[Un détail projeté.] #article-only[Un détail imprimé.]]
  La fin de la solution.
]
#solution[
  #slides-only[== Solution masquée par défaut]
  #metadata("solution") <solution-masquee-test> Une solution réservée au corrigé.
  #pause
  La suite reste également masquée dans la présentation.
]
#solution(presentation: false)[#metadata("solution") <solution-non-projetee-test> Une autre solution réservée au corrigé.]
#solution(cours: true)[#metadata("solution") <solution-cours-force-test> Une solution visible dans les deux cours.]
#solution(cours: true, presentation: true, coeur: true)[#metadata("solution") <solution-partout-test> Une solution visible partout.]
#context {
  let corrige = sys.inputs.at("corrige", default: "false") == "true"
  for cible in (<solution-masquee-test>, <solution-non-projetee-test>) {
    assert(query(cible).len() == if corrige { 1 } else { 0 })
  }
  let visible = sys.inputs.at("format") == "presentation"
  assert((query(<solution-cours-test>).len() > 0) == visible)
  assert(query(<solution-cours-force-test>).len() == if sys.inputs.at("format") == "cours" { 1 } else { 0 })
  assert(query(<solution-partout-test>).len() > 0)
  let coeurs = query(<coeur-solution-test>)
  if sys.inputs.at("format") == "presentation" {
    assert(coeurs.len() == 0)
  } else {
    assert(coeurs.len() == 1)
  }
}
== Colonnes du cours
#colonnes-cours(
  columns: (1.15fr, 1fr),
  encadrer: theoremes.exercice-sans-numero.with(full-title: ""),
  [#metadata("gauche") <colonne-test> Contenu de gauche.],
  [
    #metadata("droite") <colonne-test> Contenu de droite.
    #solution[#metadata("solution") <solution-colonne-test> Solution dans une colonne.]
  ],
)
#context {
  let cellules = query(<colonne-test>)
  assert(query(<solution-colonne-test>).len() == if sys.inputs.at("corrige", default: "false") == "true" { 1 } else { 0 })
  assert(cellules.map(it => it.value) == ("gauche", "droite"))
  let gauche = cellules.first().location().position()
  let droite = cellules.last().location().position()
  if sys.inputs.at("format") == "cours" {
    assert(gauche.page == droite.page and gauche.y == droite.y and gauche.x < droite.x)
  } else {
    assert(gauche.page == droite.page and gauche.x == droite.x and gauche.y < droite.y)
  }
}
== Largeurs des colonnes
#for nom in ("liste", "colonnes") {
  block(width: 360pt, {
    let contenus = range(3).map(i => layout(taille => [
      #metadata((nom: nom, numero: i, largeur: taille.width)) <largeur-colonne-test>
      #if i == 1 { [Un contenu beaucoup plus long qui doit revenir à la ligne dans sa colonne sans modifier la largeur de ses voisines.] } else { [Court.] }
    ]))
    if nom == "liste" {
      liste-cours(columns: 3, column-gutter: 12pt, ..contenus)
    } else {
      colonnes-cours(columns: 3, column-gutter: 12pt, ..contenus)
    }
  })
}
#context {
  if sys.inputs.at("format") == "cours" {
    for nom in ("liste", "colonnes") {
      let colonnes = query(<largeur-colonne-test>).filter(it => it.value.nom == nom)
      assert(colonnes.len() == 3)
      for i in range(1, 3) {
        assert(calc.abs(colonnes.at(i).value.largeur - colonnes.first().value.largeur) < 0.1pt)
        let precedent = colonnes.at(i - 1).location().position()
        let courant = colonnes.at(i).location().position()
        assert(precedent.page == courant.page)
        assert(calc.abs(courant.x - precedent.x - 124pt) < 0.1pt)
      }
    }
  }
}
== Espacement avant les listes
#text(size: 10pt)[
  #set par(leading: 5pt, spacing: 20pt)
  #let repere(nom) = box(height: 10pt, baseline: 0pt)[#metadata(nom) <espacement-liste-test> Texte.]
  #block[
    #repere("reference-avant")
    #enum(repere("reference-apres"))
  ]
  #block[
    #repere("liste-avant")
    #liste-cours(repere("liste-apres"))
  ]
  #block[
    #repere("colonnes-avant")
    #colonnes-cours([#enum(repere("colonnes-apres"))])
  ]
  #context {
    let marques = query(<espacement-liste-test>)
    let position(nom) = marques.find(it => it.value == nom).location().position().y
    let ecart(prefixe) = position(prefixe + "-apres") - position(prefixe + "-avant")
    let reference = ecart("reference")
    assert(reference >= 10pt)
    for prefixe in ("liste", "colonnes") {
      assert(calc.abs(ecart(prefixe) - reference) < 0.1pt, message: prefixe + ": " + repr(ecart(prefixe)) + " au lieu de " + repr(reference))
    }
  }
]
== Liste du cours
#liste-cours(
  start: 3,
  encadrer: theoremes.exercice-sans-numero,
  ..range(5).map(i => [#metadata(i) <liste-cours-test> Élément #i.]),
)
#context {
  let items = query(<liste-cours-test>)
  assert(items.map(it => it.value) == range(5))
  let positions = items.map(it => it.location().position())
  assert(positions.all(p => p.page == positions.first().page))
  if sys.inputs.at("format") == "cours" {
    assert(positions.at(0).y == positions.at(3).y)
    assert(positions.at(0).x < positions.at(3).x)
    assert(positions.at(1).y == positions.at(4).y)
    assert(positions.at(2).y > positions.at(1).y)
  } else {
    assert(positions.all(p => p.x == positions.first().x))
    let pas = positions.at(1).y - positions.at(0).y
    assert(pas > 0pt)
    for i in range(1, 5) {
      assert(calc.abs(positions.at(i).y - positions.at(i - 1).y - pas) < 0.1pt)
    }
  }
}
''', encoding='utf-8')
    for variante, corrige in (('cours', 'false'), ('cours', 'true'), ('presentation', 'false')):
        output = racine / (variante + '-' + corrige + '.pdf')
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=' + variante, '--input', 'corrige=' + corrige,
                        str(source), str(output)], check=True)
        assert output.stat().st_size > 0
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours, theoremes
#show: cours.with(titre: "Marges des algorithmes")
#context {
  let hauteur(contenu) = measure(contenu, width: 300pt).height
  let reference = hauteur(theoremes.definition[Texte.])
  let algorithme = hauteur(theoremes.algorithme[+ Texte.])
  assert(calc.abs(algorithme - reference) < 0.1pt, message: repr((algorithme, reference)))
}
''', encoding='utf-8')
    subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                    '--package-path', str(racine / 'packages'), str(source), str(racine / 'marges-algorithmes.pdf')], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, colonnes-cours, theoremes
#show: cours-et-presentation.with(titre: "Espacement des cadres")
#let repere(nom) = [#metadata(nom) <espacement-cadre-test>Texte identique.]
#for (nom, cadre) in (("definition", theoremes.definition), ("exercice", theoremes.exercice), ("methode", theoremes.methode)) {
  for disposition in ("direct", "colonnes", "coeur") {
    block(breakable: false)[
      #cadre(repere(nom + "-" + disposition + "-avant"))
      #if disposition == "colonnes" {
        colonnes-cours(columns: 1, cadre(repere(nom + "-" + disposition + "-apres")))
      } else {
        cadre(coeur: disposition == "coeur", repere(nom + "-" + disposition + "-apres"))
      }
    ]
  }
}
#context {
  let marques = query(<espacement-cadre-test>)
  let position(nom) = marques.find(it => it.value == nom).location().position()
  let ecart(nom, disposition) = {
    let avant = position(nom + "-" + disposition + "-avant")
    let apres = position(nom + "-" + disposition + "-apres")
    assert(avant.page == apres.page)
    apres.y - avant.y
  }
  for nom in ("definition", "exercice", "methode") {
    for disposition in ("colonnes", "coeur") {
      assert(calc.abs(ecart(nom, disposition) - ecart(nom, "direct")) < 0.1pt, message: nom + " " + disposition + ": espacement différent")
    }
  }
}
''', encoding='utf-8')
    subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                    '--package-path', str(racine / 'packages'), str(source), str(racine / 'espacement-cadres.pdf')], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, est-presentation, solution, theoremes
#let pauses = sys.inputs.at("pauses") == "true"
#let options = if pauses { (:) } else { (pause: false) }
#show: cours-et-presentation.with(titre: "Pauses des cadres")
== Cadres successifs
#theoremes.definition(..options)[Définition.] <definition-pause-test>
#theoremes.exercice-sans-numero(..options)[Exercice.]
#theoremes.methode(..options)[Méthode.]
#solution(cours: true, presentation: true, ..options)[Solution.]
Après les cadres, voir @definition-pause-test.
#context {
  assert(query(<definition-pause-test>).len() == 1)
  assert(query(<definition-pause-test>).first().func() == figure)
  if est-presentation() {
    let pages = query(<touying-metadata>).last().location().page()
    assert(pages == if pauses { 6 } else { 2 }, message: repr(pages))
  }
}
''', encoding='utf-8')
    for variante, pauses in (('cours', 'true'), ('presentation', 'true'), ('presentation', 'false')):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=' + variante, '--input', 'pauses=' + pauses,
                        str(source), str(racine / ('pauses-' + variante + '-' + pauses + '.pdf'))], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, colonnes-cours, slide, pause, solution, theoremes
#let animations = sys.inputs.at("animations") == "true"
#show: cours-et-presentation.with(titre: "Pauses finales", animations: animations)
== Cadre isolé
#context {
  let pages = query(<touying-metadata>).last().location().page()
  assert(pages == if animations { 9 } else { 7 }, message: repr(pages))
  assert(query(<cadre-final-test>).len() == 1)
  assert(query(<cadre-final-test>).first().func() == figure)
}
#theoremes.exercice[Un exercice isolé.]
#slide()
#theoremes.definition[Titre du cadre][Une définition avant un titre.] <cadre-final-test>
== Cadres successifs
#theoremes.definition[Première étape.]
#theoremes.exercice[Deuxième étape.]
== Colonnes
#colonnes-cours(encadrer: theoremes.exercice-sans-numero, [Gauche.], [Droite.])
== Solution finale
#solution(presentation: true)[Une solution finale.]
== Pause explicite
#theoremes.exercice(pause: false)[Une pause volontaire. #pause]
''', encoding='utf-8')
    for animations in ('true', 'false'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=presentation', '--input', 'animations=' + animations,
                        str(source), str(racine / ('pauses-finales-' + animations + '.pdf'))], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours, solution
#show: cours.with(titre: "Cours sans présentation")
Un énoncé.
#solution[#metadata("solution") <solution-simple-test> Une solution.]
#solution(cours: true, coeur: true)[#metadata("solution") <solution-simple-force-test> Une solution toujours imprimée.]
#context {
  let corrige = sys.inputs.at("corrige", default: "false") == "true"
  assert(query(<solution-simple-test>).len() == if corrige { 1 } else { 0 })
  assert(query(<solution-simple-force-test>).len() == 1)
}
''', encoding='utf-8')
    for corrige in ('false', 'true'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'corrige=' + corrige,
                        str(source), str(racine / ('cours-simple-' + corrige + '.pdf'))], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, slide, tp
#import "@preview/touying:0.8.0": utils
#show: cours-et-presentation.with(titre: "Saut de diapositive")
== Titre commun
#metadata("avant") <saut-diapositive-test>
Premier contenu.
#slide()
#metadata("apres") <saut-diapositive-test>
Deuxième contenu.
#tp(id: "tp-automates")[== Automate produit]
#metadata("produit") <saut-diapositive-test>
Contenu de la nouvelle diapositive.
#context {
  let marques = query(<saut-diapositive-test>)
  assert(marques.len() == 3)
  let projection = sys.inputs.at("format") == "presentation"
  let pages = marques.map(it => it.location().position().page)
  assert(pages.at(1) - pages.at(0) == if projection { 1 } else { 0 })
  assert(pages.at(2) - pages.at(1) == if projection { 1 } else { 0 })
  if projection { assert(utils.current-heading().body == [Automate produit]) }
}
''', encoding='utf-8')
    for variante in ('cours', 'presentation'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=' + variante,
                        str(source), str(racine / ('saut-' + variante + '.pdf'))], check=True)
    for modele, options in (('cours', ''), ('feuille', 'type: "devoir", duree: (2, 0),'), ('presentation', 'animations: false,')):
        source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours, feuille, presentation
#show: ''' + modele + '''.with(titre: "Titre du document", ''' + options + ''')
Contenu du document.
#context {
  let url = sys.inputs.at("url-document")
  let titres = query(link).filter(it => type(it.dest) == str and it.dest.starts-with("https://mpi-informatique.github.io/exercices/"))
  assert(titres.len() == if url == "" { 0 } else { 1 })
  if url != "" { assert(titres.first().dest == url) }
}
''', encoding='utf-8')
        for lien in ('', 'https://mpi-informatique.github.io/exercices/document-test/'):
            subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                            '--package-path', str(racine / 'packages'), '--input', 'url-document=' + lien,
                            str(source), str(racine / ('titre-' + modele + ('-lie' if lien else '') + '.pdf'))], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": hp, tp, coeur-en-marge, marge
#let corps = if sys.inputs.at("format") == "presentation" { 22pt } else { 10pt }
#set text(font: "New Computer Modern", size: corps)
#set page(margin: 32pt)
#let relever-note(it) = context {
  [#metadata((repere: it.text, taille: text.size)) <note-marge-test>]
  it
}
#show text.where(text: "HP"): relever-note
#show text.where(text: "TP"): relever-note
#show text.where(text: "♡"): relever-note
#show text.where(text: "N"): relever-note
#show link: it => {
  [#metadata(it.dest) <note-lien-test>]
  it
}
#let contenu() = box(width: 100%, height: 2em)[#metadata("corps") <corps-marge-test> Texte du bloc.]
#hp(contenu())
#tp(contenu())
#tp(id: "tp-automates", contenu())
#coeur-en-marge(contenu())
#marge([N], contenu())
#context {
  let notes = query(<note-marge-test>)
  let blocs = query(<corps-marge-test>)
  assert(blocs.len() == 5)
  for bloc in blocs { assert(bloc.location().position().x == 32pt) }
  if sys.inputs.at("format") == "presentation" {
    assert(notes.len() == 0)
    assert(query(<note-lien-test>).len() == 0)
  } else {
    assert(notes.map(it => it.value.repere) == ("HP", "TP", "TP", "♡", "N"))
    assert(query(<note-lien-test>).map(it => it.value) == ("https://mpi-informatique.github.io/exercices/tp-automates/",))
    for (note, bloc) in notes.zip(blocs) {
      let position = note.location().position()
      let texte = bloc.location().position()
      let taille = if note.value.repere == "♡" { corps } else { 0.7 * corps }
      assert(note.value.taille == taille)
      assert(position.x >= 0pt)
      assert(position.x + measure(text(size: taille, note.value.repere)).width < texte.x)
    }
  }
}
''', encoding='utf-8')
    for variante in ('cours', 'presentation'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=' + variante,
                        str(source), str(racine / ('notes-' + variante + '.pdf'))], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, pause, theoremes
#show: cours-et-presentation.with(titre: "Cadres hors programme", animations: false)
#let relever(it) = context {
  [#metadata((repere: it.text, taille: text.size)) <repere-cadre-hp-test>]
  it
}
#show text.where(text: "HP"): relever
#show text.where(text: "♡"): relever
== Théorème
#theoremes.theoreme(hp: true)[Un résultat hors programme. #pause Une précision.]
== Définition
#theoremes.definition-sans-numero(hp: true, coeur: true)[Une notion à connaître.]
== Méthode
#theoremes.methode(hp: true)[Une démarche hors programme.]
#context {
  let reperes = query(<repere-cadre-hp-test>)
  let hp = reperes.filter(it => it.value.repere == "HP")
  let coeurs = reperes.filter(it => it.value.repere == "♡")
  assert(hp.len() == 3)
  assert(coeurs.len() == 1)
  if sys.inputs.at("format") == "cours" {
    assert(hp.all(it => it.value.taille == 7pt))
    let position-hp = hp.at(1).location().position()
    let position-coeur = coeurs.first().location().position()
    assert(position-hp.x > position-coeur.x)
  }
}
''', encoding='utf-8')
    for variante in ('cours', 'presentation'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=' + variante,
                        str(source), str(racine / ('cadres-hp-' + variante + '.pdf'))], check=True)
print('Package local : imports, ressources, énoncé, corrigé, cours, présentation et notes en marge vérifiés.')
