//
//  DynamicImageView.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

public class DynamicImageView: UIImageView {
    
    var imageUrlString: String?
    
    public func loadImage(fromURL urlString: String) {
        imageUrlString = urlString
        let url = URL(string: urlString)
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                let imageToCache = UIImage(data: data)
                if self.imageUrlString == urlString {
                    DispatchQueue.main.async {
                        self.image = imageToCache
                    }
                }
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
            }
        }).resume()
    }
    
}
