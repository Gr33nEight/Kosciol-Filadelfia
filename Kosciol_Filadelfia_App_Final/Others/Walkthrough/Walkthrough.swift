//
//  Walkthrough.swift
//  Practise1
//
//  Created by Natanael  on 15/03/2021.
//

import SwiftUI


struct StarterPage : View {
    
    @ObservedObject var newsdata : NewsData
    @ObservedObject var albumData : albumData
    @ObservedObject var mowcaData : mowcaData
    @ObservedObject var beataAlbumData : BeataAlbumData
    @ObservedObject var podcastData : PodcastData
    @ObservedObject var ostatnieVideoData : OstatnieVideoData
    @ObservedObject var seriaData : SeriaData
    @ObservedObject var rejestracjaData : RejestracjaData
    @StateObject var storeManager: StoreManager
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View{
        if currentPage > totalPages{
            ContentView(newsdata: newsdata, mowcaData: mowcaData, albumData: albumData, beataAlbumData: beataAlbumData, podcastData: podcastData, ostatnieVideoData: ostatnieVideoData, seriaData: seriaData, rejestracjaData: rejestracjaData, storeManager: storeManager)
        }else{
            Walkthrough()
        }
    }
}


struct Walkthrough: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        ZStack {
            if currentPage == 1{
                ScreenView(image: "Logo", title: "Krok 1", detail: "Ta aplikacja ma na celu ułatwić Ci, życie jako Chrześcijanin.", bgColor: MainColor)
                    .transition(.scale)
            }
            if currentPage == 2{
                ScreenView(image: "video.fill", title: "Krok 2", detail: "W zakładce wideo, możesz oglądać poprzednie transmisje z naszych nabożeństw", bgColor: Color(#colorLiteral(red: 0.262745098, green: 0.7725490196, blue: 0.6862745098, alpha: 1)))
                    .transition(.scale)
            }
            if currentPage == 3{
                ScreenView(image: "music.note", title: "Krok 3", detail: "W zakładce audio, możesz słuchać naszych podcastów, piosenek zespołu filadelfia oraz Beaty Mazurek", bgColor: Color(#colorLiteral(red: 0.262745098, green: 0.768627451, blue: 0.5607843137, alpha: 1)))
                    .transition(.scale)
            }
            if currentPage == 4{
                ScreenView(image: "calendar", title: "Krok 4", detail: "Dzięki zakładce nowości, będziesz na bieżąco z wydarzeniami w Filadelfii", bgColor: Color(#colorLiteral(red: 0.2666666667, green: 0.7647058824, blue: 0.4392156863, alpha: 1)))
                    .transition(.scale)
            }
            if currentPage == 5{
                ScreenView(image: "creditcard.fill", title: "Krok 5", detail: "W tym miejscu będziesz mógł w prostu sposób oddać swoją dziesięcinę", bgColor: Color(#colorLiteral(red: 0.2705882353, green: 0.7568627451, blue: 0.2666666667, alpha: 1)))
                    .transition(.scale)
            }
            if currentPage == 6{
                ScreenView(image: "house.fill", title: "Krok 6", detail: "W zakładce strona główna, jest wiele opcji które możesz odkryć sam.", bgColor: SecondColor)
                    .transition(.scale)
            }
            
        }.overlay (
            
            Button(action: {
                withAnimation(.easeInOut){
                    if currentPage <= totalPages{
                        currentPage += 1
                    }else{
                        currentPage = 1
                    }
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(
                        ZStack{
                            Circle()
                                .stroke(Color.black.opacity(0.04), lineWidth: 4)
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(Color.white, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }.padding(-15)
                    )
            })
            .padding(.bottom, 17)
            ,alignment: .bottom
        )
    }
}

struct MainImage : View {
    
    @State var image: String
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View{
        ZStack {
            Circle()
                .frame(width: screenW - 200, height: screenW - 200)
                .foregroundColor(.white).opacity(0.8)
            Circle()
                .frame(width: screenW - 120, height: screenW - 120)
                .foregroundColor(.white).opacity(0.4)
            Circle()
                .frame(width: screenW - 40, height: screenW - 40)
                .foregroundColor(.white).opacity(0.2)
            
            if currentPage == 1{
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenW - 240)
                    .foregroundColor(.black)
            }else{
                Image(systemName: image)
                    .foregroundColor(.black)
                    .font(.system(size: 120))
            }
            
        }.shadow(radius: 10)
    }
}

struct BottomText : View {
    
    @State var title : String
    @State var detail : String
    
    var body: some View{
        VStack(alignment: .center, spacing: 15){
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            Text(detail)
                .multilineTextAlignment(.center)
                .font(.system(size: 19, weight: .light))
        }
    }
}

struct ScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        VStack(spacing: 10){
            HStack(spacing: 10){
                
                if currentPage == 1{
                    
                    Text("Witaj w naszej aplikacji!")
                        .font(.title)
                        .fontWeight(.bold)
                }else{
                    Button(action: {
                        withAnimation(.easeInOut){
                            currentPage -= 1
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                
                Spacer(minLength: 0)
                
                Button(action: {
                    withAnimation(.easeInOut){
                        currentPage = 7
                    }
                }, label: {
                    Text("pomiń")
                        .font(.headline)
                })
                
            }.foregroundColor(.black)
            .padding()
            
            MainImage(image: image)
            
            BottomText(title: title, detail: detail)
                .padding()
            
            Spacer(minLength: 30)
        }
        
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}


var totalPages = 6


