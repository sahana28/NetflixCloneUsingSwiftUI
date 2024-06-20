//
//  Error.swift
//  Netflix Clone
//
//  Created by Sahana  Rao on 21/02/24.
//

import Foundation


enum NetflixError : Error, LocalizedError {
    case invalidResponse
    case invalidData

    var description : String? {
        switch self {
        case .invalidResponse :
            return "Invalid Response from the server. Pls try again"
        case .invalidData:
            return "Data returned from the server is invalid"
        }
    }
    
}
