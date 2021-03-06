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
import KeychainAccess

class LoginViewController : UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var togglePasswordVisibilityButton: UIButton!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var formStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        animateUI()
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
        
        guard
            let userData = try? response.result.get(),
            let authInfo = try? AuthInfo(headers: headers)
        else {
            SVProgressHUD.showError(withStatus: "Error while trying to login")
            return
        }
        
        APIManager.shared.authInfo = authInfo
        
        if rememberMeButton.isSelected {
            storeAuthInfoToDevice(authInfo: authInfo)
        }
        
        let homeViewController = instantiateHomeViewController(userData: userData)
        navigateToViewController(viewController: homeViewController)
    }
    
    private func instantiateHomeViewController(userData: UserResponse?) -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: HomeViewController.self)
        ) as! HomeViewController
        return homeViewController
    }
    
    private func handleSuccessfulRegistration(response: DataResponse<UserResponse, AFError>) {
        SVProgressHUD.dismiss()
        loginPressed()
    }
    
    func navigateToViewController(viewController: UIViewController) {
        navigationController?.setViewControllers([viewController], animated: true)
    }
}

// MARK: - Utility

private extension LoginViewController {
    
    // MARK: - KeychainAccess
    
    func storeAuthInfoToDevice(authInfo: AuthInfo) {
        guard let encodedAuthInfo = try? JSONEncoder().encode(authInfo) else { return }
        KeychainManager.shared.storeObject(key: "authInfo", value: encodedAuthInfo)
    }
    
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
    
    func animateUI() {
        formStackView.transform = CGAffineTransform(translationX: 0, y: 200)
        formStackView.alpha = 0
        UIView.animateKeyframes(
            withDuration: 2,
            delay: 0,
            options: [],
            animations: {
                self.formStackView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.formStackView.alpha = 1
            })
    }
}
