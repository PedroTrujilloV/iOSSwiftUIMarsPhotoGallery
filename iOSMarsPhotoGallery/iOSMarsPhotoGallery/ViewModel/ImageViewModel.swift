//
//  ImageViewModel.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
    
    @Published var image: UIImage?
    private let url:URL
    private var cancelable:AnyCancellable?
    private var cache: ImageCache?
    private(set) var isLoading = false
    private static let imageProcessingQueue = DispatchQueue(label: "image_processing")
    
    init(url:URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancelable?.cancel()
    }
    
    func load() {
        
        guard !isLoading else {return}
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancelable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.imageProcessingQueue)
            .map({
                UIImage(data:$0.data)
            })
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] (subscription) in
                self?.onStart()
            }, receiveOutput: { [weak self] (image) in
                self?.cache(image)
            }, receiveCompletion: { [weak self] (completion) in
                self?.onFinish()
            }, receiveCancel: { [weak self] in
                self?.onFinish()
            }, receiveRequest: { [weak self] (demand) in // here verify self too
                self?.onStart() // verify this one // probably delete this one
            })
            .receive(on:DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel(){
        cancelable?.cancel()
    }
    
    private func cache(_ image: UIImage?){
        image.map{cache?[url] = $0}
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
}
