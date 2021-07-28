//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 19.07.2021..
//

import Foundation
import UIKit

class HomeViewController : UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    // MARK: - Show navigation bar

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
