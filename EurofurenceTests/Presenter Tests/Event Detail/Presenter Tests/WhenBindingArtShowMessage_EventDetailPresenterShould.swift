//
//  WhenBindingArtShowMessage_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

struct StubArtShowEventViewModel: EventDetailViewModel {
    
    var artShowMessageViewModel: EventArtShowMessageViewModel
    
    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(artShowMessageViewModel
        ) }
    func favourite() { }
    func unfavourite() { }
    
}

class WhenBindingArtShowMessage_EventDetailPresenterShould: XCTestCase {
    
    func testBindTheMessageOntoTheComponent() {
        let event = Event2.random
        let message = String.random
        let artShowViewModel = EventArtShowMessageViewModel(message: message)
        let viewModel = StubArtShowEventViewModel(artShowMessageViewModel: artShowViewModel)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(message, context.scene.stubbedArtShowMessageComponent.capturedMessage)
    }
    
}
