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
        NavigationView {
            PinterestCollectionView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
