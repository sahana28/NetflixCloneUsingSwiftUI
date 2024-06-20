//
//  Movie.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 21/02/24.
//

import Foundation

enum MediaType : String, Codable {
    case movie,
    tv
}

struct MovieResponse : Codable {
    let results : [Movie]
}

struct Movie : Codable {
    
    let id : Int
    let media_type : MediaType?
    let original_name : String?
    let original_title : String?
    let overview : String?
    let poster_path : String?
    let release_date : String?
    let vote_count : Int
    let vote_average : Double
}
