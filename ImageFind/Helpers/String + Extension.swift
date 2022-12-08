//
//  String + Extension.swift
//  ImageFind
//
//  Created by Anna Nosyk on 06/07/2022.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
