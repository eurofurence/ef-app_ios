import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingKnowledgeEntry_KnowledgeGroupEntriesPresenterShould: XCTestCase {

    func testBindTheNameOfTheEntryOntoTheComponent() {
        let context = KnowledgeGroupEntriesPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        let randomEntry = context.viewModel.entries.randomElement()
        let component = CapturingKnowledgeGroupEntryScene()
        context.bind(component, at: randomEntry.index)

        XCTAssertEqual(randomEntry.element.title, component.capturedTitle)
    }

}
