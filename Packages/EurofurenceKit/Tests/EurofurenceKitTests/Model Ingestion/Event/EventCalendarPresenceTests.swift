@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class EventCalendarPresenceTests: EurofurenceKitTestCase {
    
    func testEventNotPresentInCalendar() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let afterDarkDealersDenSetupID = "3842fa46-49cb-4a56-9396-05bb7cbc5904"
        let afterDarkDealersDenSetup = try scenario.model.event(identifiedBy: afterDarkDealersDenSetupID)
        
        XCTAssertFalse(
            afterDarkDealersDenSetup.isPresentInCalendar, 
            "Events should not be present in the calendar by default"
        )
    }
    
    func testEventPresentInCalendarAtSetupTime() async throws {
        let api = FakeEurofurenceAPI()
        let eventStore = FakeEventCalendar()
        let scenario = await EurofurenceModelTestBuilder().with(api: api).with(eventCalendar: eventStore).build()
        eventStore.add(entry: try expectedAfterDarkDealersDenCalendarEntry(in: scenario))
        
        try await scenario.updateLocalStore(using: .ef26)
        
        let afterDarkDealersDenSetupID = "3842fa46-49cb-4a56-9396-05bb7cbc5904"
        let afterDarkDealersDenSetup = try scenario.model.event(identifiedBy: afterDarkDealersDenSetupID)
        
        XCTAssertTrue(
            afterDarkDealersDenSetup.isPresentInCalendar,
            "Events in the calendar at launch should appear so in the model"
        )
    }
    
    func testEventPresenceInCalendarChangesAtRuntimeOutsideApplication() async throws {
        let api = FakeEurofurenceAPI()
        let eventStore = FakeEventCalendar()
        let scenario = await EurofurenceModelTestBuilder().with(api: api).with(eventCalendar: eventStore).build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let afterDarkDealersDenSetupID = "3842fa46-49cb-4a56-9396-05bb7cbc5904"
        let afterDarkDealersDenSetup = try scenario.model.event(identifiedBy: afterDarkDealersDenSetupID)
        
        XCTAssertFalse(
            afterDarkDealersDenSetup.isPresentInCalendar,
            "Events should not be present in the calendar by default"
        )
        
        eventStore.add(entry: try expectedAfterDarkDealersDenCalendarEntry(in: scenario))
        
        XCTAssertTrue(
            afterDarkDealersDenSetup.isPresentInCalendar,
            "Events in the calendar at launch should appear so in the model"
        )
    }
    
    func testAddingEventToCalendar() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let afterDarkDealersDenSetupID = "3842fa46-49cb-4a56-9396-05bb7cbc5904"
        let afterDarkDealersDenSetup = try scenario.model.event(identifiedBy: afterDarkDealersDenSetupID)
        
        let expectedCalendarEntry = try expectedAfterDarkDealersDenCalendarEntry(in: scenario)
        XCTAssertFalse(
            scenario.calendar.contains(entry: expectedCalendarEntry),
            "Event should not auto-register calendar entry"
        )
        
        let changedExpectation = expectation(description: "Event should notify it has changed after adding to calendar")
        let subscription = afterDarkDealersDenSetup.objectWillChange.sink { _ in
            changedExpectation.fulfill()
        }
        
        addTeardownBlock {
            subscription.cancel()
        }
        
        afterDarkDealersDenSetup.addToCalendar()
        
        XCTAssertTrue(
            scenario.calendar.contains(entry: expectedCalendarEntry),
            "Event should register calendar entry when explicitly told to add to the calendar"
        )
        
        waitForExpectations(timeout: 0.5)
    }
    
    func testAddingEventToCalendarMultipleTimesDoesNotDuplicateIt() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let afterDarkDealersDenSetupID = "3842fa46-49cb-4a56-9396-05bb7cbc5904"
        let afterDarkDealersDenSetup = try scenario.model.event(identifiedBy: afterDarkDealersDenSetupID)
        
        let expectedCalendarEntry = try expectedAfterDarkDealersDenCalendarEntry(in: scenario)
        afterDarkDealersDenSetup.addToCalendar()
        afterDarkDealersDenSetup.addToCalendar()
        afterDarkDealersDenSetup.addToCalendar()
        
        XCTAssertEqual(
            1,
            scenario.calendar.numberOfInstances(of: expectedCalendarEntry),
            "Event should register calendar entry when explicitly told to add to the calendar"
        )
    }
    
    func testRemovingEventFromCalendar() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let afterDarkDealersDenSetupID = "3842fa46-49cb-4a56-9396-05bb7cbc5904"
        let afterDarkDealersDenSetup = try scenario.model.event(identifiedBy: afterDarkDealersDenSetupID)
        
        let expectedCalendarEntry = try expectedAfterDarkDealersDenCalendarEntry(in: scenario)
        afterDarkDealersDenSetup.addToCalendar()
        
        let changedExpectation = expectation(
            description: "Event should notify it has changed after removing from calendar"
        )
        
        let subscription = afterDarkDealersDenSetup.objectWillChange.sink { _ in
            changedExpectation.fulfill()
        }
        
        addTeardownBlock {
            subscription.cancel()
        }
        
        afterDarkDealersDenSetup.removeFromCalendar()
        
        XCTAssertFalse(
            scenario.calendar.contains(entry: expectedCalendarEntry),
            "Event should remove calendar entry when explicitly told to"
        )
        
        waitForExpectations(timeout: 0.5)
    }
    
    private func expectedAfterDarkDealersDenCalendarEntry(
        in scenario: EurofurenceModelTestBuilder.Scenario
    ) throws -> EventCalendarEntry {
        let afterDarkDealersDenSetupID = "3842fa46-49cb-4a56-9396-05bb7cbc5904"
        return EventCalendarEntry(
            title: "After Dark Dealers' Den Setup - Dealers only!",
            startDate: try XCTUnwrap(EurofurenceISO8601DateFormatter.instance.date(from: "2022-08-25T08:00:00.000Z")),
            endDate: try XCTUnwrap(EurofurenceISO8601DateFormatter.instance.date(from: "2022-08-25T10:00:00.000Z")),
            location: "AD Dealers' Den — Convention Hall Section C Level 1",
            // swiftlint:disable line_length
            shortDescription: "Over 'ere, matey! You look like you might be in the market for something… special. Our artists and dealers here be sellin' only the finest goods ye won't find in that market down below.\r\n\r\nJoin us up in the rafters of ye olde After Dark Dealers' Den for some arts and crafts of the more exotic kind!",
            url: scenario.api.url(for: .event(id: afterDarkDealersDenSetupID))
        )
    }

}
