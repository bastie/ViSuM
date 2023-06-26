
import Vision
import UIKit

/// Eine Klasse die Bilderkennung vornimmt und dazu eine Instanze von Core ML Bildklassifizierung intern mit ``VNCoreMLRequest`` nutzt.
///
/// Was macht die Klasse?
/// - Erzeugen eines `VNImageRequestHandler` mit dem Bild
/// - Startet die Bildklassifikation für dieses Bild
/// - Konvertiert das Ergebnis in einen CompletionHandler
/// - Updates die Eigenschaft `predictions`
/// - Tag: ImagePredictor

class Workflow {
    
    /// Unser Klassifikationsmodel
    private static let Bildklassifikation = createImageClassifier()

    /// Erzeugen eines VNCoreMLModel für die Bildklassifikation
    static func createImageClassifier() -> VNCoreMLModel {
        // Erzeugen einer Instanz des Model, welches die Create ML App uns erzeugt hat
        let imageClassifierWrapper = try? LogoClassifier(configuration: MLModelConfiguration())

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("Model kann nicht erzeugt werden, weil du Dödel nicht den Namen des CoreML Model kennst. Schäm dich!")
        }

        /// mit dem Model arbeiten wir weiter
        let imageClassifierModel = imageClassifier.model

        // und erzeigen eine VNCoreMLModel aus unserem BildklassifiziererCreate a Vision instance using the image classifier's model instance.
        guard let imageClassifier = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("Wir konnten das Model leider nicht erzeugen")
        }

        return imageClassifier
    }


    /// Die Funktion signature wie Apple sie haben will für den Completion Handler
    typealias ImagePredictionHandler = (_ predictions: [Vorhersage]?) -> Void

    /// Unsere Handler
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()

    /// Erzeugen einer neuen Anfrageinstanz, welche unser Model nutzt
    private func createImageClassificationRequest() -> VNImageBasedRequest {
        let imageClassificationRequest = VNCoreMLRequest(model: Workflow.Bildklassifikation,
                                                         completionHandler: visionRequestHandler)

        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }

    /// Starten der Klassifikation für das übergebene UIImage.
    /// - Parameter photo: Das Bild
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
        let orientation = CGImagePropertyOrientation(photo.imageOrientation)

        guard let photoImage = photo.cgImage else {
            fatalError("Wie können kein Typ CGImage aus unserem Foto erstellen. Die Welt ist so gemein!")
        }

        let imageClassificationRequest = createImageClassificationRequest()
        predictionHandlers[imageClassificationRequest] = completionHandler

        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
        let requests: [VNRequest] = [imageClassificationRequest]

        // Start the image classification request.
        try handler.perform(requests)
    }

    /// Wenn Vision fertig ist, wird diese Funktion aufgerufen
    /// - Parameters:
    ///   - request: request.
    ///   - error: Fehler, falls fehler sonst nicht gesetzt
    ///
    ///   The method checks for errors and validates the request's results.
    /// - Tag: visionRequestHandler
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Jede Anfrage braucht einen predictionHandler.")
        }

        // Start with a `nil` value in case there's a problem.
        var predictions: [Vorhersage]? = nil

        // Was machen wir wenn wir fertig sind mit dieser Methode, wir rufen den Client auf der uns benötigt hat.
        defer {
            predictionHandler(predictions)
        }

        // Fehler machen nur andere
        if let error = error {
            print("Error in the sky\n\n\(error.localizedDescription)")
            return
        }

        // Haben wir ergebnis
        if request.results == nil {
            print("no result foundet")
            return
        }

        // Der nachfolgende Cast funktioniert für Image Klassifikation andere Core ML Modelle können andere Ergebnistypen erzeugen als erst mal prüfen
        guard let observations = request.results as? [VNClassificationObservation] else {
            print("Unerwüschter Ergebnistyp von VNRequest: \(type(of: request.results)).")
            return
        }

        // jetzt geht es endlich los und wir erzeugen unsere Bilderkennungsergebnisse
        predictions = observations.map { observation in
            Vorhersage(erkannt: observation.identifier,
                       wahrscheinlichkeit: observation.confidence)
        }
    }
}

private extension CGImagePropertyOrientation {
    /// Erzeugt die korrekte Orientation für CGImage aus den UIImage, da dort abweichende Werte verwendet werden
    /// - Parameter orientation: A `UIImage.Orientation` instance.
    init(_ uiimageOrientation: UIImage.Orientation) {
        switch uiimageOrientation {
            case .up: self = .up // 0 => 1
            case .down: self = .down // 1 => 3
            case .left: self = .left // 2 => 8
            case .right: self = .right // 3 => 6
            case .upMirrored: self = .upMirrored // 4 => 2
            case .downMirrored: self = .downMirrored // 5 => 4
            case .leftMirrored: self = .leftMirrored // 6 => 5
            case .rightMirrored: self = .rightMirrored // Ohno equal values: 7 => 7
            @unknown default: self = .up
        }
    }
}
