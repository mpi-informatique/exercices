// Voir docs/programme.md. Les concepts de langages vont dans chapitres.
#let chapitres-informatique = (
  // § 1–2, p. 5–7
  "methodes-de-programmation", "recursivite-et-induction",
  // § 3–4, p. 8–12 ; graphes : § 3.4 et 4.5, p. 9 et 11
  "structures", "algorithmique", "graphes",
  // § 4.6, p. 12
  "jeux",
  // § 5–7, p. 13–17
  "gestion-des-ressources", "logique", "bases-de-donnees",
  // § 8.1–8.3, p. 18–19 : les mots et expressions relèvent de 8.1
  "langages-reguliers", "automates-finis", "grammaires-non-contextuelles",
  // § 9, p. 20
  "decidabilite-et-classes-de-complexite",
)

#let chapitres-maths = (
  // MPSI–MP2I, premier semestre, p. 6–20
  "raisonnement-et-vocabulaire-ensembliste", "calcul-algebrique-et-trigonometrie",
  "nombres-complexes", "calcul-differentiel-et-integral", "equations-differentielles-lineaires",
  "nombres-reels-et-suites-numeriques",
  "limites-et-continuite", "derivabilite", "convexite", "arithmetique",
  "structures-algebriques", "calcul-matriciel-et-systemes-lineaires",
  "polynomes-et-fractions-rationnelles",
  // MPSI–MP2I, deuxième semestre, p. 21–36
  "analyse-asymptotique", "espaces-vectoriels-et-applications-lineaires", "matrices",
  "groupe-symetrique", "determinants", "integration", "denombrement", "probabilites",
  "espaces-prehilbertiens-reels", "series-numeriques", "familles-sommables",
  "fonctions-de-deux-variables",
  // MP–MPI, p. 6–14 : structures-algebriques et series-numeriques déjà ci-dessus
  "reduction", "endomorphismes-des-espaces-euclidiens",
  "topologie-des-espaces-vectoriels-normes", "series-vectorielles",
  // MP–MPI, p. 15–28
  "suites-et-series-de-fonctions", "series-entieres", "fonctions-vectorielles",
  "integration-sur-un-intervalle-quelconque", "variables-aleatoires-discretes",
  "calcul-differentiel-et-optimisation",
)

#let chapitres-programme = chapitres-informatique + chapitres-maths

#let niveaux-par-chapitre = {
  let premiere-annee-maths = (
    "raisonnement-et-vocabulaire-ensembliste", "calcul-algebrique-et-trigonometrie",
    "nombres-complexes", "calcul-differentiel-et-integral", "equations-differentielles-lineaires",
    "nombres-reels-et-suites-numeriques", "limites-et-continuite", "derivabilite", "convexite",
    "arithmetique", "structures-algebriques", "calcul-matriciel-et-systemes-lineaires",
    "polynomes-et-fractions-rationnelles", "analyse-asymptotique",
    "espaces-vectoriels-et-applications-lineaires", "matrices", "groupe-symetrique",
    "determinants", "integration", "denombrement", "probabilites", "espaces-prehilbertiens-reels",
    "series-numeriques", "familles-sommables", "fonctions-de-deux-variables",
  )
  let seconde-annee-maths = chapitres-maths.filter(chapitre => chapitre not in premiere-annee-maths)
  let informatique-mpi = (
    "langages-reguliers", "automates-finis", "grammaires-non-contextuelles",
    "decidabilite-et-classes-de-complexite",
  )
  let informatique-mp = ("recursivite-et-induction", "algorithmique", "graphes")
  let resultat = (:)
  for chapitre in premiere-annee-maths { resultat.insert(chapitre, ("MPSI", "MP2I", "MP", "MPI")) }
  for chapitre in seconde-annee-maths { resultat.insert(chapitre, ("MP", "MPI")) }
  for chapitre in chapitres-informatique { resultat.insert(chapitre, ("MP2I", "MPI")) }
  for chapitre in informatique-mpi { resultat.insert(chapitre, ("MP", "MPI")) }
  for chapitre in informatique-mp { resultat.insert(chapitre, ("MP2I", "MP", "MPI")) }
  resultat.insert("jeux", ("MPI",))
  resultat
}

#let structures-programme = (
  // § 3.1–3.2, p. 8
  "tableau", "liste", "liste-chainee", "pile", "file",
  "tableau-associatif", "table-de-hachage",
  // § 3.3, p. 9
  "arbre", "arbre-binaire", "arbre-binaire-de-recherche", "arbre-bicolore",
  "tas", "file-de-priorite", "unir-et-trouver",
  // § 3.4, p. 9
  "graphe",
)
#let algorithmes-programme = (
  // § 3.3, p. 9
  "parcours-prefixe", "parcours-infixe", "parcours-postfixe", "tri-par-tas",
  // § 4.2–4.3, p. 10–11 (algorithmes et méthodes algorithmiques)
  "retour-sur-trace", "separation-et-evaluation",
  "algorithme-glouton", "diviser-pour-regner", "rencontre-au-milieu",
  "dichotomie", "programmation-dynamique",
  // § 4.4–4.5, p. 11
  "boyer-moore", "rabin-karp", "huffman", "lempel-ziv-welch",
  "parcours-en-profondeur", "parcours-en-largeur", "tri-topologique",
  "kosaraju", "dijkstra", "floyd-warshall", "kruskal",
  // § 8.2, p. 18
  "determinisation", "berry-sethi", "elimination-des-etats",
)

// Valeurs autorisées pour les métadonnées de concours.
#let concours-possibles = (
  "Centrale",
  "Mines-Ponts",
  "CCINP",
  "ENS",
  "EPITA",
  "X",
  "X-ENS",
)

#let filieres-possibles = (
  "MP2I",
  "MPI",
  "MP",
  "PC",
  "PSI",
  "PT",
)

#let langages-possibles = ("C", "OCaml", "Python", "SQL")
