//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 11.07.2021..
//

import Foundation
import UIKit

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var togglePasswordVisibilityButton: UIButton!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initializeUI()
    }
    
    private func initializeUI(){
        initializeTextFields()
        initializeButtons()
    }
    
    private func initializeTextFields(){
        addBottomLineToTextField(emailTextField)
        addBottomLineToTextField(passwordTextField)
        emailTextField.addTarget(self, action: #selector(loginFormFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(loginFormFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordFieldChanged(_:)), for: .editingChanged)
    }
    
    private func initializeButtons(){
        togglePasswordVisibilityButton.setImage(UIImage.init(), for: .disabled)
        togglePasswordVisibilityButton.isEnabled = false
        disableLoginButton()
    }
    
    private func addBottomLineToTextField(_ textField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height + 5 ,width: textField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(bottomLine)
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.70)])
    }
    
    @IBAction private func rememberMePressed() {
        rememberMeButton.isSelected = !rememberMeButton.isSelected
    }
    
    @IBAction private func togglePasswordVisibilityPressed() {
        togglePasswordVisibilityButton.isSelected = !togglePasswordVisibilityButton.isSelected
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @objc private func loginFormFieldChanged(_ textField: UITextField) {
        if emailTextField.text != "" && passwordTextField.text != ""{
           enableLoginButton()
        } else {
            disableLoginButton()
        }
    }
    
    @objc private func passwordFieldChanged(_ textField: UITextField) {
        if passwordTextField.text != ""{
            togglePasswordVisibilityButton.isEnabled = true
        } else {
            togglePasswordVisibilityButton.isEnabled = false
        }
    }
    
    private func enableLoginButton(){
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.init(white: 1, alpha: 1)
        registerButton.alpha = 1
    }
    
    private func disableLoginButton() {
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        registerButton.alpha = 0.7
    }
}
