
import SwiftUI
import PhotosUI

struct BusinessView : View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showCameraView = false
    @State private var workingImage : UIImage?
    @State private var cameraChangePhoto = false
    @State private var prediction : String = ""
    
    var body: some View {

        if showCameraView {
            CameraPicker(showCameraView: $showCameraView, image: $workingImage, cameraChangePhoto: $cameraChangePhoto)
        }
        else {
            if let workingImage {
                Image (uiImage:
                        workingImage).resizable().scaledToFit().overlay(Text(prediction).foregroundColor(Color.white).background(Color.black).opacity(0.8)
                            .cornerRadius(10.0)
                            .padding(6), alignment: .bottomTrailing).onChange(of: workingImage) { value in
                    // funktioniert mit Fotolibrary nicht mit Camera
                    let model = BusinessModel(prediction: $prediction)
                    model.onPhotoChanged(image: workingImage)
                }
            }
            else {
                Image ("Logo").resizable().scaledToFit()
            }
        }
        
        // Control buttons
        VStack {
            Spacer().frame(height:3)
            Divider()
            HStack {
                if noMAC { // wenn die Anwendung auf einem mobilen Gerät läuft ...
                    Spacer().frame(height: 0) // ...sollten die Schaltflächen für Rechtshändler auch rechts sein
                    // Das reicht schon um eine Schaltfläche einzublenden um Fotos auszuwählen
                    PhotosPicker(selection: $selectedItem,
                                         matching: .images,
                                 photoLibrary: .shared())
                    {
                        Image(systemName: "photo.on.rectangle.angled")
                            .imageScale(.large)
                            .foregroundColor(.black)

                    }
                    .onChange(of: cameraChangePhoto) {
                        _ in
                        if (!showCameraView && cameraChangePhoto) {
                            Task {
                                cameraChangePhoto = false

                                let model = BusinessModel(prediction: $prediction)
                                if let workingImage {
                                    model.onPhotoChanged(image: workingImage)
                                }
                                
                            }
                        }
                    }
                    .onChange(of: selectedItem) { _ in
                                Task {
                                    if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            workingImage =  uiImage
                                            let model = BusinessModel(prediction: $prediction)
                                            if let workingImage {
                                                model.onPhotoChanged(image: workingImage)
                                            }
                                            return
                                        }
                                    }
                                    #if DEBUG
                                    print("FEHLER")
                                    #endif
                                }
                            }
                    
                    
                    
                    Spacer().frame(width:50, height: 0) // ...aber nicht direkt nebeneinander
                    // Um die Kamera zu aktivieren nutzen wir die CameraView
                    Button (action: {
                        self.showCameraView = true
                    }){
                        Image(systemName: "camera.badge.ellipsis")
                            .imageScale(.large)
                            .foregroundColor(.black)
                    }
                    Spacer().frame(width:90, height: 0) // ...und auch nicht zu weit rechts
                } // MAC
                else {
                    // Das reicht schon um eine Schaltfläche einzublenden um Fotos auszuwählen
                    PhotosPicker("Fotobibliothek", selection: $selectedItem,
                                         matching: .images,
                                         photoLibrary: .shared()).padding().buttonStyle(.bordered).buttonBorderShape(.roundedRectangle(radius: 3))
                        .onChange(of: cameraChangePhoto) {
                            _ in
                            if (!showCameraView && cameraChangePhoto) {
                                Task {
                                    cameraChangePhoto = false
                                    let model = BusinessModel(prediction: $prediction)
                                    if let workingImage {
                                        model.onPhotoChanged(image: workingImage)
                                    }
                                }
                            }
                        }
                        .onChange(of: selectedItem) { _ in
                                    Task {
                                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                            if let uiImage = UIImage(data: data) {
                                                workingImage = uiImage
                                                let model = BusinessModel(prediction: $prediction)
                                                if let workingImage {
                                                    model.onPhotoChanged(image: workingImage)
                                                }
                                                return
                                            }
                                        }

                                        #if DEBUG
                                        print("FEHLER")
                                        #endif
                                    }
                                }
                    // stellt sicher, dass die überlagernde Anzeige der Wahrscheinlichkeit auch tatsächlich geupdatet wird.
                        .onChange(of: prediction) { _ in
                                let model = BusinessModel(prediction: $prediction)
                                if let workingImage {
                                    model.onPhotoChanged(image: workingImage)
                                }
                        }

                    // Um die Kamera zu aktivieren nutzen wir die CameraView
                    Button ("Fotokamera", action: {
                        self.showCameraView = true
                    }).padding().buttonStyle(.bordered).buttonBorderShape(.roundedRectangle(radius: 3))
                }
            }
        }

    }
    
}

#if DEBUG
struct BusinessView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessView()
    }
}

#endif
