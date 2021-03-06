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
    
    private var paginationInfo: Pagination?
    private var shows: [Show] = []
    private let items: Int = 20
    private var isFetchingShows: Bool = false
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        subscribeToLogoutNotification()
        configureNavigationBar()
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
        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)
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
    
    func configureNavigationBar() {
         let profileDetailsButton = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(presentUserProfile)
          )
        profileDetailsButton.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        navigationItem.rightBarButtonItem = profileDetailsButton
    }
    
    @objc func presentUserProfile() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: ProfileViewController.self)
        ) as! ProfileViewController
        let navigationController = UINavigationController(rootViewController: profileViewController)
        present(navigationController, animated: true)
    }
    
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
    
    @objc private func refresh() {
        shows = []
        getTVShows(page: 1, items: items)
    }
    
    // MARK: - Notifications
    
    func subscribeToLogoutNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(openLoginScreen), name: Notification.Name("didLogout"), object: nil)
    }
    
    @objc func openLoginScreen() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: LoginViewController.self)
        ) as! LoginViewController
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
