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
    
    var userResponse: UserResponse?
    private var shows: [Show] = []
    private let incrementSize: Int = 20
    private var page: Int = 1
    private var items: Int = 20
    private var isFetchingShows: Bool = false
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureTableView()
        getTVShows(page: page, items: items)
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
    
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
            page += 1
            items += incrementSize
            getTVShows(page: page, items: items)
        }
    }
    
    private func shouldFetchShows(scrollView: UIScrollView) -> Bool {
        let position = scrollView.contentOffset.y
        let currentHeight = tableView.contentSize.height - 100 - scrollView.frame.height
        return position > currentHeight && isFetchingShows == false
    }
    
}


// MARK: - Utilites

private extension HomeViewController {
    
    func getTVShows(page: Int?, items: Int?) {
        SVProgressHUD.show()
        isFetchingShows = true
        ShowsService.getShows(page: page, items: items) { [weak self] response in
            guard let self = self else { return }
            // print(response.result)
            SVProgressHUD.dismiss()
            self.isFetchingShows = false
            
            switch response.result {
            case .success(let showData):
                self.shows += showData.shows
            default:
                SVProgressHUD.showError(withStatus: "Error while trying to login")
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
}
