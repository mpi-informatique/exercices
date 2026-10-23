from pathlib import Path
import sys
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from prepare import copy_tree
from prepare import export_pdfs, export_tp, parse_published_pages


class CopyTreeTests(unittest.TestCase):
    def test_preserve_runtime_test_modules_in_packages(self):
        with TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "source"
            source.mkdir()
            (source / "test.typ").write_text("#let is-empty = ()")
            (source / "exercice.typ").write_text("#let ex = ()")
            (source / "test.ml").write_text("let () = ()")
            self.assertEqual(copy_tree(source, root / "bank"), ["exercice.typ"])
            self.assertIn("test.typ", copy_tree(source, root / "package", exclude_tests=False))

    def test_preserve_wasm_plugins_in_packages(self):
        with TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "source"
            (source / "dist").mkdir(parents=True)
            wasm = b"\0asm\x01\0\0\0"
            (source / "dist/code-extract.wasm").write_bytes(wasm)
            self.assertEqual(copy_tree(source, root / "package", exclude_tests=False), ["dist/code-extract.wasm"])
            self.assertEqual((root / "package/dist/code-extract.wasm").read_bytes(), wasm)

    def test_reject_files_outside_public_root(self):
        with TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "source"
            source.mkdir()
            private = root / "private.txt"
            private.write_text("fictif")
            (source / "outside.txt").symlink_to(private)
            with self.assertRaisesRegex(ValueError, "hors de la banque"):
                copy_tree(source, root / "destination")


class ExportPdfTests(unittest.TestCase):
    def test_menu_selection(self):
        menu = "- Langages\n  - Rubrique\n    - cours-exemple\n    - [TD](td-exemple): cor\n    - [QCM](doc:langages/qcm)\n    - [Lien](https://example.org)\n"
        self.assertEqual(parse_published_pages(menu), {"cours-exemple": False, "td-exemple": True})

    def test_only_selected_resources_and_corrections_are_compiled(self):
        with TemporaryDirectory() as temporary:
            root = Path(temporary)
            entries = [{'id': name, 'fichier': f'{name}.typ'} for name in ('cours', 'td', 'autre')]

            def compile_pdf(source, output, signature, *inputs, exercice=False):
                target = root / output
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(b'%PDF-test')

            with patch('prepare.ROOT', root), patch('prepare.WEB', root / 'web'), patch('prepare.sources', return_value=[('cours.typ', 'cours-presentation'), ('td.typ', 'document'), ('autre.typ', 'exercice')]), patch('prepare.compiler', side_effect=compile_pdf) as compile_mock:
                export_pdfs(entries, root / 'web/public/banque', 'signature', {'cours': False, 'td': True})
            self.assertEqual(compile_mock.call_count, 4)
            self.assertEqual(set(entries[0]['pdfs']), {'enonce', 'presentation'})
            self.assertEqual(set(entries[1]['pdfs']), {'enonce', 'corrige'})
            self.assertEqual(entries[2]['pdfs'], {})

    def test_missing_resource_fails_before_compilation(self):
        with patch('prepare.compiler') as compile_mock:
            with self.assertRaisesRegex(ValueError, 'absents de la banque.*inconnu'):
                export_pdfs([], Path('unused'), 'signature', {'inconnu': False})
            compile_mock.assert_not_called()

    def test_export_course_variants_with_versioned_urls(self):
        with TemporaryDirectory() as temporary:
            root = Path(temporary)
            web = root / 'web'
            bank = web / 'public/banque'
            entries = [{'id': 'cours-exemple', 'fichier': 'chapitres/cours-exemple.typ'}]

            def compile_pdf(source, output, signature, *inputs, exercice=False):
                target = root / output
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(b'%PDF-test\n' + repr(inputs).encode())

            with patch('prepare.ROOT', root), patch('prepare.WEB', web), patch('prepare.sources', return_value=[('chapitres/cours-exemple.typ', 'cours-presentation')]), patch('prepare.compiler', side_effect=compile_pdf):
                export_pdfs(entries, bank, '1234567890abcdef' * 4, {'cours-exemple': True})

            self.assertEqual(set(entries[0]['pdfs']), {'enonce', 'corrige', 'presentation'})
            for variant, url in entries[0]['pdfs'].items():
                self.assertIn('1234567890abcdef.pdf', url)
                self.assertTrue((web / 'public' / url).read_bytes().startswith(b'%PDF-test'))
            presentation = (web / 'public' / entries[0]['pdfs']['presentation']).read_bytes()
            self.assertIn(b'format=presentation', presentation)
            self.assertNotIn(b'corrige=true', presentation)


