//
//  ImageCache.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation
import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

protocol ImageCache {
    subscript(_ url:URL) -> UIImage? {get set}
}

struct TemporaryImageCache:ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    subscript(url: URL) -> UIImage? {
        get {
            cache.object(forKey: url as NSURL)
        }
        set {
            newValue == nil ? cache.removeObject(forKey: url as NSURL) : cache.setObject(newValue!, forKey: url as NSURL)
        }
    }
}
