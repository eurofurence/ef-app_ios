//
//  WhenBindingAnnouncement_NewsViewModelShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingAnnouncement_NewsViewModelShould: XCTestCase {
    
    func testSetTheAnnouncementNameOntoTheAnnouncementScene() {
        let viewModel = AnnouncementsViewModel()
        let component = viewModel.announcements.randomElement()
        let announcement = component.element.randomElement()
        let indexPath = IndexPath(row: announcement.index, section: component.index)
        
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneWillAppear()
        context.sceneFactory.stubbedScene.bindComponent(at: indexPath)
        
        XCTAssertEqual(announcement.element.title, context.newsScene.stubbedAnnouncementComponent.capturedTitle)
    }
    
    func testSetTheAnnouncementDetailOntoTheAnnouncementScene() {
        let viewModel = AnnouncementsViewModel()
        let component = viewModel.announcements.randomElement()
        let announcement = component.element.randomElement()
        let indexPath = IndexPath(row: announcement.index, section: component.index)
        
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneWillAppear()
        context.sceneFactory.stubbedScene.bindComponent(at: indexPath)
        
        XCTAssertEqual(announcement.element.detail, context.newsScene.stubbedAnnouncementComponent.capturedDetail)
    }
    
}
