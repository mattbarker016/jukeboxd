//
//  MainCollectionViewController.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

class MainCollectionViewController: MediaCollectionViewController {
    
    private let savedReviews = Preferences<Review>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViewController() {
        title = "Jukeboxd"
        collectionView.backgroundColor = .systemBackground
        
        updateMediaContent()
    }
    
    private func setupNavigationBar() {
        
        // TODO: Create the add review button! (Part 1)
        
        // We need to add a `UIBarButtonItem` to this view controller's `navigationItem` object.
        // If you start typing "UIBarButtonItem", you'll see autocomplete fill it in. As you'll be reminded,
        // auto-complete is your friend :). After you type the class name, type a "(" or ".init" to see
        // the various ways to initalize an instance of this button, or create it.
        
        // Hint 1: Use the initializer with the `barButtonSystemItem parameter`; it takes an enumeration, which
        // means you'll just have to type a "." and type inference will suggest some options for creating
        // a button to "add" a new thing.
        
        // This button will need an action, something to do, on tapping it. That's where `target` and `selector`
        // come in. You will create a function to fire when is tapped. Then, in the `action` parameter, you'll
        // put `#selector(nameOfYourFunction)`. Look for "Part 2: Create the function" for where to put it!
        // For `target`, you just have to put `self` because your function is within this class, which can be
        // referred to as `self`.
        
        // Hint 2: The `leftBarButton` example will help you, but you can / should use a different initializer!
        
        
        // ADD YOUR CODE BELOW HERE
        
        // ADD YOUR CODE ABOVE HERE
        
        let leftBarButton = UIBarButtonItem(
            title: "Sort", style: .plain, target: self, action: #selector(didTapSortButton))
        navigationItem.leftBarButtonItem = leftBarButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - MainCollectionViewControllerDelegate
    
    override func updateMediaContent() {
        let reviews = savedReviews.get()
        content = reviews
            .sorted(by: sortingFunction(for: sortingMode, isReversed: isReversed))
            .map { $0.media }
        super.updateMediaContent()
    }
    
    // MARK: - UICollectionViewDelgate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMediaContent = content[indexPath.row]
        guard let selectedReview = (savedReviews.get().first { $0.media == selectedMediaContent }) else {
            presentErrorAlert(title: "Error", message: "Could not find review for media", on: self)
            return
        }
        let reviewViewController = ReviewViewController(review: selectedReview, delegate: self)
        // Set back button to custom title instead of previous screen title.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(didTapBackButton))
        navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // TODO: Create the add review button! (Part 2)
    
    // Here's where you'll create a function for that button. You'll need to put an @objc
    // keyword before using `func` so that `#selector` can find it. See the other functions above
    // and below for an example
    
    // Now, in this function, we want to create an instance of `SearchResultsViewController`
    // to search an album. This class conforms to the `MediaCollectionViewDelegate` protocol; check out Aside 2
    // in the crash course for more help.
    
    // You'll want to then create a `UINavigationController` whose root view controller is the
    // search results view controller. A navigation controller is the bar below the status bar that
    // typically holds the back button or title. It manages a stack of view controllers, and "pushing"
    // and "popping" left and right.
    
    // Last, you'll want to present this navigation controller. This class, which is a `UIViewController`,
    // has a function called present that will modally present a view, which means it comes from the bottom
    // over the current view, like when you create a new message or email.
    
    
    // ADD YOUR FUNCTION BELOW HERE
    
    // ADD YOUR FUNCTION ABOVE HERE
        
    @objc func didTapSortButton() {
        let title = "Sort Albums"
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        let actions = createSortAlertActions()
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
    
}

