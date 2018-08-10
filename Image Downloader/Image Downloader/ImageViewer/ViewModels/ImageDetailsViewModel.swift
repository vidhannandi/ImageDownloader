//
//  ImageDetailsViewModel.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import UIKit

class ImageDetailsViewModel: NSObject {

    //MARK:- Variables
    let model: ImageModel
    
    //MARK:- Init methods
    init(data: ImageModel) {
        model = data
    }
}
