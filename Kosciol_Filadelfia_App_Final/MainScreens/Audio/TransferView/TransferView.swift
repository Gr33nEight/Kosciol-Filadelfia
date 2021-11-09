//
//  TransferView.swift
//  TransferView
//
//  Created by Natanael  on 22/10/2021.
//

import SwiftUI

struct TransferView : View {
    @EnvironmentObject var model: BeataAlbumData
    @StateObject var storeManager: StoreManager
    
    @Binding var isShown : Bool
    var body: some View {
        ZStack{
            VStack{
                Image("imgbeata")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenW, height: screenW)
                Spacer()
            }
            VStack{
                Spacer()
                ZStack{
                    Color.white
                        .cornerRadius(50)
                    VStack{
                        ScrollView{
                            VStack(spacing: 20){
                                Text("Beata Mazurek - Spotkanie Serc")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color(UIColor.brown))
                                Text("\"Tysiąc słów\" \n\n to pierwszy z utworów znajdujący się na solowej płycie Beaty Mazurek \"Spotkanie serc\".\n\n Część piosenki powstała ponad 10 lat temu, gdy Beata zapytała swojego syna, co chciałby powiedzieć Panu Bogu. On na to: odpowiedział \"Kocham Cię Jezu\".\n\nRefren musiał poczekać kilka lat do czasu, gdy Beata to samo pytanie zadała córce: \"Jezusowi?\"- zapytała Tusia-\"chciałabym powiedzieć tysiąc słów\". I wtedy zaskoczyło. \nWszystko ostatecznie zamknięte zostało w Miłości.")
                                    .padding(.horizontal)
                                HStack{
                                    VStack(alignment:.leading){
                                        Text(" Utwory:")
                                            .bold()
                                        Text("\nTysiąc słów\nJeden dzień\nMój Dom\nChcę Pamiętać")
                                    }
                                    Spacer()
                                    VStack(alignment:.trailing){
                                        Text("\n\nKomnata\nNieskończony\nZnowu Wracam\nTy jesteś wszystkim")
                                    }
                                }.padding(.horizontal)
                                
                                HStack{
                                    Text("Cena: ")
                                        .font(.title3)
                                        .bold()
                                    Text("32.99 zł")
                                        .underline(color: Color(UIColor.brown))
                                        .font(.title2)
                                        .bold()
                                }
                                .padding(.top)
                                .padding()
                                Text("*Przy odinstalowaniu aplikacji i następnej jej instalacji, wystarczy kliknąć przycisk poniżej z napisem \"Przywróć\", aby przywrócić wcześniej dokonany zakup.")
                                    .foregroundColor(Color.black.opacity(0.5))
                                    .font(.system(size: 10))
                                    .padding(.horizontal)
                                Button {
                                    storeManager.restoreProducts()
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(UIColor.brown))
                                            .frame(width: screenW/1.2, height: 50)
                                        Text("Przywróć")
                                            .bold()
                                            .foregroundColor(.white)

                                    }.padding(.top)
                                }
                                
                            }.padding()
                        }
                        Spacer()
                        Button {
                            print("działa")
                            storeManager.purchaseProduct(product: storeManager.myProducts.first!)
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(UIColor.brown))
                                    .frame(width: screenW/1.2, height: 50)
                                Text("Kup")
                                    .bold()
                                    .foregroundColor(.white)

                            }.padding(.top)
                        }
                    }.padding(.top)
                    
                }.frame(width: screenW, height: screenW + 110)
            }
        }.overlay(
            Button(action: {
                isShown.toggle()
            }, label: {
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(40)
                    .background(
                        BlurView(style: .light)
                            .clipShape(Circle())
                            .frame(width: 45, height: 45)
                    )
            })
            , alignment: .topLeading
        )
            .edgesIgnoringSafeArea(.top)
    }
}

