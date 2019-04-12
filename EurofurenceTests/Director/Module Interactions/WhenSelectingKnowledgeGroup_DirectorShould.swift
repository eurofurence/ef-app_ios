@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSelectingKnowledgeGroup_DirectorShould: XCTestCase {

    func testShowTheGroupEntriesModuleOntoTheKnowledgeNavigationController() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface)
        let identifier = KnowledgeGroupIdentifier.random
        context.knowledgeListModule.simulateKnowledgeGroupSelected(identifier)

        XCTAssertEqual(context.knowledgeGroupEntriesModule.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(identifier, context.knowledgeGroupEntriesModule.capturedModel)
    }

}
