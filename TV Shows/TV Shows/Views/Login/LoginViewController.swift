//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 11.07.2021..
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
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
    
    // MARK: - Overrides to remove navigation bar from login screen
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - IBActions
    
    @IBAction private func rememberMePressed() {
        rememberMeButton.isSelected = !rememberMeButton.isSelected
    }
    
    @IBAction private func togglePasswordVisibilityPressed() {
        togglePasswordVisibilityButton.isSelected = !togglePasswordVisibilityButton.isSelected
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction private func loginPressed() {
        loginUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction private func registerPressed() {
        registerUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction private func emailFieldChanged() {
        if emailTextField.text != "" && passwordTextField.text != ""{
            enableLoginAndRegisterButtons()
        } else {
            disableLoginAndRegisterButtons()
        }
    }
    
    @IBAction private func passwordFieldChanged() {
        if passwordTextField.text != ""{
            togglePasswordVisibilityButton.isHidden = false
        } else {
            togglePasswordVisibilityButton.isHidden = true
        }
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            enableLoginAndRegisterButtons()
        } else {
            disableLoginAndRegisterButtons()
        }
    }
    
    // MARK: - UI initialization
    
    private func initializeUI(){
        initializeTextFields()
        initializeButtons()
    }
    
    private func initializeTextFields(){
        setTextFieldPlaceholderColor(emailTextField)
        setTextFieldPlaceholderColor(passwordTextField)
    }
    
    private func initializeButtons(){
        togglePasswordVisibilityButton.isHidden = true
        disableLoginAndRegisterButtons()
    }
    
    private func setTextFieldPlaceholderColor(_ textField: UITextField){
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.70)])
    }
    
    // MARK: - Login and register button controls
    
    private func enableLoginAndRegisterButtons(){
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.init(white: 1, alpha: 1)
        registerButton.isEnabled = true
    }
    
    private func disableLoginAndRegisterButtons() {
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        registerButton.isEnabled = false
    }
}

extension LoginViewController {
    
    // Mark: - Handling login and register actions
    
    private func loginUser(email: String, password: String){
        AuthenticationService.loginUser(email: email, password: password, onSuccess: handleSuccessfulLogin)
    }
    
    private func registerUser(email: String, password: String){
        AuthenticationService.registerUser(email: email, password: password, onSuccess: handleSuccessfulRegistration)
    }
    
    private func handleSuccessfulLogin(response: DataResponse<UserResponse, AFError>){
        let headers = response.response?.headers.dictionary ?? [:]
        guard let authHeaders = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        APIManager.shared.headers = authHeaders
        SVProgressHUD.dismiss()
        navigateToHomeView()
    }
    
    private func handleSuccessfulRegistration(response: DataResponse<UserResponse, AFError>){
        SVProgressHUD.dismiss()
        loginPressed()
    }
    
    // MARK: - Navigation
    
    private func navigateToHomeView(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerD = storyboard.instantiateViewController(withIdentifier: "HomeView")
        navigationController?.pushViewController(viewControllerD, animated: true)
    }
}
