from pathlib import Path
import sys
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from prepare import copy_tree
from prepare import export_pdfs


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
                export_pdfs(entries, bank, '1234567890abcdef' * 4)

            self.assertEqual(set(entries[0]['pdfs']), {'enonce', 'corrige', 'presentation'})
            for variant, url in entries[0]['pdfs'].items():
                self.assertIn('1234567890abcdef.pdf', url)
                self.assertTrue((web / 'public' / url).read_bytes().startswith(b'%PDF-test'))
            presentation = (web / 'public' / entries[0]['pdfs']['presentation']).read_bytes()
            self.assertIn(b'format=presentation', presentation)
            self.assertNotIn(b'corrige=true', presentation)


if __name__ == "__main__":
    unittest.main()
