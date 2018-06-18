//
//  WhenBindingDealerComponent_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingDealerComponent_DealersPresenterShould: XCTestCase {
    
    func testBindTheDealerTitleLabelOntoTheComponent() {
        let dealerGroups = [DealersGroupViewModel].random
        let viewModel = CapturingDealersViewModel(dealerGroups: dealerGroups)
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomGroup = dealerGroups.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        let component = CapturingDealerComponent()
        context.bind(component, toDealerAt: indexPath)
        
        XCTAssertEqual(randomDealer.element.title, component.capturedDealerTitle)
    }
    
}
