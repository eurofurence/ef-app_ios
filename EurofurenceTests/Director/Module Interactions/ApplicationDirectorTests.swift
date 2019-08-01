@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class ApplicationDirectorTests: XCTestCase {

    var context: ApplicationDirectorTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = ApplicationDirectorTestBuilder().build()
    }

    func testWhenKnowledgeEntrySelectsWebLinkTheWebModuleIsPresentedOntoTheTabInterface() {
        context.navigateToTabController()
        let entry = FakeKnowledgeEntry.random
        context.knowledgeListModule.simulateKnowledgeGroupSelected(.random)
        context.knowledgeGroupEntriesModule.simulateKnowledgeEntrySelected(.random)
        let link = entry.links.randomElement().element
        let url = URL.random
        context.linkRouter.stubContent(.web(url), for: link)
        context.knowledgeDetailModule.simulateLinkSelected(link)
        let webModuleForURL = context.webModuleProviding.producedWebModules[url]

        XCTAssertNotNil(webModuleForURL)
        XCTAssertEqual(webModuleForURL, context.tabModule.stubInterface.capturedPresentedViewController)
    }

    func testWhenKnowledgeEntrySelectsExternalAppLinkTheURLLauncherIsToldToHandleTheURL() {
        context.navigateToTabController()
        let entry = FakeKnowledgeEntry.random
        context.knowledgeListModule.simulateKnowledgeGroupSelected(.random)
        context.knowledgeGroupEntriesModule.simulateKnowledgeEntrySelected(.random)
        let link = entry.links.randomElement().element
        let url = URL.random
        context.linkRouter.stubContent(.externalURL(url), for: link)
        context.knowledgeDetailModule.simulateLinkSelected(link)

        XCTAssertEqual(url, context.urlOpener.capturedURLToOpen)
    }

}
