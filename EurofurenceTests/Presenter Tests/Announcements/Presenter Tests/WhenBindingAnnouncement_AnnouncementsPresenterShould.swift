//
//  WhenBindingAnnouncement_AnnouncementsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingAnnouncement_AnnouncementsPresenterShould: XCTestCase {
    
    func testBindTheTitleOntoTheComponent() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        let randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: randomAnnouncement.index)
        
        XCTAssertEqual(randomAnnouncement.element.title, boundComponent.capturedTitle)
    }
    
}
