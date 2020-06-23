//
//  EnvironmentValues+Extension.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var imageCache:ImageCache {
        get {
            self[ImageCacheKey.self]
        }
        set {
            self[ImageCacheKey.self] = newValue
        }
    }
}
