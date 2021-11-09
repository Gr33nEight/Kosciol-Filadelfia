//
//  PodcastAudio.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 10/04/2021.
//

import SwiftUI
import AVKit
import FirebaseStorage

struct PodcastView : View {
    @ObservedObject var podcastData : PodcastData
    
    @StateObject var beata : BeataAlbumData
    @StateObject var album : albumData
    @StateObject var podcast : PodcastData
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 20){
                ForEach(podcastData.podcast, id:\.self){ data in
                    Button {
                        withAnimation {
                            if !podcast.showBottomBar {
                                if album.showBottomBar {
                                    album.showBottomBar = false
                                    album.player.pause()
                                    album.isPlaying = false
                                    podcast.showBottomBar = true
                                }
                                if beata.showBottomBar {
                                    beata.showBottomBar = false
                                    beata.player.pause()
                                    beata.isPlaying = false
                                    podcast.showBottomBar = true
                                }
                                podcast.showBottomBar = true
                                
                            }
                            podcast.showFullScreen = true
                            podcast.currentPodcast = data
                            podcast.player.pause()
                            let storage = Storage.storage().reference(forURL: self.podcast.currentPodcast!.file)
                            storage.downloadURL { (url, error) in
                                if error != nil {
                                    print(error!)
                                }else{
                                    do{
                                        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                                        try AVAudioSession.sharedInstance().setActive(true)
                                    }catch{
                                        
                                    }
                                    podcast.player = AVPlayer(url: url!)
                                    podcast.player.play()
                                    
                                }
                            }
                            podcast.isPlaying = true
                            
                        }
                    } label: {
                        VStack(alignment: .leading){
                            AsyncImage(url: URL(string: data.image) ?? URL(string: "https://i.pinimg.com/originals/13/9a/19/139a190b930b8efdecfdd5445cae7754.png")!, placeholder: {ProgressView()})
                                .scaledToFit()
                                .cornerRadius(30)
                                .shadow(color: Color.black.opacity(0.5), radius: 10)
                                .frame(width: screenW/2.5, height: screenW/2.5)
                            Text(data.name)
                                .lineLimit(2)
                                .font(.system(size: 15, weight: .bold))
                                .padding(5)
                            Text(data.artistName)
                                .font(.system(size: 14, weight: .thin))
                                .padding(.horizontal, 5)
                        }.frame(width: screenW/2.5, height: screenW/2.5 + 150)
                        .padding(.horizontal)
                    }

                }
            }
        }
    }
}

struct PodcastWholeView : View {
    @ObservedObject var podcastData : PodcastData
    @Environment(\.presentationMode) var presentationMode
    @State var isPresented = false
    
    @StateObject var beata : BeataAlbumData
    @StateObject var album : albumData
    @StateObject var podcast : PodcastData
    
    var body: some View{
        VStack{
            HStack{
                AsyncImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/kosciolfiladelfiasimple.appspot.com/o/Audio%2FPodcast%2FImages%2Fpodcast%20spotify.png?alt=media&token=c9a38e2c-cbd6-48a3-a1b7-54e01cc491e6")!, placeholder: {ProgressView()})
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.6), radius: 15)
                    .frame(width: screenW/2.4, height: screenW/2.4)
                    .font(.system(size: 22))
                Spacer(minLength: 1)
                VStack(alignment: .leading){
                    Text("Podcasty Kościoła Filadelfia")
                        .font(.title)
                        .foregroundColor(.black)
                }.frame(width: screenW/2.3)
            }.frame(width: screenW - 30)
            .padding(.top, 150)
            .padding(.horizontal)
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(alignment: .leading){
                    ForEach(podcastData.podcast, id:\.self){ data in
                        Button {
                            withAnimation {
                                if !podcast.showBottomBar {
                                    if album.showBottomBar {
                                        album.showBottomBar = false
                                        album.player.pause()
                                        album.isPlaying = false
                                        podcast.showBottomBar = true
                                    }
                                    if beata.showBottomBar {
                                        beata.showBottomBar = false
                                        beata.player.pause()
                                        beata.isPlaying = false
                                        podcast.showBottomBar = true
                                    }
                                    podcast.showBottomBar = true
                                    
                                }
                                podcast.showFullScreen = true
                                podcast.currentPodcast = data
                                podcast.player.pause()
                                let storage = Storage.storage().reference(forURL: self.podcast.currentPodcast!.file)
                                storage.downloadURL { (url, error) in
                                    if error != nil {
                                        print(error!)
                                    }else{
                                        do{
                                            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                                            try AVAudioSession.sharedInstance().setActive(true)
                                        }catch{
                                            
                                        }
                                        podcast.player = AVPlayer(url: url!)
                                        podcast.player.play()
                                        
                                    }
                                }
                                podcast.isPlaying = true
                                
                            }
                        } label: {
                            HStack{
                                VStack(alignment: .leading){
                                    Text(data.name)
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 20))
                                    Text(data.artistName)
                                        .foregroundColor(Color.black.opacity(0.5))
                                        .font(.system(size: 18))
                                }.padding(.horizontal)
                                Spacer()
                            }.padding()
                        }
                    }
                }.padding(.top)
            }
        }.padding(.horizontal)
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

struct PodcastMiniPlayer : View {
    var animation: Namespace.ID
    
    var height = UIScreen.main.bounds.height / 3
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var offset : CGFloat = 0
    
    @EnvironmentObject var album: PodcastData
    
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
                    
                    AsyncImage(url: URL(string: album.currentPodcast?.image ?? "https://www.htmlcsscolor.com/preview/128x128/FFFFFF.png")!) {
                        ProgressView()
                    }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: album.showFullScreen ? height : 55, height: album.showFullScreen ? height : 55)
                        .cornerRadius(15)
                    
                    if !album.showFullScreen{
                        
                        VStack(alignment: .leading){

                            Text(album.currentPodcast?.name ?? "error")
                                .font(.system(size: 15, weight: .semibold))
                                .matchedGeometryEffect(id: "Label", in: animation)
                                .padding(.vertical, 2)
                            
                            Text(album.currentPodcast?.artistName ?? "error")
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
                        
                        Text(album.currentPodcast!.name)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .matchedGeometryEffect(id: "Label", in: animation)
                            .padding()
                            
                        
                        Text(album.currentPodcast!.artistName)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                            .matchedGeometryEffect(id: "artist", in: animation)
                        
            
                    }
                    
                    if album.showFullScreen{
                        
                        HStack(spacing: 20){
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
        let storage = Storage.storage().reference(forURL: self.album.currentPodcast!.file)
        storage.downloadURL { (url, error) in
            if error != nil {
                print(error!)
            }else{
                do{
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
                }catch{
                    
                }
                album.player = AVPlayer(url: url!)
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
}
