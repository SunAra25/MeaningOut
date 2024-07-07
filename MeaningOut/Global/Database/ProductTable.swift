//
//  ProductTable.swift
//  MeaningOut
//
//  Created by 아라 on 7/7/24.
//

import RealmSwift
import Foundation

class ProductTable: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted var title: String
    @Persisted var mallName: String
    @Persisted var link: String
    @Persisted var price: String
    @Persisted var createdAt: Date
    
    convenience init(productId: String, title: String, mallName: String, link: String, price: String) {
        self.init()
        self.productId = productId
        self.title = title
        self.mallName = mallName
        self.link = link
        self.price = price
        self.createdAt = Date()
    }
}
