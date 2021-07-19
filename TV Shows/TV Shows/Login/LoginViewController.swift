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
        setTextFieldPlaceholderColor(emailTextField)
        setTextFieldPlaceholderColor(passwordTextField)
        emailTextField.addTarget(self, action: #selector(loginFormFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(loginFormFieldChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordFieldChanged(_:)), for: .editingChanged)
    }
    
    private func initializeButtons(){
        togglePasswordVisibilityButton.isHidden = true
        disableLoginButton()
    }
    
    private func setTextFieldPlaceholderColor(_ textField: UITextField){
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.70)])
    }
    
    @IBAction private func rememberMePressed() {
        rememberMeButton.isSelected = !rememberMeButton.isSelected
    }
    
    @IBAction private func togglePasswordVisibilityPressed() {
        togglePasswordVisibilityButton.isSelected = !togglePasswordVisibilityButton.isSelected
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction private func loginPressed() {
        navigateToHomeController()
    }
    
    @IBAction private func registerPressed() {
       navigateToHomeController()
    }
    
    private func navigateToHomeController(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerD = storyboard.instantiateViewController(withIdentifier: "HomeView")
        navigationController?.pushViewController(viewControllerD, animated: true)
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
            togglePasswordVisibilityButton.isHidden = false
        } else {
            togglePasswordVisibilityButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
