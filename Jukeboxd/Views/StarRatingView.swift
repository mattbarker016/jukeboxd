//
//  StarRatingView.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/16/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

enum StarRatingState {
    case empty
    case value(Int)
}

protocol StarRatingViewDelegate {
    func didUpdateStarRating()
}

class StarRatingView: UIStackView {
    
    // MARK: - Variables
    
    var delegate: StarRatingViewDelegate?
    
    private let numberOfStars = 5
    private let horizontalSpacing: CGFloat = 2
    
    var state: StarRatingState!
    
    // MARK: - Initializers
    
    init(state: StarRatingState) {
        self.state = state
        super.init(frame: .zero)
        configureStackView()
        setState(to: state)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public
    
    func getValue() -> Int? {
        switch self.state {
        case .empty, .none:
            return nil
        case .value(let value):
            return value
        }
    }
    
    func setState(to state: StarRatingState) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        createArrangedSubviews(with: state).forEach { addArrangedSubview($0) }
        self.state = state
    }
    
    // MARK: - Private
    
    // MARK: - StackView
    
    private func configureStackView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .leading
        distribution = .fill
        spacing = horizontalSpacing
    }
    
    private func createArrangedSubviews(with state: StarRatingState) -> [UIView] {
        var arrangedSubviews: [UIView] = []
        switch state {
        case .empty:
            (0..<numberOfStars).forEach { _ in
                arrangedSubviews.append(createStar(isFilled: false))
            }
        case .value(let starRatingValue):
            (0..<starRatingValue).forEach { _ in
                arrangedSubviews.append(createStar(isFilled: true))
            }
            (starRatingValue..<numberOfStars).forEach { _ in
                arrangedSubviews.append(createStar(isFilled: false))
            }
        }
        return arrangedSubviews
    }
    
    // MARK: - Star UIImage
        
    private func createStarImage(isFilled: Bool) -> UIImage? {
        let imageName = isFilled ? "star.fill" : "star"
        let configuration = UIImage.SymbolConfiguration(scale: UIImage.SymbolScale.large)
        return UIImage(systemName: imageName, withConfiguration: configuration)
    }
    
    private func createStar(isFilled: Bool) -> UIImageView {
        let image = createStarImage(isFilled: isFilled)
        let imageView = UIImageView(image: image)
        imageView.isUserInteractionEnabled = true
        imageView.tag = NSNumber(booleanLiteral: isFilled).intValue
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        let tapGestureRecoginzer = UITapGestureRecognizer(target: self, action: #selector(didTapStarImageView))
        imageView.addGestureRecognizer(tapGestureRecoginzer)
        return imageView
    }
    
    private func indexOfStar(_ imageView: UIImageView) -> Int? {
        for (index, subview) in arrangedSubviews.enumerated() {
            if subview == imageView { return index }
        }
        return nil
    }
    
    @objc private func didTapStarImageView(sender: UITapGestureRecognizer) {
        guard
            let tappedImageView = sender.view as? UIImageView,
            let tappedImageViewState = Bool(exactly: NSNumber(integerLiteral: tappedImageView.tag)),
            let starIndex = indexOfStar(tappedImageView)
            else {
                return
        }
        
        var isStarFilled = tappedImageViewState
        var isLastStarFilled = false
        if case .value(let value) = state {
            isLastStarFilled = isStarFilled && value == starIndex + 1
        }
        let newValue = isStarFilled && isLastStarFilled ? starIndex : starIndex + 1
        setState(to: .value(newValue))
        isStarFilled = !isStarFilled
        tappedImageView.tag = NSNumber(booleanLiteral: isStarFilled).intValue
        
        delegate?.didUpdateStarRating()
    }
        
}
