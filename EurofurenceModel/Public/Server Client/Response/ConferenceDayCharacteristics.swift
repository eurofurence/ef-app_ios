//
//  ConferenceDayCharacteristics.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct ConferenceDayCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var date: Date

    public init(identifier: String, date: Date) {
        self.identifier = identifier
        self.date = date
    }

}
