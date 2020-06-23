//
//  CameraModel.swift
//  iOSMarsPhotoGallery
//
//  Created by Pedro Trujillo on 6/23/20.
//  Copyright © 2020 Pedro Trujillo V. All rights reserved.
//

import Foundation

struct CameraModel: Codable, Hashable {
    
    let identifier = UUID()
    let id: Int
    let name : String
    let rover_id : Int
    let full_name : String
    
    static func == (lhs: CameraModel, rhs: CameraModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
