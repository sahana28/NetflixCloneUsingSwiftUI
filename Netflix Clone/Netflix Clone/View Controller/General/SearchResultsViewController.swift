//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 04/03/24.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTap(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var movies : [Movie] = [Movie]()
    
    public weak var delegate : SearchResultsViewControllerDelegate?

    public let searchResultsCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 150)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.cellIdentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }


}

extension SearchResultsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:TitleCollectionViewCell.cellIdentifier , for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: movies[indexPath.row].poster_path ?? "")
       // cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = self.movies[indexPath.row]
        let title = movie.original_title ?? movie.original_name ?? " "
        APICaller.shared.getMovie(with: title) { [weak self] result in
            switch(result) {
            case .success(let responseIds):
                self?.delegate?.searchResultsViewControllerDidTap(TitlePreviewViewModel(title: title, overviewTitle: movie.overview ?? " ", youtubeView: responseIds
                    .id))
                
            case .failure(let error):
                print("Error: \(error.errorDescription ?? " ")")
                
            }
        }
        
    }
    
    
    
   
    
    
}

