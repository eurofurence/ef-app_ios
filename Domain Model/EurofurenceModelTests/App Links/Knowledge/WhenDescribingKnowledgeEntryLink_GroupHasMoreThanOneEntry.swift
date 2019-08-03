import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenDescribingKnowledgeEntryLink_GroupHasMoreThanOneEntry: XCTestCase {

    func testTheEntryAndGroupIdentifiersAreProvided() {
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
        guard let url = URL(string: urlString) else { fatalError("\(urlString) didn't make it into a URL") }
        
        let visitor = CapturingURLContentVisitor()
        context.contentLinksService.describeContent(in: url, toVisitor: visitor)
        
        XCTAssertEqual(KnowledgeGroupIdentifier(group.identifier), visitor.visitedKnowledgePairing?.group)
        XCTAssertEqual(KnowledgeEntryIdentifier(entry.identifier), visitor.visitedKnowledgePairing?.entry)
    }

}
