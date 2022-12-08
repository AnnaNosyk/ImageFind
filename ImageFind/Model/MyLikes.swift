//
//  MyLikes.swift
//  ImageFind
//
//  Created by Anna Nosyk on 08/12/2022.
//

import Foundation
import RealmSwift

@objcMembers
class MyLikes: Object {
    dynamic var image: Data?
    dynamic var selected: Bool = false
}

