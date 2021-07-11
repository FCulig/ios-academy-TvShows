//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 11.07.2021..
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var touchLabel: UILabel!
    @IBOutlet weak var touchButton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var loadingText: UILabel!
    
    var touchCounter = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        showLoadingScreen()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.hideLoadingScreen()
        })
    }
    
    @IBAction func buttonTouched(_ sender: Any) {
        touchCounter+=1
        updateDisplay()
    }
    
    func updateDisplay(){
        touchLabel.text = String(touchCounter)
    }
    
    func showLoadingScreen(){
        loader.startAnimating()
        touchLabel.isHidden = true
        touchButton.isHidden = true
    }
    
    func hideLoadingScreen(){
        loader.stopAnimating()
        loadingText.isHidden = true
        touchLabel.isHidden = false
        touchButton.isHidden = false
    }
    
}
