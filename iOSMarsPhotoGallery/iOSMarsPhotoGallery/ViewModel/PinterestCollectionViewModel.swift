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
    @Published private var numberOfRows:Int = 1 {
        didSet{
            self.calculateNumberOfObjectsPerColumn()
            self.loadDataSource()
        }
    }
    
    public var spacing:CGFloat = 5.0
    @Published var numberOfObjectsPerColumn: Int = 1

    @Published public var collectionViewDataSource:Array<Array<ImageModel>> = []
    @Published public var cellSize:CGSize = CGSize(width: 50, height: 50)
    @Published public var frameSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    init(url:URL, columns: Int = 3 ) {
        self.url = url
        self.numberOfColumns = columns
        self.load()
    }
    
    deinit {
        cancelable?.cancel()
    }
    
    func load() {
        cancelable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.urlProcessingQueue)
            .map({
                print("\n\n>>\n$0.data: \($0.data)")
                return $0.data
                })
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
                print("\n\n>>\nreceiveValue: \(String(describing: photosModel))")
                self.results = photosModel
                self.calculateNumberOfRows()
                self.calculateNumberOfObjectsPerColumn()
                self.loadDataSource()
                self.updateCellSize()
                self.updateFrameSize()
            })
    }
    
    private func calculateNumberOfRows(){
        self.numberOfRows = self.results != nil ? self.results!.photos.count : 0
    }
    
    private func calculateNumberOfObjectsPerColumn () {
        let columnObjects = self.numberOfRows/self.numberOfColumns
        let leftover = numberOfRows % numberOfColumns
        let total = leftover > 0 ? columnObjects + 1 : columnObjects
        self.numberOfObjectsPerColumn = total
    }
    
    private func loadDataSource() {
        print("\n\n>>\ncollectionViewDataSource self.results.photos: \(String(describing: self.results?.photos))")
        let chuncked = self.results != nil ? self.results!.photos.chunked(into: numberOfObjectsPerColumn) : []
        var i = 0
        print("\n\n>>\n numberOfObjectsPerColumn:\(numberOfObjectsPerColumn) numberOfRows: \(numberOfRows)")
        for chunk in chuncked {
            print("\n\n>>\ncollectionViewDataSource chunck [\(i)]: \(String(describing: chunk)) . count: \(chunk.count)")
            i += 1
        }
        self.collectionViewDataSource = chuncked
    }
    
    private func updateCellSize(){
        let w = (UIScreen.main.bounds.size.width / CGFloat(self.numberOfColumns)) - (self.spacing * 2)
        let h = (UIScreen.main.bounds.size.height/3) - (self.spacing * 2)
        self.cellSize = CGSize(width: w, height: h)
    }
    
    private func updateFrameSize(){
        let w = (UIScreen.main.bounds.size.width)
        let h = (UIScreen.main.bounds.size.height)
        self.frameSize = CGSize(width: w, height: h)
    }
    
    func cancel(){
        cancelable?.cancel()
    }
    
}
