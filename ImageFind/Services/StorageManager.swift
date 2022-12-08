//
//  StorageManager.swift
//  ImageFind
//
//  Created by Anna Nosyk on 08/12/2022.
//

import Foundation
import RealmSwift

let realm = try! Realm()
class StorageManager {
    static let shared = StorageManager()
    
    func saveImage(image: UIImage) {
    let myImage = MyLikes()
        guard let dataImage = image.pngData() else { return }
        try! realm.write {
            myImage.image = dataImage
            realm.add(myImage)
        }
    }
}
