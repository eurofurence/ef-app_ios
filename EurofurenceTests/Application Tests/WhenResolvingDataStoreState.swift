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
    
    private(set) var capturedResolveContentsStateHandler: ((EurofurenceDataStoreContentsState) -> Void)?
    func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void) {
        capturedResolveContentsStateHandler = completionHandler
    }
    
    var stubbedKnowledgeGroups: [KnowledgeGroup2]?
    func fetchKnowledgeGroups(completionHandler: ([KnowledgeGroup2]?) -> Void) {
        completionHandler(stubbedKnowledgeGroups)
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
    
}

class StubUserPreferences: UserPreferences {
    
    var refreshStoreOnLaunch = false
    
}

class WhenResolvingDataStoreState: XCTestCase {
    
    func testEmptyStateStoreProvidesAbsentStore() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let context = ApplicationTestBuilder().with(capturingDataStore).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.empty)
        
        XCTAssertEqual(.absent, state)
    }
    
    func testNonEmptyStoreWhenUserRequestedRefreshOnLaunchReturnsStale() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.present)
        
        XCTAssertEqual(.stale, state)
    }
    
    func testEmptyDataStoreWhenUserRequestedRefreshOnLaunchReturnsAbsent() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.empty)
        
        XCTAssertEqual(.absent, state)
    }
    
    func testNonEmptyStoreWhenUserDidNotRequestRefreshOnLaunchReturnsAvailable() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = false
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        capturingDataStore.capturedResolveContentsStateHandler?(.present)
        
        XCTAssertEqual(.available, state)
    }
    
    func testResolutionHandlerNotInvokedBeforeDataStoreResolvesContentsState() {
        let capturingDataStore = CapturingEurofurenceDataStore()
        let userPreferences = StubUserPreferences()
        userPreferences.refreshStoreOnLaunch = true
        let context = ApplicationTestBuilder().with(capturingDataStore).with(userPreferences).build()
        var state: EurofurenceDataStoreState?
        context.application.resolveDataStoreState { state = $0 }
        
        XCTAssertNil(state)
    }
    
}
