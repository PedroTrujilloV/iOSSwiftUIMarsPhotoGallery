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
    @ObservedObject private var printerestVM:PinterestCollectionViewModel = PinterestCollectionViewModel()
    private var cancelable: AnyCancellable?
    
    var body: some View {
            ZStack(alignment: Alignment.center){
                pinterestCollection
                .onDisappear(perform: printerestVM.cancel)
            }
    }
    
    private var pinterestCollection: some View {
        ScrollView(Axis.Set.vertical, showsIndicators: true) {
            if !printerestVM.collectionViewDataSource.isEmpty {//
                HStack(alignment: VerticalAlignment.top, spacing: self.printerestVM.spacing) {
                    ForEach(0 ..< self.printerestVM.collectionViewDataSource.endIndex) { indexColumn in
                        VStack(alignment: HorizontalAlignment.center, spacing: self.printerestVM.spacing) {
                            ForEach(0 ..< self.printerestVM.collectionViewDataSource[indexColumn].endIndex){ indexRow in
                                AsyncImageView(url: URL(string: self.printerestVM.collectionViewDataSource[indexColumn][indexRow].img_src)!,
                                           placeholder: Text("Loading images from \nCuriosity...")
                                             .font(.caption)
                                            .font(Font.custom("NewMars", size: 10))
                                            .fontWeight(Font.Weight.light)
                                            .multilineTextAlignment(.center),
                                       cache: self.cache,
                                       text: self.printerestVM.collectionViewDataSource[indexColumn][indexRow].camera.full_name,
                                       configuration: {
                                        $0.resizable()
                                })
                                    .frame(
                                        minWidth: self.printerestVM.cellSize.width,
                                        minHeight: self.printerestVM.cellSize.height * CGFloat(Float.random(in: 0.8..<1.2)),
                                            alignment: Alignment.center)
                                    .aspectRatio(2/3, contentMode: .fit)
                            }
                        }
                        .background(Color.clear)
                    }
                }
                .background(Color.clear)
            } // if end
        }
        .background(Color.clear)
    }

}

struct PinterestCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        PinterestCollectionView()
//        .background(
//                Image("background")
//                .resizable()
//                .edgesIgnoringSafeArea(Edge.Set.all)
//                .scaledToFit()
//        )
    }
}
