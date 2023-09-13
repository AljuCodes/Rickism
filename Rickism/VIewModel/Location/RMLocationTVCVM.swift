//
//  RMLocationCollectionViewCellVM.swift
//  Rickism
//
//  Created by FAO on 13/09/23.
//

import Foundation


struct RMLocationTVCVM {
    
    private let location: RMLocation

    init(location: RMLocation) {
        self.location = location
    }

    public var name: String {
        return location.name
    }

    public var type: String {
        return "Type: "+location.type
    }

    public var dimension: String {
        return location.dimension
    }
}
