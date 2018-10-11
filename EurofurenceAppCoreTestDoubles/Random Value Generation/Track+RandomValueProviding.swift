//
//  Track+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension Track: RandomValueProviding {

    public static var random: Track {
        return Track(name: .random)
    }

}
