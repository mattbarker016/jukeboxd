//
//  SeparatorView.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/16/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

class SeparatorView: UIView {
    
    static let preferredHeight: CGFloat = 1
    static let preferredSpacing: CGFloat = 16
    
    let separatorColor = UIColor.systemGray.withAlphaComponent(0.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = separatorColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
