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
                    ForEach(self.printerestVM.collectionViewDataSource, id: \.self) { column in
                        VStack(alignment: HorizontalAlignment.center, spacing: self.printerestVM.spacing) {
                            ForEach(column){ imageVM in
                                AsyncImageView(viewModel: imageVM,
                                               placeholder: LoadingPlaceholder(text: "Loading from \nCuriosity..."),
                                               configuration: { $0.resizable()})
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
