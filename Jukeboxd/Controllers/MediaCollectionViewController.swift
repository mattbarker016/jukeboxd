//
//  MediaCollectionViewController.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

protocol MediaCollectionViewDelegate {
    func updateMediaContent()
}

class MediaCollectionViewController: UICollectionViewController, MediaCollectionViewDelegate {
    
    static let reuseIdentifier = MediaCollectionViewCell.reuseIdentifier
        
    var sortingMode: SortingMode = .dateUpdated {
        didSet {
            updateMediaContent()
        }
    }
    var isReversed: Bool = false {
        didSet {
            updateMediaContent()
        }
    }
    
    var content: [Media] = []
        
    convenience init() {
        let layout = MediaCollectionViewFlowLayout()
        self.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: Self.reuseIdentifier)
        collectionView.alwaysBounceVertical = true
    }
    
    // MARK: - UICollectionView Data Source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.isEmpty ? setEmptyDataView() : removeEmptyDataView()
        return content.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MediaCollectionViewCell = (collectionView.dequeueReusableCell(withReuseIdentifier: Self.reuseIdentifier, for: indexPath) as? MediaCollectionViewCell) ?? MediaCollectionViewCell()
        cell.setCell(with: content[indexPath.row])
        return cell
    }
    
    // MARK: Empty Data Source
    
    var emptyDataView: EmptyDataView {
        return EmptyDataView(message: "Welcome to Jukeboxd! Search an album to rate and review it and keep track of your favorite albums!")
    }
    
    func setEmptyDataView() {
        collectionView.backgroundView = emptyDataView
        content = []
        collectionView.reloadData()
    }
    
    func removeEmptyDataView() {
        collectionView.backgroundView = nil
    }
    
    // MARK: MediaCollectionViewDelegate
    
    func updateMediaContent() {
        collectionView.reloadData()
    }
    
}

