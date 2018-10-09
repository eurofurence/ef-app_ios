//
//  WhenBindingEvent_WithNoPoster_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingEvent_WithNoPoster_SchedulePresenterShould: XCTestCase {
    
    func testNotShowTheBanner() {
        let viewModel = CapturingScheduleViewModel.random
        let randomGroup = viewModel.events.randomElement()
        var group = randomGroup.element
        let randomEvent = randomGroup.element.events.randomElement()
        var eventViewModel = randomEvent.element
        eventViewModel.bannerGraphicPNGData = nil
        group.events[randomEvent.index] = eventViewModel
        viewModel.events[randomGroup.index] = group
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)
        
        XCTAssertFalse(component.didShowBanner)
    }
    
    func testHideTheBanner() {
        let viewModel = CapturingScheduleViewModel.random
        let randomGroup = viewModel.events.randomElement()
        var group = randomGroup.element
        let randomEvent = randomGroup.element.events.randomElement()
        var eventViewModel = randomEvent.element
        eventViewModel.bannerGraphicPNGData = nil
        group.events[randomEvent.index] = eventViewModel
        viewModel.events[randomGroup.index] = group
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)
        
        XCTAssertTrue(component.didHideBanner)
    }
    
}
