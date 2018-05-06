//
//  DefaultAnnouncementDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultAnnouncementDetailInteractorShould: XCTestCase {
    
    func testProduceViewModelUsingAnnouncementTitleAsHeading() {
        let announcement = Announcement2.random
        let factory = DefaultAnnouncementDetailInteractorFactory()
        let interactor = factory.makeAnnouncementDetailInteractor(for: announcement)
        var viewModel: AnnouncementViewModel?
        interactor.makeViewModel { viewModel = $0 }
        
        XCTAssertEqual(announcement.title, viewModel?.heading)
    }
    
}
