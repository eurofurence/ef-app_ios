//
//  WhenResolvingDataStoreState.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingEurofurenceDataStore: EurofurenceDataStore {
    func getSavedAnnouncements() -> [APIAnnouncement]? {
        return transaction?.persistedAnnouncements
    }
    
    func getLastRefreshDate() -> Date? {
        return transaction?.persistedLastRefreshDate
    }
    
    func getSavedKnowledgeGroups() -> [APIKnowledgeGroup]? {
        return transaction?.persistedKnowledgeGroups
    }
    
    func getSavedKnowledgeEntries() -> [APIKnowledgeEntry]? {
        return transaction?.persistedKnowledgeEntries
    }
    
    func getSavedRooms() -> [APIRoom]? {
        return transaction?.persistedRooms
    }
    
    func getSavedTracks() -> [APITrack]? {
        return transaction?.persistedTracks
    }
    
    func getSavedConferenceDays() -> [APIConferenceDay]? {
        return transaction?.persistedConferenceDays
    }
    
    func getSavedEvents() -> [APIEvent]? {
        return transaction?.persistedEvents
    }
    
    func getSavedFavouriteEventIdentifiers() -> [Event2.Identifier]? {
        return transaction?.persistedFavouriteEvents
    }
    
    func getSavedDealers() -> [APIDealer]? {
        return transaction?.persistedDealers
    }
    
    private(set) var capturedKnowledgeGroupsToSave: [KnowledgeGroup2]?
    private(set) var transaction: CapturingEurofurenceDataStoreTransaction?
    var transactionInvokedBlock: (() -> Void)?
    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void) {
        let transaction = CapturingEurofurenceDataStoreTransaction()
        block(transaction)
        self.transaction = transaction
        transactionInvokedBlock?()
    }
    
}

extension CapturingEurofurenceDataStore {
    
    func save(_ response: APISyncResponse) {
        performTransaction { (transaction) in
            transaction.saveKnowledgeGroups(response.knowledgeGroups.changed)
            transaction.saveKnowledgeEntries(response.knowledgeEntries.changed)
            transaction.saveAnnouncements(response.announcements.changed)
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
            transaction.saveConferenceDays(response.conferenceDays.changed)
            transaction.saveDealers(response.dealers.changed)
        }
    }
    
    func didSave(_ knowledgeGroups: [APIKnowledgeGroup]) -> Bool {
        guard let persistedKnowledgeGroups = transaction?.persistedKnowledgeGroups else { return false }
        return persistedKnowledgeGroups.contains(elementsFrom: knowledgeGroups)
    }
    
    func didSave(_ knowledgeEntries: [APIKnowledgeEntry]) -> Bool {
        guard let persistedKnowledgeEntries = transaction?.persistedKnowledgeEntries else { return false }
        return persistedKnowledgeEntries.contains(elementsFrom: knowledgeEntries)
    }
    
    func didSave(_ announcements: [APIAnnouncement]) -> Bool {
        guard let persistedAnnouncements = transaction?.persistedAnnouncements else { return false }
        return persistedAnnouncements.contains(elementsFrom: announcements)
    }
    
    func didSave(_ events: [APIEvent]) -> Bool {
        guard let persistedEvents = transaction?.persistedEvents else { return false }
        return persistedEvents.contains(elementsFrom: events)
    }
    
    func didSave(_ events: [APIRoom]) -> Bool {
        guard let persistedRooms = transaction?.persistedRooms else { return false }
        return persistedRooms.contains(elementsFrom: events)
    }
    
    func didSave(_ tracks: [APITrack]) -> Bool {
        guard let persistedTracks = transaction?.persistedTracks else { return false }
        return persistedTracks.contains(elementsFrom: tracks)
    }
    
    func didSaveLastRefreshTime(_ lastRefreshTime: Date) -> Bool {
        return lastRefreshTime == transaction?.persistedLastRefreshDate
    }
    
    func didFavouriteEvent(_ identifier: Event2.Identifier) -> Bool {
        return transaction?.persistedFavouriteEvents.contains(identifier) ?? false
    }
    
