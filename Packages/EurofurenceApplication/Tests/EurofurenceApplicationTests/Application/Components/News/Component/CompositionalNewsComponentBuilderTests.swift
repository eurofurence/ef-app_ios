import EurofurenceApplication
import XCTest
import XCTEurofurenceModel

class CompositionalNewsComponentBuilderTests: XCTestCase {
    
    func testProducesSceneFromFactory() {
        let refreshService = CapturingRefreshService()
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let builder = CompositionalNewsComponentBuilder(refreshService: refreshService)
            .with(sceneFactory)
        
        let delegate = CapturingNewsComponentDelegate()
        let component = builder.build().makeNewsComponent(delegate)
        
        XCTAssertIdentical(component, sceneFactory.scene)
    }
    
    func testInstallsWidgetsIntoSceneInDesignatedOrder() {
        let refreshService = CapturingRefreshService()
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let (firstWidget, secondWidget) = (FakeNewsWidget(), FakeNewsWidget())
        let builder = CompositionalNewsComponentBuilder(refreshService: refreshService)
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
        let refreshService = CapturingRefreshService()
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let widget = FakeNewsWidget()
        let builder = CompositionalNewsComponentBuilder(refreshService: refreshService)
            .with(sceneFactory)
            .with(widget)
        
        let delegate = CapturingNewsComponentDelegate()
        _ = builder.build().makeNewsComponent(delegate)
        
        let installedWidgets = sceneFactory.scene.installedDataSources.isEmpty
        
        XCTAssertTrue(installedWidgets, "Should wait until scene ready before installing widgets")
    }
    
    func testTellRefreshServiceToBeginRefreshingWhenSceneRequestsIt() {
        let refreshService = CapturingRefreshService()
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let builder = CompositionalNewsComponentBuilder(refreshService: refreshService)
            .with(sceneFactory)
        
        let delegate = CapturingNewsComponentDelegate()
        _ = builder.build().makeNewsComponent(delegate)
        
        sceneFactory.scene.simulateSceneReady()
        
        XCTAssertFalse(refreshService.toldToRefresh, "Should not begin refreshing until scene requests it")
        
        sceneFactory.scene.simulateRefreshRequested()
        
        XCTAssertTrue(refreshService.toldToRefresh, "Should begin refreshing when the scene requests it")
    }
    
    func testTellDelegateToShowSettingsWhenSceneRequestsit() {
        let refreshService = CapturingRefreshService()
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let builder = CompositionalNewsComponentBuilder(refreshService: refreshService)
            .with(sceneFactory)
        
        let delegate = CapturingNewsComponentDelegate()
        _ = builder.build().makeNewsComponent(delegate)
        
        sceneFactory.scene.simulateSceneReady()
        
        let sender = "Opqaque sender"
        sceneFactory.scene.simulateSettingsTapped(sender: sender)
        
        XCTAssertEqual(sender, delegate.showSettingsSender as? String)
    }
    
    func testControlSceneRefreshIndicatorVisibilityDuringRefresh() {
        let refreshService = CapturingRefreshService()
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let builder = CompositionalNewsComponentBuilder(refreshService: refreshService)
            .with(sceneFactory)
        
        let delegate = CapturingNewsComponentDelegate()
        _ = builder.build().makeNewsComponent(delegate)
        
        sceneFactory.scene.simulateSceneReady()
        
        XCTAssertEqual(
            .unknown,
            sceneFactory.scene.loadingIndicatorState,
            "Loading indicator should not be told to show or hide until the service propogates its state"
        )
        
        refreshService.simulateRefreshBegan()
        
        XCTAssertEqual(
            .visible,
            sceneFactory.scene.loadingIndicatorState,
            "Loading indicator should be visible while refresh is active"
        )
        
        refreshService.simulateRefreshFinished()
        
        XCTAssertEqual(
            .hidden,
            sceneFactory.scene.loadingIndicatorState,
            "Loading indicator should be hidden when refresh concludes"
        )
    }
    
    private struct FakeNewsWidget: NewsWidget {
        
        let mediator = FakeTableViewMediator()
        func register(in environment: NewsWidgetEnvironment) {
            environment.install(dataSource: mediator)
        }
        
    }
    
}
