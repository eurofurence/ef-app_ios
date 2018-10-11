//
//  WhenBindingAnnouncement_AnnouncementsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
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

    func testBindTheSubtitleOntoTheComponent() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        let randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: randomAnnouncement.index)

        XCTAssertEqual(randomAnnouncement.element.detail, boundComponent.capturedDetail)
    }

    func testBindTheAnnouncementDateTimeOntoTheComponent() {
        let viewModel = FakeAnnouncementsListViewModel()
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        let randomAnnouncement = viewModel.announcements.randomElement()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: randomAnnouncement.index)

        XCTAssertEqual(randomAnnouncement.element.receivedDateTime, boundComponent.capturedReceivedDateTime)
    }

    func testTellTheSceneToHideTheUnreadIndicatorForReadAnnouncements() {
        var announcement = AnnouncementComponentViewModel.random
        announcement.isRead = true
        let viewModel = FakeAnnouncementsListViewModel(announcements: [announcement])
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: 0)

        XCTAssertTrue(boundComponent.didHideUnreadIndicator)
    }

    func testNotTellTheSceneToHideTheUnreadIndicatorForUnreadAnnouncements() {
        var announcement = AnnouncementComponentViewModel.random
        announcement.isRead = false
        let viewModel = FakeAnnouncementsListViewModel(announcements: [announcement])
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: 0)

        XCTAssertFalse(boundComponent.didHideUnreadIndicator)
    }

    func testTellTheSceneToShowTheUnreadIndicatorForUnreadAnnouncements() {
        var announcement = AnnouncementComponentViewModel.random
        announcement.isRead = false
        let viewModel = FakeAnnouncementsListViewModel(announcements: [announcement])
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: 0)

        XCTAssertTrue(boundComponent.didShowUnreadIndicator)
    }

    func testNotTellTheSceneToShowTheUnreadIndicatorForReadAnnouncements() {
        var announcement = AnnouncementComponentViewModel.random
        announcement.isRead = true
        let viewModel = FakeAnnouncementsListViewModel(announcements: [announcement])
        let interactor = FakeAnnouncementsInteractor(viewModel: viewModel)
        let context = AnnouncementsPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let boundComponent = context.bindAnnouncement(at: 0)

        XCTAssertFalse(boundComponent.didShowUnreadIndicator)
    }

}
