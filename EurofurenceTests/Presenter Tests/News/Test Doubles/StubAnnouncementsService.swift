//
//  StubAnnouncementsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubAnnouncementsService: AnnouncementsService {
    
    var announcements: [Announcement2]
    var stubbedReadAnnouncements: [Announcement2.Identifier]
    
    init(announcements: [Announcement2], stubbedReadAnnouncements: [Announcement2.Identifier] = []) {
        self.announcements = announcements
        self.stubbedReadAnnouncements = stubbedReadAnnouncements
    }
    
    fileprivate var observers = [AnnouncementsServiceObserver]()
    func add(_ observer: AnnouncementsServiceObserver) {
        observers.append(observer)
        observer.eurofurenceApplicationDidChangeAnnouncements(announcements)
        observer.announcementsServiceDidUpdateReadAnnouncements(stubbedReadAnnouncements)
    }
    
    func openAnnouncement(identifier: Announcement2.Identifier, completionHandler: @escaping (Announcement2) -> Void) {
        guard let announcement = announcements.first(where: { $0.identifier == identifier }) else { return }
        completionHandler(announcement)
    }
    
    func fetchAnnouncementImage(identifier: Announcement2.Identifier, completionHandler: @escaping (Data?) -> Void) {
        completionHandler(stubbedAnnouncementImageData(for: identifier))
    }
    
}

extension StubAnnouncementsService {
    
    func updateAnnouncements(_ announcements: [Announcement2]) {
        observers.forEach({ $0.eurofurenceApplicationDidChangeAnnouncements(announcements) })
    }
    
    func updateReadAnnouncements(_ readAnnouncements: [Announcement2.Identifier]) {
        observers.forEach({ $0.announcementsServiceDidUpdateReadAnnouncements(readAnnouncements) })
    }
    
    func stubbedAnnouncementImageData(for announcement: Announcement2.Identifier) -> Data {
        return announcement.rawValue.data(using: .utf8)!
    }
    
}
