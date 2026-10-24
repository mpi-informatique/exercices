#import "/load.typ": est-corrige
// Aperçu autonome d'un exercice exportant ex, quel que soit son emplacement.
#import "/load.typ": auteur-par-defaut, feuille
#let chemin = sys.inputs.at("exercice", default: "/templates/exercice.typ")
#import chemin: ex
#show: feuille.with(
  type: "exercice",
  titre: ex.meta.titre,
  niveau: ex.meta.niveaux.join(" / "),
  auteur: ex.meta.at("auteur", default: auteur-par-defaut),
  concours: ex.meta.concours,
  exercices: (ex,),
  corrige: est-corrige(),
)
