//
//  WhenBindingEvent_WithNoPoster_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 14/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingEvent_WithNoPoster_SchedulePresenterShould: XCTestCase {

    func testNotShowTheBanner() {
        let viewModel = CapturingScheduleViewModel.random
        let group = viewModel.events.randomElement()
        let event = group.element.events.randomElement()
        let stubbedEventViewModel = viewModel.eventViewModel(inGroup: group.index, at: event.index)
        stubbedEventViewModel.bannerGraphicPNGData = nil

        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: event.index, section: group.index)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)

        XCTAssertFalse(component.didShowBanner)
        XCTAssertTrue(component.didHideBanner)
    }

}
