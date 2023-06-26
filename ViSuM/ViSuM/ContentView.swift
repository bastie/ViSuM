//
//  ContentView.swift
//  ViSuM
//
//  Created by Sebastian Ritter on 22.06.23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    let HIGHTLIGHT_COLOR = Color(red: 0.7,green: 0.1, blue: 0.1)
    
    var body: some View {
        VStack {
            // HEADER
            VStack {
                HStack {
                    Image ("Logo.svg").imageScale(.large).foregroundColor(.accentColor)
                        .frame(width: 25.0, height: 25.0, alignment: .topLeading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    (Text("Vi").bold().foregroundColor(HIGHTLIGHT_COLOR) + Text("suelle ")+Text("Su").bold().foregroundColor(HIGHTLIGHT_COLOR)+Text("che nach ")+Text("M").bold().foregroundColor(HIGHTLIGHT_COLOR)+Text("arkenkennzeichen"))
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: 40,
                            alignment: .leadingLastTextBaseline
                        )
                }
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: 45,//.infinity,
                alignment: .topLeading
            )
            HStack {
                Divider().frame(width: 10000, height: 3, alignment: .leading).overlay(HIGHTLIGHT_COLOR)
                Spacer().frame(height:12)

            }
            // End of Header
            
            BusinessView()
            
            // Footer
            VStack {
                Spacer().frame(height:3)
                Divider().frame(width: 10000, height: 3, alignment: .leading).overlay(HIGHTLIGHT_COLOR)
                HStack {
                    Spacer().frame(height: 0)
                    Text("ViSuM").foregroundColor(HIGHTLIGHT_COLOR).frame(alignment: .topTrailing)
                }
            }
        }
        .padding()
        // next lines only for run iPad App on macOS, because #if macOS can not work
        
        .foregroundColor(Color.black)
        .background(Color(UIColor.white)
                            .ignoresSafeArea())
    }
    

}

let noMAC = Bundle.main.resourceURL!.absoluteString.contains("container") || Bundle.main.resourceURL!.absoluteString.contains("CoreSimulator") ||
    Bundle.main.resourceURL!.absoluteString.contains("Simulator Devices")

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



