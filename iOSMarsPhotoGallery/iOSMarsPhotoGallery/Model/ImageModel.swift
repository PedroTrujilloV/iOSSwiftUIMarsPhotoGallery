//
//  ImageModel.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation

struct ImageModel: Codable, Hashable { //}, Identifiable {
//    var id: ObjectIdentifier
    var identifier = UUID()
    let img_src:String
    let earth_date:String
    let camera : CameraModel
    //    let rover:Data

    
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
