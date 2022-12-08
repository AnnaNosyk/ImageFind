//
//  LikesImagesViewController.swift
//  ImageFind
//
//  Created by Anna Nosyk on 05/07/2022.
//

import UIKit
import RealmSwift

class LikesImagesVC: UICollectionViewController {
    
    private lazy var deleteButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem:  .trash, target: self, action: #selector(deleteButtonTap))
    }()
    
    
    var likesImages: Results<MyLikes>?
    
    private var numberOfSelectedImages: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       setupNavigationBar()
       setupColletionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likesImages = realm.objects(MyLikes.self)
        collectionView.reloadData()
        
    }
    
    
    @objc func deleteButtonTap() {
        for image in likesImages! {
            if image.selected {
                try! realm.write {
                    realm.delete(image)
                }
            }
        }
        collectionView.reloadData()
    }
    
    
    private func setupNavigationBar() {
        let title = UILabel()
        title.text = Constants().myImagesStr
        title.font = UIFont.systemFont(ofSize: 15,weight: .medium)
        title.textColor = UIColor(named: Constants().textColor)
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants().backGroungColor)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: title)
        navigationItem.rightBarButtonItems = [deleteButton]
    }
    
    private func setupColletionView() {
        collectionView.backgroundColor = UIColor(named: Constants().backGroungColor)
        collectionView.register(LikesImageViewCell.self, forCellWithReuseIdentifier: LikesImageViewCell.cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.allowsMultipleSelection = true
    }
    
    private func updateNavigButtonsState() {
        deleteButton.isEnabled = numberOfSelectedImages > 0
    }
    
    func refresh() {
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavigButtonsState()
    }
    

    // MARK: - UICollectionViewDataSource. Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return   likesImages?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesImageViewCell.cellId, for: indexPath) as! LikesImageViewCell
        let cellImages = likesImages?[indexPath.item]
        cell.likeImageView.image = UIImage(data: (cellImages?.image)!)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavigButtonsState()
        let cellImages = likesImages?[indexPath.item]
        try! realm.write{
            cellImages?.selected = true
        }
        }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavigButtonsState()
        let cellImages = likesImages?[indexPath.item]
        try! realm.write{
            cellImages?.selected = false
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LikesImagesVC: UICollectionViewDelegateFlowLayout {

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    return CGSize(width: width/3 - 1, height: width/3 - 1)
}
}
