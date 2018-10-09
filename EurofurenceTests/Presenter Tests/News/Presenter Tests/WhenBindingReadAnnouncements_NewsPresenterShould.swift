//
//  WhenBindingReadAnnouncements_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingReadAnnouncements_NewsPresenterShould: XCTestCase {
    
    func testTellTheBoundAnnouncementComponentToHideTheUnreadIndicator() {
        var announcement = AnnouncementComponentViewModel.random
        announcement.isRead = true
        let announcements = [announcement]
        let viewModel = AnnouncementsViewModel(announcements: [announcements])

        let indexPath = IndexPath(row: 0, section: 0)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
        
        XCTAssertTrue(context.newsScene.stubbedAnnouncementComponent.didHideUnreadIndicator)
    }
    
    func testNotTellTheBoundAnnouncementComponentToShowTheUnreadIndicator() {
        var announcement = AnnouncementComponentViewModel.random
        announcement.isRead = true
        let announcements = [announcement]
        let viewModel = AnnouncementsViewModel(announcements: [announcements])
        
        let indexPath = IndexPath(row: 0, section: 0)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
        
        XCTAssertFalse(context.newsScene.stubbedAnnouncementComponent.didShowUnreadIndicator)
    }
    
}
