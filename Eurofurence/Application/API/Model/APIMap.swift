//
//  APIMap.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIMap: Equatable {

    static func == (lhs: APIMap, rhs: APIMap) -> Bool {
        return lhs.identifier == rhs.identifier &&
               lhs.imageIdentifier == rhs.imageIdentifier &&
               lhs.mapDescription == rhs.mapDescription &&
               lhs.entries.contains(elementsFrom: rhs.entries)
    }

    struct Entry: Equatable {

        static func == (lhs: Entry, rhs: Entry) -> Bool {
            return lhs.x == rhs.x &&
                   lhs.y == rhs.y &&
                   lhs.tapRadius == rhs.tapRadius &&
                   lhs.links.contains(elementsFrom: rhs.links)
        }

        struct Link: Equatable {

            enum FragmentType: Int {
                case conferenceRoom
            }

            var type: FragmentType
            var name: String
            var target: String

        }

        var x: Int
        var y: Int
        var tapRadius: Int
        var links: [Link]

    }

    var identifier: String
    var imageIdentifier: String
    var mapDescription: String
    var entries: [Entry]

}
