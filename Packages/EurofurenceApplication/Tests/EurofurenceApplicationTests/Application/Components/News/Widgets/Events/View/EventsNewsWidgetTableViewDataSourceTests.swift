import ComponentBase
import EurofurenceApplication
import ObservedObject
import RouterCore
import ScheduleComponent
import UIKit
import XCTest

class EventsNewsWidgetTableViewDataSourceTests: XCTestCase {
    
    private var viewModel: FakeEventsWidgetViewModel!
    private var dataSource: TableViewMediator?
    private var delegate: CapturingTableViewMediatorDelegate!
    private var tableView: UITableView!
    
    private func prepareDataSource(events: [FakeEventViewModel]) {
        let viewModel = FakeEventsWidgetViewModel()
        viewModel.events = events
        viewModel.title = "Upcoming Events"
        self.viewModel = viewModel
        
        let viewModelFactory = FakeEventsWidgetViewModelFactory(viewModel: viewModel)
        
        let widget = MVVMWidget(
            viewModelFactory: viewModelFactory,
            viewFactory: TableViewNewsWidgetViewFactory()
        )
        
        self.tableView = UITableView(frame: .zero, style: .plain)
        let manager = FakeNewsWidgetManager(tableView: tableView)
        widget.register(in: manager)
        
        self.delegate = CapturingTableViewMediatorDelegate()
        self.dataSource = manager.installedDataSources.last
        self.dataSource?.delegate = delegate
    }
    
    private func dequeueCell(at firstSectionFirstRow: IndexPath) throws -> EventTableViewCell {
        let cell = dataSource?.tableView(tableView, cellForRowAt: firstSectionFirstRow)
        return try XCTUnwrap(cell as? EventTableViewCell)
    }
    
    private func dequeueSingleViewModelTestCell() throws -> EventTableViewCell {
        let firstSectionFirstRow: IndexPath = IndexPath(row: 0, section: 0)
        return try dequeueCell(at: firstSectionFirstRow)
    }
    
    private func findBindingTarget<T>(
        accessibilityIdentifier: String
    ) throws -> T where T: UIView {
        let cell = try dequeueSingleViewModelTestCell()
        return try findBindingTarget(in: cell, accessibilityIdentifier: accessibilityIdentifier)
    }
    
    private func findBindingTarget<T>(
        in parent: UIView,
        accessibilityIdentifier: String
    ) throws -> T where T: UIView {
        let interfaceElement: T? = parent.viewWithAccessibilityIdentifier(accessibilityIdentifier)
        return try XCTUnwrap(interfaceElement)
    }
    
    func testViewModelChangedNotifiesSectionChanged() {
        prepareDataSource(events: [])
        
        XCTAssertFalse(delegate.contentsDidChange)
        
        viewModel.objectDidChange.send()
        
        XCTAssertTrue(delegate.contentsDidChange)
    }
    
    func testNumberOfItemsSourcedFromViewModel() {
        let eventViewModels = (0...Int.random(in: 3...10)).map({ (_) in FakeEventViewModel() })
        prepareDataSource(events: eventViewModels)
        
        let expected = eventViewModels.count
        let actual = dataSource?.tableView(tableView, numberOfRowsInSection: 0)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testHeaderUsesTitle() throws {
        prepareDataSource(events: [])
        
        let header = dataSource?.tableView?(tableView, viewForHeaderInSection: 0)
        let sectionHeader = try XCTUnwrap(header as? UITableViewHeaderFooterView)
        
        XCTAssertEqual(viewModel.title, sectionHeader.textLabel?.text)
    }
    
    func testBindsNameToEventTableViewCell() throws {
        let eventViewModel = FakeEventViewModel()
        eventViewModel.name = "Opening Ceremony"
        prepareDataSource(events: [eventViewModel])
        
        let titleLabel: UILabel = try findBindingTarget(accessibilityIdentifier: "Event_Title")
        
        XCTAssertEqual("Opening Ceremony", titleLabel.text)
    }
    
    func testBindsLocationToEventTableViewCell() throws {
        let eventViewModel = FakeEventViewModel()
        eventViewModel.location = "Main Stage"
        prepareDataSource(events: [eventViewModel])
        
        let locationLabel: UILabel = try findBindingTarget(accessibilityIdentifier: "Event_Location")
        
        XCTAssertEqual("Main Stage", locationLabel.text)
    }
    
    func testBindsStartTimeToEventTableViewCell() throws {
        let eventViewModel = FakeEventViewModel()
        eventViewModel.startTime = "15:30"
        prepareDataSource(events: [eventViewModel])
        
        let locationLabel: UILabel = try findBindingTarget(accessibilityIdentifier: "Event_StartTime")
        
        XCTAssertEqual("15:30", locationLabel.text)
    }
    
    func testBindsEndTimeToEventTableViewCell() throws {
        let eventViewModel = FakeEventViewModel()
        eventViewModel.endTime = "16:00"
        prepareDataSource(events: [eventViewModel])
        
        let locationLabel: UILabel = try findBindingTarget(accessibilityIdentifier: "Event_EndTime")
        
        XCTAssertEqual("16:00", locationLabel.text)
    }
    
    func testBindsFavouriteStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isFavourite,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsFavourite",
            to: false
        )
        
