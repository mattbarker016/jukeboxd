//
//  LabelView.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/16/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

class LabelView: UIView {
        
    private let cornerRadius: CGFloat = 16
    
    private let widthInset: CGFloat = 12
    private let heightInset: CGFloat = 4
    
    var labelText: String!
        
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    init(text: String, color: UIColor, font: UIFont) {
        super.init(frame: .zero)
        setup()
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
        
        label.text = text
        label.font = font
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
    
    func setup() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(label)
    }
    
    func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints += createMainLabelConstraints()
        NSLayoutConstraint.activate(constraints)
    }
        
    // MARK: - Constraints
        
    func createMainLabelConstraints() -> [NSLayoutConstraint] {
        return [
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: widthInset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -widthInset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: heightInset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -heightInset)
        ]
    }
    
}
