//
//  WhenBindingSuperSponsorsOnlyMessage_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct StubSuperSponsorsOnlyEventViewModel: EventDetailViewModel {
    
    var superSponsorsOnlyWarningViewModel: EventSuperSponsorsOnlyWarningViewModel
    
    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(superSponsorsOnlyWarningViewModel
        ) }
    func favourite() { }
    func unfavourite() { }
    
}

class WhenBindingSuperSponsorsOnlyMessage_EventDetailPresenterShould: XCTestCase {
    
    func testBindTheMessageOntoTheComponent() {
        let event = Event2.random
        let message = String.random
        let superSponsorsOnlyWarningViewModel = EventSuperSponsorsOnlyWarningViewModel(message: message)
        let viewModel = StubSuperSponsorsOnlyEventViewModel(superSponsorsOnlyWarningViewModel: superSponsorsOnlyWarningViewModel)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(message, context.scene.stubbedSuperSponsorsOnlyComponent.capturedMessage)
    }
    
}
