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
    private let urlString :String = {
            let stringurl = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=2000&camera=FHAZ&page=1&api_key="
            let apiKey:String = ProcessInfo.processInfo.environment["API_KEY"] ?? "DEMO_KEY"
            return stringurl + apiKey
    }()//"https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=580&camera=FHAZ&page=1&api_key=DEMO_KEY"

    @Published var results:PhotosModel?
    private let url:URL
    private var cancelable:AnyCancellable?
    private static let urlProcessingQueue = DispatchQueue(label: "url_processing")
    
    private var numberOfColumnsForPortrait = 3
    @Published private var numberOfColumns:Int = 3
    @Published private var numberOfRows:Int = 1 {
        didSet{
            self.calculateNumberOfObjectsPerColumnForTraits()
            self.loadDataSource()
        }
    }
    
    public var spacing:CGFloat = 5.0
    @Published var numberOfObjectsPerColumn: Int = 1

    @Published public var collectionViewDataSource:Array<Array<ImageModel>> = []
    @Published public var cellSize:CGSize = CGSize(width: 50, height: 50)
    @Published public var frameSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    private var cellWidth:CGFloat
    
    init( columnsForPortrait: Int = 3 ) {
        self.numberOfColumnsForPortrait = columnsForPortrait
        self.cellWidth =  ( (UIScreen.main.bounds.size.width - (self.spacing * 2)) / CGFloat(self.numberOfColumnsForPortrait) )
        if let nasaURL = URL(string: urlString)  {
            self.url = nasaURL
        } else {
            fatalError("PinterestCollectionViewModel.init.url error: Provided URL string doesn't work")
        }
        self.load()
        self.recalculateLayout()
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
                    print("\n\n>>\nPinterestCollectionViewModel.cancelable error: \n \(error)")
                }
            }, receiveValue: { [weak self] (photosModel) in
                print("\n\n>>\nreceiveValue: \(String(describing: photosModel))")
                self?.results = photosModel
                self?.recalculateLayout()
            })
    }
    
    private func recalculateLayout(){
        self.calculateNumberOfRows()
        self.calculateNumberOfColumns()
        self.calculateNumberOfObjectsPerColumnForTraits()
        self.loadDataSource()
        self.updateCellSize()
        self.updateFrameSize()
    }
    
    private func calculateNumberOfRows(){
        self.numberOfRows = self.results != nil ? self.results!.photos.count : 0
    }
    
    private func calculateNumberOfColumns(){
        self.numberOfColumns = Int ( (UIScreen.main.bounds.size.width) / (self.cellWidth) )
        print("\n\n>>\n calculateNumberOfColumns bounds \(UIScreen.main.bounds.size.width) / cellWidth \(self.cellWidth) = numberOfColumns \(numberOfColumns)")
    }
    
    private func calculateNumberOfObjectsPerColumnForTraits () {
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
        let h = (UIScreen.main.bounds.size.height/3) - (self.spacing * 2)
        self.cellSize = CGSize(width: self.cellWidth, height: h)
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
