import Combine
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class ScheduleControllerTests: EurofurenceKitTestCase {
    
    func testControllerUpdatesAfterSync() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        
        let controller = scenario.model.makeScheduleController()
        
        let changedExpectation = expectation(description: "")
        let subscription = controller.objectWillChange.sink { _ in
            changedExpectation.fulfill()
        }
        
        addTeardownBlock {
            subscription.cancel()
        }
        
        try await scenario.updateLocalStore(using: .ef26)
        
        waitForExpectations(timeout: 3)
    }

    func testMinimalConfigurationExposesAllTracksAndDays() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let controller = scenario.model.makeScheduleController()
        
        // Given there is no configuration supplied, we would expect to see:
        // - All days available, in temporal order
        // - All tracks available, in alphabetical order
        // - The selected day = first day (as we're outside con time)
        // - The selected track = nil
        // - The current events = events occurring on the first day, in temporal + name order
        
        let daysFetchRequest = Day.temporallyOrderedFetchRequest()
        let expectedDays = try scenario.viewContext.fetch(daysFetchRequest)
        let expectedSelectedDay = try XCTUnwrap(expectedDays.first)
        
        let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
        let expectedTracks = try scenario.viewContext.fetch(tracksFetchRequest)
        
        XCTAssertEqual(expectedDays, controller.availableDays)
        XCTAssertEqual(expectedTracks, controller.availableTracks)
        XCTAssertEqual(expectedSelectedDay, controller.selectedDay)
        XCTAssertNil(controller.selectedTrack)
        XCTAssertFalse(controller.eventGroups.isEmpty)
        
        var observedStartTimes = [Date]()
        for group in controller.eventGroups {
            observedStartTimes.append(group.id)
            for event in group.elements {
                XCTAssertEqual(event.day, expectedSelectedDay)
            }
        }
        
        let sortedStartTimes = observedStartTimes.sorted()
        XCTAssertEqual(
            observedStartTimes,
            sortedStartTimes,
            "Expected to showcase events in start date order"
        )
    }

}
