//
//  WhenBindingAnnouncement_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingAnnouncement_NewsPresenterShould: XCTestCase {
    
    var viewModel: AnnouncementsViewModel!
    var announcementViewModel: AnnouncementComponentViewModel!
    var indexPath: IndexPath!
    var newsInteractor: StubNewsInteractor!
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        viewModel = AnnouncementsViewModel()
        let component = viewModel.announcements.randomElement()
        let announcement = component.element.randomElement()
        announcementViewModel = announcement.element
        indexPath = IndexPath(row: announcement.index, section: component.index)
        
        newsInteractor = StubNewsInteractor(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
    }
    
    func testSetTheAnnouncementNameOntoTheAnnouncementScene() {
        XCTAssertEqual(announcementViewModel.title, context.newsScene.stubbedAnnouncementComponent.capturedTitle)
    }
    
    func testSetTheAnnouncementDetailOntoTheAnnouncementScene() {
        XCTAssertEqual(announcementViewModel.detail, context.newsScene.stubbedAnnouncementComponent.capturedDetail)
    }
    
    func testSetTheAnnouncementDateTimeOntoTheAnnouncementScene() {
        XCTAssertEqual(announcementViewModel.receivedDateTime, context.newsScene.stubbedAnnouncementComponent.capturedReceivedDateTime)
    }
    
    func testTellTheDelegateAnnouncementSelectedWhenSceneSelectsComponentAtIndexPath() {
        let announcement = Announcement2.random
        viewModel.stub(.announcement(announcement.identifier), at: indexPath)
        context.selectComponent(at: indexPath)
        
        XCTAssertEqual(announcement.identifier, context.delegate.capturedAnnouncement)
    }
    
    func testNotTellTheDelegateToShowPrivateMessagesWhenSelectingAnnouncement() {
        let announcement = Announcement2.random
        viewModel.stub(.announcement(announcement.identifier), at: indexPath)
        context.selectComponent(at: indexPath)
        
        XCTAssertFalse(context.delegate.showPrivateMessagesRequested)
    }
    
}
