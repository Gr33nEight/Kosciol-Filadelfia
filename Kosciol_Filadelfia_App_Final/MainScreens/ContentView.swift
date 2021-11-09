//
//  ContentView.swift
//  Practise1
//
//  Created by Natanael  on 09/03/2021.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("alert2.1.5") var alertShown: Bool = true
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isShowing = false
    
    @ObservedObject var newsdata : NewsData
    @ObservedObject var mowcaData : mowcaData
    @ObservedObject var albumData : albumData
    @ObservedObject var beataAlbumData : BeataAlbumData
    @ObservedObject var podcastData : PodcastData
    @ObservedObject var ostatnieVideoData : OstatnieVideoData
    @ObservedObject var seriaData : SeriaData
    @ObservedObject var rejestracjaData : RejestracjaData
    @StateObject var storeManager: StoreManager
    
    @StateObject var sliderData = CustomSliderData()
    
    @State var isDraging = false
    
    @State var offset = CGSize.zero
    
    @State var current = 2
    @State var expand = false
    @Namespace var animation
    
    var body: some View {
        
        ZStack {
            if(alertShown){
                KonfaAlertPhysic()
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(2)
            }
            NavigationView {
                
                ZStack {
                    if isShowing{
                        SideBar(isShowing: $isShowing)
                    }
                    MainPage(albumData: albumData, newsdata: newsdata, mowcaData: mowcaData, beataAlbumData: beataAlbumData, podcastData: podcastData, ostatnieVideoData: ostatnieVideoData, seriaData: seriaData, rejestracjaData: rejestracjaData, storeManager: storeManager)
                        .disabled(isShowing ? true : false)
                        .onTapGesture {
                            if isShowing{
                                withAnimation(.spring()){
                                    isShowing.toggle()
                                }
                            }
                        }
                        .cornerRadius(isShowing ? 20 : 10)
                        .offset(x: isShowing ? 220 : 0, y: isShowing ? 44 : 0)
                        //.offset(x: offset.width, y: 0)
                        .scaleEffect(isShowing ? 0.85 : 1)
            
                        .navigationBarItems(leading: Button(action: {
                            withAnimation(.spring()){
                                isShowing.toggle()
                            }
                        }, label: {
                            Image(systemName: "list.dash")
                                .font(.system(size: 25))
                                .foregroundColor(MainColor)
                    }))
                        .navigationTitle("Strona główna")
                        .navigationBarTitleDisplayMode(.inline)
                }.edgesIgnoringSafeArea(.bottom)
           }
        }.overlay (
            VStack{
                Spacer()
                Group{
                    AudioMiniPlayer(animation: animation)
                    BeataMiniplayer(animation: animation)
                    PodcastMiniPlayer(animation: animation)
                }
            }.edgesIgnoringSafeArea(.bottom)
        )
    }
}

