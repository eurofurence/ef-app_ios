//
//  WhenSyncSucceeds_SyncAPIShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSyncSucceeds_SyncAPIShould: XCTestCase {
    
    var syncApi: V2SyncAPI!
    var jsonSession: CapturingJSONSession!
    var response: APISyncResponse?
    
    override func setUp() {
        super.setUp()
        
        let jsonSession = CapturingJSONSession()
        let syncApi = V2SyncAPI(jsonSession: jsonSession)
        let responseDataURL = Bundle(for: V2SyncAPITests.self).url(forResource: "V2SyncAPIResponse", withExtension: "json")!
        let responseData = try! Data(contentsOf: responseDataURL)
        syncApi.fetchLatestData { self.response = $0 }
        jsonSession.invokeLastGETCompletionHandler(responseData: responseData)
    }
    
    func testSuccessfulResponseProducesExpectedKnowledgeEntries() {
        let expected = makeExpectedSyncResponseFromTestFile().knowledgeEntries
        XCTAssertEqual(expected, response?.knowledgeEntries)
    }
    
    func testSuccessfulResponseProducesExpectedKnowledgeGroups() {
        let expected = makeExpectedSyncResponseFromTestFile().knowledgeGroups
        XCTAssertEqual(expected, response?.knowledgeGroups)
    }
    
    func testProduceExpectedAnnouncements() {
        let expected = APISyncDelta<APIAnnouncement>(changed: [APIAnnouncement(title: "Test-Announcement-Title",
                                                                               content: "This is Content.\n\n**with markdown**",
                                                                               lastChangedDateTime: Date(timeIntervalSince1970: 0))],
                                                     deleted: [APIAnnouncement(title: "Test-Announcement 2",
                                                                               content: "This is Content.\n\n**with markdown**",
                                                                               lastChangedDateTime: Date(timeIntervalSince1970: 0))])
        XCTAssertEqual(expected, response?.announcements)
    }
    
    private func makeExpectedSyncResponseFromTestFile() -> APISyncResponse {
        let knowledgeGroups = APISyncDelta<APIKnowledgeGroup>(changed: [APIKnowledgeGroup(identifier: "ec031cbf-d8d0-825d-4c36-b782ed8d19d8",
                                                                                          order: 0,
                                                                                          groupName: "General Information",
                                                                                          groupDescription: "Helpful things all about and around the convention")],
                                                              deleted: [APIKnowledgeGroup(identifier: "6232ae2f-4e9d-fcf4-6341-f1751b405e45",
                                                                                          order: 1,
                                                                                          groupName: "Security",
                                                                                          groupDescription: "Rules & Policies")])
        let knowledgeEntries = APISyncDelta<APIKnowledgeEntry>(changed: [APIKnowledgeEntry(groupIdentifier: "72cdaaba-e980-fa1a-ce94-7a1cc19d0f79",
                                                                                           title: "Parkhaus Neukölln Arcaden",
                                                                                           order: 0,
                                                                                           text: "The Parkhaus Neukölln Arcaden is about 2.5 km away from the hotel which means an average walking time of 30 minutes. Compared to the hotel parking this is rather cheap.",
                                                                                           links: [APILink(name: "Info Site (German)", fragmentType: .WebExternal, target: "https://www.mein-contipark.de/parkplatz-finden/parken-in-berlin/parkhaus-neukoelln-arcaden-berlin--ci3cp11881")])],
                                                               deleted: [APIKnowledgeEntry(groupIdentifier: "66e14f56-743c-1ece-a50c-b691143a3f93",
                                                                                           title: "Clockwork Creature Studio",
                                                                                           order: 1,
                                                                                           text: "Clockwork Creature Studio was founded in 2005 by Qarrezel and is a wellknown artistic costume and design studio based in Towson, Maryland, USA. Two years later the studio changed its focus and became an active small creature costuming business.",
                                                                                           links: [])])
        
        return APISyncResponse(knowledgeGroups: knowledgeGroups,
                               knowledgeEntries: knowledgeEntries,
                               announcements: APISyncDelta())
    }
    
}