class TpExportTests(unittest.TestCase):
    def test_tp_outside_course_gets_both_pdfs(self):
        with TemporaryDirectory() as temporary:
            root = Path(temporary)
            entries = [{'id': 'tp-test', 'fichier': 'tp-test.typ', 'type': 'tp'}]
            def compile_pdf(source, output, signature, *inputs, exercice=False):
                target = root / output
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(b'%PDF-test')
            with patch('prepare.ROOT', root), patch('prepare.WEB', root / 'web'), patch('prepare.sources', return_value=[('tp-test.typ', 'document')]), patch('prepare.compiler', side_effect=compile_pdf):
                export_pdfs(entries, root / 'web/public/banque', 'signature', {})
                self.assertEqual(set(entries[0]['pdfs']), {'enonce', 'corrige'})
                export_pdfs(entries, root / 'web/public/banque', 'signature', {'tp-test': False})
                self.assertEqual(set(entries[0]['pdfs']), {'enonce', 'corrige'})

    def test_tp_metadata_resources_and_correction_are_published(self):
        with TemporaryDirectory() as temporary:
            root = Path(temporary)
            directory = root / 'chapitres/langages/tp/tp-test'
            directory.mkdir(parents=True)
            for name in ('main.ml', 'corrige.ml', 'data.zip', 'annexe.pdf'):
                (directory / name).write_text('fictif')
            data = {'ouvrir': 'travail.ml', 'squelette': [{'source': 'main.ml', 'destination': 'travail.ml'}], 'ressources': [{'source': 'data.zip', 'extraire': 'donnees'}, {'source': 'annexe.pdf'}], 'corrige': [{'source': 'corrige.ml'}]}
            source = 'chapitres/langages/tp/tp-test/tp-test.typ'
            entries = [{'id': 'tp-test', 'fichier': source, 'type': 'tp', 'tp': data}]
            bank = root / 'web/public/banque'
            with patch('prepare.ROOT', root):
                exported = export_tp(entries, bank)
            self.assertEqual(entries[0]['tp']['ouvrir'], 'travail.ml')
            self.assertEqual(entries[0]['tp']['fichiers'][1]['extraire'], 'donnees')
            self.assertEqual(len(entries[0]['tp']['corrige']), 1)
            self.assertEqual(len(exported), 4)
            for resource in entries[0]['tp']['fichiers'] + entries[0]['tp']['corrige']:
                self.assertEqual((root / 'web/public' / resource['url']).read_text(), 'fictif')
            self.assertIn('chapitres/langages/tp/tp-test/annexe.pdf', exported)
            self.assertFalse((directory / 'tp.json').exists())

    def test_tp_requires_metadata(self):
        with self.assertRaisesRegex(ValueError, 'Métadonnées tp absentes'):
            export_tp([{'type': 'tp', 'fichier': 'sujet.typ'}], Path('unused'))

    def test_tp_rejects_unsafe_or_missing_resources(self):
        with TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / 'sujet'
            source.mkdir()
            (source / 'main.ml').write_text('fictif')
            (root / 'secret.ml').write_text('privé')
            (source / 'lien.ml').symlink_to(root / 'secret.ml')
            for name, error in (('../secret.ml', 'Chemin TP invalide'), ('inconnu.ml', 'absente ou hors du dossier'), ('lien.ml', 'absente ou hors du dossier')):
                data = {'ouvrir': 'main.ml', 'squelette': [{'source': name}]}
                with self.subTest(name=name), patch('prepare.ROOT', root), self.assertRaisesRegex(ValueError, error):
                    export_tp([{'type': 'tp', 'fichier': 'sujet/sujet.typ', 'tp': data}], root / 'bank')


if __name__ == "__main__":
    unittest.main()
