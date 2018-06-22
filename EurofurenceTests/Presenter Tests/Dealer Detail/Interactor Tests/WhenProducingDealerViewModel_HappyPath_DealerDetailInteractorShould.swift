//
//  WhenProducingDealerViewModel_HappyPath_DealerDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenProducingDealerViewModel_HappyPath_DealerDetailInteractorShould: XCTestCase {
    
    func testProduceExpectedNumberOfComponents() {
        let interactor = DefaultDealerDetailInteractor()
        var viewModel: DealerDetailViewModel?
        interactor.makeDealerDetailViewModel(for: .random) { viewModel = $0 }
        
        XCTAssertEqual(4, viewModel?.numberOfComponents)
    }
    
}
