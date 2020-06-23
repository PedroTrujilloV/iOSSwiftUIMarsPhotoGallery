//
//  PinterestCollectionViewModel.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class PinterestCollectionViewModel: ObservableObject {
    
    @Published var results:PhotosModel?
    private let url:URL
    private var cancelable:AnyCancellable?
    private static let urlProcessingQueue = DispatchQueue(label: "url_processing")
    
    private var numberOfColumns = 3
    private var numberOfRows:Int { return self.results != nil ? self.results!.photos.count : 0}
    public var spacing:CGFloat = 5.0
    private var numberOfObjectsPerColumn: Int {
          let columnObjects = self.numberOfRows/self.numberOfColumns
          let leftover = numberOfRows % numberOfColumns
          let total = leftover > 0 ? columnObjects + 1 : columnObjects
          return total
    }

    public var collectionViewDataSource:Array<Array<ImageModel>> {
        print("\n\n>>\ncollectionViewDataSource self.results.photos \(String(describing: self.results?.photos))")
        let chuncked = self.results != nil ? self.results!.photos.chunked(into: numberOfObjectsPerColumn) : []
          print(chuncked)
          return chuncked
    }
    
    init(url:URL, columns: Int = 3 ) {
        self.url = url
        self.numberOfColumns = columns
    }
    
    deinit {
        cancelable?.cancel()
    }
    
    func load() {
        
        cancelable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.urlProcessingQueue)
            .map{
                print("\n\n>>\n$0.data: \($0.data)")
                return $0.data
                }
            .decode(type: PhotosModel.self, decoder: JSONDecoder())
            .receive(on:DispatchQueue.main)
            .sink(receiveCompletion: { (suscribersCompletion) in
                switch suscribersCompletion {
                case .finished:
                    print("\n\n>>\nPinterestCollectionViewModel.cancelable success")
                case .failure(let error):
                    print("\n\n>>\nPinterestCollectionViewModel.cancelable error: \(error)")
                }
            }, receiveValue: { (photosModel) in
                print("\n\n>>\nreceiveValue \(String(describing: photosModel))")
                self.results = photosModel
            })
    }
    
    func cancel(){
        cancelable?.cancel()
    }
    
}
