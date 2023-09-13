//
//  RMLocationViewVM.swift
//  Rickism
//
//  Created by FAO on 13/09/23.
//

import Foundation

protocol RMLocationViewVMDelegate : AnyObject {
    func rmDidFectchAllLocations()
}


final class RMLocationViewVM {
 
    weak var delegate: RMLocationViewVMDelegate?
    
    private var locations: [RMLocation] = []{
        didSet{
            locations.forEach { location in
                cellViewModels.append(.init(location: location))
            }
        }
    }
    
    private var info: RMGetAllLocationsResponse.Info?
    
    public private(set) var cellViewModels: [RMLocationTVCVM] = []
    
    public func location(at: Int) -> RMLocation {
        return locations[at]
    }
    
    public func fetchLocations(){
        RMService.shared.execute(.listLocationRequests, expecting: RMGetAllLocationsResponse.self){ [weak self] result in
            switch result{
            case .success(let model):
                DispatchQueue.main.async {
                    self?.delegate?.rmDidFectchAllLocations()
                }
                self?.info = model.info
                self?.locations = model.results
                
            case .failure(_):
                fatalError("couldn't get location data from server")
            }
            
        }
    }
    
    private var hasMoreResults: Bool {
        return self.info?.next != nil
    }
}
