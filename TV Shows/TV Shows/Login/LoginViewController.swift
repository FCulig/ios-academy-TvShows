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
    
    var touchCounter = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        updateDisplay()
    }
    
    @IBAction func buttonTouched(_ sender: Any) {
        touchCounter+=1
        updateDisplay()
    }
    
    func updateDisplay(){
        touchLabel.text = String(touchCounter)
    }
}
