//
//  Identifier+RandomValueProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

extension Identifier: RandomValueProviding {

    public static var random: Identifier {
        return Identifier(.random)
    }

}
