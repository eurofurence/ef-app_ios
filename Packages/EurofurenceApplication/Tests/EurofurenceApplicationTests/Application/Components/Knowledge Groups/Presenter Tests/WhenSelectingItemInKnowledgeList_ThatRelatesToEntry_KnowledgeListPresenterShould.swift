import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenSelectingItemInKnowledgeList_ThatRelatesToEntry_KnowledgeListPresenterShould: XCTestCase {

    func testTellTheDelegateTheEntryWasSelected() {
        let viewModel = VisitsEntryFromKnowledgeListViewModel(entryIdentifier: .random)
        let context = KnowledgeGroupsPresenterTestBuilder().build()
        context.scene.delegate?.knowledgeListSceneDidLoad()
        context.simulateLoadingViewModel(viewModel)
        context.scene.delegate?.knowledgeListSceneDidSelectKnowledgeGroup(at: 0)
        
        XCTAssertEqual(context.delegate.capturedKnowledgeEntryToPresent, viewModel.entryIdentifier)
    }

}
