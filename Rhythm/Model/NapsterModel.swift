//
//  NapsterModel.swift
//  Rhythm
//
//  Created by Vrushank on 2022-08-06.
//

import Foundation

struct Summary:Codable{
    var tracks: [Tracks]? = [Tracks]()
}

struct Tracks:Codable{
    var id: String? = ""
    var artistId: String? = ""
    var albumId:String? = ""
    var artistName: String? = ""
    var name: String? = ""
    var albumName: String? = ""
    var links: Links? = Links()
    var playbackSeconds: Int? = 0
    var previewURL: String? = ""
}

struct Links :Codable{
    var artists: Artists? = Artists()
    var albums: Albums? = Albums()
    var genres: Genres? = Genres()
}

struct Artists :Codable{
    var ids:[String]? = [String]()
    var href: String? = ""
}

//To get new albums and singles

struct Albums: Codable{
    var albums: [AlbumsArray]? = [AlbumsArray]()
}

struct AlbumsArray :Codable{
    var id:String? = ""
    var name:String? = ""
    var tags:[String]? = [String]()
    var artistName:String? = ""
}

struct Genres :Codable{
    var ids:[String]? = [String]()
    var href: String? = ""
}

//To get Genre Name
struct Genre: Codable{
    var genres: [GenreName]? = [GenreName]()
}

struct GenreName:Codable{
    var id:String? = ""
    var name: String? = ""
}



