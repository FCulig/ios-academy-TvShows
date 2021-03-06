//
//  WriteReview.swift
//  TV Shows
//
//  Created by Infinum Infinum on 28.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

protocol WriteReviewControllerDelegate: AnyObject {
    func reviewSubmited(submissionResult: Bool)
}

class WriteReviewController: UIViewController {
    
    // MARK: - Vars and lets
    var show: Show?
    weak var delegate: WriteReviewControllerDelegate?
    private var showRating: Int = 0
    private var isTextViewPlaceholderShown: Bool = true
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var reviewTextView: UITextView!
    @IBOutlet private weak var submitReviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.delegate = self
        configureUI()
        configureTextViewDelegate()
    }
    
    @objc private func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - IBActions

private extension WriteReviewController {
    
    @IBAction func submitReviewButtonPressed() {
        guard
            let reviewText = reviewTextView.text,
            !reviewText.trimmingCharacters(in: .whitespaces).isEmpty,
            showRating > 0
        else {
            return
        }
        submitReview(rating: ratingView.rating, review: reviewText)
    }
    
}

extension WriteReviewController: UITextViewDelegate {
    
    private func configureTextViewDelegate() {
        reviewTextView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validateRatingForm()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if isTextViewPlaceholderShown {
            hideTextViewPlaceholder()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
        if isTextViewPlaceholderShown == false {
            showTextViewPlaceholder()
        }
    }
    
}

// MARK: - RatingViewDelegate

extension WriteReviewController: RatingViewDelegate {
    
    func didChangeRating(_ rating: Int) {
        showRating = rating
        validateRatingForm()
    }
    
}

// MARK: - Utilities

private extension WriteReviewController {
    
    func configureUI() {
        ratingView.isEnabled = true
        configureNavigationBar()
        disableSubmitButton()
        showTextViewPlaceholder()
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
          )
        navigationItem.title = "Write a Review"
    }
    
    func shouldEnableSubmitButton() -> Bool {
        let isTextValid = !isReviewTextViewEmpty() && isTextViewPlaceholderShown == false
        let isRatingValid = showRating > 0
        return isTextValid && isRatingValid
    }
    
    func validateRatingForm() {
        if shouldEnableSubmitButton() {
            enableSubmitButton()
        } else {
            disableSubmitButton()
        }
    }
    
    func disableSubmitButton() {
        submitReviewButton.isEnabled = false
        submitReviewButton.alpha = 0.6
    }
    
    func enableSubmitButton() {
        submitReviewButton.isEnabled = true
        submitReviewButton.alpha = 1
    }
    
    func showTextViewPlaceholder() {
        reviewTextView.text = "Enter your comment here..."
        reviewTextView.textColor = .lightGray
        isTextViewPlaceholderShown = true
    }
    
    func hideTextViewPlaceholder() {
        reviewTextView.text = ""
        reviewTextView.textColor = .black
        isTextViewPlaceholderShown = false
    }
    
    func isReviewTextViewEmpty() -> Bool {
        guard
            let reviewText = reviewTextView.text
        else {
            return false
        }
        let reviewIsEmpty = reviewText.trimmingCharacters(in: .whitespaces).isEmpty
        return reviewIsEmpty
    }
    
    func submitReview(rating: Int, review: String) {
        guard let showId = show?.id else {
            SVProgressHUD.showError(withStatus: "Error submitting show review")
            return
        }
        SVProgressHUD.show()
        ReviewsService.postReview(rating: rating, comment: review, showId: showId) { [weak self] response in
            guard
                let self = self
            else {
                SVProgressHUD.showError(withStatus: "Error submitting show review")
                return
            }
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(_):
                self.delegate?.reviewSubmited(submissionResult: true)
            case .failure(_):
                self.delegate?.reviewSubmited(submissionResult: false)
            }
            self.didSelectClose()
        }
    }
}


