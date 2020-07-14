//
//  PinterestLazyGridView.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 7/13/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import SwiftUI
//import Combine

struct PinterestLazyGridView: View {
    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var pinterestVM: PinterestCollectionViewModel = PinterestCollectionViewModel()
    var body: some View {
        ScrollView{
            LazyVGrid(columns: pinterestVM.columns,
                      spacing: pinterestVM.spacing){
                ForEach( pinterestVM.datasource){ imageVM in
                    AsyncImageView(viewModel: imageVM,
                                   placeholder: Text("Loading.."),
                                   cache: cache,
                                   configuration: {$0.resizable()})
                }
            }
        }
    }
}

struct PinterestLazyGridView_Previews:
    PreviewProvider {
    static var previews: some View {
        let vm = PinterestCollectionViewModel(columnsForPortrait: 3)
        PinterestLazyGridView(pinterestVM: vm)
    }
}
