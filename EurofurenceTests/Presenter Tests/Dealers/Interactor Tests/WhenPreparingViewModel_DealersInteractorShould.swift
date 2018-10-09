//
//  WhenPreparingViewModel_DealersInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import XCTest

class WhenPreparingViewModel_DealersInteractorShould: XCTestCase {
    
    var context: DealerInteractorTestBuilder.Context!
    var delegate: CapturingDealersViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        
        context = DealerInteractorTestBuilder().build()
        var viewModel: DealersViewModel?
        context.interactor.makeDealersViewModel { viewModel = $0 }
        delegate = CapturingDealersViewModelDelegate()
        viewModel?.setDelegate(delegate)
    }
    
    private func fetchRandomDealerAndAssociatedViewModel() -> (dealer: Dealer2, viewModel: DealerViewModel?) {
        let modelDealers = context.dealersService.index.alphabetisedDealers
        let randomGroup = modelDealers.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let dealerViewModel = delegate.capturedDealerViewModel(at: IndexPath(item: randomDealer.index, section: randomGroup.index))
        
        return (dealer: randomDealer.element, viewModel: dealerViewModel)
    }
    
    func testConvertIndexedDealersIntoExpectedGroupTitles() {
        let modelDealers = context.dealersService.index.alphabetisedDealers
        let expected = modelDealers.map { $0.indexingString }
        let actual = delegate.capturedGroups.map({ $0.title })
        
        XCTAssertEqual(expected, actual)
    }
    
    func testProduceIndexTitlesUsingGroupedIndicies() {
        let modelDealers = context.dealersService.index.alphabetisedDealers
        let expected = modelDealers.map { $0.indexingString }
        let actual = delegate.capturedIndexTitles
        
        XCTAssertEqual(expected, actual)
    }
    
    func testBindPreferredDealerNameOntoDealerViewModelTitle() {
        let context = fetchRandomDealerAndAssociatedViewModel()
        XCTAssertEqual(context.dealer.preferredName, context.viewModel?.title)
    }
    
    func testBindAlternateDealerNameOntoDealerViewModelSubtitle() {
        let context = fetchRandomDealerAndAssociatedViewModel()
        XCTAssertEqual(context.dealer.alternateName, context.viewModel?.subtitle)
    }
    
}
