//
//  MainTabBarController.swift
//  ImageFind
//
//  Created by Anna Nosyk on 29/06/2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    let imageVc = ImagesVC(collectionViewLayout: UICollectionViewFlowLayout())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewControllers = [
            generateNavigationController(rootVc: imageVc, title: "Images", image: UIImage(systemName: "photo.fill")!),
            generateNavigationController(rootVc: UIViewController(), title: "Likes", image: UIImage(systemName: "heart.fill")!)
        ]
        
        
    }
    
    private func generateNavigationController(rootVc: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigVC = UINavigationController(rootViewController: rootVc)
        navigVC.tabBarItem.title = title
        navigVC.tabBarItem.image = image
        return navigVC
    }

}
