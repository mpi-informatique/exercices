import assert from 'node:assert/strict';
import test from 'node:test';
import { availableVariants, compilationInputs, pdfFilename } from '../../shared/src/index.ts';

test('les cours, corrigés et présentations ont des paramètres et noms distincts', () => {
  assert.deepEqual(availableVariants('cours-presentation'), ['enonce', 'corrige', 'presentation']);
  for (const [variant, format, name] of [
    ['enonce', 'cours', 'cours-kleene.pdf'],
    ['corrige', 'cours', 'cours-kleene-cor.pdf'],
    ['presentation', 'presentation', 'presentation-kleene.pdf'],
  ] as const) {
    assert.deepEqual(compilationInputs(variant, 'cours-presentation'), { format, corrige: String(variant === 'corrige') });
    assert.equal(pdfFilename('chapitres/langages/cours/cours-kleene.typ', variant, 'cours-presentation'), name);
  }
  assert.deepEqual(availableVariants('cours'), ['enonce', 'corrige']);
  assert.equal(pdfFilename('chapitres/support.typ', 'corrige', 'cours'), 'support-cor.pdf');
  assert.deepEqual(compilationInputs('corrige', 'cours'), { corrige: 'true' });
  assert.deepEqual(availableVariants('presentation'), ['enonce']);
  assert.equal(pdfFilename('chapitres/support.typ', 'enonce', 'presentation'), 'support.pdf');
  assert.deepEqual(availableVariants('td'), ['enonce', 'corrige']);
  assert.equal(pdfFilename('chapitres/exercice.typ', 'corrige', 'exercice'), 'exercice-cor.pdf');
});
