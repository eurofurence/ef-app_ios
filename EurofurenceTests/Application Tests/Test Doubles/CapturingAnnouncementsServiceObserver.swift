//
//  CapturingAnnouncementsServiceObserver.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import Foundation

class CapturingAnnouncementsServiceObserver: AnnouncementsServiceObserver {
    
    private(set) var allAnnouncements: [Announcement2] = []
    private(set) var didReceieveEmptyAllAnnouncements = false
    func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [Announcement2]) {
        allAnnouncements = announcements
        didReceieveEmptyAllAnnouncements = didReceieveEmptyAllAnnouncements || announcements.isEmpty
    }
    
    private(set) var unreadAnnouncements: [Announcement2] = []
    private(set) var didReceieveEmptyUnreadAnnouncements = false
    func eurofurenceApplicationDidChangeUnreadAnnouncements(to announcements: [Announcement2]) {
        unreadAnnouncements = announcements
        didReceieveEmptyUnreadAnnouncements = didReceieveEmptyUnreadAnnouncements || announcements.isEmpty
    }
    
    private(set) var didReceieveEmptyReadAnnouncements = false
    private(set) var readAnnouncementIdentifiers = [Announcement2.Identifier]()
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [Announcement2.Identifier]) {
        didReceieveEmptyReadAnnouncements = didReceieveEmptyReadAnnouncements || readAnnouncements.isEmpty
        readAnnouncementIdentifiers = readAnnouncements
    }
    
}
