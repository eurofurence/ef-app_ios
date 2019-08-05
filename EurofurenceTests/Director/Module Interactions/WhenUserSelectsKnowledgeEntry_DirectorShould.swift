@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenUserSelectsKnowledgeEntry_DirectorShould: XCTestCase {

    func testShowTheKnowledgeEntryModuleForTheChosenEntry() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.knowledgeListModule.simulateKnowledgeGroupSelected(.random)
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface)
        let entry = KnowledgeEntryIdentifier.random
        context.knowledgeGroupEntriesModule.simulateKnowledgeEntrySelected(entry)

        XCTAssertEqual(context.knowledgeDetailModule.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(entry, context.knowledgeDetailModule.capturedModel)
    }
    
    func testShowTheKnowledgeEntryModuleForTheChosenEntry_FromGroupsList() {
        let context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        let knowledgeEntry = KnowledgeEntryIdentifier.random
        context.knowledgeListModule.simulateKnowledgeEntrySelected(knowledgeEntry)
        let knowledgeNavigationController = context.navigationController(for: context.knowledgeListModule.stubInterface)
        
        XCTAssertEqual(context.knowledgeDetailModule.stubInterface, knowledgeNavigationController?.topViewController)
        XCTAssertEqual(knowledgeEntry, context.knowledgeDetailModule.capturedModel)
    }

}
