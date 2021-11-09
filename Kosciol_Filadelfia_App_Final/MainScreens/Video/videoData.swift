//
//  mowcyData.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 06/04/2021.
//

import Foundation
import SwiftUI
import Firebase

struct Mowca : Hashable {
    var ID = UUID()
    var artistName : String
    var artistImage : String
    var numberM : String
    var film : [Film]
}

struct Film : Hashable {
    var ID = UUID()
    var filmName : String
    var file : String
    var filmImage : String
    var filmDescribe : String
    var artistName : String
    var youtubeUrl : String
    var facebookUrl : String
    var number : String
}

class mowcaData : ObservableObject {
    @Published public var mowca = [Mowca]()
    
    func loadAlbums() {
        
        Firestore.firestore().collection("Mowca").order(by: "numberM").getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let artistName = document.data()["artistName"] as? String ?? "error"
                    let artistImage = document.data()["artistImage"] as? String ?? "error"
                    let film = document.data()["film"] as? [String : [String : Any]]
                    let numberM = document.data()["numberM"] as? String ?? "error"
                    
                    var filmArray = [Film]()
                    if let film = film{
                        for film in film {
                            let filmName = film.value["filmName"] as? String ?? "error"
                            let filmImage = film.value["filmImage"] as? String ?? "error"
                            let file = film.value["file"] as? String ?? "error"
                            let filmDescribe = film.value["filmDescribe"] as? String ?? "error"
                            let artistName = film.value["artistName"] as? String ?? "error"
                            let youtubeUrl = film.value["youtubeUrl"] as? String ?? "error"
                            let facebookUrl = film.value["facebookUrl"] as? String ?? "error"
                            let number = film.value["number"] as? String ?? "error"
                            
                            filmArray.append(Film(filmName: filmName, file: file, filmImage: filmImage, filmDescribe: filmDescribe, artistName: artistName, youtubeUrl: youtubeUrl, facebookUrl: facebookUrl, number: number))
                            filmArray.sort { $0.number > $1.number }
                        }
                    }
                    self.mowca.append(Mowca(artistName: artistName, artistImage: artistImage, numberM: numberM, film: filmArray))
                }
            }else{
                print(error!)
            }
        }
    }
}


struct OstatnieVideo : Hashable {
    var ID = UUID()
    var filmName : String
    var file : String
    var filmImage : String
    var filmDescribe : String
    var artistName : String
    var youtubeUrl : String
    var facebookUrl : String
    var number : String
}

class OstatnieVideoData : ObservableObject {
    @Published var ostatnieVideo = [OstatnieVideo]()
    
    func loadData() {
        Firestore.firestore().collection("OstatnieVideo").order(by: "number", descending: false).getDocuments{ (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    let filmName = document.data()["filmName"] as? String ?? "error"
                    let filmImage = document.data()["filmImage"] as? String ?? "error"
                    let file = document.data()["file"] as? String ?? "error"
                    let filmDescribe = document.data()["filmDescribe"] as? String ?? "error"
                    let artistName = document.data()["artistName"] as? String ?? "error"
                    let youtubeUrl = document.data()["youtubeUrl"] as? String ?? "error"
                    let facebookUrl = document.data()["facebookUrl"] as? String ?? "error"
                    let number = document.data()["number"] as? String ?? "error"
                    
                    self.ostatnieVideo.append(OstatnieVideo(filmName: filmName, file: file, filmImage: filmImage, filmDescribe: filmDescribe, artistName: artistName, youtubeUrl: youtubeUrl, facebookUrl: facebookUrl, number: number))
                }
            }else{
                print(error!)
            }
        }
    }
}

struct Seria : Hashable {
    var ID = UUID()
    var seriaName : String
    var seriaImage : String
    var number : String
    var film : [SeriaFilm]
}

struct SeriaFilm : Hashable {
    var ID = UUID()
    var filmName : String
    var file : String
    var filmImage : String
    var filmDescribe : String
    var artistName : String
    var youtubeUrl : String
    var facebookUrl : String
    var number : String
}

class SeriaData : ObservableObject {
    @Published public var seria = [Seria]()
    
    func loadAlbums() {
        Firestore.firestore().collection("Seria").order(by: "number", descending: false).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let seriaName = document.data()["seriaName"] as? String ?? "error"
                    let seriaImage = document.data()["seriaImage"] as? String ?? "error"
                    let number = document.data()["number"] as? String ?? "error"
                    let film = document.data()["film"] as? [String : [String : Any]]
                    
                    var filmArray = [SeriaFilm]()
                    if let film = film{
                        for film in film {
                            let filmName = film.value["filmName"] as? String ?? "error"
                            let filmImage = film.value["filmImage"] as? String ?? "error"
                            let file = film.value["file"] as? String ?? "error"
                            let filmDescribe = film.value["filmDescribe"] as? String ?? "error"
                            let artistName = film.value["artistName"] as? String ?? "error"
                            let youtubeUrl = film.value["youtubeUrl"] as? String ?? "error"
                            let facebookUrl = film.value["facebookUrl"] as? String ?? "error"
                            let number = film.value["number"] as? String ?? "error"
                            
                            filmArray.append(SeriaFilm(filmName: filmName, file: file, filmImage: filmImage, filmDescribe: filmDescribe, artistName: artistName, youtubeUrl: youtubeUrl, facebookUrl: facebookUrl, number: number))
                            filmArray.sort { $0.number > $1.number }
                        }
                    }
                    self.seria.append(Seria(seriaName: seriaName, seriaImage: seriaImage, number: number, film: filmArray))
                }
            }else{
                print(error!)
            }
        }
    }
}
