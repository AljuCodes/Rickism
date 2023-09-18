//
//  RMSearchResultVM.swift
//  Rickism
//
//  Created by FAO on 18/09/23.
//

import Foundation

final class RMSearchResultVM {
    public private(set) var results: RMSearchResultType
    private var next: String?

    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
}
