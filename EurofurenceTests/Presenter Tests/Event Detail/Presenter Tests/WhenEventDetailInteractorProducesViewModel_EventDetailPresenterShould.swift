//
//  WhenEventDetailInteractorProducesViewModel_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenEventDetailInteractorProducesViewModel_EventDetailPresenterShould: XCTestCase {
    
    func testApplyTheTitleOntoTheScene() {
        let event = Event2.random
        let viewModel = StubEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(viewModel.title, context.scene.capturedTitle)
    }
    
}
