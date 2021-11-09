//
//  SideBarData.swift
//  Practise1
//
//  Created by Natanael  on 09/03/2021.
//

import SwiftUI
import Firebase
import MessageUI
import StoreKit

class UserData: ObservableObject{
    @Published var name : String = ""
    @Published var surname : String = ""
}

struct SideBarData: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @Binding var isShowing: Bool    
    var body: some View {
        VStack(alignment: .leading, spacing: 6){
            HStack(alignment: .top){
                Spacer()
                Button(action: {
                    withAnimation(.spring()){
                        isShowing.toggle()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                })
                .padding()
                .padding(.top)
            }
            SideBarBottomData()
                .padding(.top, 70)
            Spacer()
            Button(action:{
                self.isShowingMailView.toggle()
            }, label: {
                HStack{
                    VStack(alignment: .leading) {
                        Text("Stworzone przez")
                            .font(.system(size: 17, weight: .semibold))
                        Text("Natanael Jop")
                            .font(.system(size: 13, weight: .thin))
                    }.padding(10)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                }.foregroundColor(.white)
            })
            .disabled(!MFMailComposeViewController.canSendMail())
            .sheet(isPresented: $isShowingMailView) {
                MailViewNatan(result: self.$result)
            }
        }.padding()
    }
}


//przyszłościowo można zrobić że ikony się wypełniają podczas kliknięcia

struct SideBarBottomData : View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    var body: some View{
        VStack(alignment: .leading, spacing: 60) {
            NavigationLink(
                destination: NotesMain(),
                label: {
                    HStack(spacing: 20){
                        Image(systemName: "note.text")
                        Text("Notatki")
                    }.font(.system(size: 21))
                })
            HStack{
                NavigationLink(
                    destination: SocialMediaView(),
                    label: {
                        HStack(spacing: 20){
                            Image(systemName: "globe")
                            Text("Nasze social media")
                        }.font(.system(size: 21))
                    })
                Spacer()
            }.frame(width: screenW/2 - 20)
            HStack{
                Button(action: {
                    if let windowScene = UIApplication.shared.windows.first?.windowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }, label: {
                    HStack(spacing: 20){
                        Image(systemName: "star.fill")
                        Text("Oceń naszą aplikacje")
                    }.font(.system(size: 21))
                })
                
                Spacer()
            }.frame(width: screenW/2 - 20)
            HStack{
                Button(action: {
                    self.isShowingMailView.toggle()
                }, label: {
                    HStack(spacing: 20){
                        Image(systemName: "ladybug.fill")
                        Text("Zgłoś problem")
                    }.font(.system(size: 21))
                }).disabled(!MFMailComposeViewController.canSendMail())
                .sheet(isPresented: $isShowingMailView) {
                    MailViewNatanReportBug(result: self.$result)
                }
                Spacer()
            }.frame(width: screenW/2 - 20)
        }.font(.system(size: 22))
        .foregroundColor(.white)
    }
}

