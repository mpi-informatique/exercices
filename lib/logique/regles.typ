#import "../options.typ": est-corrige, est-presentation
#import "../document.typ": lien-externe, tableau
#import "../presentation.typ": colonnes-cours, formules-reparties, only, pause, uncover
#import "@preview/curryst:0.6.0": prooftree, rule

/// Notation de l'arithmétique de Peano.
#let PA = $upright("PA")$

/// Affiche un séquent lié au prouveur interactif, avec l’icône de lien externe en exposant.
/// Exemple : `sequent(($A → B, A$, $B$))`.
///
/// - couple (array): Couple (hypothèses, conclusion) de contenus mathématiques ; `[]` pour le contexte vide.
/// - logique (content, none): Indice affiché sous le symbole ⊢, par exemple `$i$` ou `$c$`.
/// - contexte-affiche (content, none): Abréviation du contexte à afficher ; le lien utilise les hypothèses du couple.
/// -> content
#let sequent(couple, logique: none, contexte-affiche: none) = {
  let (hypotheses, conclusion) = couple
  let convertir(contenu) = {
    let champs = contenu.fields()
    if contenu == [ ] {
      ""
    } else if champs.keys().contains("text") {
      contenu.text
    } else if champs.keys().contains("children") {
      contenu.children.map(convertir).join()
    } else if contenu.func() in (math.equation, math.lr, math.scripts) {
      convertir(contenu.body)
    } else {
      panic("Notation non prise en charge dans un lien de séquent : " + repr(contenu))
    }
  }
  let contexte = if contexte-affiche == none { hypotheses } else { contexte-affiche }
  let these = if logique == none { $⊢$ } else { $scripts(⊢)_#logique$ }
  let body = $#contexte #these #conclusion$
  let cible = convertir(hypotheses) + "⊢" + convertir(conclusion)
  for (symbole, ascii) in (("⊢", "|-"), ("→", "->"), ("∧", "&"), ("∨", "|"), ("¬", "!"), ("⊥", "0")) {
    cible = cible.replace(symbole, ascii)
  }
  cible = cible.replace(regex("\\s+"), "").replace("&", "%26").replace("|", "%7C").replace(">", "%3E")
  lien-externe("https://mpi-informatique.github.io/deduction-naturelle/?sequent=" + cible, body)
}

/// Centre un arbre de preuve et le réduit si sa largeur dépasse la place disponible.
///
/// - body (content): Arbre produit par `prooftree`.
/// -> content
#let arbre(body) = block(width: 100%, context layout(size => {
  let largeur = measure(body).width
  align(center, if largeur > size.width { scale(x: size.width / largeur * 100%, reflow: true, body) } else { body })
}))

// Les mêmes règles alimentent le tableau imprimé et les diapositives.
#let cases-regles(regles, rempli: est-presentation() or est-corrige(), hauteur: 3.4em) = {
  let arbres = regles.map(regle => {
    // Masquer les séquents conserve la longueur de la barre et la position du nom.
    let schema = if rempli { regle } else {
      // Réserver aussi une ligne au-dessus des règles sans prémisse pour aligner les barres.
      let premises = if regle.premises.len() == 0 { (regle.conclusion,) } else { regle.premises }
      regle + (premises: premises.map(hide), conclusion: hide(regle.conclusion))
    }
    prooftree(schema)
  })
  context layout(size => {
    let largeur = (
      arbres.fold(0pt, (somme, arbre) => somme + measure(arbre).width) + (arbres.len() - 1) * 0.8em.to-absolute()
    )
    let lignes = if largeur <= size.width { (formules-reparties(..arbres),) } else { arbres.map(arbre) }
    for ligne in lignes {
      block(width: 100%, height: hauteur, above: 0pt, below: 0pt)[
        #align(horizon, ligne)
      ]
    }
  })
}

