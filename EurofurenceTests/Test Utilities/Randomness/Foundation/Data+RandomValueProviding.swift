//
//  Data+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension Data: RandomValueProviding {
    
    static var random: Data {
        return String.random.data(using: .utf8)!
    }
    
}
