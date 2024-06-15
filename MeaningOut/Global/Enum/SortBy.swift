//
//  SortBy.swift
//  MeaningOut
//
//  Created by 아라 on 6/14/24.
//

import Foundation

enum SortBy: Int, CaseIterable {
    case accuracy = 0
    case date
    case expensive
    case cheap
    
    var title: String {
        switch self {
        case .accuracy: "정확도"
        case .date: "날짜순"
        case .expensive: "가격높은순"
        case .cheap: "가격낮은순"
        }
    }
    
    var value: String {
        switch self {
        case .accuracy: "sim"
        case .date: "date"
        case .expensive: "dsc"
        case .cheap: "asc"
        }
    }
}
