//
//  ProfileViewController.swift
//  TV Shows
//
//  Created by Infinum Infinum on 04.08.2021..
//

import Foundation
import UIKit
import SVProgressHUD

class ProfileViewController: UIViewController {
    
    // MARK: - Vars and lets
    private let imagePicker = UIImagePickerController()
    private var user: User?
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getCurrentUser()
        configureImagePicker()
        configureNavigationBar()
    }
    
}

// MARK: - UIImagePickerController

extension ProfileViewController: UIImagePickerControllerDelegate {
    
    private func configureImagePicker() {
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let imageData = pickedImage.jpegData(compressionQuality: 0.9) else { return }
            updateProfileImage(imageData: imageData)
        }

        dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate {
    
    private func showImagePicker() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
                
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - IBActions

extension ProfileViewController {
    
    @IBAction func logoutButtonPressed() {
    }
    
    @IBAction func changeProfileImageButtonPressed() {
        showImagePicker()
    }
}

// MARK: - Utilities

private extension ProfileViewController {
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
          )
        navigationItem.title = "My account"
    }
    
    @objc private func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }

    func getCurrentUser() {
        SVProgressHUD.show()
        UserService.getCurrentUser { [weak self] response in
            guard
                let self = self,
                let user = try? response.result.get().user
            else {
                SVProgressHUD.showError(withStatus: "Error while fetching user information")
                return
            }
            self.configureUI(user: user)
            SVProgressHUD.dismiss()
        }
    }
    
    func configureUI(user: User) {
        emailLabel.text = user.email
        guard let imageUrl = user.imageUrl else { return }
        ImageManager.shared.getImage(
            imageView: profileImage,
            imageUrl: URL(string: imageUrl),
            placeholderImage: UIImage(named: "ic-profile-placeholder")
        )
    }
    
    func updateProfileImage(imageData: Data) {
        SVProgressHUD.show()
        guard let email = user?.email else { return }
        UserService.updateProfileImage(image: imageData, email: email) { [weak self] response in
            guard
                let self = self,
                let user = try? response.result.get().user
            else {
                SVProgressHUD.showError(withStatus: "Error while fetching user information")
                return
            }
            self.configureUI(user: user)
            SVProgressHUD.dismiss()
        }
    }
}
