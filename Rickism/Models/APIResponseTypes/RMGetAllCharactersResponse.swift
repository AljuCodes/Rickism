//
//  RMGetAllCharactersResponse.swift
//  Rickism
//
//  Created by FAO on 28/08/23.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int	
        let pages: Int
        let next: String?
        let preve: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}
