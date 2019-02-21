//
//  Room+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension Room: RandomValueProviding {

    public static var random: Room {
        return Room(name: .random)
    }

}
