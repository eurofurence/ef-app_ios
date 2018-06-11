//
//  V2SyncAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct V2SyncAPI: SyncAPI {

    var jsonSession: JSONSession
    private let decoder: JSONDecoder

    init(jsonSession: JSONSession) {
        self.jsonSession = jsonSession

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter())
    }

    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (APISyncResponse?) -> Void) {
        let url = "https://app.eurofurence.org/api/v2/Sync"

        var headers: [String: String] = [:]
        if let lastSyncTime = lastSyncTime {
            headers["since"] = Iso8601DateFormatter.instance.string(from: lastSyncTime)
        }

        let request = JSONRequest(url: url, body: Data(), headers: headers)

        jsonSession.get(request) { (data, _) in
            var response: APISyncResponse?
            defer { completionHandler(response) }

            if let data = data {
                response = (try? self.decoder.decode(JSONSyncResponse.self, from: data))?.asAPIResponse()
            }
        }
    }

}

private struct JSONSyncResponse: Decodable {

    func asAPIResponse() -> APISyncResponse {
        return APISyncResponse(knowledgeGroups: KnowledgeGroups.delta,
                               knowledgeEntries: KnowledgeEntries.delta,
                               announcements: Announcements.delta,
                               events: Events.delta,
                               rooms: EventConferenceRooms.delta,
                               tracks: EventConferenceTracks.delta)
    }

    struct Leaf<T>: Decodable where T: Decodable & ModelRepresenting {
        var ChangedEntities: [T]
        var DeletedEntities: [T]

        var delta: APISyncDelta<T.ModelType> {
            return APISyncDelta(changed: ChangedEntities.map({ $0.modelValue }),
                                deleted: DeletedEntities.map({ $0.modelValue }))
        }
    }

    struct JSONKnowledgeGroup: Decodable, ModelRepresenting {
        var Id: String
        var Order: Int
        var Name: String
        var Description: String

        var modelValue: APIKnowledgeGroup {
            return APIKnowledgeGroup(identifier: Id, order: Order, groupName: Name, groupDescription: Description)
        }
    }

    struct JSONKnowledgeEntry: Decodable, ModelRepresenting {

        var Id: String
        var KnowledgeGroupId: String
        var Title: String
        var Order: Int
        var Text: String
        var Links: [JSONLink]

        var modelValue: APIKnowledgeEntry {
            return APIKnowledgeEntry(identifier: Id,
                                     groupIdentifier: KnowledgeGroupId,
                                     title: Title,
                                     order: Order,
                                     text: Text,
                                     links: Links.map({ $0.modelValue }))
        }
    }

    struct JSONLink: Decodable, ModelRepresenting {

        enum JSONFragmentType: String, Decodable, ModelRepresenting {
            case WebExternal

            var modelValue: APILink.FragmentType {
                switch self {
                case JSONLink.JSONFragmentType.WebExternal:
                    return APILink.FragmentType.WebExternal
                }
            }
        }

        var Name: String
        var FragmentType: JSONFragmentType
        var Target: String

        var modelValue: APILink {
            return APILink(name: Name, fragmentType: FragmentType.modelValue, target: Target)
        }
    }

    struct JSONAnnouncement: Decodable, ModelRepresenting {

        var Id: String
        var Title: String
        var Content: String
        var LastChangeDateTimeUtc: Date

        var modelValue: APIAnnouncement {
            return APIAnnouncement(identifier: Id,
                                   title: Title,
                                   content: Content,
                                   lastChangedDateTime: LastChangeDateTimeUtc)
        }

    }

    struct JSONRoom: Decodable, ModelRepresenting {

        var Id: String
        var Name: String

        var modelValue: APIRoom {
            return APIRoom(roomIdentifier: Id, name: Name)
        }

    }

    struct JSONEvent: Decodable, ModelRepresenting {

        var Id: String
        var ConferenceRoomId: String
        var ConferenceTrackId: String
        var StartDateTimeUtc: Date
        var EndDateTimeUtc: Date
        var Title: String
        var Abstract: String
        var PanelHosts: String
        var Description: String
        var BannerImageId: String?
        var PosterImageId: String?

        var modelValue: APIEvent {
            return APIEvent(identifier: Id,
                            roomIdentifier: ConferenceRoomId,
                            trackIdentifier: ConferenceTrackId,
                            startDateTime: StartDateTimeUtc,
                            endDateTime: EndDateTimeUtc,
                            title: Title,
                            abstract: Abstract,
                            panelHosts: PanelHosts,
                            eventDescription: Description,
                            posterImageId: PosterImageId,
                            bannerImageId: BannerImageId)
        }

    }

    struct JSONTrack: Decodable, ModelRepresenting {

        var Id: String
        var Name: String

        var modelValue: APITrack {
            return APITrack(trackIdentifier: Id, name: Name)
        }

    }

    var KnowledgeGroups: Leaf<JSONKnowledgeGroup>
    var KnowledgeEntries: Leaf<JSONKnowledgeEntry>
    var Announcements: Leaf<JSONAnnouncement>
    var EventConferenceRooms: Leaf<JSONRoom>
    var Events: Leaf<JSONEvent>
    var EventConferenceTracks: Leaf<JSONTrack>

}

private protocol ModelRepresenting {
    associatedtype ModelType: Equatable

    var modelValue: ModelType { get }
}
