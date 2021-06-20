import EurofurenceModel
import KnowledgeDetailComponent
import KnowledgeGroupComponent
import KnowledgeJourney
import XCTest
import XCTEurofurenceModel
import XCTRouter

class ShowKnowledgeContentFromListingTests: XCTestCase {
    
    func testShowsGroupContent() {
        let router = FakeContentRouter()
        let navigator = ShowKnowledgeContentFromListing(router: router)
        let group = KnowledgeGroupIdentifier.random
        navigator.knowledgeListModuleDidSelectKnowledgeGroup(group)
        
        router.assertRouted(to: KnowledgeGroupRouteable(identifier: group))
    }
    
    func testShowsEntryContent() {
        let router = FakeContentRouter()
        let navigator = ShowKnowledgeContentFromListing(router: router)
        let entry = KnowledgeEntryIdentifier.random
        navigator.knowledgeListModuleDidSelectKnowledgeEntry(entry)
        
        router.assertRouted(to: KnowledgeEntryRouteable(identifier: entry))
    }

}
