/// Das eigentliche fachliche Ergebnis was erkannt wurde und wie gut es erkannt wurde
struct Vorhersage {
    /// Was haben wir erkannt?
    let erkannt: String

    /// wie wahrscheinlich halten wir es, das die Erkenntn richtig ist, wie bei KI üblich als Float
    let wahrscheinlichkeit: Float
}

