//
//  SideBar.swift
//  Practise1
//
//  Created by Natanael  on 09/03/2021.
//

import SwiftUI

struct SideBar: View {
    @Binding var isShowing: Bool
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [MainColor, SecondColor]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            SideBarData(isShowing: $isShowing)

        }.navigationBarHidden(true)
    }
}

