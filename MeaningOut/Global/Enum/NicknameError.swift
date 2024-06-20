//
//  NicknameVaild.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import Foundation

enum NicknameError: Error {
    case symbol
    case number
    case range
    
    static func checkNickname(_ nickname: String) throws -> Bool {
        if nickname.isEmpty {
            return false
        }
        
        for char in nickname {
            if ["@", "#", "$", "%"].contains(char) {
                throw NicknameError.symbol
            }
            
            if char.isNumber {
                throw NicknameError.number
            }
        }
        
        if !(2...9 ~= nickname.count) {
            throw NicknameError.range
        }
        
        return true
    }
}

extension NicknameError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .symbol: "닉네임에 @, #, $, % 는 포함할 수 없어요"
        case .number: "닉네임에는 숫자를 포함할 수 없어요"
        case .range: "2글자 이상 10글자 미만으로 설정해주세요"
        }
    }
}
