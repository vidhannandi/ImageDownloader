//
//  ImageModel.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import UIKit

class ImageModel {

    //MARK:- Varibales
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: String
    let title: String
    let ispublic: Bool
    let isfriend: Bool
    let isfamily: Bool
    var thumbImageUrl: String { // url for thumb image
        get {
            return String(format: kImageURL, farm, server, id, secret, "t")
        }
    }
    var largeImageUrl: String { // url for large image
        get {
            return String(format: kImageURL, farm, server, id, secret, "b")
        }
    }
    var image: UIImage?
    
    //MARK:- Init methods
    init(response: [AnyHashable : Any]) {
        id = response.getStringForKey("id")
        owner = response.getStringForKey("owner")
        secret = response.getStringForKey("secret")
        server = response.getStringForKey("server")
        farm = response.getStringForKey("farm")
        title = response.getStringForKey("title")
        ispublic = response.getBoolForKey("ispublic")
        isfriend = response.getBoolForKey("isfriend")
        isfamily = response.getBoolForKey("isfamily")
    }
}
