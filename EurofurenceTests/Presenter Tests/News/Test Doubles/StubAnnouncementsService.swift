//
//  StubAnnouncementsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class StubAnnouncementsService: AnnouncementsService {
    
    var announcements: [Announcement2]
    var stubbedReadAnnouncements: [Announcement2.Identifier]
    
    init(announcements: [Announcement2], stubbedReadAnnouncements: [Announcement2.Identifier] = []) {
        self.announcements = announcements
        self.stubbedReadAnnouncements = stubbedReadAnnouncements
    }
    
    func add(_ observer: AnnouncementsServiceObserver) {
        observer.eurofurenceApplicationDidChangeUnreadAnnouncements(to: announcements)
    }
    
}
