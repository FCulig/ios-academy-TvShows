//
//  ShowDetailsController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 26.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

class ShowDetailsController: UIViewController {
    
    // MARK: - Vars and lets
    
    var show: Show?
    var reviews: [Review] = []
    var reviewPagination: Pagination?
    private var tableData: [Any] = []
    private let items: Int = 20
    private var isFetchingReviews: Bool = false
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReviews(page: 1, items: items)
        configureUI()
    }
    
    // MARK: - Reseting size of navigation bar
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - IBActions

private extension ShowDetailsController {
  
    @IBAction func writeReviewButtonPressed() {
        presentWriteReviewScreen()
    }
    
}

// MARK: - UITableViewDelegate

extension ShowDetailsController: UITableViewDelegate {
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorColor = .white
        tableData = [show, "No reviews yet."]
    }
    
}

// MARK: - UITableViewDataSource

extension ShowDetailsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = tableData[indexPath.row]
        
        if type(of: cellData) == Optional<Show>.self {
            guard let show = cellData as? Show else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TVShowDetailsTableViewCell.self),
                for: indexPath
            ) as! TVShowDetailsTableViewCell
            cell.configure(show: show)
            return cell
        }
        
        if type(of: cellData) == Review.self {
            guard let review = cellData as? Review else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: TVShowReviewTableViewCell.self),
                for: indexPath
            ) as! TVShowReviewTableViewCell
            cell.configure(review: review)
            return cell
        }
        
        if type(of: cellData) == String.self {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "NoReviewsTableViewCell",
                for: indexPath
            )
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - Implementation of infinite scrolling

extension ShowDetailsController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldFetchReviews(scrollView: scrollView) {
            guard let currentPage = reviewPagination?.page else { return }
            getReviews(page: currentPage + 1, items: items)
        }
    }
    
    private func shouldFetchReviews(scrollView: UIScrollView) -> Bool {
        let position = scrollView.contentOffset.y
        let currentHeight = tableView.contentSize.height - 100 - scrollView.frame.height
        guard let totalPages = reviewPagination?.pages else { return false }
        guard let currentPage = reviewPagination?.page else { return  false}
        return position > currentHeight && !isFetchingReviews && totalPages > currentPage
    }
    
}

// MARK: - Utilities

private extension ShowDetailsController {
    
    func configureUI() {
        configureTableView()
        setNavigationBarTitle(title: show?.title)
    }
    
    func setNavigationBarTitle(title: String?) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = title
    }
    
    func presentWriteReviewScreen() {
        let storyboard = UIStoryboard(name: "WriteReview", bundle: nil)
        let writeReviewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: WriteReviewController.self)
        ) as! WriteReviewController
        writeReviewController.show = show
        writeReviewController.delegate = self
        let navigationController = UINavigationController(rootViewController: writeReviewController)
        present(navigationController, animated: true)
    }
    
    func getReviews(page: Int, items: Int) {
        guard let show = show else {
            SVProgressHUD.showError(withStatus: "Error occured while displaying show details")
            return
        }
        SVProgressHUD.show()
        isFetchingReviews = true
        ReviewsService.getReviews(showId: show.id, page: page, items: items) { [weak self] response in
            guard
                let self = self,
                let reviews = try? response.result.get().reviews,
                let pagination = try? response.result.get().meta.pagination
            else {
                SVProgressHUD.showError(withStatus: "Error while fetching reviews")
                return
            }
            
            if reviews.count > 0 {
                self.tableData = [show]
                self.tableView.separatorColor = .lightGray
            }
            
            SVProgressHUD.dismiss()
            self.isFetchingReviews = false
            self.reviews += reviews
            self.tableData = [self.show]
            self.tableData += self.reviews
            self.reviewPagination = pagination
            self.tableView.reloadData()
        }
    }
}

extension ShowDetailsController: WriteReviewControllerDelegate {
    
    func reviewSubmited(submissionResult: Bool) {
        guard submissionResult else { return }
        reviews = []
        tableData = [show]
        guard let currentPage = reviewPagination?.page else { return }
        getReviews(page: currentPage, items: items)
    }
}
