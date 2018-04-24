//
//  StubAnnouncementsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct StubAnnouncementsService: AnnouncementsService {
    
    var announcements: [Announcement2]
    
    func fetchAnnouncements(completionHandler: @escaping ([Announcement2]) -> Void) {
        completionHandler(announcements)
    }
    
}
