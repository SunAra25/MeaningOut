//
//  UserDefaultsManager.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    private let formatter = DateFormatter()
    
    var nickname: String {
        get {
            userDefaults.string(forKey: "nickname") ?? ""
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
    
    var recentlySearch: [String : Int]? {
        get {
            userDefaults.dictionary(forKey: "recentlySearch") as? [String : Int]
        }
        
        set {
            userDefaults.set(newValue, forKey: "recentlySearch")
        }
    }
    
    var likeList: [String : Bool]? {
        get {
            userDefaults.dictionary(forKey: "likeList") as? [String : Bool]
        }
        
        set {
            userDefaults.set(newValue, forKey: "likeList")
        }
    }
    
    var createdAt: String {
        get {
            userDefaults.string(forKey: "createdAt") ?? ""
        }
        
        set {
            userDefaults.set(newValue, forKey: "createdAt")
        }
    }
    
    func resetInfo() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
