//
//  MediaView.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/16/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit

extension CGFloat {
    static let albumTrailingSpacing: CGFloat = 12
    static let labelVerticalSpacing: CGFloat = 2
    static let buttonViewBottomSpacing: CGFloat = -4
}

protocol MediaViewDelegate {
    func didTapPrimaryButtonView()
}

class MediaView: UIView {
    
    private let imageViewWidth: CGFloat = 128
    
    var media: Media!
    var delegate: MediaViewDelegate!
    
    init(media: Media, delegate: MediaViewDelegate) {
        self.media = media
        self.delegate = delegate
        super.init(frame: .init(x: 0, y: 0, width: 300, height: 200))
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var buttonView: LabelView = {
        let view = LabelView(
            text: "View".uppercased(),
            color: .systemBlue,
            font: .systemFont(ofSize: 16, weight: .bold)
        )
        return view
    }()
    
    func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapButtonView))
        addGestureRecognizer(tapGestureRecognizer)
        
        addSubviews()
        setupConstraints()
        setMedia()
    }
    
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
        containerView.addSubview(buttonView)
    }
    
    func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints += createContainerViewConstraints()
        constraints += createImageViewConstraints()
        constraints += createTitleLabelConstraints()
        constraints += createDetailLabelConstraints()
        constraints += createButtonViewConstraints()
        NSLayoutConstraint.activate(constraints)
    }
    
    func createContainerViewConstraints() -> [NSLayoutConstraint] {
        return [
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }
    
    func createImageViewConstraints() -> [NSLayoutConstraint] {
        return [
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageViewWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ]
    }
    
    func createTitleLabelConstraints() -> [NSLayoutConstraint] {
        return [
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .albumTrailingSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: .labelVerticalSpacing),
        ]
    }
    
    func createDetailLabelConstraints() -> [NSLayoutConstraint] {
        return [
            detailLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .albumTrailingSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .labelVerticalSpacing),
        ]
    }
    
    func createButtonViewConstraints() -> [NSLayoutConstraint] {
        return [
            buttonView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .albumTrailingSpacing),
            buttonView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .buttonViewBottomSpacing),
        ]
    }
    
    func setMedia() {
        titleLabel.text = media.albumName
        detailLabel.text = media.artistName
        imageView.loadImage(fromURL: media.imageURL)
    }
    
    @objc func didTapButtonView() {
        delegate.didTapPrimaryButtonView()
    }
    
}
