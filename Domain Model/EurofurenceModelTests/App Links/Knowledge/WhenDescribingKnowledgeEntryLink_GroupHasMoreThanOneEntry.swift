import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDescribingKnowledgeEntryLink_GroupHasMoreThanOneEntry: XCTestCase {

    func testTheEntryAndGroupIdentifiersAreProvided() {
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let group = characteristics.knowledgeGroups.changed.randomElement().element
        let entry = characteristics.knowledgeEntries.changed.filter({ $0.groupIdentifier == group.identifier }).randomElement().element
        let dataStore = InMemoryDataStore(response: characteristics)
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/KnowledgeEntries/\(entry.identifier)"
        guard let url = URL(string: urlString) else { fatalError("\(urlString) didn't make it into a URL") }
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertEqual(KnowledgeGroupIdentifier(group.identifier), visitor.visitedKnowledgePairing?.group)
        XCTAssertEqual(KnowledgeEntryIdentifier(entry.identifier), visitor.visitedKnowledgePairing?.entry)
    }

}
