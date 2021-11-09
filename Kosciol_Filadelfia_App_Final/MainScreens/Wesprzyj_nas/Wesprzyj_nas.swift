//
//  Wesprzyj_nas.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 26/03/2021.
//

import SwiftUI
import MobileCoreServices


struct Wesprzyj_nas: View {
    
    @State private var showNumberAlert = false
    @State private var showNameAlert = false
    
    var body: some View {
        //NavigationView{
            VStack(spacing: 40){
                ScrollView{
                    Text("Przelew")
                        .font(.largeTitle)
                        .padding(.top, 70)
                    Divider()
                        .frame(width: screenW/2, height: 2)
                        .padding(.bottom, 30)
                    Text("Numer konta")
                        .font(.title2)
                    Divider()
                        .frame(width: screenW/3, height: 2)
                    Button(action: {
                        UIPasteboard.general.setValue("08 1020 1390 0000 6202 0212 1408",
                                    forPasteboardType: kUTTypePlainText as String)
                        self.showNumberAlert.toggle()
                        
                    }, label: {
                        Text("08 1020 1390 0000 6202 0212 1408")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                            .padding(.bottom, 30)
                    }).alert(isPresented: $showNumberAlert, content: {
                        Alert(title: Text("Numer konta został skopiowany"))
                    })
                    Text("Dane odbiorcy")
                        .font(.title2)
                    Divider()
                        .frame(width: screenW/3, height: 2)
                    Button(action: {
                        UIPasteboard.general.setValue("Kościół Zielonoświątkowy 44-300 Wodzisław Śląski Górna 8",
                                    forPasteboardType: kUTTypePlainText as String)
                        self.showNameAlert.toggle()
                    }, label: {
                        Text("Kościół Zielonoświątkowy 44-300 Wodzisław Śląski Górna 8")
                            .frame(width: screenW/2)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(5)
                            .background(Color.black.opacity(0.07))
                            .cornerRadius(10)
                    }).alert(isPresented: $showNameAlert, content: {
                        Alert(title: Text("Dane odbiorcy zostały skopiowane"))
                    })
                }
            }.frame(width: screenW - 70, height: screenH/1.5)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [MainColor, SecondColor]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(15)
            //.navigationTitle("Wesprzyj nas")
            .navigationBarHidden(true)
        //}
    }
}
