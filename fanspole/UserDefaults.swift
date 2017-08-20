//
//  UserDefaults.swift
//  fanspole
//
//  Created by Hardik on 20/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case accessToken
        case refreshToken
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func setAccessToken(value: String) {
        set(value, forKey: UserDefaultsKeys.accessToken.rawValue)
        synchronize()
    }
    func getAccessToken() -> String {
        return string(forKey: UserDefaultsKeys.accessToken.rawValue)!
    }
    
    func setRefreshToken(value: String) {
        set(value, forKey: UserDefaultsKeys.refreshToken.rawValue)
        synchronize()
    }
    func getRefreshToken() -> String {
        return string(forKey: UserDefaultsKeys.refreshToken.rawValue)!
    }

    
}
