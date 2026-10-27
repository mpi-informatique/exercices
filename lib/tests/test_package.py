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
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, colonnes-cours, taille-presentation, pause, article-only, slides-only, solution, theoremes
#show: cours-et-presentation.with(titre: "Cours externe", niveau: "MPI")
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
#theoremes.methode(titre: [Construire une preuve])[
  #context { assert(text.style == "normal") }
  + Fixer les hypothèses.
  #pause
  + Établir la conclusion. #article-only[Version imprimée.] #slides-only[Version projetée.]
]
== Application
#theoremes.exercice(titre: [Monoïdes et taille])[
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
#context {
  for cible in (<definition-commune>, <theoreme-commun>, <theoreme-suivant>) {
    assert(query(cible).len() == 1 and query(cible).first().func() == figure)
  }
}
#article-only[Un détail du polycopié.]
#solution(presentation: true, coeur: true)[
  #slides-only[== Solution projetée]
  #metadata("solution") <solution-cours-test> Une solution réservée au corrigé et aux diapositives.
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
  let visible = corrige or sys.inputs.at("format") == "presentation"
  assert((query(<solution-cours-test>).len() > 0) == visible)
  assert(query(<solution-cours-force-test>).len() == if sys.inputs.at("format") == "cours" { 1 } else { 0 })
  assert(query(<solution-partout-test>).len() > 0)
  let coeurs = query(<coeur-solution-test>)
  if sys.inputs.at("format") == "presentation" {
    assert(coeurs.len() >= 2)
  } else {
    assert(coeurs.len() == if corrige { 2 } else { 1 })
  }
}
== Colonnes du cours
#colonnes-cours(
  columns: (1.15fr, 1fr),
  encadrer: theoremes.exercice-sans-numero.with(full-title: ""),
  [#metadata("gauche") <colonne-test> Contenu de gauche.],
  [#metadata("droite") <colonne-test> Contenu de droite.],
)
#context {
  let cellules = query(<colonne-test>)
  assert(cellules.map(it => it.value) == ("gauche", "droite"))
  let gauche = cellules.first().location().position()
  let droite = cellules.last().location().position()
  if sys.inputs.at("format") == "cours" {
    assert(gauche.page == droite.page and gauche.y == droite.y and gauche.x < droite.x)
  } else {
    assert(gauche.page == droite.page and gauche.x == droite.x and gauche.y < droite.y)
  }
}
''', encoding='utf-8')
    for variante, corrige in (('cours', 'false'), ('cours', 'true'), ('presentation', 'false')):
        output = racine / (variante + '-' + corrige + '.pdf')
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=' + variante, '--input', 'corrige=' + corrige,
                        str(source), str(output)], check=True)
        assert output.stat().st_size > 0
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
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, slide
#import "@preview/touying:0.8.0": utils
#show: cours-et-presentation.with(titre: "Saut de diapositive")
== Titre commun
#metadata("avant") <saut-diapositive-test>
Premier contenu.
#slide()
#metadata("apres") <saut-diapositive-test>
Deuxième contenu.
#context {
  let marques = query(<saut-diapositive-test>)
  assert(marques.len() == 2)
  let projection = sys.inputs.at("format") == "presentation"
  let pages = marques.map(it => it.location().position().page)
  assert(pages.last() - pages.first() == if projection { 1 } else { 0 })
  if projection { assert(utils.current-heading().body == [Titre commun]) }
}
''', encoding='utf-8')
    for variante in ('cours', 'presentation'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=' + variante,
                        str(source), str(racine / ('saut-' + variante + '.pdf'))], check=True)
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": complement, tp, coeur-en-marge, note-en-marge
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
#let contenu() = box(width: 100%, height: 2em)[#metadata("corps") <corps-marge-test> Texte du bloc.]
#complement(contenu())
#tp(contenu())
#coeur-en-marge(contenu())
#note-en-marge([N], contenu())
#context {
  let notes = query(<note-marge-test>)
  let blocs = query(<corps-marge-test>)
  assert(notes.map(it => it.value.repere) == ("HP", "TP", "♡", "N"))
  assert(blocs.len() == notes.len())
  for (note, bloc) in notes.zip(blocs) {
    let position = note.location().position()
    let texte = bloc.location().position()
    assert(note.value.taille == corps)
    assert(position.x >= 0pt)
    assert(position.x + measure(text(note.value.repere)).width < texte.x)
    assert(texte.x == 32pt)
  }
}
''', encoding='utf-8')
    for variante in ('cours', 'presentation'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'format=' + variante,
                        str(source), str(racine / ('notes-' + variante + '.pdf'))], check=True)
print('Package local : imports, ressources, énoncé, corrigé, cours, présentation et notes en marge vérifiés.')
