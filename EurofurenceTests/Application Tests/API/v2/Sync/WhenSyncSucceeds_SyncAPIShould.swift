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
        let apiUrl = StubV2ApiUrlProviding()
        let syncApi = V2SyncAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let responseDataURL = Bundle(for: V2SyncAPITests.self).url(forResource: "V2SyncAPIResponse", withExtension: "json")!
        let responseData = try! Data(contentsOf: responseDataURL)
        syncApi.fetchLatestData(lastSyncTime: nil) { self.response = $0 }
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
        
        let expected = APISyncDelta<APIAnnouncement>(changed: [APIAnnouncement(identifier: "b89567a0-beda-46e8-8261-26a5bf2d6a30",
                                                                               title: "Test-Announcement-Title",
                                                                               content: "This is Content.\n\n**with markdown**",
                                                                               lastChangedDateTime: expectedFirstComponents.date!)],
                                                     deleted: ["c8c8a9ad-4f43-489f-905d-9d22d0ef045f"])
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
    
    func testProduceExpectedTracks() {
        let expected = makeExpectedSyncResponseFromTestFile().tracks
        XCTAssertEqual(expected, response?.tracks)
    }
    
    func testProduceExpectedConferenceDays() {
        let expected = makeExpectedSyncResponseFromTestFile().conferenceDays
        XCTAssertEqual(expected, response?.conferenceDays)
    }
    
    func testProduceExpectedDealers() {
        let expected = makeExpectedSyncResponseFromTestFile().dealers
        XCTAssertEqual(expected, response?.dealers)
    }
    
    func testProduceExpectedMaps() {
        let expected = makeExpectedSyncResponseFromTestFile().maps
        XCTAssertEqual(expected, response?.maps)
    }
    
    func testProduceExpectedImages() {
        let expected = makeExpectedSyncResponseFromTestFile().images
        XCTAssertEqual(expected, response?.images)
    }
    
    private func makeExpectedSyncResponseFromTestFile() -> APISyncResponse {
        let knowledgeGroups = APISyncDelta<APIKnowledgeGroup>(changed: [APIKnowledgeGroup(identifier: "ec031cbf-d8d0-825d-4c36-b782ed8d19d8",
                                                                                          order: 0,
                                                                                          groupName: "General Information",
                                                                                          groupDescription: "Helpful things all about and around the convention")],
                                                              deleted: ["6232ae2f-4e9d-fcf4-6341-f1751b405e45"])
        let knowledgeEntries = APISyncDelta<APIKnowledgeEntry>(changed: [APIKnowledgeEntry(identifier: "28b153de-4797-99b6-ab80-f1f851dd2bde",
                                                                                           groupIdentifier: "72cdaaba-e980-fa1a-ce94-7a1cc19d0f79",
                                                                                           title: "Parkhaus Neukölln Arcaden",
                                                                                           order: 0,
                                                                                           text: "The Parkhaus Neukölln Arcaden is about 2.5 km away from the hotel which means an average walking time of 30 minutes. Compared to the hotel parking this is rather cheap.",
                                                                                           links: [APILink(name: "Info Site (German)", fragmentType: .WebExternal, target: "https://www.mein-contipark.de/parkplatz-finden/parken-in-berlin/parkhaus-neukoelln-arcaden-berlin--ci3cp11881")])],
                                                               deleted: ["ba2f31ad-d42a-9e40-2c79-17bb9b2f36f3"])
        
        let rooms = APISyncDelta<APIRoom>(changed: [APIRoom(roomIdentifier: "dfa62eae-f881-4aab-a592-acf8fab14ae9",
                                                            name: "Art Show — Convention Hall Section D")],
                                          deleted: ["87148f04-4c4b-433d-9469-c8a970952443"])
        
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
        
        let events = APISyncDelta<APIEvent>(changed: [APIEvent(identifier: "22b70985-ccd9-44f7-920b-ad9224558b9f",
                                                               roomIdentifier: "87148f04-4c4b-433d-9469-c8a970952443",
                                                               trackIdentifier: "ea76c202-5544-4bc7-92b7-1d1221211a55",
                                                               dayIdentifier: "5f2e5aa4-a172-4f8b-8441-1e676ea3be9f",
                                                               startDateTime: changedEventStartDate.date!,
                                                               endDateTime: changedEventEndDate.date!,
                                                               title: "Artists' Lounge",
                                                               abstract: "Do you like spending your evening around other artists, drawing and chatting about techniques, supplies and other themes? Then this social event, taking place every evening, is the right place for you to be creative and get to know eachother!",
                                                               panelHosts: "Akulatraxas",
                                                               eventDescription: "NOT FINAL\r\n\r\n\r\nDo you like spending your evening around other artists, drawing and chatting about techniques, supplies and other themes? Then this social event, taking place every evening, is the right place for you to be creative and get to know eachother!\r\n\r\nCome sit with other artists and watch, chat and have a good time together while being productive on your convention commissions. This is the perfect opportunity to use your time effectively, get critique and help on your work and relax from the working day at the Dealers' Den or Artist Alley.\r\n",
                                                               posterImageId: "postertest",
                                                               bannerImageId: "bannertest")],
                                            deleted: ["1452d472-feae-4483-8f55-93c25f7ec920"])
        
        let tracks = APISyncDelta<APITrack>(changed: [APITrack(trackIdentifier: "f92a4fc0-303f-4c13-9194-44121d80bd20",
                                                               name: "Stage")],
                                            deleted: ["cf410a89-379d-40c7-89ea-d0b6b51ea914"])
        
        let changedConferenceDayDate = DateComponents(calendar: .current,
                                                      timeZone: TimeZone(secondsFromGMT: 0),
                                                      year: 2017,
                                                      month: 8,
                                                      day: 15).date!
        let conferenceDays = APISyncDelta<APIConferenceDay>(changed: [APIConferenceDay(identifier: "5f2e5aa4-a172-4f8b-8441-1e676ea3be9f",
                                                                                       date: changedConferenceDayDate)],
                                                            deleted: ["db8e0455-8c49-4bc5-b472-e0033fe06b99"])
        
        let dealers = APISyncDelta<APIDealer>(changed: [APIDealer(identifier: "f112a4db-7856-4087-806d-b2704717dba3",
                                                                  displayName: "Akifu Toys",
                                                                  attendeeNickname: "Akeela",
                                                                  attendsOnThursday: true,
                                                                  attendsOnFriday: true,
                                                                  attendsOnSaturday: true,
                                                                  isAfterDark: true,
                                                                  artistThumbnailImageId: nil,
                                                                  artistImageId: nil,
                                                                  artPreviewImageId: nil,
                                                                  categories: ["General", "Art"],
                                                                  shortDescription: "",
                                                                  links: nil,
                                                                  twitterHandle: "",
                                                                  telegramHandle: "",
                                                                  aboutTheArtistText: "",
                                                                  aboutTheArtText: "",
                                                                  artPreviewCaption: "")],
                                              deleted: ["d53e6f6b-fdcb-4754-a4b9-6892e8d317d7"])
        
        let maps = APISyncDelta<APIMap>(changed: [APIMap(identifier: "d6f1c9b4-6d03-41cc-ae5d-ee278e5121f0",
                                                         imageIdentifier: "28c15af7-6d82-4ee7-bf3b-2603076e785e",
                                                         mapDescription: "Dealers Den",
                                                         entries: [APIMap.Entry(x: 747, y: 201, tapRadius: 50, links: [APIMap.Entry.Link(type: .dealerDetail, name: "Mirri", target: "b2166372-3b76-45d3-b3f9-e1675cade2db")])])],
                                        deleted: ["157e1849-d6fc-46ab-9d47-1b785cd867c7"])
        
        let images = APISyncDelta<APIImage>(changed: [APIImage(identifier: "8ae7d323-b56d-4155-8a88-6b418bcfd057",
                                                               internalReference: "knowledge:1b9f7858-454d-0a68-824b-359e5bbfa5b0")],
                                            deleted: ["2513aa0a-48a0-49cf-807e-8a57cf5306f8"])
        
        return APISyncResponse(knowledgeGroups: knowledgeGroups,
                               knowledgeEntries: knowledgeEntries,
                               announcements: APISyncDelta(),
                               events: events,
                               rooms: rooms,
                               tracks: tracks,
                               conferenceDays: conferenceDays,
                               dealers: dealers,
                               maps: maps,
                               images: images)
    }
    
}
