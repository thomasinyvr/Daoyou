//
//  FlickrGateway.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import Foundation

struct FlickrGateway {
    
    // MARK: - API Key
    
    private struct FlickrApiKey {
        static let Key = "XXX"
    }
    
    // MARK: - Constants
    
    private struct FlickrApiUrl {
        static let BaseUrl = "https://api.flickr.com/services/rest/"
    }
    
    private struct FlickrApiFileKeys {
        static let PlistFileName = "FlickrApiKey"
        static let PlistKeysKey = "Key"
    }
    
    private struct FlickrQueryKeys {
        static let ApiKey = "api_key"
        static let Lat = "lat"
        static let Lon = "lon"
        static let Radius = "radius"
        static let Format = "format"
        static let NoJsonCallback = "nojsoncallback"
        static let Method = "method"
        static let PerPage = "per_page"
    }
    
    struct FlickrQueryItemValues {
        static let Json = "json"
        static let MethodPhotoSearch = "flickr.photos.search"
        static let NoJsonCallback = "1"
        static let Radius = 0.15 // km
        static let PerPage = 30 // Maximum photos per page
    }
    
    private struct FlickrQueryItems {
        static let MethodPhotoSearch = NSURLQueryItem(
            name: FlickrQueryKeys.Method,
            value: FlickrQueryItemValues.MethodPhotoSearch)
        
        static let ApiKey = NSURLQueryItem(
            name: FlickrQueryKeys.ApiKey,
            value: flickrApiKey)
        
        static let Format = NSURLQueryItem(
            name: FlickrQueryKeys.Format,
            value: FlickrQueryItemValues.Json)
        
        static let NoCallback = NSURLQueryItem(
            name: FlickrQueryKeys.NoJsonCallback,
            value: FlickrQueryItemValues.NoJsonCallback)
        
        static let Radius = NSURLQueryItem(
            name: FlickrQueryKeys.Radius,
            value: String(FlickrQueryItemValues.Radius))
        
        static let PerPage = NSURLQueryItem(
            name: FlickrQueryKeys.PerPage,
            value: String(FlickrQueryItemValues.PerPage))
    }
    
    // MARK: - Public methods
    
    static func searchForPhotosNearLocation(
        latitude latitude: Double,
                 longitude: Double,
                 handler: (inner: () throws -> [String: AnyObject]) -> Void) {
        let url = generateFlickrPhotoSearchUrl(latitude: latitude, longitude: longitude)
        NetworkManager.sharedInstance.getJsonForUrl(url, handler: handler)
    }
    
    // MARK: - URL Constructor
    
    private static var flickrApiUrl: NSURLComponents {
        let urlComp = NSURLComponents(string: FlickrApiUrl.BaseUrl)!
        urlComp.queryItems = [
            FlickrQueryItems.ApiKey,
            FlickrQueryItems.Format,
            FlickrQueryItems.NoCallback]
        return urlComp
    }
    
    private static func generateFlickrPhotoSearchUrl(
        latitude latitude: Double, longitude: Double) -> NSURL {
        
        let latQueryItem = NSURLQueryItem(name: FlickrQueryKeys.Lat, value: String(latitude))
        let longQueryItem = NSURLQueryItem(name: FlickrQueryKeys.Lon, value: String(longitude))
        let radiusQueryItem = FlickrQueryItems.Radius
        let photoSearchQueryItem = FlickrQueryItems.MethodPhotoSearch
        let perPageQueryItem = FlickrQueryItems.PerPage
        let url = flickrApiUrl
        url.queryItems = url.queryItems ?? []
        url.queryItems! += [latQueryItem, longQueryItem, radiusQueryItem]
        url.queryItems! += [photoSearchQueryItem, perPageQueryItem]
        return url.URL!
    }
    
    // MARK: - Flickr API key
    
    // This is based on the expectation that there exists a plist in the project
    // caled `FlickrApiKey` which has two String entries: `Key` and `Secret`.
    
    private static var flickrApiKey: String = {
        
        let bundle = NSBundle.mainBundle()
        guard
            let path = bundle.pathForResource(FlickrApiFileKeys.PlistFileName, ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
            let apiKey = dict[FlickrApiFileKeys.PlistKeysKey] as? String else {
                return FlickrApiKey.Key
        }
        
        return apiKey
    }()
    
    
}