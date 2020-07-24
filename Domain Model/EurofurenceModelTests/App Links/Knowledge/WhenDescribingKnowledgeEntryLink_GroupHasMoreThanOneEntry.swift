import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDescribingKnowledgeEntryLink_GroupHasMoreThanOneEntry: XCTestCase {

    func testTheEntryAndGroupIdentifiersAreProvided() throws {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        let group = characteristics.knowledgeGroups.changed.randomElement().element
        let makeEntry: () -> KnowledgeEntryCharacteristics = {
            var entry = KnowledgeEntryCharacteristics.random
            entry.groupIdentifier = group.identifier
            
            return entry
        }
        
        let entries: [KnowledgeEntryCharacteristics] = [makeEntry(), makeEntry(), makeEntry()]
        characteristics.knowledgeEntries.changed = entries
        
        let entry = entries.randomElement().element
        
        let dataStore = InMemoryDataStore(response: characteristics)
        let cid = ModelCharacteristics.testConventionIdentifier
        let context = EurofurenceSessionTestBuilder().with(dataStore).build()
        let urlString = "https://this.bit.doesnt.matter/\(cid)/KnowleDGEEntRIes/\(entry.identifier)"
        let url = try XCTUnwrap(URL(string: urlString))
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertEqual(KnowledgeGroupIdentifier(group.identifier), visitor.visitedKnowledgePairing?.group)
        XCTAssertEqual(KnowledgeEntryIdentifier(entry.identifier), visitor.visitedKnowledgePairing?.entry)
    }

}
