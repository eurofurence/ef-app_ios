//
//  WhenBindingDealerComponent_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerComponent_DealersPresenterShould: XCTestCase {

    var context: DealersPresenterTestBuilder.Context!
    var dealer: StubDealerViewModel!
    var component: CapturingDealerComponent!

    override func setUp() {
        super.setUp()

        let dealerGroups = [DealersGroupViewModel].random
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroups)
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomGroup = dealerGroups.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        precondition(randomDealer.element is StubDealerViewModel)
        dealer = randomDealer.element as? StubDealerViewModel
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        component = CapturingDealerComponent()
        context.bind(component, toDealerAt: indexPath)
    }

    func testBindTheDealerTitleOntoTheComponent() {
        XCTAssertEqual(dealer.title, component.capturedDealerTitle)
    }

    func testBindTheDealerSubtitleOntoTheComponent() {
        XCTAssertEqual(dealer.subtitle, component.capturedDealerSubtitle)
    }

    func testBindTheDealerIconPNGDataOntoTheComponent() {
        XCTAssertEqual(dealer.iconPNGData, component.capturedDealerPNGData)
    }

}
