import EurofurenceApplication
import EurofurenceModel
import XCTest

class StoryboardPreloadSceneFactoryTests: XCTestCase {

    func testThePreloadSceneViewControllerIsMade() {
        let factory = StoryboardPreloadSceneFactory()
        let scene = factory.makePreloadScene()

        XCTAssertNotNil(scene.storyboard)
    }

}
