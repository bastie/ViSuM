import SwiftUI

public struct BusinessModel {
    
    /// prediction as Binding
    @Binding var prediction : String
    
    /// Create a workflow instance to doing something for prediction of image.
    let imagePredictor = Workflow()
    
    /// count of predictions to store in prediction variable
    let predictionsToShow = 3


    /// if image is changed, what is printed on it?
    public func onPhotoChanged (image : UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Developer run if you can, error is comming in (error.localizedDescription)")
        }

    }
    /// OK im ready, hier the result is setting
    /// - Parameter predictions: An array of predictions.
    /// - Tag: imagePredictionHandler
    private func imagePredictionHandler(_ vorhersage: [Vorhersage]?) {
        guard let predictions = vorhersage else {
            self.prediction = "I dont no"
            return
        }
        
        let formattedPredictions = formatPredictions(predictions)
        
        let predictionString = formattedPredictions.joined(separator: "\n")
        self.prediction = predictionString
    }
    
    /// Converts a prediction's observations into human-readable strings.
    /// - Parameter observations: The classification observations from a Vision request.
    /// - Tag: formatPredictions
    private func formatPredictions(_ predictions: [Vorhersage]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.erkannt

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name): \(confidencePercentageString(prediction.wahrscheinlichkeit))"
        }

        return topPredictions
    }
    
    /// Erzeugt eine Aufbereitung für die visuelle Darstellung des fachlichen Ergebnis
    func confidencePercentageString (_ confidence : Float) -> String {
        let percentage = confidence * 100

        switch percentage {
            case 100.0...:
                return "100 %"
            case 1.0..<100.0:
                return String(format: "%2.1f %%", percentage)
            case 1.0..<10.0:
                return String(format: "%2.1f %%", percentage)
            case ..<1.0:
                return String(format: "%1.2f %%", percentage)
            default:
                return String(format: "%2.1f %%", percentage)
        }
    }

}
