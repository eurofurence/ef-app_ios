import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenSyncSucceeds_SyncAPIShould: XCTestCase {

    func testProduceExpectedResponse() {
        let jsonSession = CapturingJSONSession()
        let apiUrl = StubAPIURLProviding()
        let syncApi = JSONAPI(jsonSession: jsonSession, apiUrl: apiUrl)
        let responseData = EurofurenceModelTestAssets.successfulSyncResponseData
        var response: ModelCharacteristics?
        syncApi.fetchLatestData(lastSyncTime: nil) { response = $0 }
        jsonSession.invokeLastGETCompletionHandler(responseData: responseData)

        let expectedResponse: ModelCharacteristics = makeExpectedSyncResponseFromTestFile()

        XCTAssertEqual(expectedResponse, response)
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable line_length
    private func makeExpectedSyncResponseFromTestFile() -> ModelCharacteristics {
        let knowledgeGroups = ModelCharacteristics.Update<KnowledgeGroupCharacteristics>(changed: [KnowledgeGroupCharacteristics(identifier: "ec031cbf-d8d0-825d-4c36-b782ed8d19d8",
                                                                                                   order: 0,
                                                                                                   groupName: "General Information",
                                                                                                   groupDescription: "Helpful things all about and around the convention",
                                                                                                   fontAwesomeCharacterAddress: "f129")],
                                                                       deleted: ["6232ae2f-4e9d-fcf4-6341-f1751b405e45"],
                                                                       removeAllBeforeInsert: true)
        let knowledgeEntries = ModelCharacteristics.Update<KnowledgeEntryCharacteristics>(changed: [KnowledgeEntryCharacteristics(identifier: "28b153de-4797-99b6-ab80-f1f851dd2bde",
                                                                                                    groupIdentifier: "72cdaaba-e980-fa1a-ce94-7a1cc19d0f79",
                                                                                                    title: "Parkhaus Neukölln Arcaden",
                                                                                                    order: 0,
                                                                                                    text: "The Parkhaus Neukölln Arcaden is about 2.5 km away from the hotel which means an average walking time of 30 minutes. Compared to the hotel parking this is rather cheap.",
                                                                                                    links: [LinkCharacteristics(name: "Info Site (German)", fragmentType: .WebExternal, target: "https://www.mein-contipark.de/parkplatz-finden/parken-in-berlin/parkhaus-neukoelln-arcaden-berlin--ci3cp11881")],
                                                                                                    imageIdentifiers: ["518ade34-48a5-4c20-a512-07e9722fe2f6"])],
                                                                        deleted: ["ba2f31ad-d42a-9e40-2c79-17bb9b2f36f3"],
                                                                        removeAllBeforeInsert: true)

        let rooms = ModelCharacteristics.Update<RoomCharacteristics>(changed: [RoomCharacteristics(identifier: "dfa62eae-f881-4aab-a592-acf8fab14ae9",
                                                                     name: "Art Show — Convention Hall Section D")],
                                                   deleted: ["87148f04-4c4b-433d-9469-c8a970952443"],
                                                   removeAllBeforeInsert: true)

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

        let events = ModelCharacteristics.Update<EventCharacteristics>(changed: [EventCharacteristics(identifier: "22b70985-ccd9-44f7-920b-ad9224558b9f",
                                                                        roomIdentifier: "87148f04-4c4b-433d-9469-c8a970952443",
                                                                        trackIdentifier: "ea76c202-5544-4bc7-92b7-1d1221211a55",
                                                                        dayIdentifier: "5f2e5aa4-a172-4f8b-8441-1e676ea3be9f",
                                                                        startDateTime: changedEventStartDate.date.unsafelyUnwrapped,
                                                                        endDateTime: changedEventEndDate.date.unsafelyUnwrapped,
                                                                        title: "Artists' Lounge",
                                                                        subtitle: "Let's be creative together!",
                                                                        abstract: "Do you like spending your evening around other artists, drawing and chatting about techniques, supplies and other themes? Then this social event, taking place every evening, is the right place for you to be creative and get to know eachother!",
                                                                        panelHosts: "Akulatraxas",
                                                                        eventDescription: "NOT FINAL\r\n\r\n\r\nDo you like spending your evening around other artists, drawing and chatting about techniques, supplies and other themes? Then this social event, taking place every evening, is the right place for you to be creative and get to know eachother!\r\n\r\nCome sit with other artists and watch, chat and have a good time together while being productive on your convention commissions. This is the perfect opportunity to use your time effectively, get critique and help on your work and relax from the working day at the Dealers' Den or Artist Alley.\r\n",
                                                                        posterImageId: "postertest",
                                                                        bannerImageId: "bannertest",
                                                                        tags: ["photoshoot"],
                                                                        isAcceptingFeedback: true)],
                                                     deleted: ["1452d472-feae-4483-8f55-93c25f7ec920"],
                                                     removeAllBeforeInsert: true)

        let tracks = ModelCharacteristics.Update<TrackCharacteristics>(changed: [TrackCharacteristics(identifier: "f92a4fc0-303f-4c13-9194-44121d80bd20",
                                                                                                      name: "Stage")],
                                                                       deleted: ["cf410a89-379d-40c7-89ea-d0b6b51ea914"],
                                                                       removeAllBeforeInsert: true)

        let changedConferenceDayDate = DateComponents(calendar: .current,
                                                      timeZone: TimeZone(secondsFromGMT: 0),
                                                      year: 2017,
                                                      month: 8,
                                                      day: 15).date.unsafelyUnwrapped
        let conferenceDays = ModelCharacteristics.Update<ConferenceDayCharacteristics>(changed: [ConferenceDayCharacteristics(identifier: "5f2e5aa4-a172-4f8b-8441-1e676ea3be9f",
                                                                                                date: changedConferenceDayDate)],
                                                                     deleted: ["db8e0455-8c49-4bc5-b472-e0033fe06b99"],
                                                                     removeAllBeforeInsert: true)

        let dealers = ModelCharacteristics.Update<DealerCharacteristics>(changed: [DealerCharacteristics(identifier: "f112a4db-7856-4087-806d-b2704717dba3",
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
                                                       deleted: ["d53e6f6b-fdcb-4754-a4b9-6892e8d317d7"],
                                                       removeAllBeforeInsert: true)

        let maps = ModelCharacteristics.Update<MapCharacteristics>(
            changed: [
                MapCharacteristics(
                    identifier: "d6f1c9b4-6d03-41cc-ae5d-ee278e5121f0",
                    imageIdentifier: "28c15af7-6d82-4ee7-bf3b-2603076e785e",
                    mapDescription: "Dealers Den",
                    order: 10,
                    entries: [
                        MapCharacteristics.Entry(
                            identifier: "651ab75e-d87f-40a6-bcad-669432ee7a86",
                            x: 747,
                            y: 201,
                            tapRadius: 50,
                            links: [
                                MapCharacteristics.Entry.Link(
                                    type: .dealerDetail,
                                    name: "Mirri",
                                    target: "b2166372-3b76-45d3-b3f9-e1675cade2db"
                                )
                            ]
                        )
                    ]
                )
            ],
            deleted: ["157e1849-d6fc-46ab-9d47-1b785cd867c7"],
            removeAllBeforeInsert: true
        )

        let images = ModelCharacteristics.Update<ImageCharacteristics>(changed: [ImageCharacteristics(identifier: "8ae7d323-b56d-4155-8a88-6b418bcfd057",
                                                                        internalReference: "knowledge:1b9f7858-454d-0a68-824b-359e5bbfa5b0",
                                                                        contentHashSha1: "u7Ih+dL/QkQf/L5TdUQuQqSirLw=")],
                                                     deleted: ["2513aa0a-48a0-49cf-807e-8a57cf5306f8"],
                                                     removeAllBeforeInsert: true)

        let announcementLastChangedDateComponents = DateComponents(calendar: .current,
                                                                   timeZone: TimeZone(secondsFromGMT: 0),
                                                                   year: 2018,
                                                                   month: 4,
                                                                   day: 5,
                                                                   hour: 12,
                                                                   minute: 47,
                                                                   second: 0)

        let announcements = ModelCharacteristics.Update<AnnouncementCharacteristics>(changed: [AnnouncementCharacteristics(identifier: "b89567a0-beda-46e8-8261-26a5bf2d6a30",
                                                                                             title: "Test-Announcement-Title",
                                                                                             content: "This is Content.\n\n**with markdown**",
                                                                                             lastChangedDateTime: announcementLastChangedDateComponents.date.unsafelyUnwrapped,
                                                                                             imageIdentifier: "e5b6efdd-8bbf-42f1-aa9e-159744c732b7")],
                                                                   deleted: ["c8c8a9ad-4f43-489f-905d-9d22d0ef045f"],
                                                                   removeAllBeforeInsert: false)

        return ModelCharacteristics(conventionIdentifier: "EF25",
                                    knowledgeGroups: knowledgeGroups,
                                    knowledgeEntries: knowledgeEntries,
                                    announcements: announcements,
                                    events: events,
                                    rooms: rooms,
                                    tracks: tracks,
                                    conferenceDays: conferenceDays,
                                    dealers: dealers,
                                    maps: maps,
                                    images: images)
    }

}
