import URLContent
import XCTComponentBase
import XCTest

class UserActivityContentRepresentationTests: ContentRepresentationTestCase {
    
    func testIntent() {
        let intent = "View Some Content"
        let intentDescription = IntentActivityDescription(intent: intent)
        let contentRepresentation = UserActivityContentRepresentation(activity: intentDescription)
        
        assert(content: contentRepresentation, isDescribedAs: IntentContentRepresentation(intent: intent))
    }
    
    func testURL() {
        let url = URL.random
        let intentDescription = URLActivityDescription(url: url)
        let contentRepresentation = UserActivityContentRepresentation(activity: intentDescription)
        
        assert(content: contentRepresentation, isDescribedAs: URLContentRepresentation(url: url))
    }

}
