//
//  ProfileType.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import UIKit

enum ProfileType {
    case user
    case example
    case selected
    
    var borderWidth: CGFloat {
        switch self {
        case .user: 3
        case .example: 1
        case .selected: 1
        }
    }
    
    var borderColor: UIColor? {
        switch self {
        case .user: .meaningPrimary
        case .example: .meaningGray1
        case .selected: .meaningPrimary
        }
    }
    
    var alpha: CGFloat {
        switch self {
        case .user: 1
        case .example: 0.5
        case .selected: 1
        }
    }
}
