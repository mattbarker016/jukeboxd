//
//  SearchResultsViewController.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

class SearchResultsViewController: MediaCollectionViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchBarTimer: Timer? = nil
    
    var searchController: UISearchController!
    
    var delegate: MediaCollectionViewDelegate?
    
    // MARK: - View Life Cycle
    
    convenience init(delegate: MediaCollectionViewDelegate? = nil) {
        self.init()
        self.delegate = delegate
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
        setupSearchController()
    }
    
    func setupViewController() {
        title = "Search"
        collectionView.backgroundColor = .systemBackground
    }
    
    func setupNavigationBar() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = barButton
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Name of album"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - UISearchBarDelegate
    
    func getFormattedSearchBarText(_ searchBar: UISearchBar) -> String {
        guard let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return ""
        }
        return searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarTimer?.invalidate()
        let searchText = getFormattedSearchBarText(searchBar)
        processSearchQuery(searchText)
    }
    
    private let autocompleteSearchDuration: TimeInterval = 0.25
    private let timerUserInfoQueryKey = "query"
    
    @objc func searchFragment(_ timer: Timer) {
        guard let userInfo = timer.userInfo as? [String : String], let query = userInfo[timerUserInfoQueryKey] else {
            return
        }
        processSearchQuery(query)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = getFormattedSearchBarText(searchController.searchBar)
        if searchText.isEmpty {
            setPlaceholderBackgroundView()
            return
        }
        searchBarTimer?.invalidate()
        searchBarTimer = Timer.scheduledTimer(timeInterval: autocompleteSearchDuration, target: self,
                                              selector: #selector(searchFragment),
                                              userInfo: [timerUserInfoQueryKey : searchText],
                                              repeats: false)
    }
    
    func processSearchQuery(_ query: String) {
        if query.isEmpty {
            setPlaceholderBackgroundView()
            return
        }
        SearchNetworkRequest.get(with: query) { (media, error) in
            guard error == nil else {
                presentErrorAlert(title: "Could Not Search Songs", message: error!.localizedDescription, on: self.searchController)
                return
            }
            DispatchQueue.main.async {
                self.removePlaceholderBackgroundView()
                self.content = media
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UIColllectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = content[indexPath.row]
        let reviewViewController = ReviewViewController(media: media)
        reviewViewController.delegate = delegate
        navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Placeholder Overrides
    
    override var placeholderBackgrounndView: PlaceholderBackgroundView {
        return PlaceholderBackgroundView(message: "Search for an album")
    }
    
}
