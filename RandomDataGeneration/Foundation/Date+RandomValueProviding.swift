//
//  Date+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension Date: RandomValueProviding {

    public static var random: Date {
        return Date(timeIntervalSince1970: .random)
    }

}
