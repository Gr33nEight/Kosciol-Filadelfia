//
//  Video.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 26/03/2021.
//

import UIKit
import SwiftUI
import AVKit


struct Video: View {
    @ObservedObject var newsData : NewsData
    @ObservedObject var mowcaData : mowcaData
    @ObservedObject var ostatnieVideoData : OstatnieVideoData
    @ObservedObject var seriaData : SeriaData
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVStack{
                HStack{
                    Text("Mówcy")
                        .font(.title)
                        .bold()
                    Spacer()
                }.padding(.top, 120)
                .padding(.horizontal, 30)
                MowcyViewTest(mowcaData: mowcaData)
                HStack{
                    Text("Serie")
                        .font(.title)
                        .bold()
                    Spacer()
                }.padding(.horizontal, 30)
                SerieView(seriaData: seriaData)
                HStack{
                    Text("Ostatnie")
                        .font(.title)
                        .bold()
                    Spacer()
                }.padding(.horizontal, 30)
                OstatnieView(ostatnieVideoData: ostatnieVideoData)
                    .padding(30)
                Spacer()
            }.navigationBarHidden(true)
        }.edgesIgnoringSafeArea(.top)
    }
}

struct MowcyViewTest : View {
    @ObservedObject var mowcaData : mowcaData
    @State private var currentFilm : Film?
    @State private var currentMowca : Mowca?
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 20){
                ForEach(mowcaData.mowca, id:\.self){ data in
                    NavigationLink(destination: MowcyWholeViewTest(mowcaData: mowcaData, currentMowca: currentMowca ?? data, mowca: data, film: currentFilm ?? data.film.first!), label: {
                        VStack{
                            AsyncImage(url: URL(string: data.artistImage)!, placeholder: {ProgressView()})
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            Text(data.artistName)
                                .font(.system(size: 13, weight: .thin))
                                .foregroundColor(.black)
                        }.foregroundColor(.black)
                        .padding(.vertical, 5)
                    })
                }
            }.padding(.horizontal, 30)
        }
    }
}

struct MowcyWholeViewTest : View {
    @Environment(\.presentationMode) var presentationMode1
    @ObservedObject var mowcaData : mowcaData
    @State var currentMowca : Mowca
    @State var isPresented = false
    var mowca : Mowca
    var film : Film
    var body: some View{
        VStack{
            HStack{
                Text(mowca.artistName)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                Spacer()
            }.padding()
            .padding(.top, 130)
            Spacer()
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack{
                    ForEach(currentMowca.film, id:\.self){ data in
                        VStack(spacing: 20){
                            HStack(spacing: 20){
                                NavigationLink(destination: mowcyPlayer(film: data, mowca: currentMowca), label: {
                                    AsyncImage(url: URL(string: data.filmImage)!, placeholder: {ProgressView()})
                                        .cornerRadius(15)
                                        .shadow(radius: 10)
                                        .scaledToFit()
                                        .frame(width: screenW/2.5)
                                        .padding(.horizontal)
                                    VStack(alignment: .leading){
                                        Text(data.filmName)
                                            .lineLimit(2)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.black)
                                        Text(data.artistName)
                                            .font(.system(size: 16.5, weight: .thin))
                                    }
                                    Spacer()
                                })
                            }.foregroundColor(.black)
                            Divider().frame(width: screenW - 50)
                        }
                    }.padding(30)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode1.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .font(.system(size: 28))
            }))
        }.edgesIgnoringSafeArea(.top)
    }
}

