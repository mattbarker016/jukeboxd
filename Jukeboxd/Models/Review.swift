//
//  Review.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import Foundation

struct Review: Codable, Equatable {
    
    var media: Media
    
    var rating: Int
    var description: String?
    
    var dateCreated: Date
    var dateUpdated: Date
    
    init(media: Media, rating: Int, description: String?) {
        self.media = media
        self.rating = rating
        self.description = description
        
        self.dateCreated = Date()
        self.dateUpdated = self.dateCreated
    }
    
}

