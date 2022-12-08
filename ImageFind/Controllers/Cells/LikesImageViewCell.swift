//
//  LikesImageViewCell.swift
//  ImageFind
//
//  Created by Anna Nosyk on 05/07/2022.
//

import UIKit
import SDWebImage

class LikesImageViewCell: UICollectionViewCell {
    
    static let cellId = "LikeCell"
    
    let likeImageView: UIImageView = {
        let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFill
         imageView.clipsToBounds = true
         imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
       
   }()
    
    private let checkmark: UIImageView = {
        let image = UIImage(systemName:"checkmark.square.fill")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    //convert image from url
    var unsplashImage: UnspashImages! {
        didSet {
            let imageUrl = unsplashImage.urls["regular"]
            guard let urlImage = imageUrl, let url = URL(string: urlImage) else {return}
            likeImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       // updateCells()
        setupConstraints()
    }
    
 
    
    
    override var isSelected: Bool {
        
        didSet {
            updateCells()
        }
    }
    
    // func for change cells when its selected
    private func updateCells() {
        likeImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likeImageView.image = nil
    }
    
    
    private func setupConstraints() {
        addSubview(likeImageView)
        addSubview(checkmark)
        
        NSLayoutConstraint.activate([
            likeImageView.topAnchor.constraint(equalTo: self.topAnchor),
            likeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            likeImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: likeImageView.trailingAnchor, constant: -8),
            checkmark.bottomAnchor.constraint(equalTo: likeImageView.bottomAnchor, constant: -10)
        ])
        
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
