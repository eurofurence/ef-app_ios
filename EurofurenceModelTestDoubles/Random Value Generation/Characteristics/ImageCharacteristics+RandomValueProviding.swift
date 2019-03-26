//
//  ImageCharacteristics+RandomValueProviding.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension ImageCharacteristics: RandomValueProviding {
    
    public static var random: ImageCharacteristics {
        return ImageCharacteristics(identifier: .random, internalReference: .random, contentHashSha1: .random)
    }
    
}
