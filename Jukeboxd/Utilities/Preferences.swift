//
//  Utilties.swift
//  ProjectBiscuit
//
//  Created by Matthew Barker on 10/2/19.
//  Copyright © 2019 Matthew Barker. All rights reserved.
//

import UIKit

enum PreferenceKey: String {
    /// Use this when  you can't use the `convenience init` and there are more than one collection of reviews to save.
    case savedReviews = "savedReviews"
}

class Preferences<T: Codable & Equatable> {
    
    fileprivate var key: String
    
    fileprivate let userDefaults = UserDefaults.standard
    
    fileprivate let encoder = PropertyListEncoder()
    fileprivate let decoder = PropertyListDecoder()
    
    /// Warning: This init should only be used for custom classes you store once!
    convenience init() {
        let classString = String(describing: type(of: T.self))
        self.init(with: classString)
    }
    
    init(with key: String) {
        self.key = key
    }
    
    // MARK: - Public API
    
    func get() -> [T] {
        return getData(with: key) ?? []
    }
    
    func contains(_ data: T) -> Bool {
        return get().contains { $0 == data }
    }
    
    func add(_ data: T) {
        var array: [T] = getData(with: key) ?? []
        array.append(data)
        setData(array, with: key)
    }
    
    func remove(_ data: T) {
        guard var array: [T] = getData(with: key) else {
            fatalError("Could not remove data: Could not get data")
        }
        array.removeAll(where: { $0 == data })
        setData(array, with: key)
    }
    
    func removeAll() {
        for data in get() {
            remove(data)
        }
    }
    
    // MARK: - Internal Functions

    fileprivate func getData<T: Decodable>(with key: String) -> [T]? {
        guard let storedObject: Data = userDefaults.object(forKey: key) as? Data else { return nil }
        return try? decoder.decode([T].self, from: storedObject)
    }
    
    fileprivate func setData<T: Encodable>(_ data: [T], with key: String) {
        guard let data = try? encoder.encode(data) else {
            fatalError("Could not encode array.")
        }
        userDefaults.set(data, forKey: key)
    }
    
}

