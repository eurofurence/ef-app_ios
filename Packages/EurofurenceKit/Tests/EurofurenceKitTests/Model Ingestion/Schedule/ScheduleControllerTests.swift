import Combine
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class ScheduleControllerTests: EurofurenceKitTestCase {
    
    func testControllerUpdatesAfterSync() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        
        let controller = scenario.model.makeScheduleController()
        
        let changedExpectation = expectation(description: "")
        changedExpectation.assertForOverFulfill = false
        let subscription = controller.objectWillChange.sink { _ in
            changedExpectation.fulfill()
        }
        
        addTeardownBlock {
            subscription.cancel()
        }
        
        try await scenario.updateLocalStore(using: .ef26)
        
        waitForExpectations(timeout: 3)
    }

    func testAllScheduleEntitiesAreAvailableInTemporalOrAlphanumericOrder() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let controller = scenario.model.makeScheduleController()
        
        // Given there is no configuration supplied, we would expect to see:
        // - All days available, in temporal order
        // - All tracks available, in alphabetical order
        // - All rooms available, in alphabetical order
        // - The selected day = first day (as we're outside con time)
        // - The selected track = nil
        // - The current events = events occurring on the first day, in temporal + name order
        
        let daysFetchRequest = Day.temporallyOrderedFetchRequest()
        let expectedDays = try scenario.viewContext.fetch(daysFetchRequest)
        let expectedSelectedDay = try XCTUnwrap(expectedDays.first)
        
        let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
        let expectedTracks = try scenario.viewContext.fetch(tracksFetchRequest)
        
        let roomsFetchRequest = Room.alphabeticallySortedFetchRequest()
        let expectedRooms = try scenario.viewContext.fetch(roomsFetchRequest)
        
        XCTAssertEqual(expectedDays, controller.availableDays)
        XCTAssertEqual(expectedTracks, controller.availableTracks)
        XCTAssertEqual(expectedRooms, controller.availableRooms)
        XCTAssertEqual(expectedSelectedDay, controller.selectedDay)
        XCTAssertNil(controller.selectedTrack)
        XCTAssertFalse(controller.eventGroups.isEmpty)
        XCTAssertEqual(expectedSelectedDay.name, controller.localizedFilterDescription)
        XCTAssertNil(controller.selectedRoom)
        
        var observedStartTimes = [Date]()
        var expectedEventCount = 0
        for group in controller.eventGroups {
            if case .startDate(let date) = group.id {
                observedStartTimes.append(date)
            }
            
            for event in group.elements {
                expectedEventCount += 1
                XCTAssertEqual(event.day, expectedSelectedDay)
            }
        }
        
        XCTAssertEqual(
            expectedEventCount,
            controller.matchingEventsCount,
            "Expected to find \(expectedEventCount) matching events"
        )
        
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
        // - All rooms available, in alphabetical order
        // - The selected day = the configured day
        // - The selected track = nil
        // - The current events = events occurring on the specified day, in temporal + name order
        
        let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
        let expectedTracks = try scenario.viewContext.fetch(tracksFetchRequest)
        
        let roomsFetchRequest = Room.alphabeticallySortedFetchRequest()
        let expectedRooms = try scenario.viewContext.fetch(roomsFetchRequest)
        
        XCTAssertTrue(controller.availableDays.isEmpty)
        XCTAssertEqual(expectedTracks, controller.availableTracks)
        XCTAssertEqual(expectedRooms, controller.availableRooms)
        XCTAssertEqual(conDayTwo, controller.selectedDay)
        XCTAssertNil(controller.selectedTrack)
        XCTAssertFalse(controller.eventGroups.isEmpty)
        XCTAssertNil(controller.localizedFilterDescription)
        XCTAssertNil(controller.selectedRoom)
        
        var observedStartTimes = [Date]()
        var expectedEventCount = 0
        for group in controller.eventGroups {
            if case .startDate(let date) = group.id {
                observedStartTimes.append(date)
            }
            
            for event in group.elements {
                expectedEventCount += 1
                XCTAssertEqual(event.day, conDayTwo)
            }
        }
        
        XCTAssertEqual(
            expectedEventCount,
            controller.matchingEventsCount,
            "Expected to find \(expectedEventCount) matching events"
        )
        
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
        // - All rooms available, in alphabetical order
        // - The selected day = first day (as we're outside con time)
        // - The selected track = the configured track
        // - The current events = events occurring on the first day that are on the track, in temporal + name order
        
        let daysFetchRequest = Day.temporallyOrderedFetchRequest()
        let expectedDays = try scenario.viewContext.fetch(daysFetchRequest)
        let expectedSelectedDay = try XCTUnwrap(expectedDays.first)
        
        let roomsFetchRequest = Room.alphabeticallySortedFetchRequest()
        let expectedRooms = try scenario.viewContext.fetch(roomsFetchRequest)
        
        XCTAssertEqual(expectedDays, controller.availableDays)
        XCTAssertTrue(controller.availableTracks.isEmpty)
        XCTAssertEqual(expectedRooms, controller.availableRooms)
        XCTAssertEqual(expectedSelectedDay, controller.selectedDay)
        XCTAssertEqual(miscTrack, controller.selectedTrack)
        XCTAssertFalse(controller.eventGroups.isEmpty)
        XCTAssertEqual(expectedSelectedDay.name, controller.localizedFilterDescription)
        XCTAssertNil(controller.selectedRoom)
        
        var observedDays = [EurofurenceKit.Day]()
        var expectedEventCount = 0
        for group in controller.eventGroups {
            if case .day(let day) = group.id {
                observedDays.append(day)
            }
            
            for event in group.elements {
                expectedEventCount += 1
                XCTAssertEqual(event.day, expectedSelectedDay)
                XCTAssertEqual(event.track, miscTrack)
            }
        }
        
        XCTAssertGreaterThan(observedDays.count, 0, "Expected to see events grouped by day")
        
        XCTAssertEqual(
            expectedEventCount,
            controller.matchingEventsCount,
            "Expected to find \(expectedEventCount) matching events"
        )
        
        let sortedDays = observedDays.sorted(by: { $0.date < $1.date })
        
        XCTAssertEqual(
            observedDays,
            sortedDays,
            "Expected to showcase events ordered by their date occurrance"
        )
    }
    
    func testMinimalConfigurationDuringTheConventionPreparesScheduleForCurrentDayTemporally() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let conDayTwoIdentifier = "7f69f120-3c8a-49bf-895a-20c2adade161"
        let conDayTwo = try scenario.model.day(identifiedBy: conDayTwoIdentifier)
        scenario.simulateTimeChange(to: conDayTwo.date)
        
        let controller = scenario.model.makeScheduleController()
        
        // Given there is no configuration supplied, we would expect to see:
        // - All days available, in temporal order
        // - All tracks available, in alphabetical order
        // - All rooms available, in alphabetical order
        // - The selected day = the second day, as it's day two according to the clock
        // - The selected track = nil
        // - The current events = events occurring on the first day, in temporal + name order
        
        let daysFetchRequest = Day.temporallyOrderedFetchRequest()
        let expectedDays = try scenario.viewContext.fetch(daysFetchRequest)
        
        let tracksFetchRequest = Track.alphabeticallySortedFetchRequest()
        let expectedTracks = try scenario.viewContext.fetch(tracksFetchRequest)
        
        let roomsFetchRequest = Room.alphabeticallySortedFetchRequest()
        let expectedRooms = try scenario.viewContext.fetch(roomsFetchRequest)
        
        XCTAssertEqual(expectedDays, controller.availableDays)
        XCTAssertEqual(expectedTracks, controller.availableTracks)
        XCTAssertEqual(expectedRooms, controller.availableRooms)
        XCTAssertEqual(conDayTwo, controller.selectedDay)
        XCTAssertNil(controller.selectedTrack)
        XCTAssertFalse(controller.eventGroups.isEmpty)
        XCTAssertNil(controller.selectedRoom)
        
        var observedStartTimes = [Date]()
        var expectedEventCount = 0
        for group in controller.eventGroups {
            if case .startDate(let date) = group.id {
                observedStartTimes.append(date)
            }
            
            for event in group.elements {
                expectedEventCount += 1
                XCTAssertEqual(event.day, conDayTwo)
            }
        }
        
        XCTAssertEqual(
            expectedEventCount,
            controller.matchingEventsCount,
            "Expected to find \(expectedEventCount) matching events"
        )
        
        let sortedStartTimes = observedStartTimes.sorted()
        XCTAssertEqual(
            observedStartTimes,
            sortedStartTimes,
            "Expected to showcase events in start date order"
        )
    }
    
    func testConfiguredForTrackThenChangingCurrentDayUpdatesEventsToMatchNewCriteria() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let miscTrackIdentifier = "0b80cc7b-b5b2-4fab-8b74-078f2b5e366e"
        let miscTrack = try scenario.model.track(identifiedBy: miscTrackIdentifier)
        let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(track: miscTrack)
        let controller = scenario.model.makeScheduleController(scheduleConfiguration: scheduleConfiguration)
        
        // Given the controller will begin on the first day as we are outside of con them
        // When a day within the boundaries of the convention is selected
        // Then days on the specified track occurring on the day are displayed
        
        let conDayOneIdentifier = "572ca56c-c473-4ca7-b4ec-c6498c077dda"
        let conDayOne = try scenario.model.day(identifiedBy: conDayOneIdentifier)
        controller.selectedDay = conDayOne
        
        let registrationOffFirstDayIdentifier = "3017968c-4804-4474-ba01-867a140916c9"
        
        for group in controller.eventGroups {
            for event in group.elements {
                if event.identifier == registrationOffFirstDayIdentifier {
                    // Found the expected event
                    return
                }
            }
        }
        
        XCTFail("Expected to update the available events following a change to the selected day")
        XCTAssertEqual("Filtered to \(conDayOne.name)", controller.localizedFilterDescription)
    }
    
    func testConfiguredForDayThenChangingTrackUpdatesDisplayedEvents() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let conDayTwoIdentifier = "7f69f120-3c8a-49bf-895a-20c2adade161"
        let conDayTwo = try scenario.model.day(identifiedBy: conDayTwoIdentifier)
        let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(day: conDayTwo)
        let controller = scenario.model.makeScheduleController(scheduleConfiguration: scheduleConfiguration)
        
        // Given the controller is displaying events on day two with no track selected
        // When a track is selected
        // Then only events within the track occurring on day two are displayed
        
        let fursuitTrackIdentifier = "f0ada704-c876-42a1-8da4-59cbcf7ab413"
        let fursuitTrack = try scenario.model.track(identifiedBy: fursuitTrackIdentifier)
        controller.selectedTrack = fursuitTrack
        
        let expectedEventIdentifiers: Set<String> = [
            "f1435c7b-49eb-4fd7-b28b-fc088def8da4",
            "dd278ad2-65df-47c3-8fd2-8171456a6a53",
            "37e2ffaf-a281-47f8-bbac-a483ea2c5bc3",
            "2fd1d2be-4993-443f-b16f-a225674c2dfa",
            "c292f7fc-dd75-4f9d-892e-5b9b9cf64c75",
            "740d2ffa-5c5d-4ca4-bf26-3034138740eb",
            "0760ae30-25e3-4a94-9a89-fb460c8df3b3",
            "4d5fb685-2945-45f7-9c2d-1975b7ec9440",
        ]
        
        var observedEventIdentifiers = Set<String>()
        for group in controller.eventGroups {
            for event in group.elements {
                observedEventIdentifiers.insert(event.identifier)
            }
        }
        
        XCTAssertEqual(
            expectedEventIdentifiers,
            observedEventIdentifiers,
            "Expected to only view fursuit events on day 2 after changing the schedule's track"
        )
        
        XCTAssertEqual(fursuitTrack.name, controller.localizedFilterDescription)
    }
    
    func testFilteringDescriptionForTrackAndEventFiltering() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let controller = scenario.model.makeScheduleController()
        
        let conDayTwoIdentifier = "7f69f120-3c8a-49bf-895a-20c2adade161"
        let conDayTwo = try scenario.model.day(identifiedBy: conDayTwoIdentifier)
        controller.selectedDay = conDayTwo
        
        let miscTrackIdentifier = "0b80cc7b-b5b2-4fab-8b74-078f2b5e366e"
        let miscTrack = try scenario.model.track(identifiedBy: miscTrackIdentifier)
        controller.selectedTrack = miscTrack
        
        XCTAssertEqual(
            "\(miscTrack.name) on \(conDayTwo.name)",
            controller.localizedFilterDescription
        )
    }
    
    func testFilteringDescriptionForTrackDayAndRoomFiltering() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let controller = scenario.model.makeScheduleController()
        
        let afterDarkDealersDenRoomIdentifier = "4d64ba76-8a9b-4dd1-9b78-c159e38c5292"
        let afterDarkDealersDen = try scenario.model.room(identifiedBy: afterDarkDealersDenRoomIdentifier)
        controller.selectedRoom = afterDarkDealersDen
        
        let conDayTwoIdentifier = "7f69f120-3c8a-49bf-895a-20c2adade161"
        let conDayTwo = try scenario.model.day(identifiedBy: conDayTwoIdentifier)
        controller.selectedDay = conDayTwo
        
        let miscTrackIdentifier = "0b80cc7b-b5b2-4fab-8b74-078f2b5e366e"
        let miscTrack = try scenario.model.track(identifiedBy: miscTrackIdentifier)
        controller.selectedTrack = miscTrack
        
        XCTAssertEqual(
            "\(miscTrack.name) in \(afterDarkDealersDen.shortName) on \(conDayTwo.name)",
            controller.localizedFilterDescription
        )
    }
    
    func testConfiguredForSpecificRoomOmitsOtherRoomsAsOptions() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let artShowRoomID = "2d5d9a98-aaca-4434-959d-99d20e675d3a"
        let artShowRoom = try scenario.model.room(identifiedBy: artShowRoomID)
        let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(room: artShowRoom)
        let schedule = scenario.model.makeScheduleController(scheduleConfiguration: scheduleConfiguration)
        
        XCTAssertEqual(artShowRoom, schedule.selectedRoom)
        XCTAssertTrue(schedule.availableRooms.isEmpty)
    }
    
    func testFilteringToSpecificRoomOnlyShowsEventsInThatRoomOrderedByDay() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let registrationRoomID = "c137717f-f297-4c3d-bc0e-542cbb032135"
        let registrationRoom = try scenario.model.room(identifiedBy: registrationRoomID)
        let scheduleConfiguration = EurofurenceModel.ScheduleConfiguration(room: registrationRoom)
        let schedule = scenario.model.makeScheduleController(scheduleConfiguration: scheduleConfiguration)
        
        var expectedEventCount = 0
        var observedDays: [EurofurenceKit.Day] = []
        for group in schedule.eventGroups {
            if case .day(let day) = group.id {
                observedDays.append(day)
            }
            
            for event in group.elements {
                expectedEventCount += 1
                XCTAssertEqual(event.room, registrationRoom)
            }
        }
        
        XCTAssertGreaterThan(observedDays.count, 0, "Expected to see events grouped by day")
        
        XCTAssertEqual(
            expectedEventCount,
            schedule.matchingEventsCount,
            "Expected to find \(expectedEventCount) matching events"
        )
        
        let sortedDays = observedDays.sorted(by: { $0.date < $1.date })
        
        XCTAssertEqual(
            observedDays,
            sortedDays,
            "Expected to showcase events ordered by their date occurrance"
        )
    }

}
