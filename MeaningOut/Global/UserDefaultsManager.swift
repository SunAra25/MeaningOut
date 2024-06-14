//
//  UserDefaultsManager.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import Foundation

class UserDefaultsManager {
    private let userDefaults = UserDefaults.standard
    
    var nickname: String {
        get {
            userDefaults.string(forKey: "nickname") ?? "아라"
        }
        
        set {
            userDefaults.set(newValue, forKey: "nickname")
        }
    }
    
    var imageNum: Int {
        get {
            userDefaults.integer(forKey: "imageNum")
        }
        
        set {
            userDefaults.set(newValue, forKey: "imageNum")
        }
    }
}
