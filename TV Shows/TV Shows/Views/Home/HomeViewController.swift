//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 19.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD

class HomeViewController : UIViewController {
    
    // MARK: Lets and vars
    
    var user: UserResponse?
    private var paginationInfo: Pagination?
    private var shows: [Show] = []
    private let items: Int = 20
    private var isFetchingShows: Bool = false
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureTableView()
        getTVShows(page: 1, items: items)
    }
    
    // MARK: - Show navigation bar

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: ShowDetailsController.self)
        ) as! ShowDetailsController
        showDetailsViewController.show = shows[indexPath.row]
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TVShowTableViewCell.self),
            for: indexPath
        ) as! TVShowTableViewCell
        cell.configure(show: shows[indexPath.row])
        return cell
    }
    
}

// MARK: - Implementation of infinite scrolling

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldFetchShows(scrollView: scrollView) {
            getTVShows(page: getCurrentPage() + 1, items: items)
        }
    }
    
    private func shouldFetchShows(scrollView: UIScrollView) -> Bool {
        let position = scrollView.contentOffset.y
        let currentHeight = tableView.contentSize.height - 100 - scrollView.frame.height
        guard let totalPages = paginationInfo?.pages else { return false }
        return position > currentHeight && !isFetchingShows && totalPages > getCurrentPage()
    }
    
}


// MARK: - Utilites

private extension HomeViewController {
    
    func getTVShows(page: Int?, items: Int?) {
        SVProgressHUD.show()
        isFetchingShows = true
        ShowsService.getShows(page: page, items: items) { [weak self] response in
            guard
                let self = self,
                let shows = try? response.result.get().shows,
                let paginationInfo = try? response.result.get().meta.pagination
            else {
                SVProgressHUD.showError(withStatus: "Error while fetching shows")
                return
            }
            SVProgressHUD.dismiss()
            self.isFetchingShows = false
            self.shows += shows
            self.paginationInfo = paginationInfo
            self.tableView.reloadData()
        }
    }
    
    private func getCurrentPage() -> Int {
        guard let currentPage = paginationInfo?.page else { return 0 }
        return currentPage
    }
}
