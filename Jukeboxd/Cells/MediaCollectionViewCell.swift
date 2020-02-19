//
//  MediaCollectionViewCell.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/13/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let smallSpacingConstant: CGFloat = 4
    static let imageTitleLabelVerticalSpacing: CGFloat = smallSpacingConstant * 2
    static let titleDetailLabelVerticalSpacing: CGFloat = smallSpacingConstant
    static let detailAccessoryStackViewVerticalSpacing: CGFloat = smallSpacingConstant
}

public class MediaCollectionViewCell: UICollectionViewCell {
        
    static let reuseIdentifier = "MediaCollectionViewCell"
        
    // MARK: View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews()
        addConstraints()
    }
    
    func setCell(with media: Media) {
        titleLabel.text = media.albumName
        detailLabel.text = media.artistName
        imageView.loadImage(fromURL: media.imageURL)
    }
    
    // MARK: - UI
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var imageView: MediaImageView = {
        let imageView = MediaImageView()
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var accessoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
    }
    
    // MARK: - Constraints
    
    func addConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints += createContainerViewConstraints()
        constraints += createImageViewConstraints()
        constraints += createTitleLabelConstraints()
        constraints += createDetailLabelConstraints()
        NSLayoutConstraint.activate(constraints)
    }
    
    func createContainerViewConstraints() -> [NSLayoutConstraint] {
        return [
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
    }
    
    func createImageViewConstraints() -> [NSLayoutConstraint] {
        return [
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ]
    }
    
    func createTitleLabelConstraints() -> [NSLayoutConstraint] {
        return [
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .imageTitleLabelVerticalSpacing),
        ]
    }
    
    func createDetailLabelConstraints() -> [NSLayoutConstraint] {
        return [
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .titleDetailLabelVerticalSpacing),
            detailLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ]
    }
        
    lazy var widthConstraint: NSLayoutConstraint = {
        let constraint = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        constraint.isActive = true
        return constraint
    }()
    
    override public func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        widthConstraint.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
        
}
