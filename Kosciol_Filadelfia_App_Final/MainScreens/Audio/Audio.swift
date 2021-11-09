//
//  AudioTest.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 07/04/2021.
//

import SwiftUI
import MediaPlayer
import AVFoundation
import FirebaseStorage

struct Audio: View{
    @StateObject var storeManager: StoreManager
    @ObservedObject var albumData : albumData
    @ObservedObject var beataAlbumData : BeataAlbumData
    @ObservedObject var podcastData : PodcastData
    @EnvironmentObject var sliderData: CustomSliderData
    var body: some View{
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                NavigationLink(destination: PodcastWholeView(podcastData: podcastData, beata: beataAlbumData, album: albumData, podcast: podcastData), label: {
                    HStack{
                        Text("Podcasty Kościoła Filadelfia")
                            .font(.system(size: 25, weight: .bold))
                        Spacer()
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 25))
                            .padding(.trailing, 5)
                    }.foregroundColor(.black)
                }).padding(.leading, 20)
                .padding(.top, 35)
                PodcastView(podcastData: podcastData, beata: beataAlbumData, album: albumData, podcast: podcastData)
                Text("Zespół Filadelfia")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.leading, 20)
                AudioView(podcast: podcastData, beata: beataAlbumData, albumData: albumData, albumD: albumData)
                Text("Beata Mazurek")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.leading, 20)
                BeataAudioView(storeManager: storeManager, podcast: podcastData, albumData: beataAlbumData, album: albumData)
            }
        }
        .navigationBarHidden(true)
        .accentColor(.black)
    }
}

struct AudioView : View {
    @StateObject var podcast : PodcastData
    @StateObject var beata: BeataAlbumData
    @ObservedObject var albumData : albumData
    @StateObject var albumD : albumData
    @State private var currentAlbum : Album?
    @State private var currentSong : Song?
    @State var album: Album?
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 20){
                ForEach(albumData.album, id:\.self){ data in
                    NavigationLink(
                        destination: AlbumView(albumData: albumData, currentAlbum: data, albumdata: albumData, beata: beata, podcast: podcast)){
                            VStack(alignment: .leading){
                                Image(data.albumImage)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(30)
                                    .shadow(color: Color.black.opacity(0.6), radius: 15)
                                    .frame(width: screenW/2.5, height: screenW/2.5)
                                Text(data.albumName)
                                    .font(.system(size: 15, weight: .bold))
                                    .padding(5)
                                Text(data.artistName)
                                    .font(.system(size: 14, weight: .thin))
                                    .padding(.horizontal, 5)
                            }
                            .frame(width: screenW/2.5, height: screenW/2.5 + 150)
                            .padding(.horizontal)
                        }
                }
            }
        }
    }
}

