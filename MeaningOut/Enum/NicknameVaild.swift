//
//  NicknameVaild.swift
//  MeaningOut
//
//  Created by 아라 on 6/13/24.
//

import Foundation

enum NicknameVaild: String {
    case none = "닉네임을 입력해주세요"
    case symbol = "닉네임에 @는 포함할 수 없어요"
    case gap = "닉네임에는 공백을 포함할 수 없어요"
    case valid
}
