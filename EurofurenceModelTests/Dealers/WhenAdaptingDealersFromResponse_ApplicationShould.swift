import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenAdaptingDealersFromResponse_ApplicationShould: XCTestCase {

    func testUseAttendeeNameAsAlternateNameWhenNotTheSameAsDisplayName() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        let nickname = String.random
        dealer.displayName = .random
        dealer.attendeeNickname = nickname
        syncResponse.dealers.changed = [dealer]
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let model = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first

        XCTAssertEqual(nickname, model?.alternateName)
    }

    func testUseNilAlternateNameWhenDisplayAndAttendeeNameAreTheSame() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.displayName = .random
        dealer.attendeeNickname = dealer.displayName
        syncResponse.dealers.changed = [dealer]
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let model = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first

        XCTAssertNil(model?.alternateName)
    }

    func testUseAttendeeNameAsPreferredNameIfDisplayNameNotSpecified() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        let nickname = String.random
        dealer.displayName = ""
        dealer.attendeeNickname = nickname
        syncResponse.dealers.changed = [dealer]
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let model = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first

        XCTAssertEqual(nickname, model?.preferredName)
    }

    func testUseQuestionMarkAsPreferredNameIfAttendeeNicknameAndDisplayNameNotSpecified_toAvoidCrashing() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var dealer = DealerCharacteristics.random
        dealer.displayName = ""
        dealer.attendeeNickname = ""
        syncResponse.dealers.changed = [dealer]
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let dealersIndex = context.dealersService.makeDealersIndex()
        let delegate = CapturingDealersIndexDelegate()
        dealersIndex.setDelegate(delegate)
        let model = delegate.capturedAlphabetisedDealerGroups.first?.dealers.first

        XCTAssertEqual("?", model?.preferredName)
    }

}
