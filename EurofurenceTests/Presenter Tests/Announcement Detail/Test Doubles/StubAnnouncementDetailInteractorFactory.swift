//
//  StubAnnouncementDetailInteractorFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct StubAnnouncementDetailInteractorFactory: AnnouncementDetailInteractorFactory {
    
    private let interactor: AnnouncementDetailInteractor
    private let announcement: Announcement2
    
    init(interactor: AnnouncementDetailInteractor, for announcement: Announcement2) {
        self.interactor = interactor
        self.announcement = announcement
    }
    
    func makeAnnouncementDetailInteractor(for announcement: Announcement2) -> AnnouncementDetailInteractor {
        return self.announcement == announcement ? interactor : StubAnnouncementDetailInteractor()
    }
    
}
