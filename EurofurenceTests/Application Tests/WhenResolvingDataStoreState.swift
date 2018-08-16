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
        return transaction.persistedAnnouncements
    }
    
    func getLastRefreshDate() -> Date? {
        return transaction.persistedLastRefreshDate
    }
    
    func getSavedKnowledgeGroups() -> [APIKnowledgeGroup]? {
        return transaction.persistedKnowledgeGroups
    }
    
    func getSavedKnowledgeEntries() -> [APIKnowledgeEntry]? {
        return transaction.persistedKnowledgeEntries
    }
    
    func getSavedRooms() -> [APIRoom]? {
        return transaction.persistedRooms
    }
    
    func getSavedTracks() -> [APITrack]? {
        return transaction.persistedTracks
    }
    
    func getSavedConferenceDays() -> [APIConferenceDay]? {
        return transaction.persistedConferenceDays
    }
    
    func getSavedEvents() -> [APIEvent]? {
        return transaction.persistedEvents
    }
    
    func getSavedFavouriteEventIdentifiers() -> [Event2.Identifier]? {
        return transaction.persistedFavouriteEvents
    }
    
    func getSavedDealers() -> [APIDealer]? {
        return transaction.persistedDealers
    }
    
    func getSavedMaps() -> [APIMap]? {
        return transaction.persistedMaps
    }
    
    func getSavedReadAnnouncementIdentifiers() -> [Announcement2.Identifier]? {
        return transaction.persistedReadAnnouncementIdentifiers
    }
    
    func getSavedImages() -> [APIImage]? {
        return transaction.persistedImages
    }
    
    private(set) var capturedKnowledgeGroupsToSave: [KnowledgeGroup2]?
    var transactionInvokedBlock: (() -> Void)?
    let transaction = CapturingEurofurenceDataStoreTransaction()
    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void) {
        block(transaction)
        transactionInvokedBlock?()
    }
    
}

extension CapturingEurofurenceDataStore {
    
    func save(_ response: APISyncResponse, lastRefreshDate: Date = Date(), block: ((EurofurenceDataStoreTransaction) -> Void)? = nil) {
        performTransaction { (transaction) in
            transaction.saveLastRefreshDate(lastRefreshDate)
            transaction.saveKnowledgeGroups(response.knowledgeGroups.changed)
            transaction.saveKnowledgeEntries(response.knowledgeEntries.changed)
            transaction.saveAnnouncements(response.announcements.changed)
            transaction.saveEvents(response.events.changed)
            transaction.saveRooms(response.rooms.changed)
            transaction.saveTracks(response.tracks.changed)
            transaction.saveConferenceDays(response.conferenceDays.changed)
            transaction.saveDealers(response.dealers.changed)
            transaction.saveMaps(response.maps.changed)
            
            block?(transaction)
        }
    }
    
    func didSave(_ knowledgeGroups: [APIKnowledgeGroup]) -> Bool {
        return transaction.persistedKnowledgeGroups.contains(elementsFrom: knowledgeGroups)
    }
    
    func didSave(_ knowledgeEntries: [APIKnowledgeEntry]) -> Bool {
        return transaction.persistedKnowledgeEntries.contains(elementsFrom: knowledgeEntries)
    }
    
    func didSave(_ announcements: [APIAnnouncement]) -> Bool {
        return transaction.persistedAnnouncements.contains(elementsFrom: announcements)
    }
    
    func didSave(_ events: [APIEvent]) -> Bool {
        return transaction.persistedEvents.contains(elementsFrom: events)
    }
    
    func didSave(_ events: [APIRoom]) -> Bool {
        return transaction.persistedRooms.contains(elementsFrom: events)
    }
    
    func didSave(_ tracks: [APITrack]) -> Bool {
        return transaction.persistedTracks.contains(elementsFrom: tracks)
    }
    
    func didSaveLastRefreshTime(_ lastRefreshTime: Date) -> Bool {
        return lastRefreshTime == transaction.persistedLastRefreshDate
    }
    
    func didFavouriteEvent(_ identifier: Event2.Identifier) -> Bool {
        return transaction.persistedFavouriteEvents.contains(identifier)
    }
    
    func didSave(_ dealers: [APIDealer]) -> Bool {
        return transaction.persistedDealers.contains(elementsFrom: dealers)
    }
    
    func didDeleteFavouriteEvent(_ identifier: Event2.Identifier) -> Bool {
        return transaction.deletedFavouriteEvents.contains(identifier)
    }
    
    func didSave(_ conferenceDays: [APIConferenceDay]) -> Bool {
        return transaction.persistedConferenceDays.contains(elementsFrom: conferenceDays)
    }
    
    func didSave(_ maps: [APIMap]) -> Bool {
        return transaction.persistedMaps.contains(elementsFrom: maps)
    }
    
