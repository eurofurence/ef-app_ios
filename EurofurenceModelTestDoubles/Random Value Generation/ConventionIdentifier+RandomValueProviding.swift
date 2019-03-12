//
//  ConventionIdentifier+RandomValueProviding.swift
//  EurofurenceModelTestDoubles
//
//  Created by Thomas Sherwood on 12/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

extension ConventionIdentifier: RandomValueProviding {
    
    public static var random: ConventionIdentifier {
        return ConventionIdentifier(identifier: .random)
    }
    
}
