//
//  Event2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension Event2: RandomValueProviding {
    
    static var random: Event2 {
        return Event2(title: .random, room: .random, startDate: .random)
    }
    
}
