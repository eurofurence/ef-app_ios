//
//  WhenBindingMainStageEvent_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

struct StubMainStageEventViewModel: EventDetailViewModel {

    var mainStageMessageViewModel: EventMainStageMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(mainStageMessageViewModel
        ) }
    func favourite() { }
    func unfavourite() { }

}

class WhenBindingMainStageEvent_EventDetailPresenterShould: XCTestCase {

    func testBindTheMessageOntoTheComponent() {
        let event = Event.random
        let message = String.random
        let kageMessageViewModel = EventMainStageMessageViewModel(message: message)
        let viewModel = StubMainStageEventViewModel(mainStageMessageViewModel: kageMessageViewModel)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(message, context.scene.stubbedMainStageMessageComponent.capturedMessage)
    }

}
