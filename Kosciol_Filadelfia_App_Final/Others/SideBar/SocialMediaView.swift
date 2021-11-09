//
//  SocialMediaView.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 12/04/2021.
//

import SwiftUI

struct SocialMediaView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    
    let images = ["ig", "fb", "yt", "logo1", "dalej", "dalej"]
    let textes = ["Odwiedź nas na Instagramie", "Odwiedź nas na Facebooku", "Oglądaj nas na YouTubie", "Sprawdź naszą stronę internetową", "Odzwiedź Instagram Dalej", "Odwiedź Dalej na Facebooku"]
    let url = ["https://www.instagram.com/kosciolfiladelfia/", "https://www.facebook.com/KosciolFiladelfia", "https://www.youtube.com/channel/UCQeoxroRb7JQIx4U2KTWcfg", "https://filadelfia.org.pl", "https://www.instagram.com/dalej.filadelfia/", "https://www.facebook.com/dalej.filadelfia"]
    
    var body: some View {
        VStack{
            Text("Możesz odwiedzić nas na różnych platformach")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(MainColor)
                .padding(.top, 120)
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(alignment: .leading){
                    ForEach(0...2, id:\.self){ index in
                        Button(action: {
                            openURL(URL(string: url[index])!)
                        }, label: {
                            HStack(spacing: 20){
                                Image(images[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 60)
                                Text("\(textes[index])")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }.padding()
                            .padding(.horizontal, 30)
                        })
                    }
                    ForEach(3...5, id:\.self){ index in
                        Button(action: {
                            openURL(URL(string: url[index])!)
                        }, label: {
                            HStack(spacing: 20){
                                Image(images[index])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 90)
                                Text("\(textes[index])")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }.padding()
                            .padding(.horizontal, 20)
                        })
                    }
                }
            }
            Spacer()
        }.edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 28))
        }))
    }
}