    func didSaveReadAnnouncement(_ identifier: Announcement2.Identifier) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(identifier)
    }
    
    func didSaveReadAnnouncements(_ identifiers: [Announcement2.Identifier]) -> Bool {
        return transaction.persistedReadAnnouncementIdentifiers.contains(elementsFrom: identifiers)
    }
    
    func didSave(_ images: [APIImage]) -> Bool {
        return transaction.persistedImages.contains(elementsFrom: images)
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
        self.persistedKnowledgeGroups.append(contentsOf: knowledgeGroups)
    }
    
    private(set) var deletedKnowledgeGroups: [String] = []
    func deleteKnowledgeGroup(identifier: String) {
        deletedKnowledgeGroups.append(identifier)
        
        if let idx = persistedKnowledgeGroups.index(where: { $0.identifier == identifier }) {
            persistedKnowledgeGroups.remove(at: idx)
        }
    }
    
    private(set) var persistedKnowledgeEntries: [APIKnowledgeEntry] = []
    func saveKnowledgeEntries(_ knowledgeEntries: [APIKnowledgeEntry]) {
        persistedKnowledgeEntries.append(contentsOf: knowledgeEntries)
    }
    
    private(set) var deletedKnowledgeEntries: [String] = []
    func deleteKnowledgeEntry(identifier: String) {
        deletedKnowledgeEntries.append(identifier)
    }
    
    private(set) var persistedAnnouncements: [APIAnnouncement] = []
    func saveAnnouncements(_ announcements: [APIAnnouncement]) {
        persistedAnnouncements.append(contentsOf: announcements)
    }
    
    private(set) var persistedEvents: [APIEvent] = []
    func saveEvents(_ events: [APIEvent]) {
        for event in events {
            if let idx = persistedEvents.index(where: { $0.identifier == event.identifier }) {
                persistedEvents.remove(at: idx)
            }
            
            persistedEvents.append(event)
        }
    }
    
    func deleteEvent(identifier: String) {
        if let idx = persistedEvents.index(where: { $0.identifier == identifier }) {
            persistedEvents.remove(at: idx)
        }
    }
    
    private(set) var persistedRooms: [APIRoom] = []
    func saveRooms(_ rooms: [APIRoom]) {
        persistedRooms.append(contentsOf: rooms)
    }
    
    private(set) var deletedConferenceDays: [String] = []
    func deleteConferenceDay(identifier: String) {
        deletedConferenceDays.append(identifier)
    }
    
    private(set) var deletedRooms: [String] = []
    func deleteRoom(identifier: String) {
        deletedRooms.append(identifier)
    }
    
    private(set) var persistedTracks: [APITrack] = []
    func saveTracks(_ tracks: [APITrack]) {
        persistedTracks.append(contentsOf: tracks)
    }
    
    private(set) var deletedTracks: [String] = []
    func deleteTrack(identifier: String) {
        deletedTracks.append(identifier)
    }
    
    private(set) var persistedConferenceDays: [APIConferenceDay] = []
    func saveConferenceDays(_ conferenceDays: [APIConferenceDay]) {
        persistedConferenceDays.append(contentsOf: conferenceDays)
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
    
    func deleteAnnouncement(identifier: String) {
        if let idx = persistedAnnouncements.index(where: { $0.identifier == identifier }) {
            persistedAnnouncements.remove(at: idx)
        }
    }
    
    private(set) var persistedDealers: [APIDealer] = []
    func saveDealers(_ dealers: [APIDealer]) {
        persistedDealers.append(contentsOf: dealers)
    }
    
    func deleteDealer(identifier: String) {
        if let idx = persistedDealers.index(where: { $0.identifier == identifier }) {
            persistedDealers.remove(at: idx)
        }
    }
    
    private(set) var persistedMaps: [APIMap] = []
    func saveMaps(_ maps: [APIMap]) {
        persistedMaps.append(contentsOf: maps)
    }
    
    func deleteMap(identifier: String) {
        if let idx = persistedMaps.index(where: { $0.identifier == identifier }) {
            persistedMaps.remove(at: idx)
        }
    }
    
    private(set) var persistedReadAnnouncementIdentifiers: [Announcement2.Identifier] = []
    func saveReadAnnouncements(_ announcements: [Announcement2.Identifier]) {
        persistedReadAnnouncementIdentifiers = announcements
    }
    
    private(set) var persistedImages = [APIImage]()
    func saveImages(_ images: [APIImage]) {
        persistedImages.append(contentsOf: images)
    }
    
    private(set) var deletedImages = [String]()
    func deleteImage(identifier: String) {
        deletedImages.append(identifier)
        
        if let idx = persistedImages.index(where: { $0.identifier == identifier }) {
            persistedImages.remove(at: idx)
        }
    }
    
}

class StubUserPreferences: UserPreferences {
    
    var refreshStoreOnLaunch = false
    var upcomingEventReminderInterval: TimeInterval = 0
    
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
