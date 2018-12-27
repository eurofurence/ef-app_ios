//
//  Day+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import RandomDataGeneration

extension Day: RandomValueProviding {

    public static var random: Day {
        return Day(date: .random)
    }

}
