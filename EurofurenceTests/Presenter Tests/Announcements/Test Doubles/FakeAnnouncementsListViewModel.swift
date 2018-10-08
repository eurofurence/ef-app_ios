//
//  FakeAnnouncementsListViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation

class FakeAnnouncementsListViewModel: AnnouncementsListViewModel {
    
    private(set) var announcements: [AnnouncementComponentViewModel]
    
    init(announcements: [AnnouncementComponentViewModel] = .random) {
        self.announcements = announcements
    }
    
    var numberOfAnnouncements: Int {
        return announcements.count
    }
    
    fileprivate var delegate: AnnouncementsListViewModelDelegate?
    func setDelegate(_ delegate: AnnouncementsListViewModelDelegate) {
        self.delegate = delegate
    }
    
    func announcementViewModel(at index: Int) -> AnnouncementComponentViewModel {
        return announcements[index]
    }
    
    func identifierForAnnouncement(at index: Int) -> Announcement2.Identifier {
        return Announcement2.Identifier("\(index)")
    }
    
}

extension FakeAnnouncementsListViewModel {
    
    func simulateUpdatedAnnouncements(_ newAnnouncements: [AnnouncementComponentViewModel]) {
        self.announcements = newAnnouncements
        delegate?.announcementsViewModelDidChangeAnnouncements()
    }
    
}
