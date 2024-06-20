//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 18/02/24.
//

import UIKit

protocol CollectionViewTableViewCellDelegate : AnyObject {
    func didTapOnTableViewCell(_ cell:CollectionViewTableViewCell, viewModel:TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    private var movies : [Movie] = [Movie]()
    static let cellIdentifier = "CollectionViewTableViewCell"
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .gray
        self.contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.cellIdentifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = self.movies[indexPath.row]
        guard let posterPath = movie.poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: posterPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = self.movies[indexPath.row]
        guard let title = movie.original_title ?? movie.original_name else { return }
        APICaller.shared.getMovie(with: title + " trailer") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let videoIdResponse):
                let overview = movie.overview ?? " "
                    self.delegate?.didTapOnTableViewCell(self, viewModel: TitlePreviewViewModel(title: title, overviewTitle: overview, youtubeView: videoIdResponse.id))
    
            case .failure(let error):
                print(error.errorDescription ?? "Error")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, actionProvider:  { _ in
            let downloadAction = UIAction(title: "Download",state: .off) { UIAction in
                print("Download")
            }
            return UIMenu(title: "", options: .displayInline, children: [downloadAction])
        })
        return config
    }
    
    
}
