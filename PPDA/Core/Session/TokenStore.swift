import Foundation

final class TokenStore {
    static let shared = TokenStore()

    private let tokenKey = "auth_token"

    private init() {}

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
//
//  TokenStore.swift
//  PPDA
//
//  Created by Mateo Cardona Marin on 23/06/26.
//

