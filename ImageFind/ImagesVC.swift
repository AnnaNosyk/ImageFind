//
//  ImagesVC.swift
//  ImageFind
//
//  Created by Anna Nosyk on 29/06/2022.
//

import UIKit

class ImagesVC: UICollectionViewController {
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem:  .add, target: self, action: #selector(addButtonTap))
    }()
    
    private lazy var actionButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem:  .action, target: self, action: #selector(actionButtonTap))
    }()
    
    //array for all images
        private var images = [UnspashImages]()
    
    var searchController : UISearchController!
   
    var networkDataFetcher = NetworkDataFether()
    
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationController?.navigationBar.barTintColor = .blue
        setupColletionView()
        setupNavigationBar()
        setupSearchBar()
       
    }
    
  
    
    @objc func addButtonTap() {
        print(#function)
    }
    @objc func actionButtonTap() {
        print(#function)
    }
    
    
    // MARK: - Setup UI Elements
    private func setupColletionView() {
        collectionView.register(ImagesViewCell.self, forCellWithReuseIdentifier: ImagesViewCell.cellId)
    }
    
    private func setupNavigationBar() {
        let title = UILabel()
        title.text = "IMAGES"
        title.font = UIFont.systemFont(ofSize: 15,weight: .medium)
        title.textColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: title)
        navigationItem.rightBarButtonItems = [actionButton, addButton]
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
    }


// MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesViewCell.cellId, for: indexPath) as! ImagesViewCell
        let cellImages = images[indexPath.item]
        cell.unsplashImage = cellImages
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

//MARK: Search Bar Delegate
extension ImagesVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        // action when user take finger off the screen
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {  _ in
            self.networkDataFetcher.getImages(searchText: searchText) { [weak self] searchResults in
                guard let fetchesImages = searchResults else {return}
                self?.images = fetchesImages.results
                self?.collectionView.reloadData()
            }
        })
       
    }
}

