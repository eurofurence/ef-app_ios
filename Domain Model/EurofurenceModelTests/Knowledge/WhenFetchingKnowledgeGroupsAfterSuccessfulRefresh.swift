import EurofurenceModel
import XCTest

class WhenFetchingKnowledgeGroupsAfterSuccessfulRefresh: XCTestCase {

    func testEntriesAreConsolidatedByGroupIdentifierInGroupOrder() {
        let context = EurofurenceSessionTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingKnowledgeServiceObserver()
        context.knowledgeService.add(observer)

        KnowledgeGroupAssertion().assertGroups(observer.capturedGroups,
                                               characterisedByGroup: syncResponse.knowledgeGroups.changed,
                                               entries: syncResponse.knowledgeEntries.changed)
    }

    func testEarlyBoundObserversAreUpdatedWithNewKnowledgeGroups() {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = CapturingKnowledgeServiceObserver()
        context.knowledgeService.add(observer)
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)

        KnowledgeGroupAssertion().assertGroups(observer.capturedGroups,
                                               characterisedByGroup: syncResponse.knowledgeGroups.changed,
                                               entries: syncResponse.knowledgeEntries.changed)
    }

}
