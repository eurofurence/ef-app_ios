import EurofurenceModel
import TestUtilities
import XCTest
import XCTEurofurenceModel

class EventFeedbackAPITests: XCTestCase {
    
    private struct OutgoingFeedbackRequest: Decodable, Equatable {
        var EventId: String
        var Rating: Int
        var Message: String
    }

    func testSubmittingFeedbackSubmitsExpectedPOSTRequest() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let id = String.random
        let rating = Int.random
        let feedback = String.random
        let request = EventFeedbackRequest(id: id, rating: rating, feedback: feedback)
        api.submitEventFeedback(request) { (_) in }
        
        let expectedFeedbackRequest = OutgoingFeedbackRequest(EventId: id, Rating: rating, Message: feedback)
        
        let actualFeedbackRequest: OutgoingFeedbackRequest? = {
            guard let data = jsonSession.POSTData else { return nil }
            
            let encoder = JSONDecoder()
            return try? encoder.decode(OutgoingFeedbackRequest.self, from: data)
        }()
        
        let expectedURL = "\(apiUrl.url)EventFeedback"
        
        XCTAssertEqual(expectedURL, jsonSession.postedURL)
        XCTAssertEqual(expectedFeedbackRequest, actualFeedbackRequest)
    }
    
    func testFeedbackSuccess() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let request = EventFeedbackRequest(id: .random, rating: .random, feedback: .random)
        var success = false
        api.submitEventFeedback(request) { success = $0 }
        
        XCTAssertFalse(success)
        
        jsonSession.invokeLastPOSTCompletionHandler(responseData: Data())
        
        XCTAssertTrue(success)
    }
    
    func testFeedbackFailure() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let api = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let request = EventFeedbackRequest(id: .random, rating: .random, feedback: .random)
        var success = false
        api.submitEventFeedback(request) { success = $0 }
        
        let error = NSError(domain: "", code: 0, userInfo: nil)
        jsonSession.invokeLastPOSTCompletionHandler(responseData: nil, error: error)
        
        XCTAssertFalse(success)
    }

}
