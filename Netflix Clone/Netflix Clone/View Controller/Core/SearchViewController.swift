//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 17/02/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies : [Movie] = [Movie]()
    
    private var serachResultsController : UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.text = "Search for a Movie or Tv show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    private let discoverTableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.cellIdentifier)
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(discoverTableView)
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        navigationItem.searchController = self.serachResultsController
        serachResultsController.searchResultsUpdater = self
        fetchDiscoverMovies()
        
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }

    private func fetchDiscoverMovies() {
        APICaller.shared.discoverMovies { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.movies = movieList
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
                
            case .failure(let error):
                guard let desc = error.errorDescription else  {
                    return
                }
                print("Error:\(desc)")
                
            }
        }
    }
    
    private func searchMovieInYoutube(with query:String) {
        //APICaller.shared.getMovie(with: query)
    }
    
    
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.cellIdentifier, for: indexPath) as? TitleTableViewCell else { return  UITableViewCell()
            
        }
        
        let movie = self.movies[indexPath.row]
        cell.configure(with: TitleViewModel(posterUrl:movie.poster_path ?? " " , titleName:movie.original_name ?? movie.original_title ?? "Unknown Title"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
               query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
        resultsController.delegate = self
        APICaller.shared.searchMovies(using: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movieList):
                    resultsController.movies = movieList
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
}

extension SearchViewController : SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTap(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
     }

}
