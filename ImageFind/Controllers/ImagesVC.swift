//
//  ImagesVC.swift
//  ImageFind
//
//  Created by Anna Nosyk on 29/06/2022.
//

import UIKit
import RealmSwift

class ImagesVC: UICollectionViewController {
    
    
    private lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem:  .add, target: self, action: #selector(addButtonTap))
    }()
    
    private lazy var actionButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem:  .action, target: self, action: #selector(actionButtonTap))
    }()
    
    private var images = [UnspashImages]()
    private var selectedImages = [UIImage]()
    var likesImages: Results<MyLikes>?
    private let itemsPerRow: CGFloat = 2
    private let sectionsInserts = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    private var numberOfSelectedImages: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    var searchController : UISearchController!
    var networkDataFetcher = NetworkDataFether()
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigButtonsState()
        setupColletionView()
        setupNavigationBar()
        setupSearchBar()
       
    }
    
    @objc func addButtonTap() {
        let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (imgs, indexPath) -> [UnspashImages] in
            var mutablePhotos = imgs
            
            let image = images[indexPath.item]
            mutablePhotos.append(image)
            return mutablePhotos
        })
    
        Alert().alert(viewController: self, message: "\(selectedPhotos!.count) \(Constants().alertMessageStr)") { UIAlertAction in
            for i in self.selectedImages {
                StorageManager.shared.saveImage(image: i)
            }
            self.refresh()
        } cancelComplition: { UIAlertAction in
            self.refresh()
        }
        
    }
    
    @objc func actionButtonTap(sender: UIBarButtonItem) {
       let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        // for all devices
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    
    private func updateNavigButtonsState() {
        addButton.isEnabled = numberOfSelectedImages > 0
        actionButton.isEnabled = numberOfSelectedImages > 0
    }
    
    func refresh() {
        selectedImages.removeAll()
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavigButtonsState()
    }
    
    
    // MARK: - Setup UI Elements
    private func setupColletionView() {
        collectionView.backgroundColor = UIColor(named: Constants().backGroungColor)
        collectionView.register(ImagesViewCell.self, forCellWithReuseIdentifier: ImagesViewCell.cellId)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        if let waterfallLayout = collectionViewLayout as? WaterfallLayout {
            waterfallLayout.delegate = self
        }
    }
    
    private func setupNavigationBar() {
        let title = UILabel()
        title.text = Constants().imagesStr
        title.font = UIFont.systemFont(ofSize: 15,weight: .medium)
        title.textColor = UIColor(named: Constants().textColor)
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants().backGroungColor)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: title)
        navigationItem.rightBarButtonItems = [actionButton, addButton]
    }
    
    private func setupSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocapitalizationType = .none
        //searchController.searchBar.placeholder = "Add"
        searchController.searchBar.searchTextField.textColor = UIColor(named: Constants().textColor)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
    }

// MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesViewCell.cellId, for: indexPath) as! ImagesViewCell
        let cellImages = images[indexPath.item]
        cell.unsplashImage = cellImages
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavigButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! ImagesViewCell
        guard let image = cell.photoImageView.image else {return}
            selectedImages.append(image)
        }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavigButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! ImagesViewCell
        guard let image = cell.photoImageView.image else {return}
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }

}
// MARK: UICollectionViewDelegateFlowLayout

extension ImagesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.item]
        let paddingSpace = sectionsInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(image.height) * widthPerItem / CGFloat(image.width)
        return CGSize(width: widthPerItem, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInserts.left
    }
  }

// MARK: - WaterfallLayoutDelegate
extension ImagesVC: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = images[indexPath.item]
        return CGSize(width: photo.width, height: photo.height)
    }
}


//MARK: - Search Bar Delegate
extension ImagesVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        // action when user take finger off the screen
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {  _ in
            self.networkDataFetcher.getImages(searchText: searchText) { [weak self] searchResults in
                guard let fetchesImages = searchResults else {return}
                self?.images = fetchesImages.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
       
    }
}
