//
//  Media.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import Foundation

struct Media: Codable, Equatable {
    
    var albumName: String
    var artistName: String
    var imageURL: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case albumName = "collectionName"
        case artistName = "artistName"
        case imageURL = "artworkUrl100"
        case url = "collectionViewUrl"
    }
    
}
