//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 11.07.2021..
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet private weak var touchCounterLabel: UILabel!
    @IBOutlet private weak var touchCounterButton: UIButton!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingIndicatorLabel: UILabel!
    
    private var numberOfClicks: Int = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        showLoadingScreen()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.hideLoadingScreen()
        })
    }
    
    @IBAction private func buttonPressed() {
        numberOfClicks += 1
        configureUI()
    }
    
    private func configureUI(){
        touchCounterLabel.text = String(numberOfClicks)
    }
    
    private func showLoadingScreen(){
        loadingIndicator.startAnimating()
        touchCounterLabel.isHidden = true
        touchCounterButton.isHidden = true
    }
    
    private func hideLoadingScreen(){
        loadingIndicator.stopAnimating()
        loadingIndicatorLabel.isHidden = true
        touchCounterLabel.isHidden = false
        touchCounterButton.isHidden = false
    }
    
}
