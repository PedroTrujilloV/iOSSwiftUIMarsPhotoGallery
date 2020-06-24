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
        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=2000&camera=FHAZ&api_key=DEMO_KEY"//
//        let urlString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=580&camera=FHAZ&page=1&api_key=DEMO_KEY"
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
                .onDisappear(perform: printerestVM.cancel)

        }
    }
    
    private var pinterestCollection: some View {
        ScrollView(Axis.Set.vertical, showsIndicators: true) {
            if !printerestVM.collectionViewDataSource.isEmpty {
                HStack(alignment: VerticalAlignment.top, spacing: self.printerestVM.spacing) {
                    ForEach(0 ..< self.printerestVM.collectionViewDataSource.endIndex) { indexColumn in
                        VStack(alignment: HorizontalAlignment.center, spacing: self.printerestVM.spacing) {
                            ForEach(0 ..< self.printerestVM.collectionViewDataSource[indexColumn].endIndex){ indexRow in
                                AsyncImageView(url: URL(string: self.printerestVM.collectionViewDataSource[indexColumn][indexRow].img_src)!,
                                           placeholder: Text("Loading from \nMAVEN \nsatelite...")
                                             .font(.caption)
//                                            .font(.system(size:10))
                                            .fontWeight(Font.Weight.light)
                                            .multilineTextAlignment(.center),
                                       cache: self.cache,
                                       text: self.printerestVM.collectionViewDataSource[indexColumn][indexRow].camera.full_name,
                                       configuration: {
                                        $0.resizable()
                                })
                                    .frame(
//                                        minWidth: self.printerestVM.cellSize.width,
                                          // idealWidth: self.printerestVM.cellSize.width * 1.1,
                                        maxWidth: (UIScreen.main.bounds.size.width / CGFloat(self.printerestVM.collectionViewDataSource.count)) - (self.printerestVM.spacing * CGFloat(self.printerestVM.collectionViewDataSource.count)),
                                        minHeight: self.printerestVM.cellSize.height * CGFloat(Float.random(in: 0.8..<1.2)),
//                                            idealHeight: self.printerestVM.cellSize.height * CGFloat(Float.random(in: 1..<1.19)),
//                                            maxHeight: self.printerestVM.cellSize.height * CGFloat(Float.random(in: 1.2..<1.5)),
                                            alignment: Alignment.center)
                                    .aspectRatio(2/3, contentMode: .fit)
                            }
                        }
                    }
                }
                .frame(width: self.printerestVM.frameSize.width)
//                .background(Color.orange)
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: self.printerestVM.frameSize.height)
//        .background(Color.green)
    }

}

struct PinterestCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        PinterestCollectionView()
    }
}
