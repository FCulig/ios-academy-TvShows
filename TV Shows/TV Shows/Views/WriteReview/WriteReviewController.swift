//
//  WriteReview.swift
//  TV Shows
//
//  Created by Infinum Infinum on 28.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

class WriteReviewController: UIViewController {
    
    // MARK: - Vars and lets
    var show: Show?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var reviewTextView: UITextView!
    @IBOutlet private weak var submitReviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
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
            !reviewText.trimmingCharacters(in: .whitespaces).isEmpty
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
        if shouldEnableSubmitButton() {
            enableSubmitButton()
        } else {
            disableSubmitButton()
        }
    }
}

// MARK: - Utilities

private extension WriteReviewController {
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
          )
        navigationItem.title = "Write a Review"
    }
    
    func configureUI() {
        ratingView.isEnabled = true
        disableSubmitButton()
    }
    
    func disableSubmitButton() {
        submitReviewButton.isEnabled = false
        submitReviewButton.alpha = 0.6
    }
    
    func enableSubmitButton() {
        submitReviewButton.isEnabled = true
        submitReviewButton.alpha = 1
    }
    
    func shouldEnableSubmitButton() -> Bool {
        guard
            let reviewText = reviewTextView.text
        else {
            return false
        }
        let reviewIsEmpty = reviewText.trimmingCharacters(in: .whitespaces).isEmpty
        let shouldEnable = !reviewIsEmpty
        return shouldEnable
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
            print(response)
        }
    }
}
