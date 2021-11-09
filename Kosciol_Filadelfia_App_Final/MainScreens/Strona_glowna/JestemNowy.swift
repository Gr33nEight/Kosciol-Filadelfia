//
//  JestemNowy.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 27/03/2021.
//

import SwiftUI
import MessageUI
import MapKit

struct Item : Identifiable{
    var id: UUID = .init()
    var latitude: Double
    var longtitude: Double
    
    var coordinate: CLLocationCoordinate2D{
        return .init(latitude: latitude, longitude: longtitude)
    }
}

struct JestemNowy: View {
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    
    @State private var isShowingMessages = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    @State private var filadelfia = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.9969122, longitude: 18.4677227), span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
    
    let annotationItems: [Item] = [
        .init(latitude: 49.9969122, longtitude: 18.4677227)
    ]
    var body: some View {
        VStack{
            Text("Jesteś tutaj nowy?")
                .underline(color: MainColor)
                .font(.largeTitle)
                .padding(.bottom, 30)
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 30){
                    Text("Kim jesteśmy")
                        .font(.title)
                        .padding(.top, 40)
                    VStack{
                        Text("Zapraszamy Cię do podróży po naszej aplikacji. Jesteśmy pewni że znajdziejsz tu wiele inspirujących treści, a także informacje o tym, kim jesteśmy i dlaczego robimy to, co robimy.").padding(.bottom)
                        Text("Jako Kościół Zielonoświątkowy należymy do drugiego co do wielkości wyznania chrześcijańskiego. Jest nas ponad 500 mln na całym świecie. W Polsce działamy w oparciu o Ustawę Sejmową pomiędzy Państwem, a Kościołem Zielonoświątkowym w RP.")
                    }.foregroundColor(.white)
                    .font(.subheadline)
                    Text("Kontakt")
                        .font(.title)
                        .padding(.top, 20)
                    HStack{
                        VStack{
                            Text("Mail:")
                                .font(.system(size: 21, weight: .bold))
                                .padding(.bottom, 15)
                            Button(action: {
                                self.isShowingMailView.toggle()
                            }, label: {
                                Text("filadelfia@filadelfia.org.pl")
                                    .underline()
                            }).disabled(!MFMailComposeViewController.canSendMail())
                            .sheet(isPresented: $isShowingMailView) {
                                MailView(result: self.$result)
                            }
                        }
                    }.frame(width: screenW - 50)
                    HStack{
                        VStack{
                            Text("Numer telefonu:")
                                .font(.system(size: 21, weight: .bold))
                                .padding()
                            let numberString = "881-622-380"
                            Button(action: {
                                self.isShowingMessages.toggle()
                            }, label: {
                                Text("881 622 380")
                                    .underline()
                            }).sheet(isPresented: self.$isShowingMessages) {
                                MessageComposeView(recipients: [numberString], body: "") { messageSent in
                                    print("MessageComposeView with message sent? \(messageSent)")
                                }
                            }
                            
                        }
                    }.frame(width: screenW - 50)
                    Text("Adres:")
                        .font(.title)
                        .padding(.top, 20)
                    HStack{
                        VStack{
                            Text("44-300 Wodzisław Śląski")
                            Text("ulica Górna 8")
                                .padding(.bottom)
                            Map(coordinateRegion: $filadelfia, annotationItems: annotationItems){ item in
                                MapAnnotation(coordinate: item.coordinate){
                                    Image(systemName: "house.fill").foregroundColor(MainColor).font(.system(size: 25))
                                }
                            }
                            
                                .frame(width: screenW - 50, height: 250)
                                .cornerRadius(20)
                        }.font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        
                        
                    }.frame(width: screenW - 50)
                    
                }.foregroundColor(.white)
                .frame(width: screenW - 50, alignment: .leading)
                .padding(.bottom, 120)
            }.frame(maxWidth: .infinity)
            .background(RoundedCorners(tl: 40, tr: 40, bl: 0, br: 0).fill(MainColor))
            
        }.padding(.top, 110)
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.mode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(MainColor)
                .font(.system(size: 28))
        }))
    }
}


struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}
