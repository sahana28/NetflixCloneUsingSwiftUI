//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 24/02/24.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "TitleCollectionViewCell"
    private let posterImagView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterImagView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImagView.frame = self.bounds
    }
    
    public func configure(with model:String) {
        let urlString = "https://image.tmdb.org/t/p/w500" + model
        guard let url = URL(string: urlString) else { return }
        posterImagView.sd_setImage(with: url)
        
    }
}
