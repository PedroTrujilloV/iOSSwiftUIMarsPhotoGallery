//
//  PinterestCollectionView.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct PinterestCollectionView: View {
    
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject private var printerestVM:PinterestCollectionViewModel
    private var cancelable: AnyCancellable?

    init() {
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1&api_key=4AeCJdckn1CYnwMFlRLHN2zz6d6lmCEPzxWgp5sE"//
//        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1&api_key=DEMO_KEY"
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
//        NavigationView {
            pinterestCollection
//                .onAppear(perform: printerestVM.load)
                .onDisappear(perform: printerestVM.cancel)

//        }
    }
    
    private var pinterestCollection: some View {
        ScrollView(Axis.Set.vertical, showsIndicators: true) {
            if !printerestVM.collectionViewDataSource.isEmpty {
                HStack(alignment: VerticalAlignment.top, spacing: printerestVM.spacing) {
                    ForEach(printerestVM.collectionViewDataSource, id: \.self) { itemsInColumn in
                        VStack(alignment: HorizontalAlignment.center, spacing: self.printerestVM.spacing) {
                            ForEach(itemsInColumn, id: \.self){ item in
                                AsyncImageView(url: URL(string: item.img_src)!,
                                           placeholder: Text("Loading from \nMAVEN \nsatelite...")
    //                                        .font(.system(size:12))
                                            .fontWeight(Font.Weight.light)
                                            .multilineTextAlignment(.center),
                                       cache: self.cache,
                                       configuration: {
                                        $0.resizable()
                                })
//                                    .frame(width: self.printerestVM.cellSize.width, height: self.printerestVM.cellSize.height, alignment: .center)
                                    .frame(minWidth: self.printerestVM.cellSize.width,
                                            idealWidth: self.printerestVM.cellSize.width,
                                            maxWidth: self.printerestVM.cellSize.width,
                                            minHeight: self.printerestVM.cellSize.height,
                                            idealHeight: self.printerestVM.cellSize.height * 1.2,
                                            maxHeight: self.printerestVM.cellSize.height * 1.4,
                                            alignment: .center)
                                    .aspectRatio(2/3, contentMode: .fit)
                                    .cornerRadius(22.0)
                            }
                        }
                    }
                }
                .background(Color.orange)
            }
        }
        .frame(width: printerestVM.frameSize.width, height: printerestVM.frameSize.height)
        .background(Color.green)
    }

}

struct PinterestCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
