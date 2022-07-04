//
//  ImagesViewCell.swift
//  ImageFind
//
//  Created by Anna Nosyk on 04/07/2022.
//

import UIKit
import SDWebImage

class ImagesViewCell: UICollectionViewCell {
    
    static let cellId = "ImageCell"
    
    private let checkmark: UIImageView = {
        let image = UIImage(systemName: "checkmark.square.fill ")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()
    
    var unsplashImage: UnspashImages! {
        didSet {
            let imageUrl = unsplashImage.urls["regular"]
            guard let urlImage = imageUrl, let url = URL(string: urlImage) else {return}
            photoImageView.sd_setImage(with: url, completed: nil)
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateCells()
        setupConstraints()
    }
    
    
    override var isSelected: Bool {
        
        didSet {
            updateCells()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
  
    
    // func for change cells when its selected
    private func updateCells() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    
    private func setupConstraints() {
        addSubview(photoImageView)
        addSubview(checkmark)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8),
            checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
