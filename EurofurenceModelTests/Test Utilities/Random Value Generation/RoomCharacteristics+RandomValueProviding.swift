//
//  RoomCharacteristics+RandomValueProviding.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension RoomCharacteristics: RandomValueProviding {
    
    public static var random: RoomCharacteristics {
        return RoomCharacteristics(identifier: .random, name: .random)
    }
    
}