struct mowcyPlayer : View {
    var film : Film
    var mowca : Mowca
    @State var showPlayer = false
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode1
    var body: some View{
        let player = AVPlayer(url: URL(string:film.file)!)
        VStack{
            Button(action: {
                showPlayer.toggle()
            }, label: {
                ZStack{
                    AsyncImage(url: URL(string: film.filmImage)!, placeholder: {ProgressView()})
                        .scaledToFit()
                    Color.black.opacity(0.3)
                    Image(systemName: "play.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }.frame(width: screenW - 50)
                .cornerRadius(15)
                .shadow(radius: 10)
                .scaledToFit()
            }).fullScreenCover(isPresented: $showPlayer, content: {
                VideoPlayer(player: player).ignoresSafeArea()
                    .onAppear {
                        AppDelegate.orientationLock = UIInterfaceOrientationMask.all
                        UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                        UINavigationController.attemptRotationToDeviceOrientation()
                    }
                    .onDisappear {
                        DispatchQueue.main.async {
                            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                            UINavigationController.attemptRotationToDeviceOrientation()
                        }
                    }
            })
            .frame(width: screenW - 50)
            .cornerRadius(15)
            .shadow(radius: 10)
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 10){
                    Text(film.filmName)
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.black)
                    Text(film.artistName)
                        .font(.system(size: 20))
                        .padding(.bottom, 30)
                    Text(film.filmDescribe)
                        .font(.system(size: 18, weight: .thin))
                }
                Spacer()
            }.padding(.horizontal, 30)
            .padding(.vertical, 10)
            Spacer()
            HStack{
                Button(action: {
                    openURL(URL(string: film.facebookUrl)!)
                }, label: {
                    VStack(spacing: 15){
                        Image("fb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Facebook")
                    }
                })
                Spacer(minLength: 0)
                Button(action: {
                    shareSheet()
                }, label: {
                    VStack(spacing: 15){
                        Image(systemName: "arrowshape.turn.up.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Udostępnij")
                    }
                })
                Spacer(minLength: 0)
                Button(action: {
                    openURL(URL(string: film.youtubeUrl)!)
                }, label: {
                    VStack(spacing: 15){
                        Image("yt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("YouTube")
                    }
                })
            }.padding(.bottom, 30)
            .padding(.horizontal, 50)
            .foregroundColor(.black)
        }.padding(.top, 150)
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode1.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 28))
        }))
    }
    
    func shareSheet() {
        let av = UIActivityViewController(activityItems: [film.facebookUrl], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct SerieView : View {
    @ObservedObject var seriaData : SeriaData
    @State private var currentFilm : SeriaFilm?
    @State private var currentSeria : Seria?
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            LazyHStack(spacing: 20){
                ForEach(seriaData.seria, id:\.self){ data in
                    NavigationLink(
                        destination: SeriaWholeView(seriaData: seriaData, currentSeria: currentSeria ?? data, seria: data, seriaFilm: currentFilm ?? data.film.first!),
                        label: {
                            VStack{
                                AsyncImage(url: URL(string: data.seriaImage)!, placeholder: {ProgressView()})
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .frame(height: screenW/2)
                                HStack{
                                    Text(data.seriaName)
                                        .font(.system(size: 20, weight: .thin))
                                        .foregroundColor(.black)
                                }
                            }
                        })
                }
            }.padding(30)
        }
    }
}

struct SeriaWholeView : View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var seriaData : SeriaData
    @State var currentSeria : Seria
    @State var isPresented = false
    var seria : Seria
    var seriaFilm : SeriaFilm
    
    var body: some View{
        VStack{
            HStack{
                Text(seria.seriaName)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                Spacer()
            }.padding()
            .padding(.top, 130)
            Spacer()
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack{
                    ForEach(currentSeria.film, id:\.self){ data in
                        VStack(spacing: 20){
                            HStack(spacing: 20){
                                NavigationLink(destination: seriaPlayer(seria: currentSeria, seriaFilm: data), label: {
                                    AsyncImage(url: URL(string: data.filmImage)!, placeholder: {ProgressView()})
                                        .cornerRadius(15)
                                        .shadow(radius: 10)
                                        .scaledToFit()
                                        .frame(width: screenW/2.5)
                                        .padding(.horizontal)
                                    VStack(alignment: .leading){
                                        Text(data.filmName)
                                            .lineLimit(2)
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.black)
                                        Text(data.artistName)
                                            .font(.system(size: 16.5, weight: .thin))
                                    }
                                    Spacer()
                                })
                            }.foregroundColor(.black)
                            Divider().frame(width: screenW - 50)
                        }
                    }.padding(30)
                }
            })
            .edgesIgnoringSafeArea(.top)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .font(.system(size: 28))
            }))
        }.edgesIgnoringSafeArea(.top)
    }
}

