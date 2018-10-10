//
//  WhenBindingSponsorsOnlyMessage_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

struct StubSponsorsOnlyEventViewModel: EventDetailViewModel {
    
    var sponsorsOnlyWarningViewModel: EventSponsorsOnlyWarningViewModel
    
    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(sponsorsOnlyWarningViewModel
        ) }
    func favourite() { }
    func unfavourite() { }
    
}

class WhenBindingSponsorsOnlyMessage_EventDetailPresenterShould: XCTestCase {
    
    func testBindTheMessageOntoTheComponent() {
        let event = Event2.random
        let message = String.random
        let sponsorsOnlyViewModel = EventSponsorsOnlyWarningViewModel(message: message)
        let viewModel = StubSponsorsOnlyEventViewModel(sponsorsOnlyWarningViewModel: sponsorsOnlyViewModel)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(message, context.scene.stubbedSponsorsOnlyComponent.capturedMessage)
    }
    
}
