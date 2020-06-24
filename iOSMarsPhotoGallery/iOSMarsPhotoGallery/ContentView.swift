//
//  ContentView.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/22/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//
import Foundation
import SwiftUI
import Combine


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PinterestCollectionView()
    }
}

    
//    private var list: some View {
//        List(0..<numberOfRows, id: \.self) {_ in
//            AsyncImageView(url: self.url,
//                       placeholder: Text("Loading from MAVEN satelite..."),
//                       cache: self.cache)
//                .frame( minHeight: 100, idealHeight: 200, maxHeight: 300, alignment: .center)
//                .aspectRatio(2/3, contentMode: .fit)
//        }
//    }
