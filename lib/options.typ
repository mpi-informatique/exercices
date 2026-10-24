#let est-presentation() = sys.inputs.at("format", default: "cours") == "presentation"

#let est-corrige(defaut: false) = sys.inputs.at("corrige", default: if defaut { "true" } else { "false" }) == "true"
