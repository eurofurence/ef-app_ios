//
//  AnnouncementsModuleDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol AnnouncementsModuleDelegate {

    func announcementsModuleDidSelectAnnouncement(_ announcement: Announcement.Identifier)

}
