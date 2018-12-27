//
//  Announcement+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import RandomDataGeneration

extension Announcement: RandomValueProviding {

    public static var random: Announcement {
        return Announcement(identifier: .random,
                             title: .random,
                             content: .random,
                             date: .random)
    }

}

extension Announcement.Identifier: RandomValueProviding {

    public static var random: Announcement.Identifier {
        return Announcement.Identifier(.random)
    }

}
