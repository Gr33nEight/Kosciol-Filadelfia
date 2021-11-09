//
//  CustomSlider.swift
//  Kosciol_Filadelfia_App_Final
//
//  Created by Natanael  on 04/11/2021.
//

import SwiftUI
import AVFoundation
import Combine


let size = UIScreen.main.bounds.size.width - 180

struct CustomSlider: View {
    
    @EnvironmentObject var data : CustomSliderData
    @State var player : AVPlayer
    @State var acc = CGSize.zero
    
    var body: some View {
        HStack(spacing:10){
            Text(data.formattedTime)
                .foregroundColor(Color.gray)
                .font(.system(size: 13))
            Slider(value: $data.sliderValue, in: 0...Float(player.currentItem?.asset.duration.seconds ?? 100)) { _ in
                let timeCM = CMTime(seconds: Double(data.sliderValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                player.seek(to: timeCM)
            }.foregroundColor(Color.black)
            Text(data.formattedAudioTime)
                .foregroundColor(Color.gray)
                .font(.system(size: 13))
        }
    }
}

//DragGesture()
//    .onChanged { value in
//        data.offset = CGSize(width: value.translation.width + acc.width, height: value.translation.height + acc.height)
//        if data.offset.width < 0 {
//            data.offset = CGSize.zero
//       }
//        if data.offset.width > size {
//            data.offset.width = size
//            data.currentTime = player.currentItem?.asset.duration.seconds ?? 0.0
//        }
//
//        data.currentTime = data.offset.width
//
//        let timeCM = CMTime(seconds: data.currentTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
//        player.seek(to: timeCM)
//
//
//    }
//    .onEnded { value in
//        data.offset = CGSize(width: value.translation.width + acc.width, height: value.translation.height + acc.height)
//        acc = data.offset
//        if data.offset.width < 0 {
//            data.offset = CGSize.zero
//       }
//        if data.offset.width > size {
//            data.offset.width = size
//            data.currentTime = player.currentItem?.asset.duration.seconds ?? 0.0
//        }
//        data.currentTime = data.offset.width
//
//        let timeCM = CMTime(seconds: data.currentTime, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
//        player.seek(to: timeCM)
//    }
