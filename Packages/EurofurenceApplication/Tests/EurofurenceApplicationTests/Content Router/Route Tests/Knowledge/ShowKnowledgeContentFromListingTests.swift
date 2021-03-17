import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTComponentBase
import XCTest

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
