import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDescribingKnowledgeEntryLink_GroupHasOneEntryExactly: XCTestCase {

    func testOnlyTheEntryIdentifierIsProvided() throws {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        var entry = KnowledgeEntryCharacteristics.random
        let group = KnowledgeGroupCharacteristics.random
        entry.groupIdentifier = group.identifier
        characteristics.knowledgeGroups.changed = [group]
        characteristics.knowledgeEntries.changed = [entry]
        
        let dataStore = InMemoryDataStore(response: characteristics)
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/KnowleDGEEntRIes/\(entry.identifier)"
        let url = try XCTUnwrap(URL(string: urlString))
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertNil(visitor.visitedKnowledgePairing)
        XCTAssertEqual(KnowledgeEntryIdentifier(entry.identifier), visitor.visitedKnowledgeEntry)
    }

}
