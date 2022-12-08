//
//  Alert.swift
//  ImageFind
//
//  Created by Anna Nosyk on 06/07/2022.
//

import UIKit


class Alert {
    func alert(viewController: UIViewController, message: String, complition:@escaping (UIAlertAction)->Void, cancelComplition:@escaping (UIAlertAction)->Void)  {
        let alert = UIAlertController(title: Constants().alertTitle, message: message, preferredStyle: .alert)
        let addAction = UIAlertAction(title: Constants().alerAddkStr, style: .default, handler: complition)
        let cancel = UIAlertAction(title: Constants().alertCancelStr, style: .destructive, handler: cancelComplition)
        alert.addAction(addAction)
        alert.addAction(cancel)
        viewController.present(alert, animated: true)
    }
}
