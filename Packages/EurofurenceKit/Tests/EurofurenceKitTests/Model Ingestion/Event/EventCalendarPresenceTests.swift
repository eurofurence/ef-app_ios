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
        eventStore.simulateContainsEvent(try expectedAfterDarkDealersDenCalendarEntry(in: scenario))
        
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
        
        eventStore.simulateContainsEvent(try expectedAfterDarkDealersDenCalendarEntry(in: scenario))
        
        XCTAssertTrue(
            afterDarkDealersDenSetup.isPresentInCalendar,
            "Events in the calendar at launch should appear so in the model"
        )
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
