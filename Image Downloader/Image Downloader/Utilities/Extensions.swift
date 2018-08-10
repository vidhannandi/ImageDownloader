//
//  Extensions.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import UIKit

//MARK:- Dictionary
extension Dictionary {
    
    func getOptionalStringForKey(_ key: Key) -> String? {
        if let value = self[key] as? String, !value.isEmpty {
            return value
        }
        if let value = self[key] as? Double {
            return floor(value) == value ? String(format: "%.0f", value) : String(value)
        }
        return nil
    }
    
    func getStringForKey(_ key: Key) -> String {
        if let value = self.getOptionalStringForKey(key) {
            return value
        }
        return ""
    }
    
    func getOptionalBoolForKey(_ key: Key) -> Bool? {
        if let value = self[key] as? Bool {
            return value
        }
        if let value = self[key] as? Int  {
            return value == 1
        }
        return nil
    }
    
    func getBoolForKey(_ key: Key) -> Bool {
        if let value = self.getOptionalBoolForKey(key) {
            return value
        }
        return false
    }
}

//MARK:- Image View
extension UIImageView {
    //method for setting image asynchronously
    func setDownloadedImage(with url: String, placeholder: UIImage? = nil, completion: ImageResponse? = nil){
        self.image = placeholder
        ImageDownloadManager.shared.addOperation(url: url, imageView: self) { [weak self]
            (image, error) -> (Void) in
            self?.image = image
            completion?(image, error)
        }
    }
}

//MARK:- UINavigationBar
extension UINavigationBar {
    func setBottomBorderColor(color: UIColor) {
        shadowImage = UIImage()
        let navigationSeparator = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5))
        navigationSeparator.backgroundColor = color
        navigationSeparator.isOpaque = true
        navigationSeparator.tag = -987
        if let oldView = self.viewWithTag(-987) {
            oldView.removeFromSuperview()
        }
        self.addSubview(navigationSeparator)
    }
}
