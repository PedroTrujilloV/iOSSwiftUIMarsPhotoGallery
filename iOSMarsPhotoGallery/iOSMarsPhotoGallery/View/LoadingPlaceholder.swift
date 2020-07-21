//
//  LoadingPlaceholder.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 7/15/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import SwiftUI

struct LoadingPlaceholder: View {
    var text = "Loading..."
    init(text:String ) {
        self.text = text
    }
    var body: some View {
        VStack(content: {
            if #available(iOS 14.0, *){
                ProgressView(self.text)
            } else {
                Text(self.text)
            }
        })
    }
}

struct LoadingPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        LoadingPlaceholder(text: "This is a placeholder.")
    }
}
