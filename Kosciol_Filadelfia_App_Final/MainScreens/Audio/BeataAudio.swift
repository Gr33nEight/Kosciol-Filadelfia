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


struct BeataAudioView : View {
    @StateObject var storeManager: StoreManager
    @StateObject var podcast : PodcastData
    @ObservedObject var albumData : BeataAlbumData
    @State private var currentAlbum : BeataAlbum?
    @State private var currentSong : BeataSong?
    @StateObject var album : albumData
    
    @EnvironmentObject var model : BeataAlbumData
    
    @EnvironmentObject var sliderData: CustomSliderData
    
    @State var showTrasnferView = false
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            if UserDefaults.standard.bool(forKey: storeManager.myProducts.first?.productIdentifier ?? "") == false{
                Button {
                    showTrasnferView.toggle()
                } label: {
                    VStack(alignment: .leading){
                        Image("imgbeata")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.6), radius: 15)
                            .frame(width: screenW/2.5, height: screenW/2.5)
                        Text("Spotkanie Serc")
                            .font(.system(size: 15, weight: .bold))
                            .padding(5)
                        Text("Beata Mazurek")
                            .font(.system(size: 14, weight: .thin))
                            .padding(.horizontal, 5)
                    }.frame(width: screenW/2.5, height: screenW/2.5 + 150)
                    .padding(.horizontal)
                }.sheet(isPresented: $showTrasnferView) {
                        
                } content: {
                    TransferView(storeManager: storeManager, isShown: $showTrasnferView)
                }

            }else{
                LazyHStack(spacing: 20){
                    ForEach(albumData.album, id:\.self){ data in
                        NavigationLink(
                            destination: BeataAlbumView(albumData: albumData, beata: albumData, album: album, podcast: podcast, currentAlbum: currentAlbum ?? data),
                            label: {
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
                                }.frame(width: screenW/2.5, height: screenW/2.5 + 150)
                                .padding(.horizontal)
                            })
                    }
                }
            }
                
        }
    }
}

