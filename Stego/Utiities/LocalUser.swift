//
//  LocalUser.swift
//  Stego
//
//  Created by George Sealy on 20/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import Foundation

enum LocalUserSetting: String {
    
    case accessToken = "com.stego.access_token"
    case appClientId = "com.stego.app_client_id"
    case appClientSecret = "com.stego.app_client_secret"
    case appClientRedirectUri = "com.stego.app_client_redirect_uri"
}


struct LocalUser {
    
    static func saveString(_ key: LocalUserSetting, value: String?) {
    
        let current = getString(key)

        if value != current {

            let defaults = UserDefaults.standard
            defaults.set(value, forKey: key.rawValue)
            
            Log("\(type(of: self)) - \(#function): Set \(key.rawValue) to: \(String(describing: value))")
            
            ASSERT(getString(key) == value)
            
            defaults.synchronize()
        }
    }
    
    static func getString(_ key: LocalUserSetting) -> String? {
        
        let defaults = UserDefaults.standard
        let result = defaults.string(forKey: key.rawValue)
        
        Log("\(type(of: self)) - \(#function): Got user string \(key.rawValue) of: \(String(describing: result))")
        
        return result
    }
}
