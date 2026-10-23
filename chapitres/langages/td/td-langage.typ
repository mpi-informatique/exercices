#import "/load.typ": exercice, feuille, question
#import "/chapitres/langages/exercices/mots-qui-commutent.typ": ex as commutation
#import "/chapitres/langages/exercices/mots-de-fibonacci.typ": ex as fibonacci
#import "/chapitres/langages/exercices/exemples-langages-reguliers.typ": ex as exemples
#import "/chapitres/langages/exercices/distance-de-hamming.typ": ex as hamming
#import "/devoirs/concours/oral/ens/ens-oral-mp-cloture-sur-mots.typ": ex as sur-mots

#let regles = exercice(
  meta: (
    titre: "Règles sur les expressions régulières",
    chapitres: ("langages-reguliers",),
    difficulte: 2,
    niveaux: ("MPI",),
  ),
  colonnes: 2,
  contenu: (
    [Pour chacune des propositions suivantes sur des expressions régulières quelconques, donner une preuve ou un contre-exemple.
      Le symbole $equiv$ signifie que les expressions décrivent le même langage.],
    question([$ (e^2)^* equiv (e^*)^2 quad ("où " e^2=e e). $], solution: [
      Faux avec $e=a$ : le mot $a$ n'appartient pas à $cal(L)((a a)^*)$, mais $a=a epsilon$ appartient à $cal(L)((a^*)^2)$.
    ]),
    question([$ (e_1 | e_2)^* equiv e_1^* | e_2^*. $], solution: [
      Faux avec $e_1=a$ et $e_2=b$ : $a b in cal(L)((a|b)^*)$, mais $a b in.not cal(L)(a^*|b^*)$.
    ]),
    question([$ (e_1 e_2)^* equiv e_1^* e_2^*. $], solution: [
      Faux avec $e_1=a$ et $e_2=b$ : $a b a b in cal(L)((a b)^*)$, mais $a b a b in.not cal(L)(a^* b^*)$.
    ]),
    question([$ (e_1 | e_2)^* equiv (e_1^* e_2^*)^*. $], solution: [
      Vrai.
      Posons $A=cal(L)(e_1)$ et $B=cal(L)(e_2)$.
      Un mot de $(A^* B^*)^*$ est une concaténation de mots de $A$ et de $B$, donc appartient à $(A union B)^*$.
      Réciproquement, $A union B subset.eq A^* B^*$ puisque chaque étoile contient $epsilon$.
      L'étoile conservant l'inclusion, $(A union B)^* subset.eq (A^* B^*)^*$.
    ]),
  ),
)

#show: feuille.with(
  titre: "TD : Langages réguliers",
  niveau: "MPI",
  auteur: "Q. Fortier",
  exercices: (commutation, fibonacci, regles, exemples, hamming, sur-mots),
  corrige: sys.inputs.at("corrige", default: "false") == "true",
)
