"""Vérifier la sélection CI, notamment les imports indirects et les ressources supprimées."""
import contextlib
import io
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'scripts'))
from ci import changed_files, selection


class SelectionTests(unittest.TestCase):
    def setUp(self):
        self.directory = TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        files = {
            'lib/base.typ': '',
            'exercice/helper.typ': '#let valeur = 1',
            'exercice/principal.typ': '#import "helper.typ": valeur\n#let code = read("corrigé.ml")\n#image("image.svg")\n#read("données")',
            'exercice/autre.typ': '// #import "principal.typ"\n/* externe /* imbriqué */ "image.svg" */\n```typst #include "principal.typ"```',
            'exercice/corrigé.ml': 'let x = 1',
            'exercice/image.svg': '<svg/>',
            'exercice/données': 'Un fichier sans extension',
            'feuilles/td.typ': '#import "/exercice/principal.typ": ex',
            'feuilles/suite.typ': '#include "td.typ"',
        }
        for name, content in files.items():
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content)
        self.entries = [('exercice/principal.typ', 'exercice'), ('exercice/autre.typ', 'exercice'), ('feuilles/td.typ', 'document'), ('feuilles/suite.typ', 'document')]
        self.affected = ['exercice/principal.typ', 'feuilles/td.typ', 'feuilles/suite.typ']

    def plan(self, *paths):
        return selection(self.root, set(paths), self.entries)

    def test_exercice_et_feuilles_importatrices(self):
        self.assertEqual(self.plan('exercice/principal.typ'), {'native_full': False, 'wasm_full': False, 'resources': self.affected})

    def test_import_indirect_et_cycle(self):
        (self.root / 'exercice/helper.typ').write_text('#include "principal.typ"')
        self.assertEqual(self.plan('exercice/helper.typ')['resources'], self.affected)

    def test_codes_et_images(self):
        for path in ('exercice/corrigé.ml', 'exercice/image.svg'):
            with self.subTest(path=path):
                self.assertEqual(self.plan(path)['resources'], self.affected)

    def test_import_supprime_reste_une_dependance(self):
        (self.root / 'exercice/helper.typ').unlink()
        self.assertEqual(self.plan('exercice/helper.typ')['resources'], self.affected)
        (self.root / 'exercice/données').unlink()
        self.assertEqual(self.plan('exercice/données')['resources'], self.affected)

    def test_commentaires_et_code_brut_ne_creent_pas_de_dependances(self):
        self.assertNotIn('exercice/autre.typ', self.plan('exercice/principal.typ', 'exercice/image.svg')['resources'])

    def test_fichiers_communs_imposent_une_verification_complete(self):
        for path in ('lib/base.typ', 'templates/fiche.typ', 'load.typ', 'nix/typst-packages.json', 'flake.lock', 'justfile', 'scripts/sources.py'):
            with self.subTest(path=path):
                plan = self.plan(path)
                self.assertTrue(plan['native_full'])
                self.assertTrue(plan['wasm_full'])
                self.assertEqual(plan['resources'], [source for source, _ in self.entries])

    def test_moteur_web_impose_seulement_les_compilations_wasm(self):
        self.assertEqual(self.plan('web/src/compiler/engine.ts'), {'native_full': False, 'wasm_full': True, 'resources': []})

    def test_modification_sans_effet_sur_les_documents(self):
        for path in ('README.md', 'docs/utilisation.md', 'web/src/components/Search.tsx'):
            with self.subTest(path=path):
                self.assertEqual(self.plan(path), {'native_full': False, 'wasm_full': False, 'resources': []})

    def test_sans_base_et_lancement_manuel(self):
        plan = selection(self.root, None, self.entries)
        self.assertTrue(plan['native_full'])
        self.assertTrue(plan['wasm_full'])
        self.assertEqual(plan['resources'], [source for source, _ in self.entries])
        self.assertIsNone(changed_files(self.root, ''))
        self.assertIsNone(changed_files(self.root, '0' * 40))

    def test_base_git_et_renommage(self):
        def git(*args):
            return subprocess.check_output(['git', *args], cwd=self.root, stderr=subprocess.PIPE, text=True).strip()
        git('init')
        git('add', '.')
        git('-c', 'user.name=CI', '-c', 'user.email=ci@example.invalid', 'commit', '-m', 'Initial')
        base = git('rev-parse', 'HEAD')
        self.assertEqual(changed_files(self.root, base), set())
        (self.root / 'exercice/image.svg').rename(self.root / 'exercice/nouvelle.svg')
        git('add', '.')
        git('-c', 'user.name=CI', '-c', 'user.email=ci@example.invalid', 'commit', '-m', 'Renommage')
        self.assertEqual(changed_files(self.root, base), {'exercice/image.svg', 'exercice/nouvelle.svg'})
        with contextlib.redirect_stderr(io.StringIO()):
            self.assertIsNone(changed_files(self.root, 'base-inexistante'))


if __name__ == '__main__':
    unittest.main()
