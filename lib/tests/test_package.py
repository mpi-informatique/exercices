"""Vérifier les principaux usages du package installé, sans dépendre de la banque."""
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
    # Une installation doit pouvoir remplacer une copie provenant du store Nix.
    for chemin in (package, *package.rglob('*')):
        if chemin.is_dir() and not chemin.is_symlink():
            chemin.chmod(chemin.stat().st_mode & ~0o222)
    installer(racine / 'packages')

    # Une ressource indépendante des déplacements d'exercices dans la banque.
    (package / 'templates/test-package.ml').write_text('let reponse = 42\n', encoding='utf-8')
    (package / 'templates/test-package.typ').write_text('''#import "/load.typ": code
#let extrait = code.code-texte(read("test-package.ml"), "reponse")
''', encoding='utf-8')
    source = racine / 'document.typ'
    def compiler(nom, *inputs):
        subprocess.run(['typst', 'compile', '--root', str(racine), '--ignore-system-fonts',
                        '--package-path', str(racine / 'packages'),
                        *[argument for valeur in inputs for argument in ('--input', valeur)],
                        str(source), str(racine / (nom + '.pdf'))], check=True)

    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": feuille, public, exercice, question, est-corrige
#assert(public("templates/test-package.typ").extrait == "let reponse = 42")
#let ex = exercice(
  meta: (titre: "Exercice de test", chapitres: (), difficulte: 1),
  contenu: (
    question([Première question.], label: <premiere>, solution: [#metadata(none) <solution-test> Réponse.], bareme: 2),
    question([Voir @premiere.]),
  ),
)
#show: feuille.with(exercices: (ex,), corrige: est-corrige())
#context {
  assert(query(<premiere>).len() == 1)
  assert(query(<solution-test>).len() == if est-corrige() { 1 } else { 0 })
  assert(query(<bareme-question>).map(it => it.value.points) == if est-corrige() { (2,) } else { () })
}
''', encoding='utf-8')
    for corrige in ('false', 'true'):
        compiler('exercice-' + corrige, 'corrige=' + corrige)

    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": cours-et-presentation, est-corrige, est-presentation, solution, theoremes
#show: cours-et-presentation.with(titre: "Cours de test")
== Résultat
#theoremes.theoreme[Un résultat. #metadata(none) <resultat-test>]
#solution[#metadata(none) <solution-test> Une solution imprimée dans le corrigé.]
#solution(presentation: true)[#metadata(none) <projection-test> Une solution projetée.]
#context {
  assert(query(<resultat-test>).len() > 0)
  assert(query(<solution-test>).len() == if est-corrige() { 1 } else { 0 })
  assert((query(<projection-test>).len() > 0) == est-presentation())
}
''', encoding='utf-8')
    for format, corrige in (('cours', 'false'), ('cours', 'true'), ('presentation', 'false')):
        compiler(format + '-' + corrige, 'format=' + format, 'corrige=' + corrige)
print('Package : installation, ressources, énoncé, corrigé, cours et présentation vérifiés.')
