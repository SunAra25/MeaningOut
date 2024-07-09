//
//  NicknameViewModel.swift
//  MeaningOut
//
//  Created by 아라 on 7/9/24.
//

import Foundation

class NicknameViewModel {
    private let userDefaults = UserDefaultsManager()
    
    var inputNewImageNum = Observable<Int?>(nil)
    var inputProfileBtnTap = Observable<Void?>(nil)
    var inputCompletedBtnTap = Observable<(String)>("")
    
    var outputShowProfileView = Observable<Int>(0)
    var outputChangeProfileImage = Observable<Int>(Int.random(in: 0...11))
    var outputSetRootVC = Observable<Void?>(nil)
    
    private var currentImgNum = Int.random(in: 0...11)
    
    init() {
        inputNewImageNum.bind { [weak self] num in
            guard let self, let num else { return }
            
            currentImgNum = num
            outputChangeProfileImage.value = num
        }
        
        inputProfileBtnTap.bind { [weak self] _ in
            guard let self else { return }
            
            outputShowProfileView.value = currentImgNum
        }
        
        inputCompletedBtnTap.bind { [weak self] nickname in
            guard let self, let imageNum = inputNewImageNum.value else { return }
            
            userDefaults.nickname = nickname
            userDefaults.imageNum = imageNum
            
            let current = Date()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy. MM. dd "
            let createdAt = formatter.string(from: current)
            
            userDefaults.createdAt = createdAt
            
            outputSetRootVC.value = ()
        }
    }
}
