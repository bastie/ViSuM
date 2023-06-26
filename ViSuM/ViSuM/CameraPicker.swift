import UIKit
import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {

    @Binding var showCameraView : Bool
    @Binding var image : UIImage?
    @Binding var cameraChangePhoto : Bool
    
    typealias UIViewControllerType = UIImagePickerController
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> CameraPicker.Coordinator {
        return Coordinator(self)
    }
}

extension CameraPicker {
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showCameraView = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.parent.image = uiimage
                self.parent.cameraChangePhoto = true
            }
            self.parent.showCameraView = false
        }
    }
}


