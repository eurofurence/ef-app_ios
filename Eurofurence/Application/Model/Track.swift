//
//  Track.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct Track: Equatable {

    static func ==(lhs: Track, rhs: Track) -> Bool {
        return lhs.name == rhs.name
    }

    var name: String

}