    func didSave(_ dealers: [APIDealer]) -> Bool {
        guard let persistedDealers = transaction?.persistedDealers else { return false }
        return persistedDealers.contains(elementsFrom: dealers)
    }
    
    func didDeleteFavouriteEvent(_ identifier: Event2.Identifier) -> Bool {
        return transaction?.deletedFavouriteEvents.contains(identifier) ?? false
    }
    
    func didSave(_ conferenceDays: [APIConferenceDay]) -> Bool {
        guard let persistedConferenceDays = transaction?.persistedConferenceDays else { return false }
        return persistedConferenceDays.contains(elementsFrom: conferenceDays)
    }
    
}

extension Array where Element: Equatable {
    
    func contains(elementsFrom other: Array<Element>) -> Bool {
        for item in other {
            if contains(item) == false {
                return false
            }
        }
        
        return true
    }
    
}

class CapturingEurofurenceDataStoreTransaction: EurofurenceDataStoreTransaction {
    
    private(set) var persistedKnowledgeGroups: [APIKnowledgeGroup] = []
    func saveKnowledgeGroups(_ knowledgeGroups: [APIKnowledgeGroup]) {
        self.persistedKnowledgeGroups = knowledgeGroups
    }
    
    private(set) var persistedKnowledgeEntries: [APIKnowledgeEntry] = []
    func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry]) {
        persistedKnowledgeEntries = knowledgeEntries
    }
    
    private(set) var persistedAnnouncements: [APIAnnouncement] = []
    func saveAnnouncements(_ announcements: [APIAnnouncement]) {
        persistedAnnouncements = announcements
    }
    
    private(set) var persistedEvents: [APIEvent] = []
    func saveEvents(_ events: [APIEvent]) {
        persistedEvents = events
    }
    
    private(set) var persistedRooms: [APIRoom] = []
    func saveRooms(_ rooms: [APIRoom]) {
        persistedRooms = rooms
    }
    
    private(set) var persistedTracks: [APITrack] = []
    func saveTracks(_ tracks: [APITrack]) {
        persistedTracks = tracks
    }
    
    private(set) var persistedConferenceDays: [APIConferenceDay] = []
    func saveConferenceDays(_ conferenceDays: [APIConferenceDay]) {
        persistedConferenceDays = conferenceDays
    }
    
    private(set) var persistedLastRefreshDate: Date?
    func saveLastRefreshDate(_ lastRefreshDate: Date) {
        persistedLastRefreshDate = lastRefreshDate
    }
    
    private(set) var persistedFavouriteEvents = [Event2.Identifier]()
    func saveFavouriteEventIdentifier(_ identifier: Event2.Identifier) {
        persistedFavouriteEvents.append(identifier)
    }
    
    private(set) var deletedFavouriteEvents = [Event2.Identifier]()
    func deleteFavouriteEventIdentifier(_ identifier: Event2.Identifier) {
        deletedFavouriteEvents.append(identifier)
    }
    
    private(set) var persistedDealers: [APIDealer] = []
    func saveDealers(_ dealers: [APIDealer]) {
        persistedDealers = dealers
    }
    
}

class StubUserPreferences: UserPreferences {
    
    var refreshStoreOnLaunch = false
    
}

class WhenResolvingDataStoreState: XCTestCase {
    
    func testStoreWithNoLastRefreshTimeIsAbsent() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let context = ApplicationTestBuilder().with(capturingDataStore).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        
        XCTAssertEqual(.absent, state)
    }
    
    func testStoreWithLastRefreshDateWithRefreshOnLaunchEnabledIsStale() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        capturingDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }
        
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        
        XCTAssertEqual(.stale, state)
    }
    
    func testStoreWithLastRefreshDateWithRefreshOnLaunchDisabledIsAvailable() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        capturingDataStore.performTransaction { (transaction) in
            transaction.saveLastRefreshDate(.random)
        }
        
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = false
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        
        XCTAssertEqual(.available, state)
    }
    
}
