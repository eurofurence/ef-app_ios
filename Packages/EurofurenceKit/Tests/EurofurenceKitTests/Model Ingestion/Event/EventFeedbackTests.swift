import Combine
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTAsyncAssertions
import XCTest

class EventFeedbackTests: EurofurenceKitTestCase {
    
    func testAttemptingToLeaveFeedbackForEventNotAcceptingFeedbackThrowsError() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let afterDarkDealersDenSetupID = "3842fa46-49cb-4a56-9396-05bb7cbc5904"
        let afterDarkDealersDenSetup = try scenario.model.event(identifiedBy: afterDarkDealersDenSetupID)
        XCTAssertFalse(afterDarkDealersDenSetup.acceptingFeedback, "Expected test event not to be accepting feedback")
        
        XCTAssertThrowsSpecificError(
            EurofurenceError.eventNotAcceptingFeedback(afterDarkDealersDenSetupID),
            try afterDarkDealersDenSetup.prepareFeedback()
        )
    }
    
    func testAttemptingToLeaveFeedbackForEventAcceptingFeedbackProducesFeedbackFormWithDefaultState() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let artistsLoungeID = "db66d940-7f38-4729-9b51-5e98351b68ef"
        let artistsLounge = try scenario.model.event(identifiedBy: artistsLoungeID)
        XCTAssertTrue(artistsLounge.acceptingFeedback, "Expected test event to be accepting feedback")
        
        let feedbackForm = try artistsLounge.prepareFeedback()
        
        XCTAssertEqual(3, feedbackForm.percentageRating)
        XCTAssertEqual("", feedbackForm.additionalComments)
    }
    
    func testFeedbackPercentageRatingConstrainedWithinPercentageRange() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let artistsLoungeID = "db66d940-7f38-4729-9b51-5e98351b68ef"
        let artistsLounge = try scenario.model.event(identifiedBy: artistsLoungeID)
        let feedbackForm = try artistsLounge.prepareFeedback()
        
        feedbackForm.percentageRating = 0
        XCTAssertEqual(1, feedbackForm.percentageRating, "Cannot designate feedback rating < 1")
        
        feedbackForm.percentageRating = 6
        XCTAssertEqual(5, feedbackForm.percentageRating, "Cannot designate feedback rating > 5")
    }
    
    func testFeedbackIdentityLinkedToOriginEvent() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let artistsLoungeID = "db66d940-7f38-4729-9b51-5e98351b68ef"
        let artistsLounge = try scenario.model.event(identifiedBy: artistsLoungeID)
        let feedbackForm = try artistsLounge.prepareFeedback()
        
        XCTAssertEqual(artistsLounge.id, feedbackForm.id)
    }
    
    func testSubmittingFeedbackUnsuccessfullyThrowsError() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let artistsLoungeID = "db66d940-7f38-4729-9b51-5e98351b68ef"
        let artistsLounge = try scenario.model.event(identifiedBy: artistsLoungeID)
        let feedbackForm = try artistsLounge.prepareFeedback()
        feedbackForm.percentageRating = 4
        feedbackForm.additionalComments = "Needs more 🦨"
        
        let expectedRequest = APIRequests.SubmitEventFeedback(
            identifier: artistsLoungeID,
            rating: 4,
            additionalComments: "Needs more 🦨"
        )
        
        let doesNotPostNotificationExpectation = expectation(
            forNotification: .EFKEventFeedbackSubmitted,
            object: artistsLounge
        )
        
        doesNotPostNotificationExpectation.isInverted = true
        
        let networkError = NSError(domain: NSURLErrorDomain, code: URLError.badServerResponse.rawValue)
        await scenario.api.stub(request: expectedRequest, with: .failure(networkError))
        
        await XCTAssertEventuallyThrowsSpecificError(
            EurofurenceError.feedbackSubmissionFailed,
            { try await feedbackForm.submit() }
        )
        
        waitForExpectations(timeout: 0.1)
    }
    
    func testSubmittingFeedbackSuccessfully() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let artistsLoungeID = "db66d940-7f38-4729-9b51-5e98351b68ef"
        let artistsLounge = try scenario.model.event(identifiedBy: artistsLoungeID)
        let feedbackForm = try artistsLounge.prepareFeedback()
        feedbackForm.percentageRating = 4
        feedbackForm.additionalComments = "Needs more 🦨"
        
        let expectedRequest = APIRequests.SubmitEventFeedback(
            identifier: artistsLoungeID,
            rating: 4,
            additionalComments: "Needs more 🦨"
        )
        
        let postsNotificationExpectation = expectation(
            forNotification: .EFKEventFeedbackSubmitted,
            object: artistsLounge
        )
        
        await scenario.api.stub(request: expectedRequest, with: .success(()))
        await XCTAssertEventuallyNoThrows({ try await feedbackForm.submit() })
        waitForExpectations(timeout: 0.1)
    }

}
