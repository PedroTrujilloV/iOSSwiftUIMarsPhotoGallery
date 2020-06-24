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



struct ImageOverlay: View {
    private var text = ""
    init(text:String) {
        self.text = text
    }
    var body: some View {
        ZStack {
            Text(self.text)
                .fontWeight(Font.Weight.light)
                .font(.caption)
//                .font(.system(size: 12.0))
                .padding(3)
                .foregroundColor(.white)
        }.background(Color.black)
        .opacity(0.8)
        .cornerRadius(20.0)
        .padding(3)
    }
} //overlay: "Credit: Ricardo Gomez Angel"



struct AsyncImageView<Placeholder:View>: View {
    private let configuration: (Image) -> Image
    @ObservedObject private var loader: ImageViewModel
    private let placeholder: Placeholder?
    private var text:String = ""
    
    init(url:URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil, text:String? = "", configuration: @escaping(Image) -> Image = {$0}) {
        
        self.loader = ImageViewModel(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
        self.text = text!
        
        print("\n\n>>\nAsyncImageView : \(String(describing: url)) \(String(describing: text))")

    }
    
    private var image: some View {
        Group{
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
                Image(uiImage: loader.image!)
                .resizable()
//                .scaledToFit()
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
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
            .cornerRadius(20.0)
    }
}
