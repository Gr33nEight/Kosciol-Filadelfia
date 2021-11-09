//
//  Timer.swift
//  Kosciol_Filadelfia_App_Final
//
//  Created by Natanael  on 11/05/2021.
//

import SwiftUI

struct KonferencjaAlertView: View {
    @AppStorage("alert2.1.5") var alertShown: Bool = true
    var body: some View {
        ZStack{
            VStack{
                ZStack{
                    Text("Co nowego?")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                }.frame(width: screenW - 100, height: screenW/5)
                .background(MainColor)
                VStack(alignment: .leading, spacing:25){
                    Text("-Już teraz możesz kupić dostęp do najnowszej płyty Beaty Mazurek, Spotkanie Serc\n\n-Zupełnie odnowiony odtwarzacz audio\n\n-Drobne poprawki")
                        .underline(color: MainColor)

                }.foregroundColor(.black)
                .font(.system(size: 20, weight: .light))
                .padding()
                .padding(.top, 15)
                Spacer(minLength: 0)
                Button(action: {
                    withAnimation(){
                        alertShown = false
                    }
                }, label: {
                    Text("Super")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(MainColor)
                }).frame(width: screenW - 100, height: screenW/5)
                .background(Color.black.opacity(0.1))
            }
        }.frame(width: screenW - 100, height: screenH/1.8)
        .background(Color.white)
        .cornerRadius(15)
    }
}

struct KonfaAlertPhysic : View {
    
    var body: some View{
        VStack{
            KonferencjaAlertView()
        }.frame(width: screenW, height: screenH)
        .background(BlurView(style: .light))
        .edgesIgnoringSafeArea(.all)
    }
}
