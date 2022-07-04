import EurofurenceApplication
import XCTest
import XCTEurofurenceModel

class EndToEndYourEurofurenceWidgetTests: XCTestCase {
    
    func testSelectingCellShowsPrivateMessages() throws {
        let dataSource = StubYourEurofurenceDataSource()
        let viewModelFactory = YourEurofurenceWidgetViewModelFactory(dataSource: dataSource)
        let widget = MVVMWidget(viewModelFactory: viewModelFactory, viewFactory: YourEurofurenceWidgetViewFactory())
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let componentFactory = CompositionalNewsComponentBuilder(refreshService: CapturingRefreshService())
            .with(sceneFactory)
            .with(widget)
            .build()
        
        let delegate = CapturingNewsComponentDelegate()
        _ = componentFactory.makeNewsComponent(delegate)
        sceneFactory.scene.simulateSceneReady()
        let personalisedDataSource = try XCTUnwrap(sceneFactory.scene.installedDataSources.first)
        personalisedDataSource.tableView?(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(delegate.showPrivateMessagesRequested)
    }
    
}
