//
//  APIAnnouncement.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIAnnouncement: Equatable {

    var title: String
    var content: String

    static func ==(lhs: APIAnnouncement, rhs: APIAnnouncement) -> Bool {
        return lhs.title == rhs.title && lhs.content == rhs.content
    }

}
