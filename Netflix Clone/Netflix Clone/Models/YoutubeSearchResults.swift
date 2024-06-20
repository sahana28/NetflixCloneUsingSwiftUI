//
//  YoutubeSearchResults.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 07/03/24.
//

import Foundation


struct YoutubeSearchResponse : Codable {
    let items : [YoutubeSearchResponseId]
}

struct YoutubeSearchResponseId: Codable {
    let id: YoutubeSearchVideoIds
}

struct YoutubeSearchVideoIds : Codable {
    let kind : String
    let videoId : String
}