struct BeataAlbumView : View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var albumData : BeataAlbumData
    @EnvironmentObject var sliderData: CustomSliderData
    @StateObject var beata : BeataAlbumData
    @StateObject var album : albumData
    @StateObject var podcast : PodcastData
    @State var currentAlbum : BeataAlbum
    @State var isPresented = false
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
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack(alignment: .leading){
                    ForEach(currentAlbum.song, id:\.self) { data in
                        Button {
                            
                            withAnimation {
                                if !beata.showBottomBar {
                                    if album.showBottomBar {
                                        album.showBottomBar = false
                                        album.player.pause()
                                        album.isPlaying = false
                                        beata.showBottomBar = true
                                    }
                                    if podcast.showBottomBar {
                                        podcast.showBottomBar = false
                                        podcast.player.pause()
                                        podcast.isPlaying = false
                                        beata.showBottomBar = true
                                    }
                                    beata.showBottomBar = true
                                    
                                }
                                beata.currentAlbum = currentAlbum
                                beata.showFullScreen = true
                                beata.currentSong = data
                                beata.player.pause()
                                let storage = Storage.storage().reference(forURL: self.beata.currentSong!.file)
                                storage.downloadURL { (url, error) in
                                    if error != nil {
                                        print(error!)
                                    }else{
                                        do{
                                            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                                            try AVAudioSession.sharedInstance().setActive(true)
                                        }catch{
                                            
                                        }
                                        beata.player = AVPlayer(url: url!)
                                        beata.player.play()
                                        let (minute, second) = secondsToHoursMinutesSeconds(seconds: Int(beata.player.currentItem?.asset.duration.seconds ?? 0.0))
                                        if second < 10 {
                                            sliderData.formattedAudioTime = "\(minute):0\(second)"
                                        }else{
                                            sliderData.formattedAudioTime = "\(minute):\(second)"
                                        }
                                        
                                    }
                                }
                                beata.isPlaying = true
                                
                                sliderData.currentTime = 0
                                sliderData.formattedAudioTime = "0:00"
                                sliderData.offset.width = 0
                                
                            }

                            } label: {
                                HStack{
                                    Text(data.number)
                                        .foregroundColor(Color.black.opacity(0.9))
                                        .font(.system(size: 20))
                                        .padding(.horizontal)
                                    VStack(alignment: .leading){
                                        Text(data.songName)
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 20))
                                        Text(currentAlbum.artistName)
                                            .foregroundColor(Color.black.opacity(0.5))
                                            .font(.system(size: 18))
                                    }
                                    Spacer()
                                    Text(data.time)
                                        .foregroundColor(Color.black.opacity(0.5))
                                        .font(.system(size: 18))
                                        .padding()
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
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
      return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

struct BeataMiniplayer: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var animation: Namespace.ID
    
    var height = UIScreen.main.bounds.height / 3
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var offsetPlayer : CGFloat = 0
    
    @EnvironmentObject var beata: BeataAlbumData
    @EnvironmentObject var sliderData: CustomSliderData
    
    var body: some View {
        if beata.showBottomBar{
            VStack{
                if beata.showFullScreen{
                    HStack{
                        Button {
                            withAnimation {
                                beata.showFullScreen = false
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
                    if beata.showFullScreen{Spacer(minLength: 0)}
                    
                    Image(beata.currentAlbum?.albumImage ?? "imgbeata")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: beata.showFullScreen ? height : 55, height: beata.showFullScreen ? height : 55)
                        .cornerRadius(15)
                    
                    if !beata.showFullScreen{
                        
                        VStack(alignment: .leading){

                            Text(beata.currentSong?.songName ?? "error")
                                .font(.system(size: 15, weight: .semibold))
                                .matchedGeometryEffect(id: "Label", in: animation)
                                .padding(.vertical, 2)
                            
                            Text("Beata Mazurek")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.primary)
                                .matchedGeometryEffect(id: "artist", in: animation)
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    if !beata.showFullScreen{
                        
                        
                        HStack{
                            Button(action: {
                                withAnimation {
                                    playPause()
                                }
                            }, label: {
                                
                                Image(systemName: beata.isPlaying ? "pause.fill"  : "play.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding(5)
                            })
                            
                            Button(action: {
                                withAnimation {
                                    beata.showBottomBar = false
                                    beata.player.pause()
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
                        
                    if beata.showFullScreen{
                        
                        Text(beata.currentSong!.songName)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .matchedGeometryEffect(id: "Label", in: animation)
                            .padding()
                            
                        
                        Text("Beata Mazurek")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                            .matchedGeometryEffect(id: "artist", in: animation)
                        
            
                    }
                    
                    if beata.showFullScreen{
                        
//                        CustomSlider(player: beata.player)
//                            .padding()
//                            .padding(.top, 30)

                        
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
                                
                                Image(systemName: beata.isPlaying ? "pause.fill"  : "play.fill")
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
                .frame(height: beata.showFullScreen ? nil : 0)
                .opacity(beata.showFullScreen ? 1 : 0)
                
            }.onReceive(timer){ _ in
                if beata.isPlaying {
                    if sliderData.currentTime <= beata.player.currentItem?.asset.duration.seconds ?? 0.0 {
                        sliderData.currentTime += 1
                        sliderData.offset.width += 1
                        let (m,s) = secondsToHoursMinutesSeconds(seconds: Int(sliderData.currentTime))
                        if s < 10 {
                            sliderData.formattedTime = "\(m):0\(s)"
                        }else{
                            sliderData.formattedTime = "\(m):\(s)"
                        }
                        
                        if sliderData.currentTime >= beata.player.currentItem?.asset.duration.seconds ?? 0.0 {
                            next()

                        }
                        
                    }
                }
            }
            
            .onAppear(perform: {
                if beata.showBottomBar{
                    playSong()
                }
                
            })
            .frame(maxHeight: beata.showFullScreen ? .infinity : screenW/5.5)
            .background(
            
                VStack(spacing: 0){
                    Color.white.opacity(beata.showFullScreen ? 1 : 0.97)
                }
                .onTapGesture(perform: {
                    
                    withAnimation(.spring()){beata.showFullScreen = true}
                })
            )
            .cornerRadius(beata.showFullScreen ? 20 : 0)
            .offset(y: beata.showFullScreen ? 0 : -screenW/6)
            .offset(y: offsetPlayer)
            .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
            .ignoresSafeArea()
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int) {
      return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func onchanged(value: DragGesture.Value){
        if value.translation.height > 0 && beata.showFullScreen {
            
            offsetPlayer = value.translation.height
        }
    }
    
    func onended(value: DragGesture.Value){
        
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)){
            if value.translation.height > height{
                
                beata.showFullScreen = false
            }
            offsetPlayer = 0
        }
    }
    func playSong(){
        let storage = Storage.storage().reference(forURL: self.beata.currentSong!.file)
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
                
                
                beata.player = AVPlayer(playerItem: item)
                let (minute, second) = secondsToHoursMinutesSeconds(seconds: Int(beata.player.currentItem?.asset.duration.seconds ?? 0.0))
                if second < 10 {
                    sliderData.formattedAudioTime = "\(minute):0\(second)"
                }else{
                    sliderData.formattedAudioTime = "\(minute):\(second)"
                }
                beata.player.play()
                beata.isPlaying = true
                
                
                //sliderData.length = ((sliderData.currentTime)/(beata.player.currentItem?.asset.duration.seconds ?? 0.0))*(size-25)
            }
        }
    }
    func playPause(){
        beata.isPlaying.toggle()
        if beata.isPlaying == false{
            beata.player.pause()
        }else{
            beata.player.play()
        }
    }
    func next(){
        if let currentIndex = beata.currentAlbum!.song.firstIndex(of: beata.currentSong!){
            if currentIndex == beata.currentAlbum!.song.count - 1 {
                
            }else{
                beata.player.pause()
                beata.currentSong! = beata.currentAlbum!.song[currentIndex + 1]
                self.playSong()
                beata.isPlaying.toggle()
                sliderData.currentTime = 0
                sliderData.offset.width = 0
            }
        }
        
    }
    func previous(){
        if let currentIndex = beata.currentAlbum!.song.firstIndex(of: beata.currentSong!) {
            if currentIndex == 0{
                
            }else{
                beata.player.pause()
                beata.currentSong! = beata.currentAlbum!.song[currentIndex - 1]
                self.playSong()
                beata.isPlaying.toggle()
                sliderData.currentTime = 0
                sliderData.offset.width = 0
            }
        }
    }
}
