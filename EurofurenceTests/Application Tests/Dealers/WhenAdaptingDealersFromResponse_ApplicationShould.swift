//
//  WhenAdaptingDealersFromResponse_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenAdaptingDealersFromResponse_ApplicationShould: XCTestCase {
    
    func testUseAttendeeNameAsAlternateNameWhenNotTheSameAsDisplayName() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
        let nickname = String.random
        dealer.displayName = .random
        dealer.attendeeNickname = nickname
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let model = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first
        
        XCTAssertEqual(nickname, model?.alternateName)
    }
    
    func testUseNilAlternateNameWhenDisplayAndAttendeeNameAreTheSame() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
        dealer.displayName = .random
        dealer.attendeeNickname = dealer.displayName
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let model = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first
        
        XCTAssertNil(model?.alternateName)
    }
    
    func testUseAttendeeNameAsPreferredNameIfDisplayNameNotSpecified() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
        let nickname = String.random
        dealer.displayName = ""
        dealer.attendeeNickname = nickname
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let model = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first
        
        XCTAssertEqual(nickname, model?.preferredName)
    }
    
    func testUseQuestionMarkAsPreferredNameIfAttendeeNicknameAndDisplayNameNotSpecified_toAvoidCrashing() {
        var syncResponse = APISyncResponse.randomWithoutDeletions
        var dealer = APIDealer.random
        dealer.displayName = ""
        dealer.attendeeNickname = ""
        syncResponse.dealers.changed = [dealer]
        let dataStore = CapturingEurofurenceDataStore()
        dataStore.save(syncResponse)
        let context = ApplicationTestBuilder().with(dataStore).build()
        let dealersIndex = context.application.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let model = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first
        
        XCTAssertEqual("?", model?.preferredName)
    }
    
}
