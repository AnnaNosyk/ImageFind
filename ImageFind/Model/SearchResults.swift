//
//  SearchResults.swift
//  ImageFind
//
//  Created by Anna Nosyk on 01/07/2022.
//

import Foundation


struct SearchResults: Decodable {
    let total:Int
    let results: [UnspashImages]
}

// parameters of image
struct UnspashImages: Decodable {
    let width: Int
    let height:Int
    let urls: [URLKind.RawValue:String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
