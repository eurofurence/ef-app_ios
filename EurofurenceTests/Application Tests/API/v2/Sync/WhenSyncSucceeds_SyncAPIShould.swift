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
        let expectedFirstComponents = DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: 0), year: 2018, month: 4, day: 5, hour: 12, minute: 47, second: 0)
        let expectedSecondComponents = DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: 0), year: 2018, month: 4, day: 5, hour: 12, minute: 49, second: 54)
        
        let expected = APISyncDelta<APIAnnouncement>(changed: [APIAnnouncement(title: "Test-Announcement-Title",
                                                                               content: "This is Content.\n\n**with markdown**",
                                                                               lastChangedDateTime: expectedFirstComponents.date!)],
                                                     deleted: [APIAnnouncement(title: "Test-Announcement 2",
                                                                               content: "This is Content.\n\n**with markdown**",
                                                                               lastChangedDateTime: expectedSecondComponents.date!)])
        XCTAssertEqual(expected, response?.announcements)
    }
    
    func testProduceExpectedRooms() {
        let expected = makeExpectedSyncResponseFromTestFile().rooms
        XCTAssertEqual(expected, response?.rooms)
    }
    
    func testProduceExpectedEvents() {
        let expected = makeExpectedSyncResponseFromTestFile().events
        XCTAssertEqual(expected, response?.events)
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
        
        let rooms = APISyncDelta<APIRoom>(changed: [APIRoom(roomIdentifier: "dfa62eae-f881-4aab-a592-acf8fab14ae9",
                                                            name: "Art Show — Convention Hall Section D")],
                                          deleted: [APIRoom(roomIdentifier: "87148f04-4c4b-433d-9469-c8a970952443",
                                                            name: "Artist Lounge — ECC Foyer 4")])
        
        let changedEventStartDate = DateComponents(calendar: .current,
                                                   timeZone: TimeZone(secondsFromGMT: 0),
                                                   year: 2017,
                                                   month: 8,
                                                   day: 15,
                                                   hour: 12,
                                                   minute: 0,
                                                   second: 0)
        let changedEventEndDate = DateComponents(calendar: .current,
                                                 timeZone: TimeZone(secondsFromGMT: 0),
                                                 year: 2017,
                                                 month: 8,
                                                 day: 16,
                                                 hour: 0,
                                                 minute: 0,
                                                 second: 0)
        let deletedEventStartDate = DateComponents(calendar: .current,
                                                   timeZone: TimeZone(secondsFromGMT: 0),
                                                   year: 2017,
                                                   month: 8,
                                                   day: 15,
                                                   hour: 16,
                                                   minute: 0,
                                                   second: 0)
        let deletedEventEndDate = DateComponents(calendar: .current,
                                                 timeZone: TimeZone(secondsFromGMT: 0),
                                                 year: 2017,
                                                 month: 8,
                                                 day: 16,
                                                 hour: 0,
                                                 minute: 0,
                                                 second: 0)
        
        let events = APISyncDelta<APIEvent>(changed: [APIEvent(roomIdentifier: "87148f04-4c4b-433d-9469-c8a970952443",
                                                               trackIdentifier: "ea76c202-5544-4bc7-92b7-1d1221211a55",
                                                               startDateTime: changedEventStartDate.date!,
                                                               endDateTime: changedEventEndDate.date!,
                                                               title: "Artists' Lounge",
                                                               abstract: "Do you like spending your evening around other artists, drawing and chatting about techniques, supplies and other themes? Then this social event, taking place every evening, is the right place for you to be creative and get to know eachother!")],
                                            deleted: [APIEvent(roomIdentifier: "c72e2290-49fd-496a-9efc-2f68a5f0f0f8",
                                                               trackIdentifier: "a14380b6-b6e1-4b29-8502-e1e1b446c6a2",
                                                               startDateTime: deletedEventStartDate.date!,
                                                               endDateTime: deletedEventEndDate.date!,
                                                               title: "Fursuit Lounge",
                                                               abstract: "Welcome to the Athropomorphic Wellness and First-Aid Center.")])
        
        return APISyncResponse(knowledgeGroups: knowledgeGroups,
                               knowledgeEntries: knowledgeEntries,
                               announcements: APISyncDelta(),
                               events: events,
                               rooms: rooms,
                               tracks: APISyncDelta())
    }
    
}
