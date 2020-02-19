//
//  MediaCollectionViewController+Sorting.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

enum SortingMode {
    case alphabeticalAlbumName
    case alphabeticalArtistName
    case dateCreated
    case dateUpdated
    case rating
}

extension MediaCollectionViewController {
    
    func sortingFunction(for mode: SortingMode, isReversed: Bool = false) -> ((Review, Review) -> Bool) {
        switch mode {
        case .alphabeticalAlbumName:
            return { (a, b) -> Bool in
                return isReversed ? (a.media.albumName > b.media.albumName) : (a.media.albumName < b.media.albumName)
            }
        case .alphabeticalArtistName:
            return { (a, b) -> Bool in
                return isReversed ? (a.media.artistName > b.media.artistName) : (a.media.artistName < b.media.artistName)
            }
        case .dateCreated:
            return { (a, b) -> Bool in
                return isReversed ? (a.dateCreated < b.dateCreated) : (a.dateCreated > b.dateCreated)
            }
        case .dateUpdated:
            return { (a, b) -> Bool in
                return isReversed ? (a.dateUpdated < b.dateUpdated) : (a.dateUpdated > b.dateUpdated)
            }
        case .rating:
            return { (a, b) -> Bool in
                return isReversed ? (a.rating < b.rating) : (a.rating > b.rating)
            }
        }
    }
    
    func createSortAlertActions() -> [UIAlertAction] {
        let alertActionCheckedKey = "checked"
        
        var actions: [UIAlertAction] = []
        
        let albumAction = UIAlertAction(title: "Album", style: .default) { (action) in
            self.sortingMode = .alphabeticalAlbumName
        }
        albumAction.setValue(sortingMode == .alphabeticalAlbumName, forKey: alertActionCheckedKey)
        actions.append(albumAction)
        
        let artistAction = UIAlertAction(title: "Artist", style: .default) { (action) in
            self.sortingMode = .alphabeticalArtistName
        }
        artistAction.setValue(sortingMode == .alphabeticalArtistName, forKey: alertActionCheckedKey)
        actions.append(artistAction)
        
        let dateCreatedAction = UIAlertAction(title: "Date Created", style: .default) { (action) in
            self.sortingMode = .dateCreated
        }
        dateCreatedAction.setValue(sortingMode == .dateCreated, forKey: alertActionCheckedKey)
        actions.append(dateCreatedAction)
        
        let dateUpdatedAction = UIAlertAction(title: "Date Updated", style: .default) { (action) in
            self.sortingMode = .dateCreated
        }
        dateUpdatedAction.setValue(sortingMode == .dateUpdated, forKey: alertActionCheckedKey)
        actions.append(dateUpdatedAction)
        
        let ratingAction = UIAlertAction(title: "Rating", style: .default) { (action) in
            self.sortingMode = .rating
        }
        ratingAction.setValue(sortingMode == .rating, forKey: alertActionCheckedKey)
        actions.append(ratingAction)
        
        let reversedAction = UIAlertAction(title: "Reverse Order", style: .default) { (action) in
            self.isReversed = !self.isReversed
        }
        reversedAction.setValue(isReversed, forKey: alertActionCheckedKey)
        actions.append(reversedAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actions.append(cancelAction)
        
        return actions
    }
    
}
