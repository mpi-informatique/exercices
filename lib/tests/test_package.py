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
    installer(racine / 'packages')
    assert not (package / 'lib/tests').exists()
    assert not (package / 'ressources').exists()
    source = racine / 'document.typ'
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": feuille, public, meta, theoremes, bloc-solution, sep, widetilde, exercice, question, partie, afficher-exercice
#let sujet = public("devoirs/concours/19/mines-ponts-2019-mp-informatique/mines-ponts-2019-mp-informatique.typ").sujet
#let td = public("chapitres/langages/td-grammaire.typ")
#assert(td.sujet.exercices.len() > 0)
#assert(public("chapitres/langages/exercices/grammaires-lineaires/grammaires-lineaires.typ").ex.meta.titre != "")
#assert(public("chapitres/maths/determinants/binomiaux.typ").ex.meta.matiere == "mathématiques")
#assert("determinants" in meta.chapitres-programme)
#assert(sujet.exercices.len() == 1)
#show: feuille.with(titre: sujet.titre, exercices: sujet.exercices,
  corrige: sys.inputs.at("corrige", default: "false") == "true")
$widetilde(a b), #sep widetilde(L)$
#theoremes.lemma-box(outlined: false, full-title: [Lemme admis])[Énoncé du lemme.]
#bloc-solution[Une solution.]
#theoremes.remark[Une remarque compatible.]
#theoremes.note[Une note compatible.]
#theoremes.example[Un exemple compatible.]
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
    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, colonnes-cours, pause, article-only, slides-only, solution, theoremes
#show: cours-et-presentation.with(titre: "Cours externe", niveau: "MPI")
= Section
== Notion
#theoremes.definition[
  - #metadata("avant") <definition-animation-test> Un contenu commun.
  #pause
  - #metadata("apres") <definition-animation-test> Un détail révélé ensuite.
] <definition-commune>
#pause
#theoremes.algorithm[Un algorithme commun.]
== Application
#theoremes.exercise[Un exercice.]
#theoremes.theorem[Un théorème.] <theoreme-commun>
#article-only[#theoremes.definition-box[Une définition sans numéro.]]
== Autre notion
#theoremes.definition[Une deuxième définition.]
#theoremes.theorem[Un deuxième théorème.] <theoreme-suivant>
Voir @definition-commune, @theoreme-commun et @theoreme-suivant.
#context {
  for cible in (<definition-commune>, <theoreme-commun>, <theoreme-suivant>) {
    assert(query(cible).len() == 1 and query(cible).first().func() == figure)
  }
}
#article-only[
  #context {
    let cadres = query(<theorion-frame-metadata>).filter(it => it.value.numbering != none)
    assert(cadres.map(it => it.value.identifier) == ("definition", "algorithm", "exercise", "theorem", "definition", "theorem"))
    assert(cadres.map(it => (it.value.counter.at)(it.location())) == ((1,), (1,), (1,), (1,), (2,), (2,)))
  }
  Un détail du polycopié.
]
#solution[
  #slides-only[== Solution projetée]
  #metadata("solution") <solution-cours-test> Une solution réservée au corrigé et aux diapositives.
  #pause
  #block[#slides-only[Un détail projeté.] #article-only[Un détail imprimé.]]
  La fin de la solution.
]
#context {
  // La pause répète la solution sur deux diapositives, une seule fois dans le corrigé.
  let nombre = if sys.inputs.at("format") == "presentation" { 2 } else if sys.inputs.at("corrige", default: "false") == "true" { 1 } else { 0 }
  assert(query(<solution-cours-test>).len() == nombre)
}
#slides-only[
  Un complément projeté.
  #context {
    // La définition de la première diapositive est répétée lors de la pause.
    let definitions = query(<theorion-frame-metadata>).filter(it => it.value.identifier == "definition")
    assert(definitions.map(it => (it.value.counter.at)(it.location())) == ((1,), (1,), (1,), (2,)))
  }
]
#context {
  // Touying conserve les éléments masqués pour réserver leur place.
  let marques = query(<definition-animation-test>)
  let projection = sys.inputs.at("format") == "presentation"
  assert(marques.filter(it => it.value == "avant").len() == if projection { 3 } else { 1 })
  assert(marques.filter(it => it.value == "apres").len() == if projection { 3 } else { 1 })
}
== Colonnes du cours
#colonnes-cours(
  columns: (1.15fr, 1fr),
  encadrer: theoremes.exercise-box.with(full-title: ""),
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
#context {
  let corrige = sys.inputs.at("corrige", default: "false") == "true"
  assert(query(<solution-simple-test>).len() == if corrige { 1 } else { 0 })
}
''', encoding='utf-8')
    for corrige in ('false', 'true'):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'), '--input', 'corrige=' + corrige,
                        str(source), str(racine / ('cours-simple-' + corrige + '.pdf'))], check=True)
print('Package local : imports, ressources, énoncé, corrigé, cours et présentation vérifiés.')
