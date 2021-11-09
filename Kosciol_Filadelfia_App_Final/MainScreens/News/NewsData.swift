//
//  NowosciData.swift
//  Practise1
//
//  Created by Natanael  on 16/03/2021.
//

import Foundation
import Firebase
import SwiftUI


class NewsData : ObservableObject{
    
    @Published public var nowosci = [NowosciData]()
    
    func loadData(){
        Firestore.firestore().collection("Nowosci").order(by: "number", descending: true).getDocuments { (snapshot, error) in
            if error == nil {
                for doc in snapshot!.documents{
                    let name = doc.data()["name"] as? String ?? "error"
                    let shortDescribe = doc.data()["shortDescribe"] as? String ?? "error"
                    let longDescribe = doc.data()["longDescribe"] as? String ?? "error"
                    let image = doc.data()["image"] as? String ?? "Logo"
                    let number = doc.data()["number"] as? String ?? "number"
                    
                    self.nowosci.append(NowosciData(name: name, shortDescribe: shortDescribe, longDescribe: longDescribe, image: image, number: number))
                }
            }else{
                print(error)
            }
        }
        
    }
}
