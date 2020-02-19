//
//  SearchNetworkRequest.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import Foundation

class SearchNetworkRequest: MediaNetworkRequest {
    
    class func get(with query: String, completion: @escaping ((_ results: [Media], _ error: Error?) -> ())) {
        let endpoint = createSearchEndpoint(with: query)
        makeRequest(with: endpoint) { (media, error) in
            completion(media, error)
        }
    }
    
    private class func createSearchEndpoint(with query: String) -> String {
        let endpoint = "search"
        let limit = 50
        let media = "music"
        let entity = "album"
        let formattedQuery = query.replacingOccurrences(of: " ", with: "+")
        return "\(baseURL)/\(endpoint)?term=\(formattedQuery)&media=\(media)&entity=\(entity)&limit=\(limit)"
    }
    
}

