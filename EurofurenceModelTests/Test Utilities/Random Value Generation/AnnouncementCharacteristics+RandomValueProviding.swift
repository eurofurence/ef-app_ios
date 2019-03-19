//
//  AnnouncementCharacteristics+RandomValueProviding.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 19/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension AnnouncementCharacteristics: RandomValueProviding {
    
    public static var random: AnnouncementCharacteristics {
        return AnnouncementCharacteristics(identifier: .random,
                                           title: .random,
                                           content: .random,
                                           lastChangedDateTime: .random,
                                           imageIdentifier: .random)
    }
    
}
