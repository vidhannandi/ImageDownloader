//
//  ImageListViewController.swift
//  Image Downloader
//
//  Created by Vidhan Nandi on 9/08/18.
//  Copyright © 2018 Vidhan Nandi. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var imagelistView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- Variables
    let viewModel = ImageListViewModel()
    var loaderView: UICollectionReusableView! {
        didSet {
            if viewModel.modelsArray.count == 0 {
                toggleLoader(show: false)
            }
        }
    }
    private var selectedFrame : CGRect?
    private var customInteractor : CustomInteractor?
    var selectedImage:UIImage?

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update Navigation
        navigationController?.navigationBar.setBottomBorderColor(color: UIColor.clear)
    }
    
    //MARK:- Helper Methods
    func setupView() { // setup table view
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.white
        }
        navigationController?.delegate = self
    }
    
    func addHandler() { // call back from viewmodel
        // Create weak refrence to avoid retain cycle
        viewModel.completionHandler = { [weak self] (actionType) in
            switch actionType {
            case .reload:
                self?.imagelistView.reloadData()
            case .showError(let error):
                self?.showError(error: error)
            case .showLoader:
                self?.toggleLoader(show: true)
            case .hideLoader:
                self?.toggleLoader(show: false)
            }
        }
    }
    
    func showError(error: String) { // show Error
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:nil))
        self.present(alert, animated: true, completion:nil)
    }
    
    func toggleLoader(show: Bool) { // show/hide loader
        loaderView?.isHidden = !show
    }
    
    func performSearch() {
        viewModel.searchImages(searchText: searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    //MARK:- Actions
    @IBAction func searchAction(_ sender: Any) {
        performSearch()
    }
}

//MARK:- UISearchBarDelegate
extension ImageListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
}

//MARK:- UICollectionViewDataSource
extension ImageListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modelsArray.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageListCell", for: indexPath) as? ImageListCell {
            cell.configure(model: viewModel.modelsArray[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            loaderView = imagelistView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "reusableView", for: IndexPath(row: 0, section: 0))
            return loaderView
        }
        return UICollectionReusableView()
    }
}

//MARK:- UICollectionViewDelegate
extension ImageListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let theAttributes:UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: navigationController!.view)
        let obj = viewModel.modelsArray[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ImageDetailsViewController") as? ImageDetailsViewController {
            selectedImage = obj.image
            controller.viewModel = ImageDetailsViewModel(data: obj)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.modelsArray.count - 1 {
            viewModel.getNextPageImages()
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridSize: CGFloat = 3
        let spacing: CGFloat = 4
        let width = (collectionView.frame.size.width - (gridSize - 1) * spacing) / gridSize
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
}

//MARK:- UINavigationControllerDelegate
extension ImageListViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = customInteractor else { return nil }
        return ci.transitionInProgress ? customInteractor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = self.selectedFrame else { return nil }
        guard let selectedImage = selectedImage else { return nil}
        
        switch operation {
        case .push:
            self.customInteractor = CustomInteractor(attachTo: toVC)
            return CustomAnimator(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: selectedImage)
        default:
            return CustomAnimator(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: false, originFrame: frame, image: selectedImage)
        }
    }
}
