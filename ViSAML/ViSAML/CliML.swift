
/// Diese CLI Anwendung erstellt ein Model in einfacher Art aus den abgelegten Daten ohne erst ein Start der UI von CreateML zu benötigen.
import Foundation
import CreateML

@main
struct CliML {
    static func main () {
        print (CommandLine.arguments[0])
        
        let train = URL (fileURLWithPath: "./train")
        let test = URL (fileURLWithPath: "./test")
        let result = URL (fileURLWithPath: "../ViSuM/ViSuM/LogoClassifier.mlmodel")
        
        do {
            print ("Trainiere Model")
            let model = try MLImageClassifier(trainingData: .labeledDirectories(at: train))
            print ("Teste Model")
            let _ = model.evaluation(on: .labeledDirectories(at: test))
            print ("Schreibe Model")
            try model.write(to: result)
        }
        catch {
            exit(1)
        }
        
    }
}
