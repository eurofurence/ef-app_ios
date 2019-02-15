//
//  Announcement+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import RandomDataGeneration

public struct StubAnnouncement: Announcement {

    public var identifier: AnnouncementIdentifier
    public var title: String
    public var content: String
    public var date: Date

}

extension StubAnnouncement: RandomValueProviding {

    public static var random: StubAnnouncement {
        return StubAnnouncement(identifier: .random,
                                title: .random,
                                content: .random,
                                date: .random)
    }

}
