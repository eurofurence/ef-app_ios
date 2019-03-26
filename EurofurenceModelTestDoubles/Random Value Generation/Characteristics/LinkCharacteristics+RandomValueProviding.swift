//
//  LinkCharacteristics+RandomValueProviding.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension LinkCharacteristics: RandomValueProviding {
    
    public static var random: LinkCharacteristics {
        return LinkCharacteristics(name: .random, fragmentType: .random, target: .random)
    }
    
}

extension LinkCharacteristics.FragmentType: RandomValueProviding {
    
    public static var random: LinkCharacteristics.FragmentType {
        return .WebExternal
    }
    
}
