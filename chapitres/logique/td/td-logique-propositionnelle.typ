#import "/load.typ": est-corrige, feuille
#import "/chapitres/logique/exercices/calcul-propositionnel.typ": ex as calcul
#import "/chapitres/logique/exercices/arbres-decision/arbres-decision.typ": ex as decision
#import "/chapitres/logique/exercices/systemes-connecteurs.typ": ex as connecteurs
#import "/chapitres/logique/exercices/formes-normales-tseitin.typ": ex as formes
#import "/chapitres/logique/exercices/automates-valuations.typ": ex as automates
#import "/chapitres/logique/exercices/clauses-satisfaites.typ": ex as clauses

#show: feuille.with(
  type: "td",
  titre: "TD : Logique propositionnelle",
  niveau: "MPI",
  auteur: "Q. Fortier",
  exercices: (calcul, decision, connecteurs, formes, automates, clauses),
  corrige: est-corrige(),
  nouvelle-page: false,
)
