//
//  PhotoListViewModel.swift
//  MVVM
//
//  Created by 이동건 on 29/06/2018.
//  Copyright © 2018 이동건. All rights reserved.
//

import Foundation

class PhotoListViewModel {
    //MARK: Properties
    let apiService: APIServiceProtocol
    private var photos: [Photo] = [Photo]()
    var selectedPhoto: Photo?
    var isAllowSegue: Bool = false
    
    //MARK: Observed Properties
    private var cellViewModels:[PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet{
            // notify
            self.reloadTableViewClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isLoading: Bool = false {
        didSet{
            // notify
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet{
            // notify
            self.showAlertClosure?()
        }
    }
    
    //MARK: Binding Closures
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var showAlertClosure: (()->())?
    
    //MARK: Initializer
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    //MARK: Methods
    func requestFetchData(){
        self.isLoading = true // trigger activity indicator startAnimating
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            // Compelete Fetching Data
            self?.isLoading = false // trigger activity indicator stopAnimating
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedPhoto(photos: photos)
            }
        }
    }
    
    private func processFetchedPhoto( photos: [Photo] ) {
        self.photos = photos // Cache
        var viewModels = [PhotoListCellViewModel]() // TableViewCellViewModel
        photos.forEach({viewModels.append(createCellViewModel(photo: $0))})
        self.cellViewModels = viewModels // trigger photoListTableView reloadData
    }
    
    func createCellViewModel( photo: Photo ) -> PhotoListCellViewModel {
        //Wrap a description
        var descTextContainer: [String] = [String]()
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }
        if let description = photo.description {
            descTextContainer.append( description )
        }
        let desc = descTextContainer.joined(separator: " - ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return PhotoListCellViewModel( titleText: photo.name,
                                       descText: desc,
                                       imageUrl: photo.image_url,
                                       dateText: dateFormatter.string(from: photo.created_at) )
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
}

//MARK:- User Interaction
extension PhotoListViewModel {
    func userPressed(at indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        if photo.for_sale {
            // allow segue
            self.isAllowSegue = true
            self.selectedPhoto = photo
        }else{
            self.isAllowSegue = false
            self.selectedPhoto = nil
            // trigger alert
            self.alertMessage = "This item is not for sale"
        }
    }
}

