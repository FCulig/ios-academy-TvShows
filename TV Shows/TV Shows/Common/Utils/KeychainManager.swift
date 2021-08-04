//
//  KeychainManager.swift
//  TV Shows
//
//  Created by Infinum Infinum on 03.08.2021..
//

import Foundation
import KeychainAccess

final class KeychainManager {
    
    // MARK: - Lets and vars

    static let shared = KeychainManager()
    private let keychain: Keychain

    // MARK: - Initializer
    
    private init() {
        keychain = Keychain(service: "http://tv-shows.infinum.academy/")
    }
    
    func storeObject(key: String, value: Data) {
        keychain[data: key] = value
    }
    
    func getObject(key: String) -> Data? {
        return try? keychain.getData(key)
    }
    
    func removeObject(key: String) {
        keychain[data: key] = nil
    }
}
