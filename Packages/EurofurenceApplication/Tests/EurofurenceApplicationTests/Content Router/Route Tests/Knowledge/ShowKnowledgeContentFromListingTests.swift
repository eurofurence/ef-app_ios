import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class ShowKnowledgeContentFromListingTests: XCTestCase {
    
    func testShowsGroupContent() {
        let router = FakeContentRouter()
        let navigator = ShowKnowledgeContentFromListing(router: router)
        let group = KnowledgeGroupIdentifier.random
        navigator.knowledgeListModuleDidSelectKnowledgeGroup(group)
        
        router.assertRouted(to: KnowledgeGroupContentRepresentation(identifier: group))
    }
    
    func testShowsEntryContent() {
        let router = FakeContentRouter()
        let navigator = ShowKnowledgeContentFromListing(router: router)
        let entry = KnowledgeEntryIdentifier.random
        navigator.knowledgeListModuleDidSelectKnowledgeEntry(entry)
        
        router.assertRouted(to: KnowledgeEntryContentRepresentation(identifier: entry))
    }

}
