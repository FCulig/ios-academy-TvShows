//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 19.07.2021..
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    var userResponse: UserResponse?
    
    let shows: [String] = [
        "A",
        "B",
        "C",
        "D",
        "A",
        "B",
        "C",
        "D",
        "A",
        "B",
        "C",
        "D",
        "A",
        "B",
        "C",
        "D",
        "A",
        "B",
        "C",
        "D",
    ]
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.dataSource = self
        getTVShows(page: 1, items: 20)
    }
    
    // MARK: - Show navigation bar

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        cell.showNameLabel.text = shows[indexPath.row]
        return cell
    }
}


// MARK: - Utilites

private extension HomeViewController {
    
    func getTVShows(page: Int?, items: Int?) {
        ShowsService.getShows(page: page, items: items) { [weak self] response in
            guard let self = self else { return }
            print(response.result)
        }
    }
    
}
