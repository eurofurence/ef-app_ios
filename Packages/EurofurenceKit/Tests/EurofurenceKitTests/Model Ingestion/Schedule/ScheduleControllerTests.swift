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
    
    func testConfiguredForSpecificDayOmitsOtherDaysAsOptions() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let conDayTwoIdentifier = "7f69f120-3c8a-49bf-895a-20c2adade161"
        let conDayTwo = try scenario.model.day(identifiedBy: conDayTwoIdentifier)
        let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(day: conDayTwo)
        let controller = scenario.model.makeScheduleController(scheduleConfiguration: scheduleConfiguration)
        
        // Given the controller is configured for a specific day, we would expect to see:
        // - No days available
        // - All tracks available, in alphabetical order
        // - The selected day = the configured day
        // - The selected track = nil
        // - The current events = events occurring on the specified day, in temporal + name order
        
        let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
        let expectedTracks = try scenario.viewContext.fetch(tracksFetchRequest)
        
        XCTAssertTrue(controller.availableDays.isEmpty)
        XCTAssertEqual(expectedTracks, controller.availableTracks)
        XCTAssertEqual(conDayTwo, controller.selectedDay)
        XCTAssertNil(controller.selectedTrack)
        XCTAssertFalse(controller.eventGroups.isEmpty)
        
        var observedStartTimes = [Date]()
        for group in controller.eventGroups {
            observedStartTimes.append(group.id)
            for event in group.elements {
                XCTAssertEqual(event.day, conDayTwo)
            }
        }
        
        let sortedStartTimes = observedStartTimes.sorted()
        XCTAssertEqual(
            observedStartTimes,
            sortedStartTimes,
            "Expected to showcase events in start date order"
        )
    }
    
    func testConfiguredForSpecificTrackOmitsOtherTracksAsOptions() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let miscTrackIdentifier = "0b80cc7b-b5b2-4fab-8b74-078f2b5e366e"
        let miscTrack = try scenario.model.track(identifiedBy: miscTrackIdentifier)
        let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(track: miscTrack)
        let controller = scenario.model.makeScheduleController(scheduleConfiguration: scheduleConfiguration)
        
        // Given the controller is configured for a specific track, we would expect to see:
        // - All days available, in temporal order
        // - No tracks available
        // - The selected day = first day (as we're outside con time)
        // - The selected track = the configured track
        // - The current events = events occurring on the first day that are on the track, in temporal + name order
        
        let daysFetchRequest = Day.temporallyOrderedFetchRequest()
        let expectedDays = try scenario.viewContext.fetch(daysFetchRequest)
        let expectedSelectedDay = try XCTUnwrap(expectedDays.first)
        
        XCTAssertEqual(expectedDays, controller.availableDays)
        XCTAssertTrue(controller.availableTracks.isEmpty)
        XCTAssertEqual(expectedSelectedDay, controller.selectedDay)
        XCTAssertEqual(miscTrack, controller.selectedTrack)
        XCTAssertFalse(controller.eventGroups.isEmpty)
        
        var observedStartTimes = [Date]()
        for group in controller.eventGroups {
            observedStartTimes.append(group.id)
            for event in group.elements {
                XCTAssertEqual(event.day, expectedSelectedDay)
                XCTAssertEqual(event.track, miscTrack)
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
