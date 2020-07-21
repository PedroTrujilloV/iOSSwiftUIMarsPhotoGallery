//
//  PinterestLazyGridView.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 7/13/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import SwiftUI
//import Combine

@available(iOS 14.0, *)
struct PinterestLazyGridView: View {
    @ObservedObject var pinterestVM: PinterestCollectionViewModel = PinterestCollectionViewModel()
    var body: some View {
        ScrollView{
            LazyVGrid(columns: pinterestVM.columns,
                      alignment:.center,
                      spacing: pinterestVM.spacing){
                ForEach( pinterestVM.datasource){ imageVM in
                    AsyncImageView(viewModel: imageVM,
                                   placeholder: LoadingPlaceholder(text: "Loading image.."),
                                   configuration: {$0.resizable()})
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct PinterestLazyGridView_Previews:
    PreviewProvider {
    static var previews: some View {
        Group {
            PinterestLazyGridView()
            PinterestLazyGridView()
                .preferredColorScheme(.dark)
        }
    }
}
