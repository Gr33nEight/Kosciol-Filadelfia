//
//  Strona_glownaData.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 27/03/2021.
//

import Foundation
import Firebase
import SwiftUI

struct Strona_glownaImage : Hashable {
    var id = UUID()
    var image : String
}


class Strona_glownaData : ObservableObject{
    
    @Published public var strona_glowna = [Strona_glownaImage]()
    
    func loadData(){
        Firestore.firestore().collection("Strona_glowna").getDocuments { (snapshot, error) in
            if error == nil {
                for doc in snapshot!.documents{
                    let image = doc.data()["image"] as? String ?? "Logo"
                    
                    self.strona_glowna.append(Strona_glownaImage(image: image))
                }
            }else{
                print(error)
            }
        }
        
    }
}

