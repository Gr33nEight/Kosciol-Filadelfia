

import SwiftUI
import MediaPlayer
import AVFoundation
import FirebaseStorage

struct MainPage: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var exist = false
    @State var appear = false
    @Namespace var animation
    
    @State private var isShowing = false
    @State var seledtedIndex = 2
    
    let tabBarImageNames = ["video.fill", "music.note", "house.fill", "calendar", "creditcard.fill"]
    let tabBarTextNames = ["Wideo", "Audio", "Strona główna", "Aktualności", "Wesprzyj nas"]
    
    @ObservedObject var albumData : albumData
    @ObservedObject var newsdata : NewsData
    @ObservedObject var mowcaData : mowcaData
    @ObservedObject var beataAlbumData : BeataAlbumData
    @ObservedObject var podcastData : PodcastData
    @ObservedObject var ostatnieVideoData : OstatnieVideoData
    @ObservedObject var seriaData : SeriaData
    @ObservedObject var rejestracjaData : RejestracjaData
    @StateObject var storeManager: StoreManager
    @EnvironmentObject var sliderData: CustomSliderData
    
    
    @State private var isPlaying = true
    @State private var bigPlayer = false
    @State var song : Song?
    @State var songHolder: Song?
    @State var album: Album?
    @State var albumHolder: Album?
    @State var isOpened = false
    @State var currentIndex = 1
    @State var player = AVPlayer()
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                ZStack(alignment: .bottom){
                    switch seledtedIndex{
                    
                    case 0:
                        NavigationView{
                            ZStack{
                                Color.white.ignoresSafeArea()
                                Video(newsData: newsdata, mowcaData: mowcaData, ostatnieVideoData: ostatnieVideoData, seriaData: seriaData)
                            }
                            
                        }.ignoresSafeArea()
                        .navigationTitle("Wideo")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    case 1:
                        
                        NavigationView{
                            Audio(storeManager: storeManager, albumData: albumData, beataAlbumData: beataAlbumData, podcastData: podcastData)
                            
                        }
                        .navigationTitle("Audio")
                        .navigationBarTitleDisplayMode(.inline)
                    case 2:
                        NavigationView{
                            ZStack{
                                Color.white.ignoresSafeArea()
                                Strona_glowna(rejestracjaData: rejestracjaData, data: newsdata)
                            }
                        }
                        .navigationTitle("Strona główna")
                        .navigationBarTitleDisplayMode(.inline)
                    case 3:
                        NavigationView{
                            News(newsData: newsdata)
                        }
                        .navigationTitle("Aktualności")
                        .navigationBarTitleDisplayMode(.inline)
                    case 4:
                        NavigationView{
                            Wesprzyj_nas()
                        }
                        .navigationTitle("Wesprzyj nas")
                        .navigationBarTitleDisplayMode(.inline)
                    default:
                        NavigationView{
                            Strona_glowna(rejestracjaData: rejestracjaData, data: newsdata)
                                .navigationTitle("Strona główna")
                        }
                        .navigationTitle("Strona główna")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    }
                    
                } //top bar
                
                Spacer()
                
                VStack {
                    HStack{
                        ForEach(0..<5) { num in
                            Button(action: {
                                withAnimation{
                                    seledtedIndex = num
                                }
                            }, label: {
                                Spacer(minLength: 0)
                                Image(systemName: tabBarImageNames[num])
                                    .font(.system(size: 20))
                                    .foregroundColor(seledtedIndex == num ? MainColor : Color.black.opacity(0.5))
                                    .offset(y: seledtedIndex == num ? -10 : 0)
                                Spacer(minLength: 0)
                            })
                            
                        }
                        
                    }//.padding(.top, 1)
                    
                    HStack{
                        ForEach(0..<5) { num in
                            Button(action: {
                                withAnimation{
                                    seledtedIndex = num
                                }
                            }, label: {
                                Spacer(minLength: 0)
                                Text(tabBarTextNames[num])
                                    .font(.system(size: 9))
                                    .foregroundColor(seledtedIndex == num ? MainColor : Color.black.opacity(0.5))
                                    .offset(y: seledtedIndex == num ? -10 : 0)
                                Spacer(minLength: 0)
                            })
                            
                        }
                        
                    }.padding(.top, 1)
                }.padding(.horizontal, 10).padding(.bottom, 20).padding(.top, 6) //bottom bar
                
            }
        }
    }
}
