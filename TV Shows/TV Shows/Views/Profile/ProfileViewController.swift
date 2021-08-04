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
    private var user: UserResponse?
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getCurrentUser()
        configureNavigationBar()
    }
    
}

extension ProfileViewController {
    
    // MARK: - IBActions
    
    @IBAction func logoutButtonPressed() {
    }
    
    @IBAction func changeProfileImageButtonPressed() {
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
}
