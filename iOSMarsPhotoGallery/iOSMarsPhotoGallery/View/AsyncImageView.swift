//
//  AsyncImageView.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct AsyncImageView<Placeholder:View>: View {
    private let configuration: (Image) -> Image
    @ObservedObject private var loader: ImageViewModel
    private let placeholder: Placeholder?
    
    init(url:URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil, configuration: @escaping(Image) -> Image = {$0}) {
        self.loader = ImageViewModel(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    private var image: some View {
        Group{
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
                Image(uiImage: loader.image!)
                .resizable()
            }
            else {
                placeholder
            }
        }
    }
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
}
