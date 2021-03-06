//
//  AppDelegate.swift
//  TV Shows
//
//  Created by Infinum Infinum on 08.07.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        
        guard let encodedAuthInfo = KeychainManager.shared.getObject(key: "authInfo") else { return true }
        guard let authInfo = try? JSONDecoder().decode(AuthInfo.self, from: encodedAuthInfo) as AuthInfo else { return true }
        
        APIManager.shared.authInfo = authInfo
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: HomeViewController.self)
        ) as! HomeViewController
        navigationController.viewControllers = [homeViewController]
        self.window?.rootViewController = navigationController
        
        return true
    }


}

