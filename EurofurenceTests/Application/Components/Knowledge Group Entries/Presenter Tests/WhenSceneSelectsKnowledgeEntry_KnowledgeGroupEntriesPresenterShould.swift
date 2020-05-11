import Eurofurence
import EurofurenceModel
import XCTest

class WhenSceneSelectsKnowledgeEntry_KnowledgeGroupEntriesPresenterShould: XCTestCase {

    func testTellTheDelegateAboutTheSelectedEntryIdentifier() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        let randomEntry = context.viewModel.entries.randomElement()
        context.simulateSceneDidSelectEntry(at: randomEntry.index)
        let expected = context.viewModel.identifierForKnowledgeEntry(at: randomEntry.index)

        XCTAssertEqual(expected, context.delegate.selectedKnowledgeEntryIdentifier)
    }

}
