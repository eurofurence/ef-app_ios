@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBuildingCollectThemAllModule_PresenterShould: XCTestCase {

    func testReturnInterfaceFromSceneFactory() {
        let context = CollectThemAllPresenterTestBuilder().build()
        XCTAssertEqual(context.scene, context.producedViewController)
    }

    func testApplyTheShortTitleToTheScene() {
        let context = CollectThemAllPresenterTestBuilder().build()
        XCTAssertEqual(.collect, context.scene.capturedShortTitle)
    }

    func testApplyTheTitleToTheScene() {
        let context = CollectThemAllPresenterTestBuilder().build()
        XCTAssertEqual(.collectThemAll, context.scene.capturedTitle)
    }
    
    func testApplyTheIconToTheScene() {
        let context = CollectThemAllPresenterTestBuilder().build()
        let expected = UIImage(named: "Collectemall-50", in: .main, compatibleWith: nil)?.pngData()
        
        XCTAssertEqual(expected, context.scene.capturedIconData)
    }

}