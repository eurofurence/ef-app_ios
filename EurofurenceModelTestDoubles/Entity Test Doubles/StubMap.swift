//
//  Map+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import RandomDataGeneration

public struct StubMap: Map {

    public var identifier: MapIdentifier
    public var location: String

}

extension StubMap: RandomValueProviding {

    public static var random: StubMap {
        return StubMap(identifier: .random, location: .random)
    }

}
