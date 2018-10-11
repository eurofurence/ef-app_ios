//
//  WhenBindingEventGroup_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingEventGroup_SchedulePresenterShould: XCTestCase {

    func testBindTheGroupTitleOntoTheHeader() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomGroup = viewModel.events.randomElement()
        let header = CapturingScheduleEventGroupHeader()
        context.bind(header, forGroupAt: randomGroup.index)

        XCTAssertEqual(randomGroup.element.title, header.capturedTitle)
    }

}
