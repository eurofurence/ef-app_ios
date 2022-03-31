import ComponentBase
import EurofurenceApplication
import ObservedObject
import ScheduleComponent
import UIKit
import XCTest

class EventsNewsWidgetTableViewDataSourceTests: XCTestCase {
    
    private var viewModel: FakeEventsWidgetViewModel!
    private var dataSource: EventsNewsWidgetTableViewDataSource<FakeEventsWidgetViewModel>?
    private var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        tableView = UITableView(frame: .zero, style: .plain)
    }
    
    private func prepareDataSource(events: [FakeEventViewModel]) {
        let viewModel = FakeEventsWidgetViewModel()
        viewModel.events = events
        viewModel.title = "Upcoming Events"
        self.viewModel = viewModel
        
        let dataSource = EventsNewsWidgetTableViewDataSource(viewModel: viewModel)
        dataSource.registerReusableViews(into: tableView)
        self.dataSource = dataSource
    }
    
    private func dequeueSingleViewModelTestCell() throws -> EventTableViewCell {
        let firstSectionFirstRow: IndexPath = IndexPath(row: 0, section: 0)
        let cell = dataSource?.tableView(tableView, cellForRowAt: firstSectionFirstRow)
        
        return try XCTUnwrap(cell as? EventTableViewCell)
    }
    
    private func findBindingTarget<T>(
        accessibilityIdentifier: String
    ) throws -> T where T: UIView {
        let cell = try dequeueSingleViewModelTestCell()
        let interfaceElement: T? = cell.viewWithAccessibilityIdentifier(accessibilityIdentifier)
        
        return try XCTUnwrap(interfaceElement)
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
        
        let header = dataSource?.tableView(tableView, viewForHeaderInSection: 0)
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
        
        try assertViewModel(
            with: \.isKageEvent,
            as: true,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_KageWineGlass",
            to: false
        )
        
        try assertViewModel(
            with: \.isKageEvent,
            as: false,
            setsIsHiddenForViewWithAccessibilityIdentifier: "Event_KageWineGlass",
            to: true
        )
    }
    
    private func assertViewModel(
        with viewModelKeyPath: WritableKeyPath<FakeEventViewModel, Bool>,
        as viewModelValue: Bool,
        setsIsHiddenForViewWithAccessibilityIdentifier accessibilityIdentifier: String,
        to expected: Bool
    ) throws {
        var eventViewModel = FakeEventViewModel()
        eventViewModel[keyPath: viewModelKeyPath] = viewModelValue
        prepareDataSource(events: [eventViewModel])
        let view = try findBindingTarget(accessibilityIdentifier: accessibilityIdentifier)
        let actual = view.isHidden
        
        XCTAssertEqual(expected, actual)
    }
    
    private class FakeEventsWidgetViewModel: EventsWidgetViewModel {
        
        typealias Event = FakeEventViewModel
        
        var title: String = ""
        
        var numberOfEvents: Int {
            events.count
        }
        
        var events: [FakeEventViewModel] = []
        
        func event(at index: Int) -> Event {
            events[index]
        }
        
    }
    
    private class FakeEventViewModel: EventViewModel {
        
        @Observed var name: String
        @Observed var location: String
        @Observed var startTime: String
        @Observed var endTime: String
        @Observed var isFavourite: Bool
        @Observed var isSponsorOnly: Bool
        @Observed var isSuperSponsorOnly: Bool
        @Observed var isArtShow: Bool
        @Observed var isKageEvent: Bool
        @Observed var isDealersDen: Bool
        @Observed var isMainStage: Bool
        @Observed var isPhotoshoot: Bool
        
        init(
            name: String = "Name",
            location: String = "Location",
            startTime: String = "Start Time",
            endTime: String = "End Time",
            isFavourite: Bool = false,
            isSponsorOnly: Bool = false,
            isSuperSponsorOnly: Bool = false,
            isArtShow: Bool = false,
            isKageEvent: Bool = false,
            isDealersDen: Bool = false,
            isMainStage: Bool = false,
            isPhotoshoot: Bool = false
        ) {
            self.name = name
            self.location = location
            self.startTime = startTime
            self.endTime = endTime
            self.isFavourite = isFavourite
            self.isSponsorOnly = isSponsorOnly
            self.isSuperSponsorOnly = isSuperSponsorOnly
            self.isArtShow = isArtShow
            self.isKageEvent = isKageEvent
            self.isDealersDen = isDealersDen
            self.isMainStage = isMainStage
            self.isPhotoshoot = isPhotoshoot
        }
        
    }
    
}

private extension UIView {
    
    func viewWithAccessibilityIdentifier<T>(_ accessibilityIdentifier: String) -> T? where T: UIView {
        if self.accessibilityIdentifier == accessibilityIdentifier, let view = self as? T {
            return view
        } else {
            return subviews
                .lazy
                .compactMap({ $0.viewWithAccessibilityIdentifier(accessibilityIdentifier) as? T })
                .first
        }
    }
    
}
