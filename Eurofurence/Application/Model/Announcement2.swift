//
//  Announcement2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct Announcement2: Equatable {

    var title: String
    var content: String

    static func ==(lhs: Announcement2, rhs: Announcement2) -> Bool {
        return lhs.title == rhs.title && lhs.content == rhs.content
    }

}
