//
//  ImageOperation.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//


import UIKit

class ImageOperation: Operation {
    
    //MARK:- Enum
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String { return "is" + self.rawValue }
    }
    
    //MARK:- Variables
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    let url : String?
    let customCompletionBlock: ImageResponse?
    
    //MARK:- Init
    init(url : String, completionBlock : @escaping ImageResponse) {
        self.url = url
        self.customCompletionBlock = completionBlock
    }
    
    //MARK:- Additional methods
    func finishTask() {
        if isExecuting {
            state = .finished
        }
    }
    
    //MARK:- overriden Method
    override func start() {
        if self.isCancelled {
            finishTask()
        } else {
            state = .ready
            main()
        }
    }
    
    override func main() {
        if let url = self.url, !self.isCancelled {
            state = .executing
            NetworkManager.shared.imageRequest(urlString: url) { [weak self] (image, error) -> (Void) in
                if self?.isCancelled == false {
                    self?.customCompletionBlock?(image, error)
                }
                self?.finishTask()
            }
        } else {
            finishTask()
        }
    }
}