/// Affiche les règles en tableau imprimé ou en diapositives avec révélation progressive.
///
/// - lignes (array): Lignes choisies dans `regles`, avec des intuitions affichées en sous-ligne et des remarques ou applications facultatives.
///   Les champs `intuition-introduction` et `intuition-elimination` contiennent les explications sans le libellé « Intuitivement ».
/// - axiome (dictionary, none): Schéma de l’axiome, omis si `none`.
/// - condition-axiome (content): Annotation sous le schéma de l’axiome, par exemple son constructeur OCaml.
/// - compact (bool): Réduire la hauteur des schémas et les marges du tableau imprimé.
/// - rempli (bool): Afficher les séquents ; par défaut, seulement dans le corrigé et la présentation.
/// - conditions-dessus (bool): Placer les conditions d'introduction et d'élimination au-dessus des règles dans le tableau imprimé.
/// - progressif (bool): Révéler les règles progressivement dans la présentation.
/// -> content
#let tableau-regles(
  lignes,
  axiome: none,
  condition-axiome: [],
  compact: false,
  rempli: est-presentation() or est-corrige(),
  conditions-dessus: false,
  progressif: true,
) = {
  if est-presentation() {
    let afficher-regles(regles) = {
      if progressif {
        only(1, cases-regles(regles, rempli: false))
        only("2-", cases-regles(regles, rempli: rempli))
      } else {
        cases-regles(regles, rempli: rempli)
      }
    }
    if axiome != none {
      heading(depth: 2)[Axiome]
      afficher-regles((axiome,))
      if progressif { pause }
      if progressif {
        uncover("2-", text(size: 0.75em, condition-axiome))
      } else {
        text(size: 0.75em, condition-axiome)
      }
    }
    for ligne in lignes {
      let intuition(champ) = {
        let body = ligne.at(champ, default: [])
        if body != [] {
          let contenu = text(size: 0.75em)[#underline[Intuitivement] : #body]
          if progressif { uncover("2-", contenu) } else { contenu }
        }
      }
      heading(depth: 2, ligne.titre)
      colonnes-cours(
        empiler-presentation: false,
        separation: true,
        align: center + top,
        [
          *Introduction*

          #text(size: 0.75em, ligne.at("condition-introduction", default: []))
          #afficher-regles(ligne.introduction)
          #intuition("intuition-introduction")
        ],
        [
          *Élimination*

          #text(size: 0.75em, ligne.at("condition-elimination", default: []))
          #afficher-regles(ligne.elimination)
          #intuition("intuition-elimination")
        ],
      )
      // Une seule pause révèle simultanément les deux colonnes.
      if progressif { pause }
      ligne.at("remarque", default: [])
      ligne.at("applications", default: [])
    }
  } else {
    let hauteur = if compact { 2.4em } else { 3.4em }
    let cellules = ()
    if axiome != none {
      cellules += (
        [*Axiome*],
        table.cell(colspan: 2)[
          #cases-regles((axiome,), rempli: rempli, hauteur: hauteur)
          #text(size: 0.85em, condition-axiome)
        ],
      )
    }
    for ligne in lignes {
      let intuitions = (
        ligne.at("intuition-introduction", default: []),
        ligne.at("intuition-elimination", default: []),
      )
      let avec-intuitions = intuitions.any(body => body != [])
      cellules += (
        [*#ligne.titre*],
        [
          #if conditions-dessus { text(size: 0.85em, ligne.at("condition-introduction", default: [])) }
          #cases-regles(ligne.introduction, rempli: rempli, hauteur: hauteur)
          #if not conditions-dessus { text(size: 0.85em, ligne.at("condition-introduction", default: [])) }
        ],
        [
          #if conditions-dessus { text(size: 0.85em, ligne.at("condition-elimination", default: [])) }
          #cases-regles(ligne.elimination, rempli: rempli, hauteur: hauteur)
          #if not conditions-dessus { text(size: 0.85em, ligne.at("condition-elimination", default: [])) }
        ],
      )
      if avec-intuitions {
        cellules += (table.hline(stroke: none), text(size: 0.85em)[Intuitivement])
        cellules += intuitions.map(body => table.cell(align: left + top, text(size: 0.85em, body)))
      }
    }
    block(breakable: false, tableau(
      columns: (auto, 1fr, 1fr),
      inset: (x: 0.6em, y: if compact { 0.3em } else { 0.8em }),
      table.header([*Opérateur*], [*Introduction*], [*Élimination*]),
      ..cellules,
    ))
  }
}

// Schémas communs au cours et au TP. Le TP omet les constantes.
#let axiome = rule(name: [ax], [$Γ, X ⊢ X$])
/// Règle du raisonnement par l'absurde (logique classique).
#let raa = rule(name: [raa], [$Γ, ¬ X ⊢ ⊥$], [$Γ ⊢ X$])
/// Règle du tiers exclu (logique classique).
#let te = rule(name: [te], [$Γ ⊢ X ∨ ¬ X$])
#let regles = (
  constantes: (
    titre: [Vrai $⊤$ et faux $⊥$],
    introduction: (rule(name: [$⊤_i$], [$Γ ⊢ ⊤$]),),
    elimination: (rule(name: [$⊥_e$], [$Γ ⊢ ⊥$], [$Γ ⊢ X$]),),
  ),
  implication: (
    titre: [Implication $→$],
    introduction: (rule(name: [$scripts(→)_i$], [$Γ, X ⊢ Y$], [$Γ ⊢ X → Y$]),),
    elimination: (rule(name: [$scripts(→)_e$], [$Γ ⊢ X → Y$], [$Γ ⊢ X$], [$Γ ⊢ Y$]),),
  ),
  conjonction: (
    titre: [Conjonction $∧$],
    introduction: (rule(name: [$∧_i$], [$Γ ⊢ X$], [$Γ ⊢ Y$], [$Γ ⊢ X ∧ Y$]),),
    elimination: (
      rule(name: [$∧_e^g$], [$Γ ⊢ X ∧ Y$], [$Γ ⊢ X$]),
      rule(name: [$∧_e^d$], [$Γ ⊢ X ∧ Y$], [$Γ ⊢ Y$]),
    ),
  ),
  disjonction: (
    titre: [Disjonction $∨$],
    introduction: (
      rule(name: [$∨_i^g$], [$Γ ⊢ X$], [$Γ ⊢ X ∨ Y$]),
      rule(name: [$∨_i^d$], [$Γ ⊢ Y$], [$Γ ⊢ X ∨ Y$]),
    ),
    elimination: (
      rule(
        name: [$∨_e$],
        [$Γ, X ⊢ Z$],
        [$Γ, Y ⊢ Z$],
        [$Γ ⊢ X ∨ Y$],
        [$Γ ⊢ Z$],
      ),
    ),
  ),
  negation: (
    titre: [Négation $¬$],
    introduction: (rule(name: [$¬_i$], [$Γ, X ⊢ ⊥$], [$Γ ⊢ ¬ X$]),),
    elimination: (rule(name: [$¬_e$], [$Γ ⊢ X$], [$Γ ⊢ ¬ X$], [$Γ ⊢ ⊥$]),),
  ),
)

/// Répartit les règles de déduction naturelle sur des lignes équilibrées, par exemple dans une colle ou un exercice.
///
/// - selection (array): Liste de groupes de `regles` (comme `regles.implication`) ou de schémas individuels `rule(...)`. Par défaut, toutes les règles intuitionnistes.
/// - axiome (dictionary, none): Schéma de l'axiome ajouté en tête, ou `none` pour l'omettre.
/// - classique (bool): Ajouter les règles classiques `raa` et `te`.
/// - titre (content, none): Libellé facultatif au-dessus des règles, omis par défaut.
/// - taille (length): Taille du texte des règles.
/// -> content
#let rappel-regles(
  selection: (regles.constantes, regles.implication, regles.conjonction, regles.disjonction, regles.negation),
  axiome: axiome,
  classique: false,
  titre: none,
  taille: 0.85em,
) = {
  let schemas = ()
  if axiome != none { schemas.push(axiome) }
  for item in selection {
    if "introduction" in item or "elimination" in item {
      schemas += item.at("introduction", default: ()) + item.at("elimination", default: ())
    } else {
      schemas.push(item)
    }
  }
  if classique { schemas += (raa, te) }
  if schemas.len() == 0 and titre == none { return [] }
  block(width: 100%, breakable: false, {
    if titre != none {
      block(above: 0pt, below: 0.35em, text(size: 0.85em, weight: "bold", titre))
    }
    set text(size: taille)
    context layout(size => {
      if schemas.len() == 0 { return [] }
      let arbres = schemas.map(prooftree)
      let intervalle = 1em.to-absolute()
      let maximum = size.width + intervalle
      let largeurs = arbres.map(schema => calc.min(maximum, measure(schema).width + intervalle))

      let decouper(limite) = {
        let lignes = ()
        let debut = 0
        let largeur = 0pt
        for (i, ajout) in largeurs.enumerate() {
          if i > debut and largeur + ajout > limite {
            lignes.push(arbres.slice(debut, i))
            debut = i
            largeur = 0pt
          }
          largeur += ajout
        }
        lignes + (arbres.slice(debut),)
      }

      // Réduire la largeur maximale des lignes en conservant leur nombre minimal.
      let lignes = decouper(maximum)
      if lignes.len() > 1 {
        let minimum = largeurs.sum() / lignes.len()
        while maximum - minimum > 0.5pt {
          let milieu = (minimum + maximum) / 2
          let essai = decouper(milieu)
          if essai.len() > lignes.len() {
            minimum = milieu
          } else {
            maximum = milieu
            lignes = essai
          }
        }
      }
      stack(spacing: 0.75em, ..lignes.map(ligne => {
        if ligne.len() == 1 { arbre(ligne.first()) } else { formules-reparties(..ligne) }
      }))
    })
  })
}
