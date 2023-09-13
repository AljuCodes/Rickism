//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Afraz Siddiqui on 12/23/22.
//

import Foundation

/// Object that represents a singlet API call
final class RMRequest {
    
    
    var endPoint: RMEndpoint?
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    private let patchComponents: [String]
    private let queryParameters: [URLQueryItem]
    private var tempUrlString: String? = nil
    
    private var urlString: String {
        var urlString = Constants.baseUrl+"/"+endPoint!.rawValue
        
        if !patchComponents.isEmpty {
            patchComponents.forEach({
                urlString += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty{
            urlString += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&"
            )
            urlString += argumentString
        }
        
        return urlString
    }
    

    init?(url: URL, endPoint: RMEndpoint? =  nil){
//        print("this is working ")
        self.tempUrlString = url.absoluteString
        for rmEndPointCase in  RMEndpoint.allCases {
            if  url.absoluteString.contains(rmEndPointCase.rawValue) {
                self.endPoint = rmEndPointCase
            }
        }
        self.patchComponents = []
        self.queryParameters = []
//        print(url.absoluteString)
//        let string = url.absoluteString
//        if !string.contains(Constants.baseUrl){
//            return nil
//        }
//        let trimmed  = string.replacingOccurrences(of: Constants.baseUrl, with: "")
//        print("trimmed \(trimmed)")
//        if trimmed.contains("/") {
//            let components = trimmed.components(separatedBy: "/")
//            print("components after / : \(components)" )
//            if !components.isEmpty {
//                let endpointString = components[0]
//                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
//                    self.init(endPoint: rmEndpoint)
//                    return
//                }
//            }
//        }
//        if trimmed.contains("?"){
//            let components = trimmed.components(separatedBy: "?")
//            print("? components \(components)")
//            if !components.isEmpty {
//                let endpointString = components[0]
//                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
//                    self.init(endPoint: rmEndpoint)
//                    return
//                }
//            }
//        }
//        return nil
    }
    
//    MARK: - Public
    
    public var url: URL? {
            return URL(string: tempUrlString ?? urlString)
    }
    
    
    public init(
        endPoint: RMEndpoint,
        patchComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endPoint = endPoint
        self.patchComponents = patchComponents
        self.queryParameters = queryParameters
    }
    

    
    public let httpMethod = "GET"
}


extension RMRequest {
    static let listCharactersRequests = RMRequest(endPoint: .character)
    static let listEpisodeRequests = RMRequest(endPoint: .episode)
    static let listLocationRequests = RMRequest(endPoint: .location)
}
