//
//  MediaNetworkRequest.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import Foundation

class MediaNetworkRequest {
    
    static let baseURL = "https://itunes.apple.com"
    
    static let decoder = JSONDecoder()
    
    private struct SearchResponse: Codable {
        let results: [Media]
    }
    
    internal class func makeRequest(with urlString: String, completion: @escaping ((_ results: [Media], _ error: Error?) -> ())) {
        guard let url = URL(string: urlString) else {
            fatalError("Could not convert string to URL!")
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Request has no data!")
                completion([], error)
                return
            }
            do {
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                let parsedMedia = searchResponse.results.compactMap { parseMediaResult($0) }
                completion(parsedMedia, error)
            } catch {
                print("Could not decode SearchResponse!")
                completion([], error)
            }
        }
        task.resume()
    }
    
    private static func parseMediaResult(_ media: Media) -> Media {
        let songLink = "https://album.link"
        let d = 600 // Dimension of album art
        
        var parsedMedia = media
        parsedMedia.url = "\(songLink)/\(media.url)"
        
        guard let regex = try? NSRegularExpression(pattern: "source/[0-9]+x[0-9]+bb.jpg", options: .caseInsensitive) else {
            return parsedMedia
        }
        parsedMedia.imageURL = regex.stringByReplacingMatches(in: media.imageURL,
                                                              options: .withTransparentBounds,
                                                              range: NSRange(location: 0, length: media.imageURL.count),
                                                              withTemplate: "source/\(d)x\(d)bb.jpg")
        return parsedMedia
    }
    
}
