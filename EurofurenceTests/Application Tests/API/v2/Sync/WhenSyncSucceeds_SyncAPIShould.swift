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
        let expectedSecondComponents = DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: 0), year: 2018, month: 4, day: 5, hour: 12, minute: 49, second: 54)
        
        let expected = APISyncDelta<APIAnnouncement>(changed: [APIAnnouncement(identifier: "b89567a0-beda-46e8-8261-26a5bf2d6a30",
                                                                               title: "Test-Announcement-Title",
                                                                               content: "This is Content.\n\n**with markdown**",
                                                                               lastChangedDateTime: expectedFirstComponents.date!)],
                                                     deleted: [APIAnnouncement(identifier: "c8c8a9ad-4f43-489f-905d-9d22d0ef045f",
                                                                               title: "Test-Announcement 2",
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
    
    private func makeExpectedSyncResponseFromTestFile() -> APISyncResponse {
        let knowledgeGroups = APISyncDelta<APIKnowledgeGroup>(changed: [APIKnowledgeGroup(identifier: "ec031cbf-d8d0-825d-4c36-b782ed8d19d8",
                                                                                          order: 0,
                                                                                          groupName: "General Information",
                                                                                          groupDescription: "Helpful things all about and around the convention")],
                                                              deleted: [APIKnowledgeGroup(identifier: "6232ae2f-4e9d-fcf4-6341-f1751b405e45",
                                                                                          order: 1,
                                                                                          groupName: "Security",
                                                                                          groupDescription: "Rules & Policies")])
        let knowledgeEntries = APISyncDelta<APIKnowledgeEntry>(changed: [APIKnowledgeEntry(identifier: "28b153de-4797-99b6-ab80-f1f851dd2bde",
                                                                                           groupIdentifier: "72cdaaba-e980-fa1a-ce94-7a1cc19d0f79",
                                                                                           title: "Parkhaus Neukölln Arcaden",
                                                                                           order: 0,
                                                                                           text: "The Parkhaus Neukölln Arcaden is about 2.5 km away from the hotel which means an average walking time of 30 minutes. Compared to the hotel parking this is rather cheap.",
                                                                                           links: [APILink(name: "Info Site (German)", fragmentType: .WebExternal, target: "https://www.mein-contipark.de/parkplatz-finden/parken-in-berlin/parkhaus-neukoelln-arcaden-berlin--ci3cp11881")])],
                                                               deleted: [APIKnowledgeEntry(identifier: "ba2f31ad-d42a-9e40-2c79-17bb9b2f36f3",
                                                                                           groupIdentifier: "66e14f56-743c-1ece-a50c-b691143a3f93",
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
                                            deleted: [APIEvent(identifier: "1452d472-feae-4483-8f55-93c25f7ec920",
                                                               roomIdentifier: "c72e2290-49fd-496a-9efc-2f68a5f0f0f8",
                                                               trackIdentifier: "a14380b6-b6e1-4b29-8502-e1e1b446c6a2",
                                                               dayIdentifier: "5f2e5aa4-a172-4f8b-8441-1e676ea3be9f",
                                                               startDateTime: deletedEventStartDate.date!,
                                                               endDateTime: deletedEventEndDate.date!,
                                                               title: "Fursuit Lounge",
                                                               abstract: "Welcome to the Athropomorphic Wellness and First-Aid Center.",
                                                               panelHosts: "Mystifur",
                                                               eventDescription: "",
                                                               posterImageId: nil,
                                                               bannerImageId: nil)])
        
        let tracks = APISyncDelta<APITrack>(changed: [APITrack(trackIdentifier: "f92a4fc0-303f-4c13-9194-44121d80bd20",
                                                               name: "Stage")],
                                            deleted: [APITrack(trackIdentifier: "cf410a89-379d-40c7-89ea-d0b6b51ea914",
                                                               name: "Supersponsor Event")])
        
        let changedConferenceDayDate = DateComponents(calendar: .current,
                                                      timeZone: TimeZone(secondsFromGMT: 0),
                                                      year: 2017,
                                                      month: 8,
                                                      day: 15).date!
        let deletedConferenceDayDate = DateComponents(calendar: .current,
                                                      timeZone: TimeZone(secondsFromGMT: 0),
                                                      year: 2017,
                                                      month: 8,
                                                      day: 16).date!
        let conferenceDays = APISyncDelta<APIConferenceDay>(changed: [APIConferenceDay(identifier: "5f2e5aa4-a172-4f8b-8441-1e676ea3be9f",
                                                                                       date: changedConferenceDayDate)],
                                                            deleted: [APIConferenceDay(identifier: "db8e0455-8c49-4bc5-b472-e0033fe06b99",
                                                                                       date: deletedConferenceDayDate)])
        
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
                                              deleted: [APIDealer(identifier: "d53e6f6b-fdcb-4754-a4b9-6892e8d317d7",
                                                                  displayName: "",
                                                                  attendeeNickname: "Frazzle",
                                                                  attendsOnThursday: true,
                                                                  attendsOnFriday: true,
                                                                  attendsOnSaturday: true,
                                                                  isAfterDark: false,
                                                                  artistThumbnailImageId: "59b6023f-f739-4d40-a977-3d6bad1ab434",
                                                                  artistImageId: "81e6a80a-21cb-4524-a961-9d356aada9a1",
                                                                  artPreviewImageId: "6a624433-bc5f-4d31-b18e-0c443611f497",
                                                                  categories: [],
                                                                  shortDescription: "Frazzle, the SewerRat. Knallratte. Cartoon animator, comic artist, menace to balloons. Creator of Trixie Vixen.\r\nAt my table, you will find pretty oldschool style print media and merchandise from own production, often featuring busty and toony anthro girl. \r\nLive Sketch Commissions - feel free to stay and watch!",
                                                                  links: [APILink(name: "",
                                                                                  fragmentType: .WebExternal,
                                                                                  target: "http://www.furaffinity.net/user/frazzle/")],
                                                                  twitterHandle: "FrazzleRat",
                                                                  telegramHandle: "HefeleToons",
                                                                  aboutTheArtistText: "My name is Chris Hefele, been around in the Furry Fandom since the late 90s. In Germany as \"SewerRat\" or \"die Knallratte\", and internationally as \"Frazzle\". \r\nIn RL, I work as a traditional 2D animator (handdrawn/full), so a bit of a dinosaur. Aside of that, it is illustrations, character design, storyboard and other areas of film making and advertising. Very soft spot for foxes.",
                                                                  aboutTheArtText: "Got my mind stuck in the 80s, my art stuck in the 90s, and I am not ashamed to say I looove cheesy pin-up flat-color black-outlined top-heavy toonyness. Strongly inspired by Chuck Jones and Disney work from days gone by, and trying to keep that flame alive. \r\nI got a thing for anvil-and-dynamite style toon stuff (this is where the little rat comes from), strong female leads, and a recurring topic of \"Bad Girls vs. Balloons\", which I am perhaps a bit infamous for.\r\nNot to be taken too seriously.",
                                                                  artPreviewCaption: "Pin-Ups focusing on joie-de-vivre, flirtatious and strong anthro girls. These ladies will try to cheer you up and help you pull through life, no matter if on a Zippo in your pocket, on a college bag around your shoulder, or as a print on your wall. But you better treat 'em well, or they might just pull an anvil out of their pocket and throw it! ;)")])
        
        let maps = APISyncDelta<APIMap>(changed: [APIMap(identifier: "d6f1c9b4-6d03-41cc-ae5d-ee278e5121f0",
                                                         imageIdentifier: "28c15af7-6d82-4ee7-bf3b-2603076e785e",
                                                         mapDescription: "Dealers Den",
                                                         entries: [])],
                                        deleted: [APIMap(identifier: "157e1849-d6fc-46ab-9d47-1b785cd867c7",
                                                         imageIdentifier: "ba02881c-ab37-4e0c-b7f3-ef161c756714",
                                                         mapDescription: "Venue (Estrel)",
                                                         entries: [])])
        
        return APISyncResponse(knowledgeGroups: knowledgeGroups,
                               knowledgeEntries: knowledgeEntries,
                               announcements: APISyncDelta(),
                               events: events,
                               rooms: rooms,
                               tracks: tracks,
                               conferenceDays: conferenceDays,
                               dealers: dealers,
                               maps: maps)
    }
    
}
