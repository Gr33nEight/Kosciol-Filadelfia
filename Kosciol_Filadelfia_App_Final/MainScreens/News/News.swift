//
//  News.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 26/03/2021.
//

import SwiftUI

struct NowosciData : Hashable {
    var id = UUID()
    var name : String
    var shortDescribe : String
    var longDescribe : String
    var image : String
    var number : String
}

struct News: View {
    
    private func showMore(proxy: GeometryProxy) -> Bool {
        var show: Bool = false
        
        let x = proxy.frame(in: .global).minX
        
        let diff = abs(x - 45)
        if diff < 100 {
            show.toggle()
        }
        return show
    }
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        
        let x = proxy.frame(in: .global).minX
        
        let diff = abs(x - 45)
        if diff < 100 {
            scale = 1 + (110 - diff) / 500
        }
        return scale
    }
    
    @ObservedObject var newsData : NewsData
    @State var isShowing = false
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false){
            HStack(spacing: 110){
                ForEach(newsData.nowosci, id:\.self) { now in
                    NavigationLink(
                        destination: wholeView(data: now),
                        label: {
                            GeometryReader { proxy in
                                
                                let show = showMore(proxy: proxy)
                                let scale = getScale(proxy: proxy)
                                
                                VStack(alignment: .leading, spacing: 15){
                                    
                                    AsyncImage(url: URL(string: now.image)!, placeholder: {ProgressView()})
                                        .scaledToFill()
                                        .frame(width: screenW/1.5, height: screenW/1.5)
                                        .cornerRadius(20)
                                        .shadow(radius: show ? 0 : 10) // wraznie czego można to usunąć
                                        .padding(35)
                                        .scaleEffect(CGSize(width: scale, height: scale))
                                    
                                    
                                    if show{
                                        Text(now.name)
                                            .font(.system(size: 20, weight: .semibold))
                                            .padding(.horizontal, 15)
                                        Text(now.shortDescribe)
                                            .font(.system(size: 17, weight: .thin))
                                            .padding(.horizontal, 10)
                                            .padding(5)
                                        Spacer()
                                        
                                    }
                                }.animation(.easeOut(duration: 0.5))
                                
                                //.shadow(radius: 10)
                                .frame(width: screenW/1.2)
                                //.background(show ? Color.black.opacity(0.03) : Color.clear)
                                
                                .animation(.easeInOut(duration: 0.5))
                                .cornerRadius(20)
                                .padding(.trailing, 100)
                            }.frame(width: 225, height: screenH - 200)
                            .foregroundColor(.black)
                        })
                    
                }
            }.padding(.leading, 40)
            .padding(.trailing, 150)
            .navigationBarHidden(true)
        }.padding(.top, 20)
    }
}


struct wholeView : View{
    @State var data : NowosciData
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                AsyncImage(url: URL(string: data.image)!, placeholder: {ProgressView()})
                    .cornerRadius(15)
                    .frame(width: screenW - 50, height: screenW - 50)
                    .padding()
                    .padding(.top, 120)
                VStack(alignment: .leading){
                    Text(data.name)
                        .font(.system(size: 22, weight: .bold))
                        .padding(.bottom)
                    Text(data.longDescribe)
                        .font(.system(size: 20, weight: .thin))
                }.padding(30)
                .foregroundColor(.black)
                Spacer()
            }
        }.edgesIgnoringSafeArea(.top)
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







