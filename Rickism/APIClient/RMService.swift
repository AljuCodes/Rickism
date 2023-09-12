//
//  RMService.swift
//  RickAndMorty
//
//  Created by Afraz Siddiqui on 12/23/22.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()

    /// Privatized constructor
    private init() {}

    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    private let cacheManager = RMAPICacheManager()
    
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    public func execute<T:Codable>(_ request: RMRequest,
                        expecting type: T.Type,
                        completion: @escaping (Result<T,Error>) -> Void) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        // cached data stuff
        if let cachedData = cacheManager.getCachedResponse(for: request.endPoint!, url: urlRequest.url!){
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
                //
            } catch {
                completion(.failure(error))
            }
            return
        }
        
        let task  = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, _, error in
            
            guard let data, error == nil else {
                completion(.failure(error ?? RMServiceError.failedToGetData))
            return
            }
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endPoint!, url: request.url!, data: data)
                completion(.success(result))
                //
            } catch {
                
                print("Decoder error has been thrown for type: \(type.self), for \(String(describing: urlRequest.url?.absoluteString)), data \(data.description)")
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
