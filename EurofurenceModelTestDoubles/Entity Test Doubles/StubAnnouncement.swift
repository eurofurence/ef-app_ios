//
//  Announcement+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

public final class StubAnnouncement: Announcement {

    public var identifier: AnnouncementIdentifier
    public var title: String
    public var content: String
    public var date: Date
    
    public var imagePNGData: Data?

    public init(identifier: AnnouncementIdentifier,
                title: String,
                content: String,
                date: Date) {
        self.identifier = identifier
        self.title = title
        self.content = content
        self.date = date
    }
    
    public func fetchAnnouncementImagePNGData(completionHandler: @escaping (Data?) -> Void) {
        completionHandler(imagePNGData)
    }

}

extension StubAnnouncement: RandomValueProviding {

    public static var random: StubAnnouncement {
        return StubAnnouncement(identifier: .random,
                                title: .random,
                                content: .random,
                                date: .random)
    }

}
