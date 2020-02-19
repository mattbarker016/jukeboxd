//
//  EmptyDataView.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/16/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

class EmptyDataView: UIView {
    
    var labelText: String!
    
    init(message: String) {
        self.labelText = message
        super.init(frame: .zero)
        setupViews()
        label.text = message
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        addSubview(label)
        addConstraints()
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    func addSubviews() {
        addSubview(label)
    }
    
    func addConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints += addLabelConstraints()
        NSLayoutConstraint.activate(constraints)
    }
    
    func addLabelConstraints() -> [NSLayoutConstraint] {
        return [
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
    }
    
}
