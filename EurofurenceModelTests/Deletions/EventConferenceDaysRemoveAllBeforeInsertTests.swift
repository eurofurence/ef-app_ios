import EurofurenceModel
import XCTest

class EventConferenceDaysRemoveAllBeforeInsertTests: XCTestCase {

    func testTellTheDataStoreToDeleteTheConferenceDays() {
        let originalResponse = ModelCharacteristics.randomWithoutDeletions
        var subsequentResponse = originalResponse
        subsequentResponse.conferenceDays.removeAllBeforeInsert = true
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: originalResponse)
        context.performSuccessfulSync(response: subsequentResponse)

        XCTAssertEqual(subsequentResponse.conferenceDays.changed, context.dataStore.fetchConferenceDays(),
                       "Should have removed original days between sync events")
    }

}
