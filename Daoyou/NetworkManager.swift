//
//  NetworkManager.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import UIKit

struct NetworkManager {
    
    // MARK: - Property helpers
    
    private var session: NSURLSession {
        return NSURLSession.sharedSession()
    }
    
    // MARK: - Singleton
    
    static let sharedInstance = NetworkManager()
    
    private init() { }
    
    // MARK: - GET JSON
    
    func getJsonForUrl(url: NSURL, handler: (inner: () throws -> [String: AnyObject]) -> Void) {
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            do {
                
                guard error == nil else {
                    print("downloadJsonForUrl, error: \(error)")
                    handler(inner: { throw NetworkManagerError.Unknown })
                    return
                }
                
                guard let data = data else {
                    print("downloadJsonForUrl, no data")
                    handler(inner: { throw NetworkManagerError.NoData })
                    return
                }
                
                guard let json = try NSJSONSerialization.JSONObjectWithData(
                    data, options: []) as? [String: AnyObject] else {
                        print("downloadJsonForUrl, error parsing json")
                        handler(inner: { throw NetworkManagerError.ParsingJson })
                        return
                }
                
                return handler(inner: { return json })
                
            } catch {
                handler(inner: { throw NetworkManagerError.Unknown })
            }
        }
        task.resume()
    }
    
    // MARK: - GET Data
    
    func getImageForUrl(url: NSURL, handler: (inner: () throws -> UIImage) -> Void) {
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            guard error == nil else {
                print("getImageForUrl, error: \(error)")
                handler(inner: { throw NetworkManagerError.Unknown })
                return
            }
            
            guard let data = data else {
                print("getImageForUrl, no data")
                handler(inner: { throw NetworkManagerError.NoData })
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("downloadJsonForUrl, error parsing json")
                handler(inner: { throw NetworkManagerError.ParsingImage })
                return
            }
            
            return handler(inner: { return image })
            
        }
        task.resume()
    }
    
}

