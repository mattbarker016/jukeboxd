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
        
        // TODO: Add the proper styling for this UILabel!
        // Hint: look at titleLabel and think about how you'd modify it
        // for a secondary detail label.
        
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
        
        // TODO: Add layout constraints to the detail UILabel!
        
        // Auto-Layout is a blessing and a curse, a boon and a burden. This is a horribly
        // quick and dirty lesson about them, but here it goes. Auto-layout is what enables developers
        // to layout complex views on devices with variable size. When you use auto-layout, you use
        // constraints to layout out views with respect to one another. Constraints are like math equations
        // that the compiler users to figure where where on the screen to put a view.
        
        // Every view has a series of anchors for significant points. `leadingAnchor`, or `leftAnchor`, is
        // the leftmost-side of a view, and `trailingAnchor` or `rightAnchor` is the right side. There's also
        // `topAnchor` and `bottomAnchor`. `widthAnchor` and `heightAnchor` are used to set widths and heights
        // in relation to other views. You can see eamples of these anchors and constraints in the other
        // constraint functions in this class.
        
        // Your job is to add the constraints for one last view, a detail label. This cell has three views:
        // the album `imageView`, the `titleLabel` for the album name, and the `detailLabel` for the artistName.
        // All of these views are in a `containerView`, which does just that: contain all the views.
        
        // The cell has the imageView at the top, which has its leading, trailing, and top anchors pinned to the
        // container view. The width should be the same, and the height should match the width. (Aside: We make the
        // image the width of the container because we tell the cell how big it should be, not the other way around
        // where the image defines the cell.)
        
        // Similarly, the `titleLabel` is directly below the imageView, with some spacing (see the `constant` in
        // the constraint) so they're not on top of each other. It's leading and trailing anchors match the
        // imageView. Our `detailLabel` will be similar to those constraints, but we have to add a `bottomAnchor` constraint
        // to the container view so the cell has all four sides of its frame accounted for.
        
        // All you need are 4 constraints to add: one for each side of the label. Get to it! If you're not sure
        // where to start, look at the other constraint functions in this class as a reference point.
        
        // ADD YOUR CODE BELOW HERE
        
        return [] // add proper constraints here
        
        // ADD YOUR CODE ABOVE HERE
        
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
