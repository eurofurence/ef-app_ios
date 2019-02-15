//
//  Announcement.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public typealias AnnouncementIdentifier = Identifier<Announcement>

public protocol Announcement {

    var identifier: AnnouncementIdentifier { get }
    var title: String { get }
    var content: String { get }
    var date: Date { get }

}
