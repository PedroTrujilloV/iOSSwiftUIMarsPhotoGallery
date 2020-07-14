//
//  ImageOverlay.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 7/14/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import SwiftUI

struct ImageOverlay: View {
    private var text = ""
    init(text:String) {
        self.text = text
    }
    var body: some View {
        ZStack {
            Text(self.text)
                .fontWeight(Font.Weight.light)
            .font(Font.custom("NewMars", size: 10))
                .font(.caption)
                .padding(3)
                .foregroundColor(.white)
        }.background(Color.black)
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(3)
    }
} //overlay: "Credit: Ricardo Gomez Angel"


struct ImageOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ImageOverlay(text: "This is an overlay")
    }
}
