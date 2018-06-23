//
//  WhenFetchingExtendedDealerData_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenFetchingExtendedDealerData_ApplicationShould: XCTestCase {
    
    func testUseTheSameAlternateNameAsTheShortFormDealerModel() {
        let response = APISyncResponse.randomWithoutDeletions
        let context = ApplicationTestBuilder().build()
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(response)
        let randomDealer = response.dealers.changed.randomElement().element
        let identifier = Dealer2.Identifier(randomDealer.identifier)
        var dealerData: ExtendedDealerData?
        context.application.fetchExtendedDealerData(for: identifier) { dealerData = $0 }
        let index = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        index.setDelegate(delegate)
        let shortFormModel = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first
        
        XCTAssertEqual(shortFormModel?.alternateName, dealerData?.alternateName)
    }
    
}
