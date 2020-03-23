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
        
        // TODO: Set up a review!
        
        // In this function, we're setting up `ReviewViewController` to present an existing view.
        // We are given a review object that comes from the device's memory. We have to set a few
        // UI componenets to display the review's information. Specifically, we have to set:
        
        // dateLabel: A UILabel that shows when the review was created or updated.
        // starRatingView: A UIView that displays the rating of the review.
        // reviewTextView: a UITextView that allows the user to view or edit the review description.
        
        // Helper Functions
        // `formattedDateString` will return a readable description of a Date object.
        
        // Remember, always try adding a "." after a unknown data type to see what properties or functions
        // you can use in it. When autocomplete gives you a function, you can double-click the placeholder
        // values to get the class name and then type a "." after to see how you could use it.
        
        // YOUR CODE STARTS HERE
        
        
        
        // YOUR CODE ENDS HERE

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
        } else {
            let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(didTapDelete))
            navigationItem.rightBarButtonItem = deleteButton
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
        // Hide dateReviewedLabel and dateLabel based on context.
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
    
    @objc func didTapSave() {
        saveReview()
        dismissViewController()
    }
    
    @objc func didTapDelete() {
        presentDeletionConfirmation()
    }
    
    // MARK: - Helper Functions
    
    @objc func saveReview() {
        
        // TODO: Save a review!
        
        // This file, `ReviewViewController`, manages the experience when the user is viewing or creating an album review.
        // This function, `saveReview`, fires when the textfield is updated, star rating is changed, or the save button is tapped.
        // Note: A user could be updating an existing review (which auto-saves), or creating a new review.
        
        // You will need to access data from these sources:
        //     1. starRatingView: The view that shows the number of selected stars for the review.
        //     2. reviewTextView: The textfield used for entering the review text itself.
        //     3. getExistingReview(): This will return an existing review for the current album if it exists;
        //        Otherwise, it will be nil.
        //     4. savedReviews: This object allows you to get saved reviews on device and save new reviews.
        
        // Hint: Auto-complete is your friend! Type "." after any the above objects to see what properties and functions you can
        // use to save the review!
        
        // Some Potential Gotchas
        //     1. Is there a situation wher e you wouldn't want to save a review due to invalid data? To handle that scenario, you
        //     could use `return` to end the function execution, and maybe use a helper functinon called `presentErrorAlert`.
        //     2. If you're updating an existing review, how do you make sure only the updated review information is saved?

        
        // YOUR CODE STARTS HERE
        
        
        
        // YOUR CODE ENDS HERE
        
        
        // This function will be called on the main collection view controller to refresh its data
        // based on the reviews saved to the device.
        delegate?.updateMediaContent()
    }
    
    func getExistingReview() -> Review? {
        return savedReviews.get().first(where: { $0.media == media })
    }
    
    func dismissViewController() {
        if navigationController?.viewControllers.first is MainCollectionViewController {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    func presentDeletionConfirmation() {
        let title = "Delete Review"
        let message = "Are you sure you want to delete your review of \(media.albumName)?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler:  { (_) in
            self.deleteReview()
            self.dismissViewController()
        })
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
    
    func deleteReview() {
        if let existingReview = getExistingReview() {
            savedReviews.remove(existingReview)
            delegate?.updateMediaContent()
        }
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
    public func didTapPrimaryButtonView() {
        if isSwiftPlayground {
            presentErrorAlert(title: "Feature Unavailable", message: "This feature isn't available in Swift Playgrounds.", on: self)
        } else {
            guard let link = URL(string: media.url) else { return }
            let safariViewController = SFSafariViewController(url: link)
            present(safariViewController, animated: true)
        }
    }
}
