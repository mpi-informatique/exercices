"""Vérifier le chargement de MPI et des fichiers voisins d'un corrigé."""
from pathlib import Path
import sys
from tempfile import TemporaryDirectory

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / 'scripts'))
from build import test_ocaml

with TemporaryDirectory(prefix='test ocaml ') as dossier:
    dossier = Path(dossier)
    (dossier / 'voisin.ml').write_text('let nombre = 2\n')
    script = dossier / 'corrige.ml'
    script.write_text('''#mod_use "voisin.ml";;
let a = Mpi.Automate.creer ~nb_etats:Voisin.nombre ~initiaux:[0] ~finaux:[1] ~transitions:[];;
assert (Mpi.Automate.nb_etats a = Voisin.nombre);;
''')
    test_ocaml(script)
