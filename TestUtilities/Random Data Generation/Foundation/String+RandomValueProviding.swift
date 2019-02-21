//
//  String+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension String: RandomValueProviding {

    public static var random: String {
        return "\(arc4random())"
    }

}
