@testable import Eurofurence
import EurofurenceModel
import XCTest

class InOrderToSupportSyncKnowledgeListLoading_KnowledgeGroupsListPresenterShould: XCTestCase {

    func testShowTheLoadingIndicatorBeforeRequestingViewModelToBePrepared() {
        let context = KnowledgeGroupsPresenterTestBuilder().build()
        context.knowledgeViewModelFactory.prepareViewModelInvokedHandler = {
            XCTAssertTrue(context.scene.didShowLoadingIndicator)
        }

        context.scene.delegate?.knowledgeListSceneDidLoad()
    }

}
