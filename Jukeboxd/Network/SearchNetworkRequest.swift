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
        
        // TODO: Create the iTunes API search endpoint!
        
        // Use the documentation link to read what information is needed and look at examples
        // to create the correct endpoint to search for the passed in album name (`query`)
        
        // Documentation: https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/Searching.html#//apple_ref/doc/uid/TP40017632-CH5-SW1
        
        // Use the variable `baseURL` to start off your request. Then, plug in the proper endpoint name
        // and then all the parameters needed to make the request. If the documentation is confusing, try
        // looking up more about how HTTP GET requests work and are constructed!
        
        return "IMPLEMENT ME BABY"
        
    }
    
}

