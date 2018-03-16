//
//  URL+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension URL: RandomValueProviding {
    
    static var random: URL {
        return URL(string: "https://\(String.random)")!
    }
    
}
