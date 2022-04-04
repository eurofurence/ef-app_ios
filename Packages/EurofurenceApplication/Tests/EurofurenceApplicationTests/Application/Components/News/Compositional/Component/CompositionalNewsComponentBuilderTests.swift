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
    
    func testInstallsWidgetsIntoSceneInDesignatedOrder() {
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let (firstWidget, secondWidget) = (FakeNewsWidget(), FakeNewsWidget())
        let builder = CompositionalNewsComponentBuilder()
            .with(sceneFactory)
            .with(firstWidget)
            .with(secondWidget)
        
        let delegate = CapturingNewsComponentDelegate()
        _ = builder.build().makeNewsComponent(delegate)
        sceneFactory.scene.simulateSceneReady()
        
        let expected = [firstWidget.mediator, secondWidget.mediator]
        let actual = sceneFactory.scene.installedDataSources
        let installedWidgets = actual.elementsEqual(expected, by: { $0 === $1 })
        
        XCTAssertTrue(installedWidgets, "Should install all widgets passed to builder in the order they are provided")
    }
    
    func testWaitsUntilSceneReadyBeforeInstallingWidgets() {
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let widget = FakeNewsWidget()
        let builder = CompositionalNewsComponentBuilder()
            .with(sceneFactory)
            .with(widget)
        
        let delegate = CapturingNewsComponentDelegate()
        _ = builder.build().makeNewsComponent(delegate)
        
        let installedWidgets = sceneFactory.scene.installedDataSources.isEmpty
        
        XCTAssertTrue(installedWidgets, "Should wait until scene ready before installing widgets")
    }
    
    private class FakeCompositionalNewsSceneFactory: CompositionalNewsSceneFactory {
        
        let scene = FakeCompositionalNewsScene()
        func makeCompositionalNewsScene() -> UIViewController & CompositionalNewsScene {
            scene
        }
        
    }
    
    private class FakeCompositionalNewsScene: UIViewController, CompositionalNewsScene {
        
        private(set) var installedDataSources = [TableViewMediator]()
        private var delegate: CompositionalNewsSceneDelegate?
        
        func setDelegate(_ delegate: CompositionalNewsSceneDelegate) {
            self.delegate = delegate
        }
        
        func install(dataSource: TableViewMediator) {
            installedDataSources.append(dataSource)
        }
        
        func simulateSceneReady() {
            delegate?.sceneReady()
        }
        
    }
    
    private struct FakeNewsWidget: NewsWidget {
        
        let mediator = FakeTableViewMediator()
        func register(in manager: NewsWidgetManager) {
            manager.install(dataSource: mediator)
        }
        
    }
    
}
