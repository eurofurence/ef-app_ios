import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class ShowKnowledgeContentFromGroupListingTests: XCTestCase {

    func testShowsKnowledgeEntryContent() {
        let knowledgeEntry = KnowledgeEntryIdentifier.random
        let router = FakeContentRouter()
        let navigator = ShowKnowledgeContentFromGroupListing(router: router)
        navigator.knowledgeGroupEntriesComponentDidSelectKnowledgeEntry(identifier: knowledgeEntry)
        
        router.assertRouted(to: KnowledgeEntryContentRepresentation(identifier: knowledgeEntry))
    }

}
