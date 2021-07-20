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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
            enableLoginAndRegisterButtons()
        } else {
            disableLoginAndRegisterButtons()
        }
    }
    
    @objc private func passwordFieldChanged(_ textField: UITextField) {
        if passwordTextField.text != ""{
            togglePasswordVisibilityButton.isHidden = false
        } else {
            togglePasswordVisibilityButton.isHidden = true
        }
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
        disableLoginAndRegisterButtons()
    }
    
    private func setTextFieldPlaceholderColor(_ textField: UITextField){
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.70)])
    }
    
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
    
    @IBAction private func loginPressed() {
        let parameters: [String: String] = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "password_confirmation": passwordTextField.text!
        ]
        
        loginUser(parameters: parameters)
    }
    
    @IBAction private func registerPressed() {
        let parameters: [String: String] = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "password_confirmation": passwordTextField.text!
        ]
        
        registerUser(parameters: parameters)
    }
    
    private func registerUser(parameters: [String: String]){
        SVProgressHUD.show()
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(_):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self?.loginUser(parameters: parameters)
                case .failure(var error):
                    // TODO: Pokazi error s backenda
                    SVProgressHUD.showError(withStatus: "Error processing request")
                }
            }
    }
    
    private func loginUser(parameters: [String: String]){
        SVProgressHUD.show()
        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(let userResponse):
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self?.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }
    
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        SVProgressHUD.dismiss()
        navigateToHomeView()
    }
    
    private func navigateToHomeView(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewControllerD = storyboard.instantiateViewController(withIdentifier: "HomeView")
        navigationController?.pushViewController(viewControllerD, animated: true)
    }
}
