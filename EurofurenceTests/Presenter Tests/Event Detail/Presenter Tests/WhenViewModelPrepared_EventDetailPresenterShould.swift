//
//  WhenViewModelPrepared_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenViewModelPrepared_EventDetailPresenterShould: XCTestCase {
    
    func testNotFavouriteTheViewModel() {
        let event = Event2.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        
        XCTAssertFalse(viewModel.wasToldToFavouriteEvent)
    }
    
}
