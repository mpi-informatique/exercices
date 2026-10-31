"""Vérifier le référencement sur le HTML et les sitemaps réellement construits."""
import json
from html.parser import HTMLParser
from pathlib import Path
import unittest
from urllib.parse import quote, urljoin
import xml.etree.ElementTree as ET

WEB = Path(__file__).resolve().parents[1]
DIST = WEB / 'dist'
NS = {'s': 'http://www.sitemaps.org/schemas/sitemap/0.9'}


class Page(HTMLParser):
    def __init__(self, path):
        super().__init__()
        self.links = []
        self.meta = {}
        self.text = []
        self.schemas = []
        self.structured = False
        self.feed(path.read_text())

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag in ('link', 'a'):
            self.links.append(attrs)
        if tag == 'meta':
            self.meta[attrs.get('name', attrs.get('property'))] = attrs.get('content')
        if tag == 'script' and attrs.get('type') == 'application/ld+json':
            self.structured = True

    def handle_endtag(self, tag):
        if tag == 'script':
            self.structured = False

    def handle_data(self, data):
        if self.structured:
            self.schemas.append(json.loads(data))
        else:
            self.text.append(data)

    @property
    def canonical(self):
        return next(link['href'] for link in self.links if link.get('rel') == 'canonical')


class SeoTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not (DIST / 'index.html').exists():
            raise unittest.SkipTest('Construire le site avec npm run build avant les tests SEO.')
        cls.resources = json.loads((WEB / 'src/generated/catalogue.json').read_text())
        cls.home = Page(DIST / 'index.html')
        cls.base = cls.home.canonical
        cls.urls = {entry.text for entry in ET.parse(DIST / 'sitemap-0.xml').findall('.//s:loc', NS)}

    def test_sitemap_covers_exactly_public_resource_pages(self):
        expected = {self.base} | {urljoin(self.base, quote(resource['id']) + '/') for resource in self.resources}
        self.assertEqual(self.urls, expected)
        index_urls = [entry.text for entry in ET.parse(DIST / 'sitemap-index.xml').findall('.//s:loc', NS)]
        self.assertEqual(index_urls, [urljoin(self.base, 'sitemap-0.xml')])

    def test_catalogue_is_available_without_javascript(self):
        links = {urljoin(self.base, link.get('href', '')) for link in self.home.links}
        self.assertTrue(self.urls - {self.base} <= links)
        items = self.home.schemas[0]['mainEntity']['itemListElement']
        self.assertEqual({item['url'] for item in items}, self.urls - {self.base})

    def test_each_resource_has_consistent_metadata_and_static_content(self):
        for resource in self.resources:
            with self.subTest(resource=resource['id']):
                page = Page(DIST / resource['id'] / 'index.html')
                self.assertEqual(page.canonical, urljoin(self.base, quote(resource['id']) + '/'))
                self.assertEqual(page.meta['og:url'], page.canonical)
                self.assertEqual(page.meta['description'], page.meta['og:description'])
                self.assertIn(resource['titre'], page.meta['description'])
                self.assertIn(resource['titre'], page.text)
                self.assertNotIn('noindex', page.meta.get('robots', ''))
                self.assertEqual(page.schemas[0]['@type'], 'LearningResource')
                self.assertEqual(page.schemas[0]['url'], page.canonical)
                self.assertTrue(any('/blob/main/' in link.get('href', '') for link in page.links))

    def test_technical_and_embedded_pages_are_not_indexable(self):
        pages = [DIST / 'contribution/index.html', DIST / '404.html', *DIST.glob('apercu/*/index.html')]
        for path in pages:
            with self.subTest(page=path):
                page = Page(path)
                self.assertEqual(page.meta['robots'], 'noindex, follow')
                if path.parent.parent.name == 'apercu':
                    self.assertEqual(page.canonical, urljoin(self.base, path.parent.name + '/'))


if __name__ == '__main__':
    unittest.main()
