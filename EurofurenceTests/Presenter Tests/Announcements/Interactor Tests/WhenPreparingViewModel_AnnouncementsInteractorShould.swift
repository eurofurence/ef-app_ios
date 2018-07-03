//
//  WhenPreparingViewModel_AnnouncementsInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingAnnouncementsListViewModelDelegate: AnnouncementsListViewModelDelegate {
    
    private(set) var toldAnnouncementsDidChange = false
    func announcementsViewModelDidChangeAnnouncements() {
        toldAnnouncementsDidChange = true
    }
    
}

class WhenPreparingViewModel_AnnouncementsInteractorShould: XCTestCase {
    
    func testIndicateTheTotalNumberOfAnnouncements() {
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        
        XCTAssertEqual(announcements.count, viewModel?.numberOfAnnouncements)
    }
    
    func testAdaptAnnouncementTitles() {
        let announcements = [Announcement2].random
        let randomAnnouncement = announcements.randomElement()
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: randomAnnouncement.index)
        
        XCTAssertEqual(randomAnnouncement.element.title, announcementViewModel?.title)
    }
    
    func testAdaptAnnouncementContents() {
        let announcements = [Announcement2].random
        let randomAnnouncement = announcements.randomElement()
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: randomAnnouncement.index)
        
        XCTAssertEqual(randomAnnouncement.element.content, announcementViewModel?.detail)
    }
    
    func testAdaptReadAnnouncements() {
        let announcements = [Announcement2].random
        let randomAnnouncement = announcements.randomElement()
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        announcementsService.stubbedReadAnnouncements = [randomAnnouncement.element.identifier]
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: randomAnnouncement.index)
        
        XCTAssertEqual(true, announcementViewModel?.isRead)
    }
    
    func testAdaptUnreadAnnouncements() {
        let announcements = [Announcement2].random
        let randomAnnouncement = announcements.randomElement()
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: randomAnnouncement.index)
        
        XCTAssertEqual(false, announcementViewModel?.isRead)
    }
    
    func testProvideTheExpectedIdentifier() {
        let announcements = [Announcement2].random
        let randomAnnouncement = announcements.randomElement()
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let actual = viewModel?.identifierForAnnouncement(at: randomAnnouncement.index)
        
        XCTAssertEqual(randomAnnouncement.element.identifier, actual)
    }
    
    func testUpdateTheAvailableViewModelsWhenAnnouncementsChange() {
        let originalAnnouncements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: originalAnnouncements)
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let newAnnouncements = [Announcement2].random(upperLimit: originalAnnouncements.count)
        let delegate = CapturingAnnouncementsListViewModelDelegate()
        viewModel?.setDelegate(delegate)
        announcementsService.updateAnnouncements(newAnnouncements)
        let randomAnnouncement = newAnnouncements.randomElement()
        let announcementViewModel = viewModel?.announcementViewModel(at: randomAnnouncement.index)
        
        XCTAssertEqual(randomAnnouncement.element.title, announcementViewModel?.title)
        XCTAssertTrue(delegate.toldAnnouncementsDidChange)
    }
    
    func testUpdateTheAvailableViewModelsWhenReadAnnouncementsChange() {
        let announcements = [Announcement2].random
        let announcementsService = StubAnnouncementsService(announcements: announcements)
        let interactor = DefaultAnnouncementsInteractor(announcementsService: announcementsService)
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let delegate = CapturingAnnouncementsListViewModelDelegate()
        viewModel?.setDelegate(delegate)
        announcementsService.updateReadAnnouncements(.random)
        
        XCTAssertTrue(delegate.toldAnnouncementsDidChange)
    }
    
}
