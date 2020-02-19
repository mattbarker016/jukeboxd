//
//  MediaCollectionViewFlowLayout.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/16/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

class MediaCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // Constants
    let numberOfItemsPerRow = 2
    let interItemSpacing: CGFloat = 16
    
    // Section Insets
    let horizontalInset: CGFloat = 20
    let verticalInset: CGFloat = 0
    
    override init() {
        super.init()
                
        let containerWidth = UIScreen.main.bounds.width - horizontalInset * 2
        let numberOfSpaces = numberOfItemsPerRow - 1
        let totalItemWidth = containerWidth - (interItemSpacing * CGFloat(numberOfSpaces))
        let itemWidth = totalItemWidth / CGFloat(numberOfItemsPerRow)
        
        estimatedItemSize = CGSize(width: itemWidth, height: 1)
        minimumInteritemSpacing = interItemSpacing
        minimumLineSpacing = interItemSpacing
        scrollDirection = .vertical
        sectionInset = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
    }

}
