@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenPreloadCompletes_DirectorShould: XCTestCase {

    func testShowTheTabModuleWithDefaultTabOrder() {
        let context = ApplicationDirectorTestBuilder().build()
        context.rootModule.simulateTutorialShouldBePresented()
        context.tutorialModule.simulateTutorialFinished()
        context.preloadModule.simulatePreloadFinished()
        let tabModule = context.tabModule.stubInterface
        let capturedTabModules = context.tabModule.capturedTabModules.compactMap({ $0 as? UINavigationController }).compactMap({ $0.topViewController })
        let expectedTabModules = [
            context.newsModule.stubInterface,
            context.scheduleModule.stubInterface,
            context.dealersModule.stubInterface,
            context.knowledgeListModule.stubInterface,
            context.mapsModule.stubInterface,
            context.collectThemAllModule.stubInterface,
            context.additionalServicesModule.stubInterface
        ]

        XCTAssertEqual(tabModule, context.windowWireframe.capturedRootInterface)
        XCTAssertEqual(expectedTabModules, capturedTabModules)
    }

}
