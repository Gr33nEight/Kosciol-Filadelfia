//
//  Rejestracja.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 27/03/2021.
//

import SwiftUI
import Firebase

struct Rejestracja: View {
    @ObservedObject var rejestracjaData : RejestracjaData
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .leading){
            Text("Rejestracja")
                .font(.title)
                .bold()
                .foregroundColor(.black)
                .padding()
            ScrollView(.vertical, showsIndicators: false, content: {
                LazyVStack(spacing: 20){
                    if self.rejestracjaData.rejestracjaInfo.first == nil{
                        VStack{
                            Text("Nie ma żadnych wydarzeń")
                                .foregroundColor(MainColor)
                                .font(.system(size: 22, weight: .semibold))
                                .padding(.top, 200)
                        }
                    }else{
                        ForEach(rejestracjaData.rejestracjaInfo, id:\.self){ data in
                            Button(action: {
                                openURL(URL(string: data.url)!)
                            }, label: {
                                VStack(alignment: .leading, spacing: 5, content: {
                                    AsyncImage(url: URL(string: data.image)!, placeholder: {ProgressView()})
                                        .scaledToFit()
                                        .cornerRadius(20)
                                        .shadow(radius: 15)
                                        .frame(width: screenW - 50)
                                        .padding(30)
                                        
                                    Text(data.name)
                                        .font(.system(size: 20))
                                        .bold()
                                        .padding(.horizontal, 30)
                                }).foregroundColor(.black)
                            })
                        }
                    }
                }
            }).frame(width: screenW)
        }.padding(.top, 140)
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


struct RejestracjaInfo : Hashable {
    var id = UUID()
    var image : String
    var url : String
    var name : String
}

class RejestracjaData : ObservableObject{
    @Published var rejestracjaInfo = [RejestracjaInfo]()
    
    func loadData() {
        Firestore.firestore().collection("Rejestracja").getDocuments{ (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    let image = document.data()["image"] as? String ?? "error"
                    let name = document.data()["name"] as? String ?? "error"
                    let url = document.data()["url"] as? String ?? "error"
                    
                    self.rejestracjaInfo.append(RejestracjaInfo(image: image, url: url, name: name))
                }
            }else{
                print(error!)
            }
        }
    }
}

