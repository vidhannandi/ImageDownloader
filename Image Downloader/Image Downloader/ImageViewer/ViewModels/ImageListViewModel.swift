//
//  ImageListViewModel.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import UIKit

class ImageListViewModel {

    //MARK:- Variables
    private(set) var modelsArray = [ImageModel]()
    private var currentPage = 1
    private var totalPages = 1
    private var text: String?
    private var isRequestInProgress = false
    var completionHandler : ((_ action : CallBackType) -> Void)?

    //MARK:- Helper Methods
    private func getFormattedURL() -> String { // Format Url
        var urlString = kSearchURL
        urlString += "&format=json&page=\(currentPage)&per_page=\(kPageSize)"
        if let text = text {
            urlString += "&text=\(text)"
        }
        return urlString
    }
    
    private func getJSON(stringResponse: String?) -> [AnyHashable: Any]? { // convert string to JSON
        var response : [AnyHashable: Any]?
        if let stringResponse = stringResponse {
            var dataReponnse = stringResponse.replacingOccurrences(of: "jsonFlickrApi(", with: "")
            dataReponnse = String(dataReponnse.dropLast())
            do {
                if let data = dataReponnse.data(using: String.Encoding.utf8),
                    let jsonDict = try JSONSerialization.jsonObject(with: data) as? [AnyHashable: Any] {
                    response = jsonDict
                }
            } catch {
                debugPrint(error.localizedDescription)
                completionHandler?(.showError(error: error.localizedDescription))
            }
        }
        return response
    }
    
    private func getErrorMessage(response: [AnyHashable : Any]?, error: Error?) -> String? { // check for error response
        var errorMsg: String?
        if let error = error {
            errorMsg = error.localizedDescription
        } else if let response = response {
            if response.getStringForKey("stat").lowercased() != "ok" {
                let msg = response.getStringForKey("message")
                errorMsg = msg.isEmpty ? kUnknownError : msg
            }
        }
        return errorMsg
    }
    
    private func parseData(response: [AnyHashable : Any]?, error: Error?) { // parse data and add to data models
        if let error = getErrorMessage(response: response, error: error) {
            completionHandler?(.showError(error: error))
        } else if let photos = response?["photos"] as? [AnyHashable : Any] {
            if let page = photos["page"] as? Int {
                currentPage = page
            }
            
            if let pages = photos["pages"] as? Int {
                totalPages = pages
            }
            
            if let photoArr = photos["photo"] as? [[AnyHashable : Any]] {
                var dataSet = [ImageModel]()
                for item in photoArr {
                    dataSet.append(ImageModel(response: item))
                }
                if dataSet.count > 0 {
                    modelsArray.append(contentsOf: dataSet)
                    completionHandler?(.reload)
                }
            }
        }
    }
    
    //MARK:- Network Methods
    func searchImages(searchText: String? = nil) { // search for text
        if !isRequestInProgress && searchText?.isEmpty == false {
            text = searchText
            if modelsArray.count > 0 {
                modelsArray = []
                completionHandler?(.reload)
            }
            getImages()
        }
    }
    
    func getNextPageImages() { // load next page
        if !isRequestInProgress{
            currentPage += 1
            if currentPage <= totalPages {
                getImages()
            }
        }
    }
    
    private func getImages() { // api call for images
        completionHandler?(.showLoader)
        NetworkManager.shared.stringRequest(urlString: getFormattedURL(), type: RequestType.get) { [weak self] (stringResponse, error) -> (Void) in
            self?.parseData(response: self?.getJSON(stringResponse: stringResponse), error: error)
            self?.completionHandler?(.hideLoader)
        }
    }
}
