//
//  ReviewViewController.swift
//  Jukeboxd
//
//  Created by Matthew Barker on 2/16/20.
//  Copyright © 2020 Matthew Barker. All rights reserved.
//

import UIKit
import SafariServices

private extension CGFloat {
    static let horizontalInset: CGFloat = 20
    static let containerViewTopSpacing: CGFloat = 20
    static let titleDetailLabelVerticalSpacing: CGFloat = 8
    static let componentVerticalSpacing: CGFloat = 16
}

class ReviewViewController: UIViewController {
    
    var media: Media
    var delegate: MediaCollectionViewDelegate?
    
    private let savedReviews = Preferences<Review>()
    private var textViewTimer: Timer?
    
    var isNewReview: Bool {
        return navigationController?.viewControllers.first is SearchResultsViewController
    }
    
    // MARK: - View Life Cycle
    
    /// Create a new review for `media`
    init(media: Media, delegate: MediaCollectionViewDelegate? = nil) {
        self.media = media
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    /// View and edit an existing review
    convenience init(review: Review, delegate: MediaCollectionViewDelegate? = nil) {
        self.init(media: review.media, delegate: delegate)
        
        dateLabel.text = formattedDateString(for: review.dateCreated)
        starRatingView.setState(to: .value(review.rating))
        reviewTextView.text = review.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        if isNewReview {
            // Only show Save on new reviews; all other changes are auto-saved.
            let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
            saveButton.isEnabled = false
            navigationItem.rightBarButtonItem = saveButton
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupViewController() {
        view.backgroundColor = .systemBackground
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setupViews()
    }
    
    // MARK: - UI Elements
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var mediaView: MediaView!
    
    var mediaViewRatingSpacer: SeparatorView = {
        return SeparatorView()
    }()
    
    var dateReviewedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "Date Reviewed"
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    var starRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "Rating"
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    var starRatingView: StarRatingView = {
        return StarRatingView(state: .empty)
    }()
    
    var starRatingTextViewSpacer: SeparatorView = {
        return SeparatorView()
    }()
    
    private let placeholderText = "Add review..."
    
    var keyboardToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneOnKeyboard))
        toolbar.items = [flexSpace, doneButton]
        return toolbar
    }()
    
