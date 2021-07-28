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

class LoginViewController : UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var togglePasswordVisibilityButton: UIButton!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    // MARK: - Hide navigation bar
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

// MARK: - IBActions

private extension LoginViewController {
    
    @IBAction func rememberMePressed() {
        rememberMeButton.isSelected = !rememberMeButton.isSelected
    }
    
    @IBAction func togglePasswordVisibilityPressed() {
        togglePasswordVisibilityButton.isSelected = !togglePasswordVisibilityButton.isSelected
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func loginPressed() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            return
        }
        loginUser(email: email, password: password)
    }
    
    @IBAction func registerPressed() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            return
        }
        registerUser(email: email, password: password)
    }
    
    @IBAction func emailFieldChanged() {
        if shouldEnableLoginAndRegisterButtons() {
            enableLoginAndRegisterButtons()
        } else {
            disableLoginAndRegisterButtons()
        }
    }
    
    @IBAction func passwordFieldChanged() {
        if shouldShowPasswordVisibilityButton() {
            togglePasswordVisibilityButton.isHidden = false
        } else {
            togglePasswordVisibilityButton.isHidden = true
        }
        
        if shouldEnableLoginAndRegisterButtons() {
            enableLoginAndRegisterButtons()
        } else {
            disableLoginAndRegisterButtons()
        }
    }
    
}

// Mark: - Handling login and register actions

private extension LoginViewController {
    
    func loginUser(email: String, password: String) {
        SVProgressHUD.show()
        AuthenticationService.loginUser(email: email, password: password) { [weak self] response in
            guard let self = self else { return }
            self.handleSuccessfulLogin(response: response)
        }
    }
    
    func registerUser(email: String, password: String) {
        SVProgressHUD.show()
        AuthenticationService.registerUser(email: email, password: password) { [weak self] response in
            guard let self = self else { return }
            self.handleSuccessfulRegistration(response: response)
        }
    }
    
    func handleSuccessfulLogin(response: DataResponse<UserResponse, AFError>) {
        let headers = response.response?.headers.dictionary ?? [:]
        guard let authHeaders = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        APIManager.shared.headers = authHeaders
        SVProgressHUD.dismiss()
        navigateToHomeView()
    }
    
    private func handleSuccessfulRegistration(response: DataResponse<UserResponse, AFError>) {
        SVProgressHUD.dismiss()
        loginPressed()
    }
    
    func navigateToHomeView() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerD = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(viewControllerD, animated: true)
    }
}

// MARK: - Utility

private extension LoginViewController {
    
    // MARK: - UI initialization
    
    func initializeUI() {
        initializeTextFields()
        initializeButtons()
    }
    
    func initializeTextFields() {
        setTextFieldPlaceholderColor(emailTextField)
        setTextFieldPlaceholderColor(passwordTextField)
    }
    
    func initializeButtons() {
        togglePasswordVisibilityButton.isHidden = true
        disableLoginAndRegisterButtons()
    }
    
    func setTextFieldPlaceholderColor(_ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.70)])
    }
    
    func shouldShowPasswordVisibilityButton () -> Bool {
        guard
            let password = passwordTextField.text
        else {
            return false
        }
        let passwordIsEmpty = password.trimmingCharacters(in: .whitespaces).isEmpty
        let shouldShow = !passwordIsEmpty
        return shouldShow
    }
    
    func shouldEnableLoginAndRegisterButtons() -> Bool {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
        else {
            return false
        }
        let emailIsEmpty = email.trimmingCharacters(in: .whitespaces).isEmpty
        let passwordIsEmpty = password.trimmingCharacters(in: .whitespaces).isEmpty
        let shouldDisable = emailIsEmpty || passwordIsEmpty
        return !shouldDisable
    }
    
    // MARK: - Login and register button controls
    
    func enableLoginAndRegisterButtons() {
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor.init(white: 1, alpha: 1)
        registerButton.isEnabled = true
    }
    
    func disableLoginAndRegisterButtons() {
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.init(white: 1, alpha: 0.3)
        registerButton.isEnabled = false
    }
    
}