struct AlbumView : View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var albumData : albumData
    @State var currentAlbum : Album
    @State var isPresented = false
    
    @StateObject var albumdata : albumData
    @StateObject var beata : BeataAlbumData
    @StateObject var podcast : PodcastData
    
    @State var song: Song?
    @State var isOpened: Bool?
    @State var album: Album?
    
    
    var body: some View{
        VStack{
            HStack{
                Image(currentAlbum.albumImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.6), radius: 15)
                    .frame(width: screenW/2.4, height: screenW/2.4)
                Spacer(minLength: 0)
                VStack(alignment: .leading, spacing: 5){
                    HStack{
                        Text("Album")
                            .font(.system(size: 15, weight: .thin))
                        Circle()
                            .frame(width: 5, height: 5)
                        Text(currentAlbum.numberOfSongs)
                            .font(.system(size: 15, weight: .thin))
                        Circle()
                            .frame(width: 5, height: 5)
                        Text(currentAlbum.date)
                            .font(.system(size: 15, weight: .thin))
                    }.foregroundColor(Color.black.opacity(0.5))
                    Text(currentAlbum.albumName)
                        .font(.title)
                        .foregroundColor(.black)
                    Text(currentAlbum.artistName)
                        .foregroundColor(Color.black.opacity(0.5))
                        .font(.system(size: 19, weight: .thin))
                }.frame(width: screenW/2.3)
            }.frame(width: screenW - 30)
            .padding(.top, 150)
            .padding(.horizontal)
//            HStack(spacing: 18){
//                Button(action: {
//
//                }, label: {
//                    ZStack{
//                        Color.black
//                        VStack{
//                            Image(systemName: "play.circle")
//                            Text("Odtwarzaj")
//                        }.font(.system(size: 18))
//                        .foregroundColor(.white)
//                    }.frame(width: screenW/2.3, height: 50, alignment: .center)
//                    .cornerRadius(10)
//                    .shadow(radius: 15)
//                }).padding(.leading)
//                Button(action: {
//
//                }, label: {
//                    ZStack{
//                        Color.black.opacity(0.05)
//                        VStack{
//                            Image(systemName: "shuffle")
//                            Text("Lososwo")
//                        }.font(.system(size: 18))
//                        .foregroundColor(.black)
//                    }.frame(width: screenW/2.3, height: 50, alignment: .center)
//                    .cornerRadius(10)
//                    .shadow(radius: 15)
//                }).padding(.trailing)
//            }.frame(width: screenW - 30)
//            .padding(.horizontal)
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(alignment: .leading){
                    ForEach(currentAlbum.song, id:\.self) { data in
                        Button {
                            withAnimation {
                                albumdata.currentAlbum = currentAlbum
                                if !albumdata.showBottomBar {
                                    if beata.showBottomBar {
                                        beata.showBottomBar = false
                                        beata.player.pause()
                                        beata.isPlaying = false
                                        albumdata.showBottomBar = true
                                    }
                                    if podcast.showBottomBar {
                                        podcast.showBottomBar = false
                                        podcast.player.pause()
                                        podcast.isPlaying = false
                                        albumdata.showBottomBar = true
                                    }
                                    
                                    albumdata.showBottomBar = true
                                }
                                albumdata.showFullScreen = true
                                albumdata.currentSong = data
                                albumdata.player.pause()
                                let storage = Storage.storage().reference(forURL: self.albumdata.currentSong!.file)
                                storage.downloadURL { (url, error) in
                                    if error != nil {
                                        print(error!)
                                    }else{
                                        do{
                                            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                                            try AVAudioSession.sharedInstance().setActive(true)
                                        }catch{
                                            
                                        }
                                        albumdata.player = AVPlayer(url: url!)
                                        albumdata.player.play()
                                        
                                    }
                                }
                                albumdata.isPlaying = true
                            }
                        } label: {
                            HStack{
                                Text(data.number)
                                    .foregroundColor(Color.black.opacity(0.9))
                                    .font(.system(size: 20))
                                    .padding(.horizontal)
                                VStack(alignment: .leading){
                                    Text(data.songName)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 20))
                                    Text(currentAlbum.artistName)
                                        .foregroundColor(Color.black.opacity(0.5))
                                        .font(.system(size: 18))
                                }
                                Spacer()
                            }.padding()
                        }
                    }
                }.padding(.top)
            }
        }
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 28))
        }))
    }
}

struct AudioMiniPlayer : View {
    var animation: Namespace.ID
    
    var height = UIScreen.main.bounds.height / 3
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var offset : CGFloat = 0
    
    @EnvironmentObject var album: albumData
    
