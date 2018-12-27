//
//  WhenBindingDealersDenBanner_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

struct StubDealersDenEventViewModel: EventDetailViewModel {

    var dealersDenMessageViewModel: EventDealersDenMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) { visitor.visit(dealersDenMessageViewModel
        ) }
    func favourite() { }
    func unfavourite() { }

}

class WhenBindingDealersDenBanner_EventDetailPresenterShould: XCTestCase {

    func testBindTheMessageOntoTheComponent() {
        let event = Event.random
        let message = String.random
        let artShowViewModel = EventDealersDenMessageViewModel(message: message)
        let viewModel = StubDealersDenEventViewModel(dealersDenMessageViewModel: artShowViewModel)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))

        XCTAssertEqual(message, context.scene.stubbedDealersDenMessageComponent.capturedMessage)
    }

}
