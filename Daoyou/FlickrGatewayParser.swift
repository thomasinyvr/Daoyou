//
//  FlickrGatewayParser.swift
//  Daoyou
//
//  Created by Thomas Friesman on 2016-07-12.
//  Copyright © 2016 Thomas Friesman. All rights reserved.
//

import Foundation

struct FlickrGatewayParser {
    
    
    
    // MARK: - Flickr.Photos.Search
    
    private struct PhotosSearchConstants {
        static let Photos = "photos"
        static let Photo = "photo"
    }
    
    static func parsePhotosSearchResult(
        json: [String: AnyObject],
        aPin pin: Pin)
        throws -> [Photo] {
            guard
                let
                jsonPhotos = json[PhotosSearchConstants.Photos] as? [String: AnyObject],
                jsonPhoto = jsonPhotos[PhotosSearchConstants.Photo] as? [[String: AnyObject]]
                    else {
                    throw FlickrGatewayError.JsonParsing
            }
            
            let photos = jsonPhoto.map { Photo(dict: $0, aPin: pin) }
    
            return photos
    }
}
    