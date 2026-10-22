import assert from 'node:assert/strict';
import test from 'node:test';
import { readFileSync } from 'node:fs';
import { availableContestYears, contestYearBounds, fitYearRange, parseSearchQuery } from '../src/lib/filters.ts';
import { createSearch } from '../src/lib/search.ts';
import type { Resource } from '../../shared/src/index.ts';

const resources: Resource[] = JSON.parse(readFileSync(new URL('../src/generated/catalogue.json', import.meta.url), 'utf8'));
const search = createSearch(resources);

test('les années proposées dépendent des concours, sans doublons ni années inventées', () => {
  const fixtures = [
    { nom: 'CCINP', annee: 2023 }, { nom: 'CCINP', annee: 2023 },
    { nom: 'ENS', annee: 2018 }, { nom: 'ENS' }, { nom: 'Mines-Ponts', annee: 2019 }, null,
  ].map(concours => ({ ...resources[0]!, concours }));
  assert.deepEqual(availableContestYears(fixtures, []), ['2023', '2019', '2018']);
  assert.deepEqual(availableContestYears(fixtures, ['CCINP']), ['2023']);
  assert.deepEqual(availableContestYears(fixtures, ['ENS', 'Mines-Ponts']), ['2019', '2018']);
  assert.deepEqual(availableContestYears(fixtures, ['mines ponts']), ['2019']);
  assert.deepEqual(availableContestYears(fixtures, ['absent']), []);
  assert.deepEqual(contestYearBounds(fixtures, []), [2018, 2023]);
  assert.deepEqual(contestYearBounds(fixtures, ['CCINP']), [2023, 2023]);
  assert.equal(contestYearBounds(fixtures, ['absent']), undefined);
});

test('la plage inclut ses bornes, écarte les concours non datés et préserve les autres types cochés', () => {
  const fixtures: Resource[] = [2017, 2018, 2019, 2022, 2023, undefined].map((annee, index) => ({ ...resources[0]!, id: `concours-${index}`, type: 'concours', concours: { nom: 'ENS', annee } }));
  fixtures.push({ ...resources[0]!, id: 'td', type: 'td', concours: null });
  const find = createSearch(fixtures);
  assert.deepEqual(find('', { type: ['concours'], concoursAnnees: [2018, 2022] }).map(resource => resource.id), ['concours-1', 'concours-2', 'concours-3']);
  assert.deepEqual(find('', { type: ['concours', 'td'], concoursAnnees: [2018, 2022] }).map(resource => resource.id), ['concours-1', 'concours-2', 'concours-3', 'td']);
  assert.equal(find('', { type: ['concours'] }).length, 6);
  assert.deepEqual(find('année:2019', { concoursAnnees: [2018, 2022] }).map(resource => resource.id), ['concours-2']);
});

test('la plage reste valide après un changement de concours, y compris sans année connue', () => {
  assert.deepEqual(fitYearRange([2017, 2021], [2018, 2023]), [2018, 2021]);
  assert.deepEqual(fitYearRange([2019, 2024], [2018, 2023]), [2019, 2023]);
  assert.deepEqual(fitYearRange([2022, 2022], [2018, 2023]), [2022, 2022]);
  assert.equal(fitYearRange([2018, 2023], [2018, 2023]), undefined);
  assert.equal(fitYearRange([2018, 2023], [2019, 2019]), undefined);
  assert.equal(fitYearRange([2018, 2022], [2023, 2023]), undefined);
  assert.equal(fitYearRange([2018, 2022], undefined), undefined);
});

test('les difficultés sont des niveaux exacts réunis par ou, dans le panneau comme dans le texte', () => {
  const expected = resources.filter(resource => resource.difficulte === 2 || resource.difficulte === 4);
  assert.ok(expected.some(resource => resource.difficulte === 2));
  assert.ok(expected.some(resource => resource.difficulte === 4));
  assert.deepEqual(search('', { difficulte: ['2', '4'] }), expected);
  assert.deepEqual(search('difficulté:2,4', {}), expected);
  assert.deepEqual(search('difficultés:2 difficulté:4', {}), expected);
  assert.deepEqual(search('difficulté:2', { difficulte: ['4'] }), []);
  assert.deepEqual(search('type:concours difficulté:2,4', { concoursAnnees: [2018, 2022] }), expected.filter(resource => resource.type === 'concours' && resource.concours?.annee !== undefined && resource.concours.annee >= 2018 && resource.concours.annee <= 2022));
});

