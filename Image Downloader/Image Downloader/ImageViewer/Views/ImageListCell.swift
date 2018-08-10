//
//  ImageListCell.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import UIKit

class ImageListCell: UICollectionViewCell {

    //MARK:- Outlets
    @IBOutlet weak var flickrImageview: UIImageView!
    
    //MARK:- HelperMethods
    func configure(model: ImageModel) { // Configure Cell
        flickrImageview.setDownloadedImage(with: model.thumbImageUrl) { (image, error) -> (Void) in
            model.image = image
        }
    }
}
