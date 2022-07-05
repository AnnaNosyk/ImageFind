//
//  LikesImagesViewController.swift
//  ImageFind
//
//  Created by Anna Nosyk on 05/07/2022.
//

import UIKit

class LikesImagesVC: UICollectionViewController {
    
    private lazy var deleteButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem:  .trash, target: self, action: #selector(deleteButtonTap))
    }()
    
    var images = [UnspashImages]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
       setupColletionView()
    }
    
    
    @objc func deleteButtonTap() {
        
        print(#function)
    }
    
    private func setupNavigationBar() {
        let title = UILabel()
        title.text = "MY IMAGES"
        title.font = UIFont.systemFont(ofSize: 15,weight: .medium)
        title.textColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: title)
        navigationItem.rightBarButtonItems = [deleteButton]
    }
    
    private func setupColletionView() {
        collectionView.register(LikesImageViewCell.self, forCellWithReuseIdentifier: LikesImageViewCell.cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1

    }
    

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesImageViewCell.cellId, for: indexPath) as! LikesImageViewCell
        let cellImages = images[indexPath.item]
        cell.unsplashImage = cellImages
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension LikesImagesVC: UICollectionViewDelegateFlowLayout {

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    return CGSize(width: width/3 - 1, height: width/3 - 1)
}
}
