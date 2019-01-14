//
//  ImageCharacteristics.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct ImageCharacteristics: Equatable {

    public var identifier: String
    public var internalReference: String

    public init(identifier: String, internalReference: String) {
        self.identifier = identifier
        self.internalReference = internalReference
    }

}
