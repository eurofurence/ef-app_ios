@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenOpeningKnowledgeEntry_WithParentGroup_DirectorShould: XCTestCase {

    func testShowTheKnowledgeList_Group_AndEntry() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface).unsafelyUnwrapped
        let knowledgeEntry = KnowledgeEntryIdentifier.random
        let knowledgeGroup = KnowledgeGroupIdentifier.random
        context.director.openKnowledgeEntry(knowledgeEntry, parentGroup: knowledgeGroup)
        
        let index = context.tabModule.capturedTabModules.firstIndex(of: knowledgeNavigationController)
        
        XCTAssertEqual(index, context.tabModule.stubInterface.selectedIndex)
        XCTAssertEqual(knowledgeEntry, context.knowledgeDetailModule.capturedModel)
        XCTAssertEqual(knowledgeGroup, context.knowledgeGroupEntriesModule.capturedModel)
        XCTAssertEqual(
            [context.knowledgeListModule.stubInterface,
             context.knowledgeGroupEntriesModule.stubInterface,
             context.knowledgeDetailModule.stubInterface],
            knowledgeNavigationController.viewControllers
        )
    }

}
