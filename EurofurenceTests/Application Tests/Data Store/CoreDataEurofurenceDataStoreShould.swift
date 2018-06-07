//
//  CoreDataEurofurenceDataStoreShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct CoreDataEurofurenceDataStore: EurofurenceDataStore {
    
    func resolveContentsState(completionHandler: @escaping (EurofurenceDataStoreContentsState) -> Void) {
        completionHandler(.empty)
    }
    
    func performTransaction(_ block: @escaping (EurofurenceDataStoreTransaction) -> Void) {
        
    }
    
    func fetchKnowledgeGroups(completionHandler: ([APIKnowledgeGroup]?) -> Void) {
        
    }
    
    func fetchKnowledgeEntries(completionHandler: ([APIKnowledgeEntry]?) -> Void) {
        
    }
    
    func getSavedRooms() -> [APIRoom]? {
        return nil
    }
    
    func getSavedTracks() -> [APITrack]? {
        return nil
    }
    
    func getSavedEvents() -> [APIEvent]? {
        return nil
    }
    
}

class CoreDataEurofurenceDataStoreShould: XCTestCase {
    
    func testBeEmptyWhenStoreDoesNotExist() {
        let dataStore = CoreDataEurofurenceDataStore()
        var state: EurofurenceDataStoreContentsState?
        dataStore.resolveContentsState { state = $0 }
        
        XCTAssertEqual(.empty, state)
    }
    
}
