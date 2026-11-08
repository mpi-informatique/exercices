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

    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": feuille, public, exercice, partie, question, donnees, nombre-questions, est-corrige, lien
#assert(public("templates/test-package.typ").extrait == "let reponse = 42")
#assert(lien("test")[Site].dest == "https://mpi-informatique.github.io/exercices/test/")
#assert(lien(<premiere>)[Question].dest == <premiere>)
#let ex = exercice(meta: (titre: "Exercice de test", chapitres: (), difficulte: 1))[
  = Section automatique <section-test>
  == Sous-section automatique <sous-section-test>

  #partie("Partie explicite", numero: "II.B")[

  ]

  #heading(numbering: none)[Introduction sans numéro] <titre-libre-test>

  #question(label: <premiere>, bareme: 2)[Première question.][#metadata(none) <solution-test> Réponse.]

  #question[Voir @premiere et #lien(<premiere>)[la première question].]

  #[
    #set heading(numbering: "A.1")
    = Section personnalisée <titre-personnalise-test>
  ]
]
#show: feuille.with(exercices: (ex,), corrige: est-corrige())
#let automatique = exercice(meta: ex.meta)[
  #partie("Première partie")[
    #partie("Sous-partie")[#question[X][Y]]
  ]
]
#assert(automatique.contenu.first().numero == "I")
#assert(automatique.contenu.first().contenu.first().numero == "I.A")
#let partage = partie("Partie reprise", numero: "III.B", contexte: ([Rappel.],))[#question[A][B]]
#let extrait = donnees(partage)
#assert(extrait.numero == "III.B" and extrait.contexte == ([Rappel.],))
#assert(nombre-questions(exercice(meta: ex.meta, extrait.contexte + extrait.contenu).contenu) == 1)
#let compose = exercice(meta: ex.meta, ([Premier paragraphe.], [Second paragraphe.], question[X]))
#assert(compose.contenu.at(0) == [Premier paragraphe.] and compose.contenu.at(1) == [Second paragraphe.])
#context {
  assert(query(<premiere>).len() == 1)
  assert(query(<solution-test>).len() == if est-corrige() { 1 } else { 0 })
  assert(query(<bareme-question>).map(it => it.value.points) == if est-corrige() { (2,) } else { () })
  let section = query(<section-test>).first()
  let sous-section = query(<sous-section-test>).first()
  assert(section.numbering == "I.1.1 –")
  assert(counter(heading).at(section.location()) == (1,))
  assert(counter(heading).at(sous-section.location()) == (1, 1))
  assert(query(<titre-libre-test>).first().numbering == none)
  assert(query(<titre-personnalise-test>).first().numbering == "A.1")
  assert(query(heading).filter(it => it.numbering == none).len() == 3)
}
''', encoding='utf-8')
    for corrige in ('false', 'true'):
        compiler('exercice-' + corrige, 'corrige=' + corrige)

    source.write_text('''#import "@mpi-informatique/exercices:0.1.0": colonnes-cours, cours-et-presentation, est-corrige, est-presentation, solution, theoremes
#show: cours-et-presentation.with(titre: "Cours de test")
== Résultat
#theoremes.theoreme[Un résultat. #metadata(none) <resultat-test>]
#solution[#metadata(none) <solution-test> Une solution imprimée dans le corrigé.]
#solution(presentation: true)[#metadata(none) <projection-test> Une solution projetée.]
#context {
  assert(query(<resultat-test>).len() > 0)
  assert(query(<solution-test>).len() == if est-corrige() and not est-presentation() { 1 } else { 0 })
  assert((query(<projection-test>).len() > 0) == est-presentation())
}
== Colonnes
#colonnes-cours(
  [#metadata(none) <colonne-defaut-gauche> Gauche.],
  [#metadata(none) <colonne-defaut-droite> Droite.],
)
#colonnes-cours(
  columns: 3,
  separation: true,
  empiler-presentation: false,
  [#metadata(none) <colonne-gauche> Gauche.],
  [Centre.],
  [#metadata(none) <colonne-droite> Droite.],
)
#context {
  let position(label) = query(label).first().location().position()
  let gauche = position(<colonne-defaut-gauche>)
  let droite = position(<colonne-defaut-droite>)
  if est-presentation() {
    assert(gauche.x == droite.x and gauche.y < droite.y)
  } else {
    assert(gauche.x < droite.x)
  }
  assert(position(<colonne-gauche>).x < position(<colonne-droite>).x)
}
''', encoding='utf-8')
    for format, corrige in (('cours', 'false'), ('cours', 'true'), ('presentation', 'false'), ('presentation', 'true')):
        compiler(format + '-' + corrige, 'format=' + format, 'corrige=' + corrige)
print('Package : installation, ressources, énoncé, corrigé, cours et présentation vérifiés.')
