//
//  AudioDataTest.swift
//  kosciol_filadelfia_simple
//
//  Created by Natanael  on 07/04/2021.
//

import Foundation
import SwiftUI
import Firebase
import MediaPlayer

struct Album : Hashable {
    var ID = UUID()
    var artistName : String
    var albumName : String
    var albumImage : String
    var number : String
    var numberOfSongs : String
    var date : String
    
    var song : [Song]
}

struct Song : Hashable {
    var ID = UUID()
    var songName : String
    var number : String
    var time : String
    var file : String
    var image : String
}

class albumData : ObservableObject {
    
    @Published public var isPlaying : Bool = false
    @Published public var player = AVPlayer()
    @Published public var currentAlbum : Album? = nil
    @Published public var currentSong: Song? = nil
    @Published public var showBottomBar = false
    @Published public var showFullScreen = false
    @Published public var album = [Album]()
    
    func loaAlbums() {
        Firestore.firestore().collection("Album").order(by: "number", descending: true).getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let artistName = document.data()["artistName"] as? String ?? "error"
                    let albumName = document.data()["albumName"] as? String ?? "error"
                    let albumImage = document.data()["albumImage"] as? String ?? "error"
                    let number = document.data()["number"] as? String ?? "error"
                    let date = document.data()["date"] as? String ?? "error"
                    let numberOfSongs = document.data()["numberOfSongs"] as? String ?? "error"
                    let song = document.data()["song"] as? [String : [String : Any]]
                    
                    var songArray = [Song]()
                    if let song = song{
                        for song in song {
                            let songName = song.value["songName"] as? String ?? "error"
                            let number = song.value["number"] as? String ?? "error"
                            let time = song.value["time"] as? String ?? "error"
                            let file = song.value["file"] as? String ?? "error"
                            let image = song.value["image"] as? String ?? "error"
                            
                            songArray.append(Song(songName: songName, number: number, time: time, file: file, image: image))
                            songArray.sort { $1.number > $0.number }
                        }
                    }
                    self.album.append(Album(artistName: artistName, albumName: albumName, albumImage: albumImage, number: number, numberOfSongs: numberOfSongs, date: date, song: songArray))
                }
            }else{
                print(error!)
            }
        }
    }
}


struct BeataAlbum : Hashable {
    var ID = UUID()
    var artistName : String
    var albumName : String
    var albumImage : String
    var number : String
    var numberOfSongs : String
    var date : String
    
    var song : [BeataSong]
}

struct BeataSong : Hashable {
    var ID = UUID()
    var songName : String
    var number : String
    var time : String
    var file : String
}


class BeataAlbumData : ObservableObject {
    
    @Environment(\.presentationMode) var mode
    
    @Published public var isPlaying : Bool = false
    @Published public var player = AVPlayer()
    @Published public var currentAlbum : BeataAlbum? = nil
    @Published public var currentSong: BeataSong? = nil
    @Published public var showBottomBar = false
    @Published public var showFullScreen = false
    @Published public var album = [BeataAlbum]()
    
    func loaAlbums() {
        Firestore.firestore().collection("BeataAlbum").getDocuments { (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents {
                    let artistName = document.data()["artistName"] as? String ?? "error"
                    let albumName = document.data()["albumName"] as? String ?? "error"
                    let albumImage = document.data()["albumImage"] as? String ?? "error"
                    let number = document.data()["number"] as? String ?? "error"
                    let date = document.data()["date"] as? String ?? "error"
                    let numberOfSongs = document.data()["numberOfSongs"] as? String ?? "error"
                    let song = document.data()["song"] as? [String : [String : Any]]
                    
                    var songArray = [BeataSong]()
                    if let song = song{
                        for song in song {
                            let songName = song.value["songName"] as? String ?? "error"
                            let number = song.value["number"] as? String ?? "error"
                            let time = song.value["time"] as? String ?? "error"
                            let file = song.value["file"] as? String ?? "error"
                            
                            songArray.append(BeataSong(songName: songName, number: number, time: time, file: file))
                            songArray.sort { $1.number > $0.number }
                            
                        }
                    }
                    self.album.append(BeataAlbum(artistName: artistName, albumName: albumName, albumImage: albumImage, number: number, numberOfSongs: numberOfSongs, date: date, song: songArray))
                }
            }else{
                print(error!)
            }
        }
    }
    
}


struct Podcast : Hashable {
    var image : String
    var name : String
    var artistName : String
    var file : String
    var number : String
    var time : String
}

class PodcastData : ObservableObject {
    
    @Published public var isPlaying : Bool = false
    @Published public var player = AVPlayer()
    @Published public var currentPodcast: Podcast? = nil
    @Published public var showBottomBar = false
    @Published public var showFullScreen = false
    @Published var podcast = [Podcast]()
    
    func loadData() {
        Firestore.firestore().collection("Podcast").order(by: "number", descending: true).getDocuments{ (snapshot, error) in
            if error == nil {
                for document in snapshot!.documents{
                    let image = document.data()["image"] as? String ?? "error"
                    let name = document.data()["name"] as? String ?? "error"
                    let artistName = document.data()["artistName"] as? String ?? "error"
                    let file = document.data()["file"] as? String ?? "error"
                    let number = document.data()["number"] as? String ?? "error"
                    let time = document.data()["time"] as? String ?? "31:20"
                    
                    self.podcast.append(Podcast(image: image, name: name, artistName: artistName, file: file, number: number, time: time))
                }
            }else{
                print(error!)
            }
        }
    }
}
