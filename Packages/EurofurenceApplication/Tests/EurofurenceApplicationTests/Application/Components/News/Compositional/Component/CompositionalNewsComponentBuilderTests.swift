import EurofurenceApplication
import XCTest

class CompositionalNewsComponentBuilderTests: XCTestCase {
    
    func testProducesSceneFromFactory() {
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let builder = CompositionalNewsComponentBuilder()
            .with(sceneFactory)
        
        let delegate = CapturingNewsComponentDelegate()
        let component = builder.build().makeNewsComponent(delegate)
        
        XCTAssertIdentical(component, sceneFactory.scene)
    }
    
    private class FakeCompositionalNewsSceneFactory: CompositionalNewsSceneFactory {
        
        let scene = FakeCompositionalNewsScene()
        func makeCompositionalNewsScene() -> UIViewController & NewsWidgetManager {
            scene
        }
        
    }
    
    private class FakeCompositionalNewsScene: UIViewController, NewsWidgetManager {
        
        func install(dataSource: TableViewMediator) {
            
        }
        
    }
    
}
