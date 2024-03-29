import Combine
import EurofurenceApplication
import EurofurenceModel
import ObservedObject
import RouterCore
import XCTComponentBase
import XCTest
import XCTEurofurenceModel
import XCTRouter

class NewsAnnouncementsWidgetViewModelTests: XCTestCase {
    
    private var fakeMarkdownFormatter: StubMarkdownRenderer!
    private var fakeTimestampsFormatter: FakeDateFormatter!
    private var dataSource: ControllableNewsAnnouncementsDataSource!
    private var viewModel: DataSourceBackedNewsAnnouncementsWidgetViewModel!
    private var configuration: StubNewsAnnouncementsConfiguration!
    private var router: FakeContentRouter!
    
    override func setUp() {
        super.setUp()
        
        fakeMarkdownFormatter = StubMarkdownRenderer()
        fakeTimestampsFormatter = FakeDateFormatter()
        let formatters = AnnouncementsWidgetFormatters(
            announcementTimestamps: fakeTimestampsFormatter,
            markdownRenderer: fakeMarkdownFormatter
        )
        
        dataSource = ControllableNewsAnnouncementsDataSource()
        configuration = StubNewsAnnouncementsConfiguration()
        let viewModelFactory = NewsAnnouncementsWidgetViewModelFactory(
            dataSource: dataSource,
            configuration: configuration,
            formatters: formatters
        )
        
        router = FakeContentRouter()
        viewModel = viewModelFactory.makeViewModel(router: router)
    }
    
    func testUnreadAnnouncement() throws {
        let announcement = FakeAnnouncement.random
        fakeTimestampsFormatter.stub("Timestamp", for: announcement.date)
        dataSource.updateAnnouncements([announcement])
        
        XCTAssertEqual(1, viewModel.numberOfElements)
        
        let announcementViewModel = try self.announcementViewModel(at: 0)
        let actualBody = announcementViewModel.body
        let expectedBody = fakeMarkdownFormatter.stubbedContents(for: announcement.content)
        
        XCTAssertEqual(announcement.title, announcementViewModel.title)
        XCTAssertTrue(announcementViewModel.isUnreadIndicatorVisible)
        XCTAssertEqual("Timestamp", announcementViewModel.formattedTimestamp)
        XCTAssertEqual(expectedBody, actualBody)
    }
    
    func testReadAnnouncement() throws {
        let announcement = FakeAnnouncement.random
        announcement.markRead()
        dataSource.updateAnnouncements([announcement])
        
        XCTAssertEqual(1, viewModel.numberOfElements)
        
        let announcementViewModel = try self.announcementViewModel(at: 0)
        
        XCTAssertEqual(announcement.title, announcementViewModel.title)
        XCTAssertFalse(announcementViewModel.isUnreadIndicatorVisible)
    }
    
    func testUnreadAnnouncementBecomesRead() throws {
        let announcement = FakeAnnouncement.random
        announcement.markRead()
        dataSource.updateAnnouncements([announcement])
        let announcementViewModel = try self.announcementViewModel(at: 0)
        
        var notifiedObjectDidChange = false
        let subscription = announcementViewModel
            .objectDidChange
            .sink { (_) in
                notifiedObjectDidChange = true
            }
        
        defer {
            subscription.cancel()
        }
        
        XCTAssertFalse(notifiedObjectDidChange)
        
        announcement.markRead()
        
        XCTAssertTrue(notifiedObjectDidChange)
    }
    
    func testCapsDisplayedAnnouncementsToConfiguredLimit() {
        let announcements = [FakeAnnouncement.random, FakeAnnouncement.random, FakeAnnouncement.random]
        configuration.maxDisplayedAnnouncements = 2
        dataSource.updateAnnouncements(announcements)
        
        XCTAssertEqual(3, viewModel.numberOfElements)
        
        XCTAssertEqual(.showMoreAnnouncements, viewModel.element(at: 0))
        XCTAssertEqual(announcements[0].title, try self.announcementViewModel(at: 1).title)
        XCTAssertEqual(announcements[1].title, try self.announcementViewModel(at: 2).title)
    }
    
    func testViewingAnnouncement() throws {
        let announcement = FakeAnnouncement.random
        dataSource.updateAnnouncements([announcement])
        let announcementViewModel = try self.announcementViewModel(at: 0)
        announcementViewModel.open()
        
        router.assertRouted(to: AnnouncementRouteable(identifier: announcement.identifier))
    }
    
    func testViewingAllAnnouncements() {
        viewModel.openAllAnnouncements()
        router.assertRouted(to: AnnouncementsRouteable())
    }
    
    func testUpdatingAnnouncementsNotifiesChange() throws {
        var notifiedObjectDidChange = false
        
        let subscription = viewModel
            .objectDidChange
            .sink { (_) in
                notifiedObjectDidChange = true
            }
        
        defer {
            subscription.cancel()
        }
        
        XCTAssertFalse(notifiedObjectDidChange)
        
        dataSource.updateAnnouncements([FakeAnnouncement.random])
        
        XCTAssertTrue(notifiedObjectDidChange)
    }
    
    private func announcementViewModel(at index: Int) throws -> DataSourceBackedAnnouncementWidgetViewModel {
        guard index < viewModel.numberOfElements else {
            struct IndexOutOfRange: Error { }
            throw IndexOutOfRange()
        }
        
        let element = viewModel.element(at: index)
        return try XCTUnwrap(element.viewModel)
    }
    
}
