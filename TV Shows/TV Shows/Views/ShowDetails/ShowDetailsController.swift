//
//  ShowDetailsController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 26.07.2021..
//

import Foundation
import UIKit

class ShowDetailsController: UIViewController {
    
    // MARK: - Vars and lets
    /*var userStrong: User = {
        return User(email: "", imageUrl: "", id: "")
    }*/
    var user: User?
    var show: Show?
    private var tableData: [Any] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TVShowDetailsTableViewCell.self),
            for: indexPath
        ) as! TVShowDetailsTableViewCell
        //print(show)
        cell.configure(show: show)
        return cell
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
        //tableData += reviews
    }
}
