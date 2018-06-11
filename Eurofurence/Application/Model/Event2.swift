//
//  Event2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct Event2: Equatable {

    struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        typealias RawValue = String

        init(_ value: String) {
            self.rawValue = value
        }

        init?(rawValue: String) {
            self.rawValue = rawValue
        }

        var rawValue: String

        static func < (lhs: Event2.Identifier, rhs: Event2.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    var identifier: Event2.Identifier
    var title: String
    var abstract: String
    var room: Room
    var track: Track
    var hosts: String
    var startDate: Date
    var endDate: Date
    var eventDescription: String
    var posterGraphicPNGData: Data?
    var bannerGraphicPNGData: Data?

}
