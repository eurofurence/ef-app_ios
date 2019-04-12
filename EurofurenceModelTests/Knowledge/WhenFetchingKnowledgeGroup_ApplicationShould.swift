import EurofurenceModel
import XCTest

class WhenFetchingKnowledgeGroup_ApplicationShould: XCTestCase {

    func testReturnOnlyEntriesForThatGroup() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        context.performSuccessfulSync(response: syncResponse)
        let randomGroup = syncResponse.knowledgeGroups.changed.randomElement()

        var actual: KnowledgeGroup?
        context.knowledgeService.fetchKnowledgeGroup(identifier: KnowledgeGroupIdentifier(randomGroup.element.identifier)) { actual = $0 }

        KnowledgeGroupAssertion().assertGroup(actual,
                                              characterisedByGroup: randomGroup.element,
                                              entries: syncResponse.knowledgeEntries.changed)
    }

}
