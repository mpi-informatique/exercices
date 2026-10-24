#import "/load.typ": est-corrige
#import "/load.typ": exercice, feuille, partie, question

#let ex = exercice(
  meta: (
    titre: "Titre du sujet de concours",
    chapitres: ("langages-reguliers", "automates-finis"),
    difficulte: 2,
    niveaux: ("MPI",),
    duree: (4, 0),
    // concours: (nom: "ENS", annee: 2019, filiere: "MP", oral: false),
  ),
  // Corrections conservées dans les données, sans affichage. Remarques du jury en italique.
  corrections: none, // Exemple : [- Question 1 : ajouter l'hypothèse de finitude.]
  jury: none,
  notation: none, // Consignes globales pour le correcteur, sans affichage.
  contenu: (
    [Les réponses doivent être justifiées.
      On fixe un alphabet $Σ$.],
    partie("I", "Langages", jury: none, contenu: (
      partie(
        "I.A",
        "Langages finis",
        contexte: ([On fixe un alphabet $Σ$.],),
        contenu: (
          question(
            [Montrer qu'un langage fini sur $Σ$ est régulier.],
            jury: none, // Observation du jury, affichée en italique avant la solution.
            solution: [Un mot est décrit par la concaténation de ses lettres
              (par $ε$ pour le mot vide).
              Une union finie de telles expressions décrit tout langage fini ; $∅$ décrit le langage vide.],
            bareme: none,
            notation: none, // Consignes propres à cette question, sans affichage.
          ),
        ),
      ),
      partie(
        "I.B",
        "Miroir",
        contexte: ([On fixe un alphabet $Σ$.],),
        contenu: (
          question([Le miroir d'un langage fini est-il régulier ?], solution: [Il est fini, donc régulier.]),
        ),
      ),
    )),
  ),
)

#show: feuille.with(
  type: "devoir", // Un concours est un devoir avec une attribution.
  titre: ex.meta.titre,
  niveau: ex.meta.niveaux.join(" / "),
  concours: ex.meta.concours,
  exercices: (ex,),
  corrige: est-corrige(),
)
