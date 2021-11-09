//
//  Strona_glowna.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 26/03/2021.
//

import SwiftUI

struct Strona_glowna: View {
    @ObservedObject var rejestracjaData : RejestracjaData
    @Environment(\.openURL) var openURL
    @ObservedObject var data : NewsData
    
    @State var showKonfaView = false
    
    var body: some View {
        //NavigationView{
            ScrollView{
                LazyVStack(spacing: 50){
                    Image("mainLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenW)
                        .padding(.horizontal, 50)
                        .padding(.top, 40)
                    
                    PageView()
                    NavigationLink(
                        destination: Rejestracja(rejestracjaData: rejestracjaData),
                        label: {
                            Image("RejestracjaOnline")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .frame(width: screenW - 50)
                                .shadow(radius:25)
                                .padding(.horizontal, 50)
                        })
                    NavigationLink(
                        destination: JestemNowy(),
                        label: {
                            Image("JestemTutajNowy")
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .frame(width: screenW - 50)
                                .shadow(radius:25)
                                .padding(.horizontal, 50)
                        })
                    HStack(spacing: 60){
                        Spacer()
                        Button(action: {openIg()}, label: {
                            Image("ig")
                                .resizable()
                                .frame(width: screenW/8.5, height: screenW/8.5)
                        })
                        Button(action: {openYt()}, label: {
                            Image("yt")
                                .resizable()
                                .frame(width: screenW/8.5, height: screenW/8.5)
                        })
                        Button(action: {openFb()}, label: {
                            Image("fb")
                                .resizable()
                                .frame(width: screenW/8.5, height: screenW/8.5)
                        })
                        Spacer()
                    }.padding(.top, 30)
                    Spacer()
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
            .zIndex(1)
        }
    func openIg(){
        guard let url = URL(string: "https://www.instagram.com/kosciolfiladelfia/")else {
            return
        }
        openURL(url)
    }
    func openFb(){
        guard let url = URL(string: "https://www.facebook.com/KosciolFiladelfia")else {
            return
        }
        openURL(url)
    }
    func openYt(){
        guard let url = URL(string: "https://www.youtube.com/channel/UCQeoxroRb7JQIx4U2KTWcfg")else {
            return
        }
        openURL(url)
    }
}

struct PageView : View {
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var currentIndex = 1
    @State private var numberOfIndex = 6
    var body: some View{
        TabView(selection: $currentIndex){
            ForEach(1..<numberOfIndex+1, id:\.self, content: { index in
                Image("\(index)")
                    .resizable()
                    .frame(width: screenW - 50, height: screenW/2)
                    .scaledToFit()
                    .cornerRadius(20)
            }).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }.frame(width: screenW, height: screenW/2)
        .tabViewStyle(PageTabViewStyle())
        .onReceive(self.timer) { _ in
            withAnimation(){
                currentIndex = currentIndex < numberOfIndex+1 ? currentIndex + 1 : 0
            }
        }
    }
}



struct Strona_glowna_Previews: PreviewProvider {
    static var previews: some View {
        Strona_glowna(rejestracjaData: RejestracjaData(), data: NewsData())
    }
}
