//
//  Enums.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import Foundation

enum CallBackType {
    case reload
    case showLoader
    case hideLoader
    case showError(error: String)
}
