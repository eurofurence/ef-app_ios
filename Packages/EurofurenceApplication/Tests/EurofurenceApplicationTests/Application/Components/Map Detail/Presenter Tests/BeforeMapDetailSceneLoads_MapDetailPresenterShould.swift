import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class BeforeMapDetailSceneLoads_MapDetailPresenterShould: XCTestCase {

    func testNotBindAnySceneComponents() {
        let identifier = MapIdentifier.random
        let viewModelFactory = FakeMapDetailViewModelFactory(expectedMapIdentifier: identifier)
        let context = MapDetailPresenterTestBuilder().with(viewModelFactory).build(for: identifier)

        XCTAssertNil(context.scene.capturedTitle)
    }

}
