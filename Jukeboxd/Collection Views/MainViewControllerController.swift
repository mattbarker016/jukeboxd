//
//  ViewController.swift
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
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = rightBarButton
        
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
    
    @objc private func didTapAddButton() {
        let searchResultsViewController = SearchResultsViewController(delegate: self)
        let navigationController = UINavigationController(rootViewController: searchResultsViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
        
    @objc func didTapSortButton() {
        let title = "Sort Albums"
        let alertController = UIAlertController(title: nil, message: title, preferredStyle: .actionSheet)
        let actions = createSortAlertActions()
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
    
}

