//
//  Product.swift
//  MeaningOut
//
//  Created by 아라 on 6/15/24.
//

import Foundation

struct SearchResponse: Codable {
    let total, start, display: Int
    var items: [Product]
}

struct Product: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, hprice, mallName, productId: String
    
    var titleNoneHTML: String {
        title.htmlEscaped
    }
}
