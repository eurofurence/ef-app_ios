//
//  WhenPreparingViewModel_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_DealersInteractorShould: XCTestCase {
    
    func testGroupDealersByFirstCharacterOfTitle() {
        let dealers = [Dealer2].random
        let dealersService = FakeDealersService(dealers: dealers)
        let interactor = DefaultDealersInteractor(dealersService: dealersService)
        var viewModel: DealersViewModel?
        interactor.makeDealersViewModel { viewModel = $0 }
        let delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
        let expected = Dictionary(grouping: dealers, by: { $0.preferredName.first! }).map({ String($0.key) }).sorted()
        let actual = delegate.capturedGroups.map({ $0.title })
        
        XCTAssertEqual(expected, actual)
    }
    
}
