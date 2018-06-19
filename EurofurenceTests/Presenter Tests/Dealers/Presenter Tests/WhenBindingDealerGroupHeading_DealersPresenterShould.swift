//
//  WhenBindingDealerGroupHeading_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingDealerGroupHeading_DealersPresenterShould: XCTestCase {
    
    func testBindTheGroupHeadingOntoTheComponent() {
        let groups = [DealersGroupViewModel].random
        let randomGroup = groups.randomElement()
        let expected = randomGroup.element.title
        let interactor = FakeDealersInteractor(dealerGroupViewModels: groups)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindComponentHeader(at: randomGroup.index)
        
        XCTAssertEqual(expected, component.capturedDealersGroupTitle)
    }
    
}
