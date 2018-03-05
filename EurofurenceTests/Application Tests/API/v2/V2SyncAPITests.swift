//
//  V2SyncAPITests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class V2SyncAPITests: XCTestCase {
    
    func testTheSyncEndpointShouldReceieveRequest() {
        let jsonSession = CapturingJSONSession()
        let syncApi = V2SyncAPI(jsonSession: jsonSession)
        let url = "https://app.eurofurence.org/api/v2/Sync"
        syncApi.fetchLatestData { (_) in }
        
        XCTAssertEqual(url, jsonSession.getRequestURL)
    }
    
    func testSuccessfulResponseProducesExpectedResult() {
        let jsonSession = CapturingJSONSession()
        let syncApi = V2SyncAPI(jsonSession: jsonSession)
        let responseDataURL = Bundle(for: V2SyncAPITests.self).url(forResource: "V2SyncAPIResponse", withExtension: "json")!
        let responseData = try! Data(contentsOf: responseDataURL)
        let expected = makeExpectedSyncResponseFromTestFile()
        var actual: APISyncResponse?
        syncApi.fetchLatestData { actual = $0 }
        jsonSession.invokeLastGETCompletionHandler(responseData: responseData)
        
        XCTAssertEqual(expected, actual)
    }
    
    func makeExpectedSyncResponseFromTestFile() -> APISyncResponse {
        let knowledgeGroups = APISyncDelta<APIKnowledgeGroup>(changed: [APIKnowledgeGroup(identifier: "ec031cbf-d8d0-825d-4c36-b782ed8d19d8",
                                                                                          groupName: "General Information",
                                                                                          groupDescription: "Helpful things all about and around the convention")],
                                                              deleted: [APIKnowledgeGroup(identifier: "6232ae2f-4e9d-fcf4-6341-f1751b405e45",
                                                                                          groupName: "Security",
                                                                                          groupDescription: "Rules & Policies")])
        let knowledgeEntries = APISyncDelta<APIKnowledgeEntry>(changed: [APIKnowledgeEntry(groupIdentifier: "72cdaaba-e980-fa1a-ce94-7a1cc19d0f79",
                                                                                           title: "Parkhaus Neukölln Arcaden")],
                                                               deleted: [APIKnowledgeEntry(groupIdentifier: "66e14f56-743c-1ece-a50c-b691143a3f93",
                                                                                           title: "Clockwork Creature Studio")])
        
        return APISyncResponse(knowledgeGroups: knowledgeGroups,
                               knowledgeEntries: knowledgeEntries)
    }
    
}
