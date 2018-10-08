//
//  IndexPath+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension IndexPath: RandomValueProviding {
    
    public static var random: IndexPath {
        return IndexPath(item: .random, section: .random)
    }
    
}
