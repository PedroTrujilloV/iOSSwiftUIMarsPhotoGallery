//
//  PhotosModel.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation

struct PhotosModel : Codable, Hashable {
    
    let identifier = UUID()
    let photos: [ImageModel]
    
    static func == (lhs: PhotosModel, rhs: PhotosModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
