import { useEffect, useMemo, useRef, useState } from 'react';
import { Search, SlidersHorizontal, X } from 'lucide-react';
import { typeLabel, type Resource } from '@mpi-informatique/exercices-core';
import { contestYearBounds, fitYearRange, fieldValues, filterFields, filterLabels, type FilterField, type SearchFilters } from '../lib/filters';
import { MultiSelect } from './MultiSelect';
import { ContestYearRange } from './ContestYearRange';
import type { ResourceSearch } from '../lib/search';
import { resourceBadgeLabel } from '../lib/labels';
import { exerciseUrl } from '../lib/urls';
import chapters from '../generated/chapitres.json';
import { isPrivate } from '../lib/privateBank';

const chapterGroups = Object.entries(chapters).map(([label, values]) => ({ label, values }));
const primaryFields: FilterField[] = ['type', 'chapitres', 'concours', 'difficulte'];
const advancedFields = filterFields.filter(key => !primaryFields.includes(key) && key !== 'annee');

interface Props {
  resources: Resource[];
  search: ResourceSearch;
  selected?: string;
  query: string;
  filters: SearchFilters;
  onQuery: (query: string) => void;
  onFilters: (filters: SearchFilters) => void;
  onSelect: (resource: Resource) => void;
}

export default function SearchSidebar({ resources, search, selected, query, filters, onQuery, onFilters, onSelect }: Props) {
  const results = useMemo(() => search(query, filters), [search, query, filters]);
  const list = useRef<HTMLElement>(null);
  const [focused, setFocused] = useState(selected);
  const active = results.find(resource => resource.id === focused) ?? results.find(resource => resource.id === selected) ?? results[0];
  useEffect(() => { setFocused(selected); list.current?.querySelector('[aria-current="page"]')?.scrollIntoView({ block: 'nearest' }); }, [selected]);
  const options = useMemo(() => Object.fromEntries(filterFields.map(key => [key, [...new Set(resources.flatMap(resource => fieldValues(resource, key)))].sort((a, b) => a.localeCompare(b, 'fr', { numeric: true })).map(value => ({ value, label: key === 'type' ? typeLabel(value) : key === 'concours' ? value : key === 'difficulte' ? `${value} / 5` : value.replaceAll('-', ' ') }))])), [resources]);
  const yearBounds = useMemo(() => contestYearBounds(resources, filters.concours ?? []), [resources, filters.concours]);
  const hasFilters = query || Object.values(filters).some(value => Array.isArray(value) ? value.length > 0 : value !== undefined);
  function changeFilter(key: FilterField, values: string[]) {
    const next = { ...filters, [key]: values };
    if (key === 'concours') next.concoursAnnees = fitYearRange(filters.concoursAnnees, contestYearBounds(resources, values));
    if (key === 'type' && !values.includes('concours')) next.concoursAnnees = undefined;
    onFilters(next);
  }
  const select = (key: FilterField) => <MultiSelect key={key} label={filterLabels[key]} placeholder={key === 'type' ? 'Types' : key === 'chapitres' ? 'Chapitres' : undefined} options={options[key]!} groups={key === 'chapitres' ? chapterGroups : undefined} values={filters[key] ?? []} onChange={values => changeFilter(key, values)} selectionHint={key === 'type' && filters.concoursAnnees ? filters.concoursAnnees.join('–') : undefined} optionDetails={key === 'type' ? value => value === 'concours' && <ContestYearRange bounds={yearBounds} value={filters.concoursAnnees} onChange={concoursAnnees => onFilters({ ...filters, concoursAnnees })} /> : undefined} />;

  return <div className="search-panel" id="search-panel">
    <div className="sidebar-top">
      <label className="search-input input"><Search size={15} /><input type="search" placeholder="Recherche, concours:CCINP…" title='Critères : concours:CCINP année:2022 type:td chapitre:"automates finis" difficulté:2,4. Plusieurs valeurs : concours:CCINP,ENS.' aria-label="Rechercher un exercice" aria-keyshortcuts="/" value={query} onChange={event => onQuery(event.target.value)} onKeyDown={event => {
        if (event.nativeEvent.isComposing) return;
        if (event.key === 'ArrowDown' || event.key === 'ArrowUp') { event.preventDefault(); const links = list.current?.querySelectorAll<HTMLAnchorElement>('a'); links?.[event.key === 'ArrowDown' ? 0 : links.length - 1]?.focus(); }
        if (event.key === 'Enter' && results[0]) { event.preventDefault(); onSelect(results[0]); }
      }} /><kbd>/</kbd></label>
      <div className="primary-filters">
        {primaryFields.map(select)}
      </div>
      <details className="advanced-filters"><summary><SlidersHorizontal size={13} /> Filtres <span>{advancedFields.filter(key => filters[key]?.length).length || ''}</span></summary>
        <div className="filter-grid">{advancedFields.map(select)}</div>
      </details>
    </div>
    <div className="results-heading" aria-live="polite"><span><strong>{results.length}</strong> ressource{results.length !== 1 ? 's' : ''}</span>{hasFilters && <button className="reset-filters" onClick={() => { onQuery(''); onFilters({}); }}><X size={12} /> Effacer</button>}</div>
    <nav ref={list} className="results" aria-label="Résultats de recherche" onKeyDown={event => {
      if (!['ArrowDown', 'ArrowUp', 'Home', 'End'].includes(event.key)) return;
      const links = [...list.current!.querySelectorAll<HTMLAnchorElement>('a')];
      const position = links.indexOf(event.target as HTMLAnchorElement);
      if (position < 0) return;
      event.preventDefault();
      const next = event.key === 'Home' ? 0 : event.key === 'End' ? links.length - 1 : Math.max(0, Math.min(links.length - 1, position + (event.key === 'ArrowDown' ? 1 : -1)));
      links[next]?.focus();
    }}>
      {results.map(resource => <a key={resource.id} href={exerciseUrl(resource.id)} title={[resource.titre, resourceBadgeLabel(resource), resource.fichier, ...resource.chapitres].join('\n')} className={`result ${selected === resource.id ? 'selected' : ''}`} aria-current={selected === resource.id ? 'page' : undefined} tabIndex={active?.id === resource.id ? 0 : -1} onFocus={event => { setFocused(resource.id); event.currentTarget.scrollIntoView({ block: 'nearest' }); }}
        onClick={event => { if (!event.metaKey && !event.ctrlKey && !event.shiftKey && !event.altKey) { event.preventDefault(); onSelect(resource); } }}>
        <span className="result-title">{resource.titre}</span>{isPrivate(resource) && <span className="private-badge">Privé</span>}<span className={`resource-type type-${resource.type}`}>{resourceBadgeLabel(resource)}</span>
      </a>)}
      {!results.length && <p className="empty-results">Aucun résultat</p>}
    </nav>
  </div>;
}