    var body: some View {
        if album.showBottomBar{
            VStack{
                if album.showFullScreen{
                    HStack{
                        Button {
                            withAnimation {
                                album.showFullScreen = false
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 25, weight: .semibold))
                                .foregroundColor(.black)
                                .padding()
                        }

                        Spacer()
                    }
                        .zIndex(10)
                }
                
                HStack(spacing: 15){
                    if album.showFullScreen{Spacer(minLength: 0)}
                    
                    Image(album.currentAlbum!.albumImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: album.showFullScreen ? height : 55, height: album.showFullScreen ? height : 55)
                        .cornerRadius(15)
                    
                    if !album.showFullScreen{
                        
                        VStack(alignment: .leading){

                            Text(album.currentSong?.songName ?? "error")
                                .font(.system(size: 15, weight: .semibold))
                                .matchedGeometryEffect(id: "Label", in: animation)
                                .padding(.vertical, 2)
                            
                            Text(album.currentAlbum?.artistName ?? "error")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.primary)
                                .matchedGeometryEffect(id: "artist", in: animation)
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    if !album.showFullScreen{
                        
                        HStack{
                            Button(action: {
                                withAnimation {
                                    playPause()
                                }
                            }, label: {
                                
                                Image(systemName: album.isPlaying ? "pause.fill"  : "play.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding(5)
                            })
                            
                            Button(action: {
                                withAnimation {
                                    album.showBottomBar = false
                                    album.player.pause()
                                }
                            }, label: {
                                
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding(5)
                            })
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 15){
                        
                    if album.showFullScreen{
                        
                        Text(album.currentSong?.songName ?? "error")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .matchedGeometryEffect(id: "Label", in: animation)
                            .padding()
                            
                        
                        Text(album.currentAlbum?.artistName ?? "error")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                            .matchedGeometryEffect(id: "artist", in: animation)
                        
            
                    }
                    
                    if album.showFullScreen{
                        
                        HStack(spacing: 20){
                            Button(action: {
                                previous()
                            }, label: {
                                
                                Image(systemName: "backward.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                                    .padding(5)
                            })
                            Button(action: {
                                withAnimation {
                                    playPause()
                                }
                            }, label: {
                                
                                Image(systemName: album.isPlaying ? "pause.fill"  : "play.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                                    .padding(5)
                            })
                            
                            Button(action: {
                                next()
                            }, label: {
                                
                                Image(systemName: "forward.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                                    .padding(5)
                            })
                        }.padding(.top, screenW/3)
                    }
                    Spacer(minLength: 0)
                    
                }
                .padding(.top,20)
                .frame(height: album.showFullScreen ? nil : 0)
                .opacity(album.showFullScreen ? 1 : 0)
                
            }.onAppear(perform: {
                if album.showBottomBar{
                    playSong()
                }
            })
            .frame(maxHeight: album.showFullScreen ? .infinity : screenW/5.5)
            .background(
            
                VStack(spacing: 0){
                    Color.white.opacity(album.showFullScreen ? 1 : 0.97)
                }
                .onTapGesture(perform: {
                    
                    withAnimation(.spring()){album.showFullScreen = true}
                })
            )
            .cornerRadius(album.showFullScreen ? 20 : 0)
            .offset(y: album.showFullScreen ? 0 : -screenW/6)
            .offset(y: offset)
            .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
            .ignoresSafeArea()
        }
    }
    
    func onchanged(value: DragGesture.Value){
        if value.translation.height > 0 && album.showFullScreen {
            
            offset = value.translation.height
        }
    }
    
    func onended(value: DragGesture.Value){
        
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)){
            if value.translation.height > height{
                
                album.showFullScreen = false
            }
            offset = 0
        }
    }
    func playSong(){
        let storage = Storage.storage().reference(forURL: self.album.currentSong!.file)
        storage.downloadURL { (url, error) in
            if error != nil {
                print(error!)
            }else{
                let item = AVPlayerItem(url: url!)
                do{
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
                }catch{
                    
                }
                album.player = AVPlayer(playerItem: item)
                album.player.play()
                album.isPlaying = true
            }
        }
    }
    func playPause(){
        album.isPlaying.toggle()
        if album.isPlaying == false{
            album.player.pause()
        }else{
            album.player.play()
        }
    }
    func next(){
        if let currentIndex = album.currentAlbum!.song.firstIndex(of: album.currentSong!){
            if currentIndex == album.currentAlbum!.song.count - 1 {
                
            }else{
                album.player.pause()
                album.currentSong! = album.currentAlbum!.song[currentIndex + 1]
                self.playSong()
                album.isPlaying.toggle()
            }
        }
        
    }
    func previous(){
        if let currentIndex = album.currentAlbum!.song.firstIndex(of: album.currentSong!) {
            if currentIndex == 0{
                
            }else{
                album.player.pause()
                album.currentSong! = album.currentAlbum!.song[currentIndex - 1]
                self.playSong()
                album.isPlaying.toggle()
            }
        }
    }
}
