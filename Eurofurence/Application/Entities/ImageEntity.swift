//
//  ImageEntity.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class ImageEntity: Equatable {

    static func ==(lhs: ImageEntity, rhs: ImageEntity) -> Bool {
        return lhs.identifier == rhs.identifier &&
               lhs.pngImageData == rhs.pngImageData
    }

    var identifier: String
    var pngImageData: Data

    init(identifier: String, pngImageData: Data) {
        self.identifier = identifier
        self.pngImageData = pngImageData
    }

}