struct seriaPlayer : View {
    var seria : Seria
    var seriaFilm : SeriaFilm
    @State var showPlayer = false
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        let player = AVPlayer(url: URL(string: seriaFilm.file)!)
        VStack{
            Button(action: {
                showPlayer.toggle()
            }, label: {
                ZStack{
                    AsyncImage(url: URL(string: seria.seriaImage)!, placeholder: {ProgressView()})
                        .scaledToFit()
                    Color.black.opacity(0.3)
                    Image(systemName: "play.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }.frame(width: screenW - 50)
                .cornerRadius(15)
                .shadow(radius: 10)
                .scaledToFit()
            }).fullScreenCover(isPresented: $showPlayer, content: {
                VideoPlayer(player: player).ignoresSafeArea()
                    .onAppear {
                        AppDelegate.orientationLock = UIInterfaceOrientationMask.all
                        UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                        UINavigationController.attemptRotationToDeviceOrientation()
                    }
                    .onDisappear {
                        DispatchQueue.main.async {
                            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                            UINavigationController.attemptRotationToDeviceOrientation()
                        }
                    }
            })
            .frame(width: screenW - 50)
            .cornerRadius(15)
            .shadow(radius: 10)
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 10){
                    Text(seriaFilm.filmName)
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.black)
                    Text(seriaFilm.artistName)
                        .font(.system(size: 20))
                        .padding(.bottom, 30)
                    Text(seriaFilm.filmDescribe)
                        .font(.system(size: 18, weight: .thin))
                }
                Spacer()
            }.padding(.horizontal, 30)
            .padding(.vertical, 10)
            Spacer()
            HStack{
                Button(action: {
                    openURL(URL(string: seriaFilm.facebookUrl)!)
                }, label: {
                    VStack(spacing: 15){
                        Image("fb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Facebook")
                    }
                })
                Spacer(minLength: 0)
                Button(action: {
                    shareSheet()
                }, label: {
                    VStack(spacing: 15){
                        Image(systemName: "arrowshape.turn.up.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Udostępnij")
                    }
                })
                Spacer(minLength: 0)
                Button(action: {
                    openURL(URL(string: seriaFilm.youtubeUrl)!)
                }, label: {
                    VStack(spacing: 15){
                        Image("yt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("YouTube")
                    }
                })
            }.padding(.bottom, 30)
            .padding(.horizontal, 50)
            .foregroundColor(.black)
        }.padding(.top, 150)
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 28))
        }))
    }
    
    func shareSheet() {
        let av = UIActivityViewController(activityItems: [seriaFilm.facebookUrl], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct OstatnieView : View {
    @ObservedObject var ostatnieVideoData : OstatnieVideoData
    var body: some View{
        LazyVStack(spacing: 30){
            ForEach(ostatnieVideoData.ostatnieVideo, id:\.self){ data in
                NavigationLink(destination: OstatniePlayer(ostatnie: data), label: {
                    VStack{
                        HStack{
                            AsyncImage(url: URL(string: data.filmImage)!, placeholder: {ProgressView()})
                                .cornerRadius(15)
                                .shadow(radius: 10)
                                .scaledToFit()
                                .frame(width: screenW/2.5)
                            Spacer()
                            VStack(alignment: .leading){
                                Text(data.filmName)
                                    .lineLimit(2)
                                    .font(.system(size: 18, weight: .semibold))
                                Text(data.artistName)
                                    .font(.system(size: 16, weight: .thin))
                            }.foregroundColor(.black)
                        }
                        Divider().frame(width: screenW - 50)
                    }
                })
            }
        }
    }
}

struct OstatniePlayer : View {
    var ostatnie : OstatnieVideo
    @State var showPlayer = false
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        let player = AVPlayer(url: URL(string: ostatnie.file)!)
        VStack{
            Button(action: {
                showPlayer.toggle()
            }, label: {
                ZStack{
                    AsyncImage(url: URL(string: ostatnie.filmImage)!, placeholder: {ProgressView()})
                        .scaledToFit()
                    Color.black.opacity(0.3)
                    Image(systemName: "play.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }.frame(width: screenW - 50)
                .cornerRadius(15)
                .shadow(radius: 10)
                .scaledToFit()
            }).fullScreenCover(isPresented: $showPlayer, content: {
                VideoPlayer(player: player).ignoresSafeArea()
                    .onAppear {
                        AppDelegate.orientationLock = UIInterfaceOrientationMask.all
                        UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                        UINavigationController.attemptRotationToDeviceOrientation()
                    }
                    .onDisappear {
                        DispatchQueue.main.async {
                            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                            UINavigationController.attemptRotationToDeviceOrientation()
                        }
                    }
            })
            .frame(width: screenW - 50)
            .cornerRadius(15)
            .shadow(radius: 10)
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 10){
                    Text(ostatnie.filmName)
                        .font(.system(size: 23, weight: .semibold))
                        .foregroundColor(.black)
                    Text(ostatnie.artistName)
                        .font(.system(size: 20))
                        .padding(.bottom, 30)
                    Text(ostatnie.filmDescribe)
                        .font(.system(size: 18, weight: .thin))
                }.frame(width: screenW - 55)
                Spacer()
            }.padding(.horizontal, 30)
            .padding(.vertical, 10)
            Spacer()
            HStack{
                Button(action: {
                    openURL(URL(string: ostatnie.facebookUrl)!)
                }, label: {
                    VStack(spacing: 15){
                        Image("fb")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Facebook")
                    }
                })
                Spacer(minLength: 0)
                Button(action: {
                    shareSheet()
                }, label: {
                    VStack(spacing: 15){
                        Image(systemName: "arrowshape.turn.up.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("Udostępnij")
                    }
                })
                Spacer(minLength: 0)
                Button(action: {
                    openURL(URL(string: ostatnie.youtubeUrl)!)
                }, label: {
                    VStack(spacing: 15){
                        Image("yt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("YouTube")
                    }
                })
            }.padding(.bottom, 30)
            .padding(.horizontal, 50)
            .foregroundColor(.black)
        }.padding(.top, 150)
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .font(.system(size: 28))
        }))
    }
    
    func shareSheet() {
        let av = UIActivityViewController(activityItems: [ostatnie.facebookUrl], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}


