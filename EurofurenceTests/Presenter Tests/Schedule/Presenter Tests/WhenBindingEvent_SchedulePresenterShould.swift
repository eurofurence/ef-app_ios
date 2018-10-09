//
//  WhenBindingEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingEvent_SchedulePresenterShould: XCTestCase {
    
    var context: SchedulePresenterTestBuilder.Context!
    var component: CapturingScheduleEventComponent!
    var eventViewModel: ScheduleEventViewModel!
    
    override func setUp() {
        super.setUp()
        
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomGroup = viewModel.events.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        eventViewModel = randomEvent.element
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)
    }
    
    func testBindTheEventNameOntoTheComponent() {
        XCTAssertEqual(eventViewModel.title, component.capturedEventTitle)
    }
    
    func testBindTheStartTimeFromTheEventOntoTheEventScene() {
        XCTAssertEqual(eventViewModel.startTime, component.capturedStartTime)
    }
    
    func testBindTheEndTimeFromTheEventOntoTheEventScene() {
        XCTAssertEqual(eventViewModel.endTime, component.capturedEndTime)
    }
    
    func testBindTheEventLocationFromTheEventOntoTheEventScene() {
        XCTAssertEqual(eventViewModel.location, component.capturedLocation)
    }
    
    func testBindTheBannerGraphicDataOntoTheEventScene() {
        XCTAssertEqual(eventViewModel.bannerGraphicPNGData, component.capturedBannerGraphicPNGData)
    }
    
    func testShowTheBanner() {
        XCTAssertTrue(component.didShowBanner)
    }
    
    func testNotHideTheBanner() {
        XCTAssertFalse(component.didHideBanner)
    }
    
}
