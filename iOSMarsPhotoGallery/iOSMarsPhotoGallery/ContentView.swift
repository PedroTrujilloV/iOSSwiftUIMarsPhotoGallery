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

struct PinterestCollectionView: View {
    
    @Environment(\.imageCache) var cache: ImageCache
    private var cancelable: AnyCancellable?
    @ObservedObject private var printerestVM:PinterestCollectionViewModel
    
    
    init() {
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1&api_key=4AeCJdckn1CYnwMFlRLHN2zz6d6lmCEPzxWgp5sE"//"https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=DEMO_KEY"
        if let nasaURL = URL(string: urlString)  {
            printerestVM = PinterestCollectionViewModel(url: nasaURL)
        } else {
            fatalError("ContentView_Previews.url error: Provided URL string doesn't work")
        }
    }
    
    init(url:URL) {
        printerestVM = PinterestCollectionViewModel(url: url)
    }
    
    var body: some View {
        NavigationView {
            pinterestCollection
                .onAppear(perform: printerestVM.load)
                .onDisappear(perform: printerestVM.cancel)

        }
    }

    
    private var pinterestCollection: some View {
        ScrollView(Axis.Set.vertical, showsIndicators: true) {
            HStack(alignment: VerticalAlignment.top, spacing: printerestVM.spacing) {
                ForEach(printerestVM.collectionViewDataSource, id: \.self){ itemsInColumn in
                    VStack(alignment: HorizontalAlignment.center, spacing: self.printerestVM.spacing) {
                        ForEach(itemsInColumn, id: \.self){ item in
                            AsyncImageView(url: item.img_src,
                                       placeholder: Text("Loading from \nMAVEN \nsatelite...")
//                                        .font(.system(size:12))
                                        .fontWeight(Font.Weight.light)
                                        .multilineTextAlignment(.center),
                                   cache: self.cache,
                                   configuration: {
                                    $0.resizable()
                            })
                            .frame( minHeight: 100, idealHeight: 200, maxHeight: 400, alignment: .center)
                                .aspectRatio(2/3, contentMode: .fit)
                                .cornerRadius(22.0)
                        }
                    }
                }
            }
        }
    }

}

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
