import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenFetchingKnowledgeGroupsBeforeRefreshWhenStoreHasGroups: XCTestCase {

    func testTheGroupsFromTheStoreAreAdaptedInOrder() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let dataStore = InMemoryDataStore(response: syncResponse)
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let observer = CapturingKnowledgeServiceObserver()
        context.knowledgeService.add(observer)

        KnowledgeGroupAssertion().assertGroups(observer.capturedGroups,
                                               characterisedByGroup: syncResponse.knowledgeGroups.changed,
                                               entries: syncResponse.knowledgeEntries.changed)
    }

}