        try assertViewModel(
            with: \.isFavourite,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsFavourite",
            to: true
        )
    }
    
    func testBindsSponsorStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isSponsorOnly,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsSponsorOnly",
            to: false
        )
        
        try assertViewModel(
            with: \.isSponsorOnly,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsSponsorOnly",
            to: true
        )
    }
    
    func testBindsSuperSponsorStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isSuperSponsorOnly,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsSuperSponsorOnly",
            to: false
        )
        
        try assertViewModel(
            with: \.isSuperSponsorOnly,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsSuperSponsorOnly",
            to: true
        )
    }
    
    func testBindsArtShowStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isArtShow,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsArtShow",
            to: false
        )
        
        try assertViewModel(
            with: \.isArtShow,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsArtShow",
            to: true
        )
    }
    
    func testBindsDealersDenStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isDealersDen,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsDealersDen",
            to: false
        )
        
        try assertViewModel(
            with: \.isDealersDen,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsDealersDen",
            to: true
        )
    }
    
    func testBindsMainStageStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isMainStage,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsMainStage",
            to: false
        )

        try assertViewModel(
            with: \.isMainStage,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsMainStage",
            to: true
        )
    }

    func testBindsPhotoshootStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isPhotoshoot,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsPhotoshoot",
            to: false
        )

        try assertViewModel(
            with: \.isPhotoshoot,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsPhotoshoot",
            to: true
        )
    }
    
    func testBindsKageStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isKageEvent,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_KageBug",
            to: false
        )
        
        try assertViewModel(
            with: \.isKageEvent,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_KageBug",
            to: true
        )
    }
    
    func testBindsFaceMaskRequiredStateToEventTableViewCell() throws {
        try assertViewModel(
            with: \.isFaceMaskRequired,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsFaceMaskRequired",
            to: true
        )
        
        try assertViewModel(
            with: \.isFaceMaskRequired,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_IsFaceMaskRequired",
            to: false
        )
    }
    
    func testSelectingCellUsesRowToNotifySelectedEventIndex() {
        prepareDataSource(events: [])
        dataSource?.tableView?(tableView, didSelectRowAt: IndexPath(row: 1, section: 2))
        
        XCTAssertEqual(1, viewModel.selectedEventIndex)
    }
    
    func testCellTransitionsFromNotFavouriteToFavourite() throws {
        let eventViewModel = FakeEventViewModel()
        eventViewModel.isFavourite = false
        prepareDataSource(events: [eventViewModel])
        
        let isFavouriteView: UIView = try findBindingTarget(accessibilityIdentifier: "Event_IsFavourite")
        
        eventViewModel.isFavourite = true
        
        XCTAssertFalse(isFavouriteView.isHidden)
    }
    
    private func assertViewModel(
        with viewModelKeyPath: WritableKeyPath<FakeEventViewModel, Bool>,
        as viewModelValue: Bool,
        setsIsHiddenForViewWithAccessibilityIdentifier accessibilityIdentifier: String,
        to expected: Bool,
        line: UInt = #line
    ) throws {
        var eventViewModel = FakeEventViewModel()
        eventViewModel[keyPath: viewModelKeyPath] = viewModelValue
        prepareDataSource(events: [eventViewModel])
        let view = try findBindingTarget(accessibilityIdentifier: accessibilityIdentifier)
        let actual = view.isHidden
        
        XCTAssertEqual(expected, actual, line: line)
    }
    
}
