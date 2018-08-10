//
//  ImageDetailsViewController.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import UIKit

class ImageDetailsViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- Variables
    var viewModel: ImageDetailsViewModel!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    //MARK:- Helper Methods
    func setupNavigation() { // Update Navigation
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor.white)
        navigationItem.title = viewModel.model.title
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupUI() { // Update UI
        activityIndicator.startAnimating()
        imageView.setDownloadedImage(with: viewModel.model.thumbImageUrl) { (image, error) -> (Void) in // Fetch the already downloaded thumb Image
            DispatchQueue.main.async {
                self.imageView.setDownloadedImage(with: self.viewModel.model.largeImageUrl, placeholder: image) { [weak self] (image, error) -> (Void) in
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
