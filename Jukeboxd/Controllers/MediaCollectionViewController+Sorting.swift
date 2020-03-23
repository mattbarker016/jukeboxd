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
        
        // TODO: Enable the album sorting logic!
        
        // This function returns a sorting function based on the passed in `sortingMode`.
        // We are creating a function that takes in two instances of a `Review` that are
        // assigned the values `a` and `b`, and returning `true` if review `a` should be
        // before review `b`. The sorting value could also be reversed (`isReversed`)
        
        // Based on each case below, use the proper review properties to sort the reviews
        // accordingly. The first one has been implemented for you. Use it as a reference example!
        
        // Challenge: Is there a simpler way to implemenet the `.rating` case? Hint: How could
        // you only use one greater / less than operator with `isReversed`?
        
        switch mode {
        case .rating:
            return { (a, b) -> Bool in
                return isReversed ? (a.rating < b.rating) : (a.rating > b.rating)
            }
            
        case .alphabeticalAlbumName:
            return { (a, b) -> Bool in
                
                // Implement me!
                
                return true // remove me once you return the proper value
            }
            
        case .alphabeticalArtistName:
            return { (a, b) -> Bool in
                
                // Implement me!
                
                return true // remove me once you return the proper value
            }
        case .dateCreated:
            return { (a, b) -> Bool in
                
                // Implement me!
                
                return true // remove me once you return the proper value
            }
            
        case .dateUpdated:
            return { (a, b) -> Bool in
                
                // Implement me!
                
                return true // remove me once you return the proper value
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
