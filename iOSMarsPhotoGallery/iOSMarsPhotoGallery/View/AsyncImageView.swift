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
    @ObservedObject private var imageVM: ImageViewModel
    private let placeholder: Placeholder?
    private var text:String = ""
    
    init(url:URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil, text:String? = "", configuration: @escaping(Image) -> Image = {$0}) {
        
        self.imageVM = ImageViewModel(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
        self.text = text!
        
        print("\n\n>>\nAsyncImageView : \(String(describing: url)) \(String(describing: text))")

    }
    
    init(viewModel:ImageViewModel,
         placeholder: Placeholder? = nil,
         configuration: @escaping(Image) -> Image = {$0}) {
        
        self.imageVM = viewModel
        self.placeholder = placeholder
        self.configuration = configuration
        self.text = viewModel.fullDescription
    }
    
    private var image: some View {
        Group{
            if imageVM.image != nil {
                configuration(Image(uiImage: imageVM.image!))
                Image(uiImage: imageVM.image!)
                .resizable()
                //.scaledToFit()
                .overlay(ImageOverlay(text: self.text ), alignment: Alignment.bottomLeading)
                .cornerRadius(20.0)
            }
            else {
                placeholder
            }
        }
    }
    var body: some View {
        image
            .onAppear(perform: imageVM.load)
            .onDisappear(perform: imageVM.cancel)
            .cornerRadius(20.0)
    }
}

struct AsyncImageView_Previews:
    PreviewProvider {
    static var previews: some View {
        let imageVM = ImageViewModel(imageModel: ImageModel(img_src: "https://mars.nasa.gov/system/resources/detail_files/22300_PIA22928.jpg",
                                                            earth_date: "today",
                                                            camera: CameraModel(id: 112,
                                                                                name: "Front",
                                                                                rover_id: 5,
                                                                                full_name: "Front Stereo")
                                     ))
        
        AsyncImageView(viewModel: imageVM,
                       placeholder: Text("Hello, World!")) 
        
    }
}
