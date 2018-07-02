//
//  WhenAnnouncementsViewModelUpdatesAnnouncements_AnnouncementsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenAnnouncementsViewModelUpdatesAnnouncements_AnnouncementsPresenterShould: XCTestCase {
    
    func testRebindTheNewAnnouncements() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let newAnnouncements = [AnnouncementComponentViewModel].random
        viewModel.simulateUpdatedAnnouncements(newAnnouncements)
        
        XCTAssertEqual(newAnnouncements.count, context.scene.capturedAnnouncementsToBind)
    }
    
}
