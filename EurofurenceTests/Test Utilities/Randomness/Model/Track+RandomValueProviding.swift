//
//  Track+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension Track: RandomValueProviding {
    
    static var random: Track {
        return Track(name: .random)
    }
    
}
