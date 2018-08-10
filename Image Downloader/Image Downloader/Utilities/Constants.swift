//
//  Constants.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import Foundation

let kPageSize = 100
let kUnknownError = "An Unknown error has occured"
let kFlickrAPIKey = "2c621073cb6aa5c12ef5aa14aa4cdcb0"
let kFlickrAPISecret = "db808e1145d70dce"

let kBaseURL = "https://api.flickr.com/services/rest/"

let kSearchURL = "\(kBaseURL)?method=flickr.photos.search&api_key=\(kFlickrAPIKey)"
let kImageURL = "https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg"
