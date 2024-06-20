//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 17/02/24.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var movies : [Movie] = [Movie]()
    
    private let upcomingTableView : UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.cellIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = "Upcoming"
        upcomingTableView.frame = view.bounds
        view.addSubview(upcomingTableView)
        
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        fetchUpcoming()
        
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movieList):
                self?.movies = movieList
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
               
            case .failure(let error):
                guard let desc = error.errorDescription  else { return }
                    print("Error occured:\(desc)")
                
            }
        }
    }
    
    

}

extension UpcomingViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.cellIdentifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let movie = self.movies[indexPath.row]
        
        cell.configure(with: TitleViewModel(posterUrl:movie.poster_path ?? "Unknown Title Name" , titleName: movie.original_title ?? movie.original_name ?? " "))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = self.movies[indexPath.row]
        let title = selectedMovie.original_title ?? selectedMovie.original_name ?? " "
        APICaller.shared.getMovie(with: title) { [weak self] result in
            switch(result) {
            case .success(let responseIds):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    let viewModel = TitlePreviewViewModel(title: title, overviewTitle: selectedMovie.overview ?? " ", youtubeView: responseIds.id)
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print("Error: \(error.errorDescription ?? " ")")
                
            }
        }
    }
    
    
}
