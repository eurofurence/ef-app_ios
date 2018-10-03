//
//  ImageRepository.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol ImageRepository {

    func save(_ image: ImageEntity)
    func deleteEntity(identifier: String)
    func loadImage(identifier: String) -> ImageEntity?
    func containsImage(identifier: String) -> Bool

}
