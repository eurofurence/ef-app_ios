//
//  WhenFetchingIdentifierForSearchResult_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingIdentifierForSearchResult_DealersInteractorShould: XCTestCase {
    
    func testProvideTheIdentifierForTheDealer() {
        let dealersService = FakeDealersService()
        let interactor = DefaultDealersInteractor(dealersService: dealersService)
        var viewModel: DealersSearchViewModel?
        interactor.makeDealersSearchViewModel { viewModel = $0 }
        let modelDealers = dealersService.index.alphabetisedDealersSearchResult
        let randomGroup = modelDealers.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let expected = randomDealer.element.identifier
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        let actual = viewModel?.identifierForDealer(at: indexPath)
        
        XCTAssertEqual(expected, actual)
    }
    
}
