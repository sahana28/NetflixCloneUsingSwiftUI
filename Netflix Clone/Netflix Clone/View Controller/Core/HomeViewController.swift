//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 17/02/24.
//
//API Key = 3817d85bf632cdbb87f2d91fadd2c2b6
import UIKit

enum Sections : Int {
    case TrendingMovies = 0,
    TrendingTv = 1,
    Popular = 2,
    Upcoming = 3,
    TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles = ["Trending Movies","Trending Tv","Popular","Upcoming movies","Top rated"]
    var movieList = [Movie]()
    var error : NetflixError?
    private var headerView : HeroTableHeaderView?
    private var randomTrendingMovie : Movie?

     private let homeFeedTableView : UITableView = {
         let tableView = UITableView(frame: .zero, style: .grouped)
         tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.cellIdentifier)
         return tableView
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configureTableView()
        self.configureNavBar()
        fetchTrendingMovies()
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "netflix")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
            
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureHeroHeaderView() {
        let viewModel = TitleViewModel(posterUrl: self.randomTrendingMovie?.poster_path ?? "", titleName: self.randomTrendingMovie?.original_name ?? self.randomTrendingMovie?.original_title ?? " ")
        headerView?.configure(with: viewModel)
    }
    
    private func fetchTrendingMovies() {
        APICaller().getTrendingMovies { result in
            switch(result) {
            case .success(let response) :
                self.movieList = response
                self.randomTrendingMovie = self.movieList.randomElement()
                self.configureHeroHeaderView()
            case .failure(let error):
                self.error = error
                if let desc = error.description {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Alert", message: desc, preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                        self.present(alert, animated: true)
                    }
                    
                }
                
            }
            
         }
    }
    
    func configureTableView() {
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        homeFeedTableView.frame  = view.bounds
        view.addSubview(homeFeedTableView)
        headerView = HeroTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        homeFeedTableView.tableHeaderView = headerView
    }
    
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.cellIdentifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let movieList):
                    cell.configure(with: movieList)
                case .failure(let error):
                    print(error.errorDescription ?? "Error in showing movies")
                }
            
            }
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTv { result in
                switch result {
                case .success(let movieList):
                    cell.configure(with: movieList)
                case  .failure(let error):
                    print(error.errorDescription ?? "Error in showing movies")
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let movieList):
                    cell.configure(with: movieList)
                case  .failure(let error):
                    print(error.errorDescription ?? "Error in showing movies")
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let movieList):
                    cell.configure(with: movieList)
                case  .failure(let error):
                    print(error.errorDescription ?? "Error in showing movies")
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let movieList):
                    cell.configure(with: movieList)
                case  .failure(let error):
                    print(error.errorDescription ?? "Error in showing movies")
                }
            }
        
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.font  = .systemFont(ofSize: 18, weight: .semibold)
        headerView.frame = CGRect(x: headerView.frame.origin.x + 20, y: headerView.frame.origin.y, width: 100, height: headerView.frame.height)
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.text = headerView.textLabel?.text?.capitalized
    }
    
}

extension HomeViewController : CollectionViewTableViewCellDelegate {
    func didTapOnTableViewCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}
