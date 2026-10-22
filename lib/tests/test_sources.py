"""Contrat de découverte partagé avec l'extension : le dossier n'impose rien."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "scripts"))
from sources import classify, pdf_filename, sources, variants

assert pdf_filename('chapitres/langages/colle.typ', 'enonce') == 'colle.pdf'
assert pdf_filename('chapitres/langages/colle.typ', 'corrige') == 'colle-cor.pdf'
assert pdf_filename('chapitres/langages/cours-kleene.typ', 'cours', 'cours-presentation') == 'cours-kleene.pdf'
assert pdf_filename('chapitres/langages/cours-kleene.typ', 'presentation', 'cours-presentation') == 'presentation-kleene.pdf'
assert pdf_filename('chapitres/langages/support.typ', 'cours', 'cours') == 'support.pdf'
assert pdf_filename('chapitres/langages/support.typ', 'corrige', 'cours') == 'support-cor.pdf'
assert pdf_filename('chapitres/langages/cours-kleene.typ', 'corrige', 'cours-presentation') == 'cours-kleene-cor.pdf'
assert pdf_filename('chapitres/langages/support.typ', 'corrige', 'cours-presentation') == 'cours-support-cor.pdf'

assert classify('#let ex = exercice()', '2026/graphes/un.typ') == 'exercice'
assert classify('#show: feuille.with(type: "devoir", exercices: ())', 'ds.typ') == 'document'
assert classify('#show: feuille.with(type: "colle", exercices: ())', 'libre/colle.typ') == 'document'
assert classify('#show: feuille.with(exercices: ())', 'ancien.typ') == 'document'
assert classify('#let ex = exercice()', 'devoirs/concours/19/sujet.typ') == 'exercice'
assert classify('// #show: feuille.with()\n#let ex = exercice()', 'a.typ') == 'exercice'
assert classify('/* a /* b */ #let ex = exercice() */', 'a.typ') is None
assert classify('`#show: feuille.with()`', 'a.typ') is None
assert classify('#let texte = "#show: feuille.with()"', 'a.typ') is None
assert classify('#import "autre.typ": partie', 'a.typ') is None
assert classify('#import "sujet.typ": ex', 'a.typ') == 'exercice'
assert classify('#import "sujet.typ": autre as ex', 'a.typ') == 'exercice'
assert classify('#show: cours.with(titre: "Cours")', 'libre/a.typ') == 'cours'
assert classify('#show: presentation.with(titre: "Présentation")', 'libre/b.typ') == 'presentation'
assert classify('#show: cours-et-presentation.with(titre: "Cours")', 'libre/c.typ') == 'cours-presentation'
assert classify('// #show: cours-et-presentation.with()\n`#show: presentation.with()`', 'a.typ') is None
assert variants('cours-presentation') == {'cours': ('format=cours', 'corrige=false'), 'corrige': ('format=cours', 'corrige=true'), 'presentation': ('format=presentation', 'corrige=false')}
assert variants('cours') == {'cours': ('corrige=false',), 'corrige': ('corrige=true',)}
assert variants('presentation') == {'presentation': ()}
assert variants('exercice') == variants('document') == {'enonce': ('corrige=false',), 'corrige': ('corrige=true',)}
print('Découverte des sources et variantes : exercices, documents, cours et présentations vérifiés.')

decouvertes = dict(sources())
assert not any(source.startswith('lib/tests/') for source in decouvertes)
print('Exclusion des tests de bibliothèque vérifiée.')
