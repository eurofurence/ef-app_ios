//
//  WhenBindingPhotoshootBanner_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

struct StubPhotoshootEventViewModel: EventDetailViewModel {
    
    var photoshootMessageViewModel: EventPhotoshootMessageViewModel
    
    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(photoshootMessageViewModel
        ) }
    func favourite() { }
    func unfavourite() { }
    
}

class WhenBindingPhotoshootBanner_EventDetailPresenterShould: XCTestCase {
    
    func testBindTheMessageOntoTheComponent() {
        let event = Event2.random
        let message = String.random
        let kageMessageViewModel = EventPhotoshootMessageViewModel(message: message)
        let viewModel = StubPhotoshootEventViewModel(photoshootMessageViewModel: kageMessageViewModel)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(message, context.scene.stubbedPhotoshootMessageComponent.capturedMessage)
    }
    
}
