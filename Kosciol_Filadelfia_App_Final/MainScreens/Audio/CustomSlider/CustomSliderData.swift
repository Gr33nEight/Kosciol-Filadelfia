//
//  CustomSliderData.swift
//  Kosciol_Filadelfia_App_Final
//
//  Created by Natanael  on 05/11/2021.
//

import SwiftUI
import AVFoundation
import Combine

class CustomSliderData : ObservableObject {
    
    @Published public var formattedTime: String = "0:00"
    @Published public var currentTime: CGFloat = 0.0
    @Published public var formattedAudioTime: String = "0:00"
    @Published public var offset = CGSize.zero
    @Published public var length = 0.0
    
    let didChange = PassthroughSubject<CustomSliderData,Never>()

    var sliderValue: Float = 0 {
      willSet {
          currentTime = CGFloat(newValue)
          didChange.send(self)
      }
    }
}
