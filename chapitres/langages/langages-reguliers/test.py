"""Vérifier la recherche de facteur, y compris le motif vide et les chevauchements."""
from pathlib import Path
import os
import shlex
import subprocess
from tempfile import TemporaryDirectory

source = Path(__file__).with_name('corrige.c')
with TemporaryDirectory() as dossier:
    executable = Path(dossier) / 'facteur'
    commande = shlex.split(os.environ.get('CC', 'cc'))
    subprocess.run(commande + ['-std=c11', '-Wall', '-Wextra', '-Werror', '-DTEST', str(source), '-o', str(executable)], check=True)
    subprocess.run([str(executable)], check=True)
