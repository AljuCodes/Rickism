//
//  RMAPICacheManager.swift
//  Rickism
//
//  Created by FAO on 10/09/23.
//

import Foundation


final class RMAPICacheManager {
    
    private var cacheDictionary : [
    RMEndpoint: NSCache<NSString, NSData>
    ] = [:]
    
    init(){
        setupCache()
    }
    
    public func setCache(for endPoint: RMEndpoint, url: URL, data: Data){
        guard let targetCache = cacheDictionary[endPoint]  else {
            return
        }
        let key = url.absoluteString as NSString
        
        targetCache.setObject(data as NSData, forKey: key)
        if isCachedLogVisible {
            print("cache has been set for url: \(url)")
        }
        
    }
    
    
    public func getCachedResponse(for endPoint: RMEndpoint, url: URL) -> Data? {
        guard let targetCache = cacheDictionary[endPoint]  else {
            return nil
        }
        let key = url.absoluteString as NSString
        let cacheData = targetCache.object(forKey: key) as? Data
        if cacheData != nil  {
            if isCachedLogVisible {
                print(" cache has been get for url: \(url)")
            }
            
        } else {
            if isCachedLogVisible {
                print(" cache did not  get for url: \(url)")
            }
            
        }
            return cacheData
    }
    
    private func setupCache(){
        RMEndpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
