//
//  StubAnnouncementDetailInteractorFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct StubAnnouncementDetailInteractorFactory: AnnouncementDetailInteractorFactory {
    
    var interactor: StubAnnouncementDetailInteractor
    
    func makeAnnouncementDetailInteractor(for announcement: Announcement2) -> AnnouncementDetailInteractor {
        return interactor
    }
    
}
