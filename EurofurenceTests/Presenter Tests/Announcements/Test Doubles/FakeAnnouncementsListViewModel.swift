//
//  FakeAnnouncementsListViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeAnnouncementsListViewModel: AnnouncementsListViewModel {
    
    let announcements = [Announcement2].random
    
    var numberOfAnnouncements: Int {
        return announcements.count
    }
    
}
