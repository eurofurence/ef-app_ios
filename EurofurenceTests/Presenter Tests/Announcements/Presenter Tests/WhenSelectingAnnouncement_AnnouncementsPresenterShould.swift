//
//  WhenSelectingAnnouncement_AnnouncementsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenSelectingAnnouncement_AnnouncementsPresenterShould: XCTestCase {
    
    func testTellTheModuleDelegateWhichAnnouncementWasSelected() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidSelectAnnouncement(at: randomAnnouncement.index)
        let expected = viewModel.identifierForAnnouncement(at: randomAnnouncement.index)
        
        XCTAssertEqual(expected, context.delegate.capturedSelectedAnnouncement)
    }
    
    func testTellTheSceneToDeselectTheSelectedAnnouncement() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidSelectAnnouncement(at: randomAnnouncement.index)
        
        XCTAssertEqual(randomAnnouncement.index, context.scene.capturedAnnouncementIndexToDeselect)
    }
    
}
