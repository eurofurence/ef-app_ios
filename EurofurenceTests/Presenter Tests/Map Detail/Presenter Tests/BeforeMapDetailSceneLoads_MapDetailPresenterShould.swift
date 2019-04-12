@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class BeforeMapDetailSceneLoads_MapDetailPresenterShould: XCTestCase {

    func testNotBindAnySceneComponents() {
        let identifier = MapIdentifier.random
        let interactor = FakeMapDetailInteractor(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(interactor).build(for: identifier)

        XCTAssertNil(context.scene.capturedTitle)
    }

}
