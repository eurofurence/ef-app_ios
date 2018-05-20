//
//  BeforeEventDetailSceneLoads_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class BeforeEventDetailSceneLoads_EventDetailPresenterShould: XCTestCase {
    
    func testNotApplyTheEventTitleFromTheViewModel() {
        let event = Event2.random
        let viewModel = StubEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        
        XCTAssertNil(context.scene.capturedTitle)
    }
    
}
