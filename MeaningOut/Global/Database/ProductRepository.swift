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
            NotificationCenter.default.post(Notification(name: NSNotification.Name("UpdateProductTable")))
        }
    }
    
    func fetchLikeList() -> Results<ProductTable> {
        return realm.objects(ProductTable.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    func deleteItem(primary key: String) {
        let item = realm.object(ofType: ProductTable.self, forPrimaryKey: key)!
        
        try! realm.write {
            realm.delete(item)
            NotificationCenter.default.post(Notification(name: NSNotification.Name("UpdateProductTable")))
        }
    }
}
