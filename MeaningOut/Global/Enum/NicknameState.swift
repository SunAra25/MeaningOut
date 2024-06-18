//
//  NicknameVaild.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import Foundation

enum NicknameState: String {
    case none = ""
    case symbol = "닉네임에 @, #, $, % 는 포함할 수 없어요"
    case number = "닉네임에는 숫자를 포함할 수 없어요"
    case range = "2글자 이상 10글자 미만으로 설정해주세요"
    case valid = "사용할 수 있는 닉네임이에요"
    
    static func checkNickname(_ nickname: String) -> NicknameState {
        if nickname.isEmpty {
            return .none
        }
        
        for char in nickname {
            if ["@", "#", "$", "%"].contains(char) {
                return .symbol
            }
            
            if char.isNumber {
                return .number
            }
        }
        
        if !(2...9 ~= nickname.count) {
            return .range
        }
        
        return .valid
    }
}
