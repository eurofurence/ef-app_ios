import EurofurenceModel
import XCTest

class WhenSyncSucceeds_ForEmptyDataStore_ApplicationShould: XCTestCase {

    func testSaveAllCharacteristicsIntoTheStore() {
        let context = EurofurenceSessionTestBuilder().build()
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        let store = context.dataStore

        context.performSuccessfulSync(response: characteristics)

        XCTAssertTrue(characteristics.knowledgeGroups.changed.contains(elementsFrom: store.fetchKnowledgeGroups()))
        XCTAssertTrue(characteristics.knowledgeEntries.changed.contains(elementsFrom: store.fetchKnowledgeEntries()))
        XCTAssertTrue(characteristics.announcements.changed.contains(elementsFrom: store.fetchAnnouncements()))
        XCTAssertTrue(characteristics.events.changed.contains(elementsFrom: store.fetchEvents()))
        XCTAssertTrue(characteristics.rooms.changed.contains(elementsFrom: store.fetchRooms()))
        XCTAssertTrue(characteristics.tracks.changed.contains(elementsFrom: store.fetchTracks()))
        XCTAssertTrue(characteristics.dealers.changed.contains(elementsFrom: store.fetchDealers()))
        XCTAssertTrue(characteristics.maps.changed.contains(elementsFrom: store.fetchMaps()))
        XCTAssertTrue(characteristics.conferenceDays.changed.contains(elementsFrom: store.fetchConferenceDays()))
        XCTAssertTrue(characteristics.images.changed.contains(elementsFrom: store.fetchImages()))
    }
    
    func testNotifyContentObserversBeforeSignallingInitialized_BUG() throws {
        let context = EurofurenceSessionTestBuilder().build()
        let observer = EmitsAllContentBeforeSessionStateChangeObserver()
        context.announcementsService.add(observer)
        context.repositories.events.add(observer)
        context.knowledgeService.add(observer)
        context.sessionStateService.add(observer: observer)
        
        let schedule = context.repositories.events.loadSchedule(tag: "Test")
        schedule.setDelegate(observer)
        
        let characteristics = ModelCharacteristics.randomWithoutDeletions
        
        context.performSuccessfulSync(response: characteristics)
        
        let lastEvent = try XCTUnwrap(observer.events.last)
        
        XCTAssertEqual(.sessionState, lastEvent)
    }
    
}

private class EmitsAllContentBeforeSessionStateChangeObserver {
    
    enum Update {
        case announcements
        case readAnnouncements
        
        case events
        case runningEvents
        case upcomingEvents
        case favouriteEvents
        
        case scheduleEvents
        case scheduleDays
        case scheduleDay
        
        case knowledge
        
        case sessionState
    }
    
    private(set) var events = [Update]()
    
}

extension EmitsAllContentBeforeSessionStateChangeObserver: SessionStateObserver {
    
    func sessionStateDidChange(_ newState: EurofurenceSessionState) {
        events.append(.sessionState)
    }
    
}

extension EmitsAllContentBeforeSessionStateChangeObserver: AnnouncementsRepositoryObserver {
    
    func announcementsServiceDidChangeAnnouncements(_ announcements: [Announcement]) {
        events.append(.announcements)
    }
    
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        events.append(.readAnnouncements)
    }
    
}

extension EmitsAllContentBeforeSessionStateChangeObserver: ScheduleRepositoryObserver {
    
    func eventsDidChange(to events: [Event]) {
        self.events.append(.events)
    }
    
    func runningEventsDidChange(to events: [Event]) {
        self.events.append(.runningEvents)
    }
    
    func upcomingEventsDidChange(to events: [Event]) {
        self.events.append(.upcomingEvents)
    }
    
    func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        events.append(.favouriteEvents)
    }
    
}

extension EmitsAllContentBeforeSessionStateChangeObserver: ScheduleDelegate {
    
    func scheduleEventsDidChange(to events: [Event]) {
        self.events.append(.scheduleEvents)
    }
    
    func eventDaysDidChange(to days: [Day]) {
        events.append(.scheduleDays)
    }
    
    func currentEventDayDidChange(to day: Day?) {
        events.append(.scheduleDay)
    }
    
    func scheduleSpecificationChanged(to newSpecification: AnySpecification<Event>) {
        
    }
    
}

extension EmitsAllContentBeforeSessionStateChangeObserver: KnowledgeServiceObserver {
    
    func knowledgeGroupsDidChange(to groups: [KnowledgeGroup]) {
        events.append(.knowledge)
    }
    
}