test('recherche française : accents, préfixes, fautes et plusieurs termes', () => {
  assert.ok(search('residuels minimisation', {}).some(resource => resource.id === 'residuels-minimisation'));
  assert.ok(search('residuel', {}).some(resource => resource.id === 'residuels-minimisation'));
  assert.ok(search('minimisatoin', {}).some(resource => resource.id === 'residuels-minimisation'));
  assert.deepEqual(search('zzzintrouvable', {}), []);
});

test('les filtres de documents et de métadonnées se cumulent', () => {
  const results = search('automates', { type: ['concours'], niveaux: ['MPI'], concours: ['ENS'] });
  assert.ok(results.length);
  assert.ok(results.every(resource => resource.type === 'concours' && resource.niveaux.includes('MPI') && resource.concours?.nom === 'ENS'));
  assert.ok(search('', { type: ['td'], chapitres: ['automates-finis'] }).some(resource => resource.id === 'td-automate'));
  assert.ok(search('', { difficulte: ['2'] }).every(resource => resource.difficulte === 2));
});

test('critères textuels, valeurs multiples et années', () => {
  const criteria = 'concours:CCINP,ENS année:2022,2023';
  const expected = resources.filter(resource => ['CCINP', 'ENS'].includes(resource.concours?.nom ?? '') && [2022, 2023].includes(resource.concours?.annee ?? 0));
  assert.ok(expected.length);
  assert.deepEqual(new Set(search(criteria, {}).map(resource => resource.id)), new Set(expected.map(resource => resource.id)));
  assert.deepEqual(search('concours:CCINP concours:ENS', {}), search('', { concours: ['CCINP', 'ENS'] }));
  assert.deepEqual(search('chapitre:"automates finis" type:td', {}), search('', { chapitres: ['automates-finis'], type: ['td'] }));
  assert.deepEqual(search('concours:ccinP', {}), search('', { concours: ['CCINP'] }));
  assert.deepEqual(search('concours:CCINP', { concours: ['ENS'] }), []);
  assert.deepEqual(search('residuels chapitre:automates-finis', {}), search('residuels', { chapitres: ['automates-finis'] }));
  assert.deepEqual(search('', { type: ['td', 'concours'] }), resources.filter(resource => ['td', 'concours'].includes(resource.type)));
});

test('la saisie incomplète ou incorrecte ne casse pas la recherche', () => {
  for (const query of ['concours:', 'chapitre:"automates', 'chapitre:"\\q"', 'difficulté:6', 'difficulté:2,6', 'inconnu:valeur', 'année:,']) {
    assert.doesNotThrow(() => search(query, {}));
    assert.equal(parseSearchQuery(query).text, query);
  }
  assert.deepEqual(parseSearchQuery('difficulté:3 difficulté:2').filters, { difficulte: ['3', '2'] });
});

test('les chapitres sont regroupés selon le programme et une matière entière se combine aux types', () => {
  const groups: Record<string, string[]> = JSON.parse(readFileSync(new URL('../src/generated/chapitres.json', import.meta.url), 'utf8'));
  assert.deepEqual(Object.keys(groups), ['Informatique', 'Mathématiques']);
  const chapters = Object.values(groups).flat();
  assert.equal(new Set(chapters).size, chapters.length);
  assert.ok(resources.every(resource => resource.chapitres.every(chapter => chapters.includes(chapter))));
  for (const group of Object.values(groups)) {
    const expected = resources.filter(resource => resource.chapitres.some(chapter => group.includes(chapter)));
    assert.ok(expected.length);
    assert.deepEqual(search('', { chapitres: group }), expected);
    assert.deepEqual(search('', { chapitres: group, type: ['exercice', 'concours'] }), expected.filter(resource => ['exercice', 'concours'].includes(resource.type)));
  }
});
