import EurofurenceApplication
import ObservedObject
import ScheduleComponent
import UIKit
import XCTest

class EventsNewsWidgetTableViewDataSourceTests: XCTestCase {
    
    private var dataSource: EventsNewsWidgetTableViewDataSource<FakeEventsWidgetViewModel>?
    private var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        
        tableView = UITableView(frame: .zero, style: .plain)
    }
    
    private func prepareDataSource(events: [FakeEventViewModel]) {
        let viewModel = FakeEventsWidgetViewModel()
        viewModel.events = events
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
    
    private class FakeEventsWidgetViewModel: EventsWidgetViewModel {
        
        typealias Event = FakeEventViewModel
        
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
