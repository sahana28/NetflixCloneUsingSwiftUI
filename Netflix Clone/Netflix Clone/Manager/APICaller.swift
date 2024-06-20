//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 19/02/24.
//

import Foundation



struct Constants {
    static let API_KEY = "3817d85bf632cdbb87f2d91fadd2c2b6"
    static let baseUrl = "https://api.themoviedb.org/"
    static let youtubeAPI_KEY = "AIzaSyCnV6j04FV7eJnh-OM9DxhNeRAVwzDJNbM"
    static let youtubeSearchUrl = "https://youtube.googleapis.com/youtube/v3/search"
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping(Result<[Movie],NetflixError>)-> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(NetflixError.invalidResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(NetflixError.invalidData))
            }
        }
        task.resume()
    }
    
    func getTrendingTv(completion:@escaping(Result<[Movie],NetflixError>)-> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(NetflixError.invalidResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(NetflixError.invalidData))
            }
        }
        task.resume()
        
    }
    
    func getUpcomingMovies(completion:@escaping(Result<[Movie],NetflixError>)->Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
        
    }
    
    func getPopularMovies(completion:@escaping(Result<[Movie],NetflixError>)->Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
        
    }
    
    func getTopRatedMovies(completion:@escaping(Result<[Movie],NetflixError>)->Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func discoverMovies(completion:@escaping(Result<[Movie],NetflixError>)->Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&page=1&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func searchMovies(using searchString: String, completion: @escaping(Result<[Movie],NetflixError>)->Void) {
        guard let query = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion:@escaping(Result<YoutubeSearchResponseId,NetflixError>) -> Void) {
       guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeSearchUrl)?q=\(query)&key=\(Constants.youtubeAPI_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                
                return
            }
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
                
            } catch {
                completion(.failure(NetflixError.invalidResponse))
            }
        }
        task.resume()
                
    }
    
    
    
}
