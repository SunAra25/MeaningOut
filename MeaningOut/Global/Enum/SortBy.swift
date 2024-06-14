//
//  SortBy.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import Foundation

enum SortBy: String, CaseIterable {
    case accuracy = "정확도"
    case date = "날짜순"
    case expensive = "가격높은순"
    case cheap = "가격낮은순"
    
    var index: Int {
        switch self {
        case .accuracy: 0
        case .date: 1
        case .expensive: 2
        case .cheap: 3
        }
    }
}
