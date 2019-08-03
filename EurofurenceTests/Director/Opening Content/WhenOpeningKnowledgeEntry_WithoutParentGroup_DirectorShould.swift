@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenOpeningKnowledgeEntry_WithoutParentGroup_DirectorShould: XCTestCase {

    func testShowTheKnowledgeList_AndEntry() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let knowledgeNavigationController = unwrap(context.navigationController(for: context.knowledgeListModule.stubInterface))
        let knowledgeEntry = KnowledgeEntryIdentifier.random
        context.director.openKnowledgeEntry(knowledgeEntry)
        
        let index = context.tabModule.capturedTabModules.firstIndex(of: knowledgeNavigationController)
        
        XCTAssertEqual(index, context.tabModule.stubInterface.selectedIndex)
        XCTAssertEqual(knowledgeEntry, context.knowledgeDetailModule.capturedModel)
        XCTAssertEqual(
            [context.knowledgeListModule.stubInterface,
             context.knowledgeDetailModule.stubInterface],
            knowledgeNavigationController.viewControllers
        )
    }

}
