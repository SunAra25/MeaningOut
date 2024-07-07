//
//  ProductRepository.swift
//  MeaningOut
//
//  Created by 아라 on 7/7/24.
//

import RealmSwift
import Foundation

final class ProductRepository {
    private let realm = try! Realm()
    
    func printFileURL() {
        print(realm.configuration.fileURL)
    }
    
    func createItem(_ data: ProductTable) {
        try! realm.write {
            realm.add(data)
            print("Realm Crete Success")
        }
    }
    
    func fetchLikeList() -> Results<ProductTable> {
        return realm.objects(ProductTable.self)
    }
    
    func deleteItem(_ item: ProductTable) {
        try! realm.write {
            realm.delete(item)
        }
    }
}
