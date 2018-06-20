//
//  WhenBindingDealerSearchResultGroupHeading_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingDealerSearchResultGroupHeading_DealersPresenterShould: XCTestCase {
    
    func testBindTheGroupHeadingOntoTheComponent() {
        let groups = [DealersGroupViewModel].random
        let randomGroup = groups.randomElement()
        let expected = randomGroup.element.title
        let searchViewModel = CapturingDealersSearchViewModel(dealerGroups: groups)
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindComponentHeader(forSearchResultGroupAt: randomGroup.index)
        
        XCTAssertEqual(expected, component.capturedDealersGroupTitle)
    }
    
}
