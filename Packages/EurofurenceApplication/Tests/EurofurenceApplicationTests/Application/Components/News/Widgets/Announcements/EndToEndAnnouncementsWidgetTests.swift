import EurofurenceApplication
import XCTest
import XCTEurofurenceModel

class EndToEndAnnouncementsWidgetTests: XCTestCase {
    
    func testSelectingAllAnnouncementsItemShowsAllAnnouncements() throws {
        let configuration = StubNewsAnnouncementsConfiguration()
        configuration.maxDisplayedAnnouncements = 1
        
        let dataSource = ControllableNewsAnnouncementsDataSource()
        dataSource.updateAnnouncements([FakeAnnouncement.random, FakeAnnouncement.random, FakeAnnouncement.random])
        let viewModelFactory = NewsAnnouncementsWidgetViewModelFactory(
            dataSource: dataSource,
            configuration: configuration
        )
        
        let widget = MVVMWidget(viewModelFactory: viewModelFactory, viewFactory: AnnouncementsNewsWidgetViewFactory())
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let componentFactory = CompositionalNewsComponentBuilder().with(sceneFactory).with(widget).build()
        let delegate = CapturingNewsComponentDelegate()
        _ = componentFactory.makeNewsComponent(delegate)
        sceneFactory.scene.simulateSceneReady()
        
        let announcementsDataSource = try XCTUnwrap(sceneFactory.scene.installedDataSources.first)
        announcementsDataSource.tableView?(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(delegate.showAllAnnouncementsRequested)
    }
    
    func testSelectingAnnouncementShowsAnnouncement() throws {
        let announcement = FakeAnnouncement.random
        let dataSource = ControllableNewsAnnouncementsDataSource()
        dataSource.updateAnnouncements([announcement])
        let viewModelFactory = NewsAnnouncementsWidgetViewModelFactory(
            dataSource: dataSource,
            configuration: StubNewsAnnouncementsConfiguration()
        )
        
        let widget = MVVMWidget(viewModelFactory: viewModelFactory, viewFactory: AnnouncementsNewsWidgetViewFactory())
        let sceneFactory = FakeCompositionalNewsSceneFactory()
        let componentFactory = CompositionalNewsComponentBuilder().with(sceneFactory).with(widget).build()
        let delegate = CapturingNewsComponentDelegate()
        _ = componentFactory.makeNewsComponent(delegate)
        sceneFactory.scene.simulateSceneReady()
        
        let announcementsDataSource = try XCTUnwrap(sceneFactory.scene.installedDataSources.first)
        announcementsDataSource.tableView?(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(announcement.identifier, delegate.capturedAnnouncement)
    }
    
}
