//
//  TitleTableViewCell.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 01/03/24.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {

   static let cellIdentifier = "titleCellIdentifier"
    
    private let playButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLable : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLable)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        let imageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
        
        let titleLabelConstraints = [
            titleLable.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLable.widthAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        let playbuttonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            //playButton.widthAnchor.constraint(equalToConstant: pl)
        ]
        
        NSLayoutConstraint.activate(playbuttonConstraints)
    }
    
    public func configure(with model:TitleViewModel) {
        guard let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterUrl)") else { return }
        self.posterImageView.sd_setImage(with: imageURL)
        self.titleLable.text = model.titleName
    }
    
}
