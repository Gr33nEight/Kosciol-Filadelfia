//
//  Hide.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 06/04/2021.
//

import SwiftUI

public extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View{
        if hidden{
            if !remove{
                self.hidden()
            }
        }else{
            self
        }
    }
}
