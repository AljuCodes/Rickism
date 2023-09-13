//
//  RMGetAllLocationsResponse.swift
//  Rickism
//
//  Created by FAO on 13/09/23.
//

import Foundation

struct RMGetAllLocationsResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let preve: String?
    }
    
    let info: Info
    let results: [RMLocation]
}
