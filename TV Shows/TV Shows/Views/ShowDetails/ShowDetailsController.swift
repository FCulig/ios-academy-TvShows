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
    /*var userStrong: User = {
        return User(email: "", imageUrl: "", id: "")
    }*/
    var user: User?
    var show: Show?
    var reviews: [Review] = []
    private var tableData: [Any] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReviews()
        configureUI()
        configureTableData()
    }
    
    // MARK: - Reseting size of navigation bar
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

// MARK: - UITableViewDelegate

extension ShowDetailsController: UITableViewDelegate {
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }
    
}

// MARK: - UITableViewDataSource

extension ShowDetailsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
        
        return UITableViewCell()
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
    
    func configureTableData() {
        tableData.append(show as Any)
    }
    
    func getReviews() {
        guard
            let show = show
        else {
            SVProgressHUD.showError(withStatus: "Error occured while displaying show details")
            return
        }
        SVProgressHUD.show()
        ReviewsService.getReviews(showId: show.id, page: 1, items: 50) { [weak self] response in
            guard
                let self = self,
                let reviews = try? response.result.get().reviews
            else {
                SVProgressHUD.showError(withStatus: "Error while fetching reviews")
                return
            }
            SVProgressHUD.dismiss()
            self.reviews += reviews
            self.tableData += self.reviews
            self.tableView.reloadData()
        }
    }
}