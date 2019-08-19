@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenOpeningKnowledgeEntries_DirectorShould: XCTestCase {

    func testSwapToTheCorrectTab() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface).unsafelyUnwrapped
        context.director.openKnowledgeGroups()
        
        let index = context.tabModule.capturedTabModules.firstIndex(of: knowledgeNavigationController)
        
        XCTAssertEqual(index, context.tabModule.stubInterface.selectedIndex)
    }
    
    func testDisposeOfAnyPushedControllers() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.knowledgeListModule.simulateKnowledgeGroupSelected(.random)
        context.knowledgeGroupEntriesModule.simulateKnowledgeEntrySelected(.random)
        context.director.openKnowledgeGroups()
        
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface).unsafelyUnwrapped
        
        XCTAssertEqual(knowledgeNavigationController.viewControllers, [context.knowledgeListModule.stubInterface])
    }

}
