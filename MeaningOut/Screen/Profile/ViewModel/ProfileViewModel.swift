//
//  ProfileViewMoel.swift
//  MeaningOut
//
//  Created by 아라 on 7/9/24.
//

import Foundation

class ProfileViewModel {
    var inputNewImageNum = Observable<Int?>(0)
    var inputWillDisappear = Observable<Void?>(nil)
    
    var outputChangeProfileImage = Observable<Int?>(nil)
    var outputPopVC  = Observable<Int?>(nil)
    
    private var currentImgNum: Int
    
    init(_ imgNum: Int) {
        currentImgNum = imgNum
        
        inputNewImageNum.bind { [weak self] num in
            guard let self, let num else { return }
            currentImgNum = num
            outputChangeProfileImage.value = num
        }
        
        inputWillDisappear.bind { [weak self] _ in
            guard let self else { return }
            outputPopVC.value = currentImgNum
        }
    }
}
