/// Teste si l'entrée système `format` vaut `presentation`.
///
/// -> bool
#let est-presentation() = sys.inputs.at("format", default: "cours") == "presentation"

/// Teste l'entrée système `corrige`, avec une valeur de repli si elle est absente.
///
/// - defaut (bool): Valeur utilisée en l'absence d'entrée.
/// -> bool
#let est-corrige(defaut: false) = sys.inputs.at("corrige", default: if defaut { "true" } else { "false" }) == "true"