    var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled  = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = true
        textView.textColor = .label
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.allowsEditingTextAttributes = true
        return textView
    }()
    
    // MARK: - UI Helper Functions
    
    func setupViews() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        //  Scroll View & Container View
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        // Media View
        mediaView = MediaView(media: media, delegate: self)
        containerView.addSubview(mediaView)
        
        // First Spacer
        containerView.addSubview(mediaViewRatingSpacer)
        
        // Date Reviewed Label
        containerView.addSubview(dateReviewedLabel)
        dateReviewedLabel.isHidden = isNewReview
        
        // Date Label
        containerView.addSubview(dateLabel)
        dateLabel.isHidden = isNewReview
        
        // Star Rating Label
        containerView.addSubview(starRatingLabel)
        
        // Star Rating
        starRatingView.delegate = self
        containerView.addSubview(starRatingView)
        
        // Second Spacer
        containerView.addSubview(starRatingTextViewSpacer)
        
        // Text Editor
        reviewTextView.delegate = self
        reviewTextView.inputAccessoryView = keyboardToolbar
        if reviewTextView.text.isEmpty {
            reviewTextView.text = placeholderText
        }
        containerView.addSubview(reviewTextView)
    }
    
    // MARK: - Constraints
        
    func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints += addScrollViewConstraints()
        constraints += addContainerViewConstraints()
        constraints += addMediaViewConstraints()
        constraints += addMediaViewRatingSpacerConstraints()
        constraints += addDateReviewedLabelConstraints()
        constraints += addDateLabelConstraints()
        constraints += addStarRatingLabelConstraints()
        constraints += addStarRatingViewConstraints()
        constraints += addStarRatingTextViewSpacerConstraints()
        constraints += addReviewTextViewConstraints()
        NSLayoutConstraint.activate(constraints)
    }
    
    func addScrollViewConstraints() -> [NSLayoutConstraint] {
        return [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .horizontalInset),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -.horizontalInset),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
    }
    
    func addContainerViewConstraints() -> [NSLayoutConstraint] {
        return [
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .containerViewTopSpacing),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
    }
    
    func addMediaViewConstraints() -> [NSLayoutConstraint] {
        return [
            mediaView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mediaView.topAnchor.constraint(equalTo: containerView.topAnchor),
        ]
    }
    
    func addMediaViewRatingSpacerConstraints() -> [NSLayoutConstraint] {
        return [
            mediaViewRatingSpacer.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: SeparatorView.preferredSpacing),
            mediaViewRatingSpacer.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            mediaViewRatingSpacer.heightAnchor.constraint(equalToConstant: SeparatorView.preferredHeight),
        ]
    }
    
    func addDateReviewedLabelConstraints() -> [NSLayoutConstraint] {
        return [
            dateReviewedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateReviewedLabel.topAnchor.constraint(equalTo: mediaViewRatingSpacer.bottomAnchor, constant: SeparatorView.preferredSpacing),
        ]
    }
    
    func addDateLabelConstraints() -> [NSLayoutConstraint] {
        return [
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: dateReviewedLabel.bottomAnchor, constant: .titleDetailLabelVerticalSpacing),
        ]
    }
    
    func addStarRatingLabelConstraints() -> [NSLayoutConstraint] {
        // Hide dateReviewedLabel and dateLabel based on contxt.
        var topAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>
        var topAnchorConstant: CGFloat
        if isNewReview {
            topAnchor = mediaViewRatingSpacer.bottomAnchor
            topAnchorConstant = SeparatorView.preferredSpacing
        } else {
            topAnchor = dateLabel.bottomAnchor
            topAnchorConstant = .componentVerticalSpacing
        }
        return [
            starRatingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            starRatingLabel.topAnchor.constraint(equalTo: topAnchor, constant: topAnchorConstant),
        ]
    }
    
    func addStarRatingViewConstraints() -> [NSLayoutConstraint] {
        return [
            starRatingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            starRatingView.topAnchor.constraint(equalTo: starRatingLabel.bottomAnchor, constant: .titleDetailLabelVerticalSpacing),
        ]
    }
    
    func addStarRatingTextViewSpacerConstraints() -> [NSLayoutConstraint] {
        return [
            starRatingTextViewSpacer.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: SeparatorView.preferredSpacing),
            starRatingTextViewSpacer.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            starRatingTextViewSpacer.heightAnchor.constraint(equalToConstant: SeparatorView.preferredHeight),
        ]
    }
    
    func addReviewTextViewConstraints() -> [NSLayoutConstraint] {
        return [
            reviewTextView.topAnchor.constraint(equalTo: starRatingTextViewSpacer.bottomAnchor, constant: SeparatorView.preferredSpacing),
            reviewTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            reviewTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            reviewTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ]
    }
    
    // MARK: - Selectors
    
    @objc func didTapView(sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: containerView)
        // Begin text editing if the view is tapped  at or below the text view.
        if touchLocation.y > reviewTextView.frame.minY {
            reviewTextView.becomeFirstResponder()
        }
    }
    
    @objc func didTapDoneOnKeyboard() {
        reviewTextView.resignFirstResponder()
    }
        
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc func didTapSave() {
        saveReview()
        
        if navigationController?.viewControllers.first is MainCollectionViewController {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc func saveReview() {
        // Rating
        guard let rating = starRatingView.getValue() else {
            presentErrorAlert(title: "Invalid Review", message: "You have to provide a rating to save a review!", on: self)
            return
        }
        // Review
        var reviewDescription = reviewTextView.text
        if reviewDescription == placeholderText {
            reviewDescription = nil
        }
        // Save
        if var existingReview = savedReviews.get().first(where: { $0.media == media }) {
            savedReviews.remove(existingReview)
            existingReview.dateUpdated = Date()
            existingReview.rating = rating
            existingReview.description = reviewDescription
            savedReviews.add(existingReview)
        } else {
            let newReview = Review(media: media, rating: rating, description: reviewDescription)
            savedReviews.add(newReview)
        }
        delegate?.updateMediaContent()
    }
        
}

// MARK: - UITextViewDelegate
extension ReviewViewController: UITextViewDelegate {
            
    private func isTextViewEmptyOrPlaceholder(in textView: UITextView) -> Bool {
        return textView.text.isEmpty || textView.text == placeholderText
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
           textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewTimer?.invalidate()
        textViewTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self,
                                              selector: #selector(saveReview),
                                              userInfo: nil,
                                              repeats: false)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
        }
        if !isTextViewEmptyOrPlaceholder(in: textView) && !isNewReview {
            navigationItem.rightBarButtonItem?.isEnabled = true
            saveReview()
        }
    }
}

// MARK: - StarRatingViewDelegate
extension ReviewViewController: StarRatingViewDelegate {
    func didUpdateStarRating() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        if !isNewReview {
            saveReview()
        }
    }
}

// MARK: - MediaViewDelegate
extension ReviewViewController: MediaViewDelegate {
    func didTapPrimaryButtonView() {
        guard let link = URL(string: media.url) else { return }
        let safariViewController = SFSafariViewController(url: link)
        present(safariViewController, animated: true)
    }
}
