import ComponentBase
import EurofurenceApplication
import ObservedObject
import XCTest

class AnnouncementsNewsWidgetTableViewDataSourceTests: XCTestCase {
    
    private var viewModel: FakeNewsAnnouncementsWidgetViewModel!
    private var dataSource: AnnouncementsNewsWidgetTableViewDataSource<FakeNewsAnnouncementsWidgetViewModel>!
    private var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        viewModel = FakeNewsAnnouncementsWidgetViewModel()
        let viewFactory = AnnouncementsNewsWidgetViewFactory<FakeNewsAnnouncementsWidgetViewModel>()
        dataSource = viewFactory.makeView(viewModel: viewModel)
        tableView = UITableView()
        dataSource.registerReusableViews(into: tableView)
    }
    
    func testHasAnnouncementsHeader() throws {
        let headerView = dataSource.tableView(tableView, viewForHeaderInSection: 0)
        let brandedHeaderView = try XCTUnwrap(headerView as? ConventionBrandedTableViewHeaderFooterView)
        
        XCTAssertEqual(.announcements, brandedHeaderView.textLabel?.text)
    }
    
    func testNumberOfRowsSourcedFromViewModel() {
        viewModel.elements = [.showMoreAnnouncements, .announcement(.init())]
        XCTAssertEqual(2, dataSource.tableView(tableView, numberOfRowsInSection: 0))
    }
    
    func testAllAnnouncementsElement() throws {
        viewModel.elements = [.showMoreAnnouncements]
        let promptLabel: UILabel = try findBindingTarget("ShowAllAnnouncements_Prompt")
        
        XCTAssertEqual(.allAnnouncements, promptLabel.text)
    }
    
    func testAnnouncementElement_BindsFormattedTimestamp() throws {
        let announcement = FakeNewsAnnouncementViewModel()
        announcement.formattedTimestamp = "Today"
        viewModel.elements = [.announcement(announcement)]
        let titleLabel: UILabel = try findBindingTarget("Announcement_Timestamp")
        
        XCTAssertEqual(announcement.formattedTimestamp, titleLabel.text)
    }
    
    func testAnnouncementElement_BindsTitle() throws {
        let announcement = FakeNewsAnnouncementViewModel()
        announcement.title = "You're here early. Please read this!"
        viewModel.elements = [.announcement(announcement)]
        let titleLabel: UILabel = try findBindingTarget("Announcement_Title")
        
        XCTAssertEqual(announcement.title, titleLabel.text)
    }
    
    func testAnnouncementElement_BindsBody() throws {
        let announcement = FakeNewsAnnouncementViewModel()
        announcement.body = NSAttributedString(string: "Check this out")
        viewModel.elements = [.announcement(announcement)]
        let titleLabel: UILabel = try findBindingTarget("Announcement_Body")
        
        XCTAssertEqual(announcement.body, titleLabel.attributedText)
    }
    
    func testAnnouncementElement_UnreadIndicatorVisible() throws {
        let announcement = FakeNewsAnnouncementViewModel()
        announcement.isUnreadIndicatorVisible = true
        viewModel.elements = [.announcement(announcement)]
        let unreadIndicator: UIView = try findBindingTarget("Announcement_UnreadIndicator")
        
        XCTAssertFalse(unreadIndicator.isHidden)
    }
    
    func testAnnouncementElement_UnreadIndicatorNotVisible() throws {
        let announcement = FakeNewsAnnouncementViewModel()
        announcement.isUnreadIndicatorVisible = false
        viewModel.elements = [.announcement(announcement)]
        let unreadIndicator: UIView = try findBindingTarget("Announcement_UnreadIndicator")
        
        XCTAssertTrue(unreadIndicator.isHidden)
    }
    
    func testAnnouncementElement_UnreadToRead() throws {
        let announcement = FakeNewsAnnouncementViewModel()
        announcement.isUnreadIndicatorVisible = true
        viewModel.elements = [.announcement(announcement)]
        let unreadIndicator: UIView = try findBindingTarget("Announcement_UnreadIndicator")
        announcement.isUnreadIndicatorVisible = false
        
        XCTAssertTrue(unreadIndicator.isHidden)
    }
    
    func testSelectingAllAnnouncements() throws {
        viewModel.elements = [.showMoreAnnouncements]
        dataSource.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(viewModel.openedAllAnnouncements)
    }
    
    func testSelectingAnnouncement() throws {
        let announcement = FakeNewsAnnouncementViewModel()
        viewModel.elements = [.announcement(announcement)]
        dataSource.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(announcement.opened)
        XCTAssertFalse(viewModel.openedAllAnnouncements)
    }
    
    func testRequestsReloadWhenViewModelChanges() throws {
        let delegate = CapturingTableViewMediatorDelegate()
        dataSource.delegate = delegate
        viewModel.objectDidChange.send()
        
        XCTAssertTrue(delegate.contentsDidChange)
    }
    
    private func findBindingTarget<View>(_ accessibilityIdentifier: String) throws -> View where View: UIView {
        let firstRowFirstSection = IndexPath(row: 0, section: 0)
        let cell = dataSource.tableView(tableView, cellForRowAt: firstRowFirstSection)
        let bindingTarget: View? = cell.viewWithAccessibilityIdentifier(accessibilityIdentifier)
        
        return try XCTUnwrap(bindingTarget)
    }
    
    private class FakeNewsAnnouncementsWidgetViewModel: NewsAnnouncementsWidgetViewModel {
        
        typealias Announcement = FakeNewsAnnouncementViewModel
        
        var elements = [AnnouncementWidgetContent<Announcement>]()
        
        var numberOfElements: Int {
            elements.count
        }
        
        func element(at index: Int) -> AnnouncementWidgetContent<Announcement> {
            elements[index]
        }
        
        private(set) var openedAllAnnouncements = false
        func openAllAnnouncements() {
            openedAllAnnouncements = true
        }
        
    }
    
    private class FakeNewsAnnouncementViewModel: NewsAnnouncementViewModel {
        
        var formattedTimestamp: String = ""
        var title: String = ""
        var body: NSAttributedString = NSAttributedString()
        
        @Observed var isUnreadIndicatorVisible: Bool = false
        
        private(set) var opened = false
        func open() {
            opened = true
        }
        
    }
    
}
