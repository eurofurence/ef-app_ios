//
//  V2SyncAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct V2SyncAPI: SyncAPI {

    var jsonSession: JSONSession
    let apiUrl: String
    private let decoder: JSONDecoder

    public init(jsonSession: JSONSession, apiUrl: V2ApiUrlProviding) {
        self.jsonSession = jsonSession
        self.apiUrl = apiUrl.url

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter())
    }

    public func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (APISyncResponse?) -> Void) {
        let sinceParameterPathComponent: String = {
            if let lastSyncTime = lastSyncTime {
                let formattedTime = Iso8601DateFormatter.instance.string(from: lastSyncTime)
                return "?since=\(formattedTime)"
            } else {
                return ""
            }
        }()

        let url = "\(apiUrl)Sync\(sinceParameterPathComponent)"
        let request = JSONRequest(url: url, body: Data())

        jsonSession.get(request) { (data, _) in
            var response: APISyncResponse?
            defer { completionHandler(response) }

            if let data = data {
                do {
                    let decodedResponse = try self.decoder.decode(JSONSyncResponse.self, from: data)
                    response = decodedResponse.asAPIResponse()
                } catch {
                    print(error)
                }
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
                               tracks: EventConferenceTracks.delta,
                               conferenceDays: EventConferenceDays.delta,
                               dealers: Dealers.delta,
                               maps: Maps.delta,
                               images: Images.delta)
    }

    struct Leaf<T>: Decodable where T: Decodable & ModelRepresenting {
        var ChangedEntities: [T]
        var DeletedEntities: [String]
        var RemoveAllBeforeInsert: Bool

        var delta: APISyncDelta<T.ModelType> {
            return APISyncDelta(changed: ChangedEntities.map({ $0.modelValue }),
                                deleted: DeletedEntities,
                                removeAllBeforeInsert: RemoveAllBeforeInsert)
        }
    }

    struct JSONKnowledgeGroup: Decodable, ModelRepresenting {
        var Id: String
        var Order: Int
        var Name: String
        var Description: String
        var FontAwesomeIconCharacterUnicodeAddress: String

        var modelValue: APIKnowledgeGroup {
            return APIKnowledgeGroup(identifier: Id,
                                     order: Order,
                                     groupName: Name,
                                     groupDescription: Description,
                                     fontAwesomeCharacterAddress: FontAwesomeIconCharacterUnicodeAddress)
        }
    }

    struct JSONKnowledgeEntry: Decodable, ModelRepresenting {

        var Id: String
        var KnowledgeGroupId: String
        var Title: String
        var Order: Int
        var Text: String
        var Links: [JSONLink]
        var ImageIds: [String]

        var modelValue: APIKnowledgeEntry {
            return APIKnowledgeEntry(identifier: Id,
                                     groupIdentifier: KnowledgeGroupId,
                                     title: Title,
                                     order: Order,
                                     text: Text,
                                     links: Links.map({ $0.modelValue }),
                                     imageIdentifiers: ImageIds)
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
        var ImageId: String?

        var modelValue: APIAnnouncement {
            return APIAnnouncement(identifier: Id,
                                   title: Title,
                                   content: Content,
                                   lastChangedDateTime: LastChangeDateTimeUtc,
                                   imageIdentifier: ImageId)
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
        var ConferenceDayId: String
        var StartDateTimeUtc: Date
        var EndDateTimeUtc: Date
        var Title: String
        var SubTitle: String
        var Abstract: String
        var PanelHosts: String
        var Description: String
        var BannerImageId: String?
        var PosterImageId: String?
        var Tags: [String]?

        var modelValue: APIEvent {
            return APIEvent(identifier: Id,
                            roomIdentifier: ConferenceRoomId,
                            trackIdentifier: ConferenceTrackId,
                            dayIdentifier: ConferenceDayId,
                            startDateTime: StartDateTimeUtc,
                            endDateTime: EndDateTimeUtc,
                            title: Title,
                            subtitle: SubTitle,
                            abstract: Abstract,
                            panelHosts: PanelHosts,
                            eventDescription: Description,
                            posterImageId: PosterImageId,
                            bannerImageId: BannerImageId,
                            tags: Tags)
        }

    }

    struct JSONTrack: Decodable, ModelRepresenting {

        var Id: String
        var Name: String

        var modelValue: APITrack {
            return APITrack(trackIdentifier: Id, name: Name)
        }

    }

    struct JSONEventConferenceDay: Decodable, ModelRepresenting {

        var Id: String
        var Date: Date

        var modelValue: APIConferenceDay {
            return APIConferenceDay(identifier: Id, date: Date)
        }

    }

    struct JSONDealer: Decodable, ModelRepresenting {

        var Id: String
        var DisplayName: String
        var AttendeeNickname: String
        var AttendsOnThursday: Bool
        var AttendsOnFriday: Bool
        var AttendsOnSaturday: Bool
        var IsAfterDark: Bool
        var ArtistThumbnailImageId: String?
        var ArtistImageId: String?
        var ArtPreviewImageId: String?
        var Categories: [String]
        var ShortDescription: String
        var Links: [JSONLink]?
        var TwitterHandle: String
        var TelegramHandle: String
        var AboutTheArtistText: String
        var AboutTheArtText: String
        var ArtPreviewCaption: String

        var modelValue: APIDealer {
            return APIDealer(identifier: Id,
                             displayName: DisplayName,
                             attendeeNickname: AttendeeNickname,
                             attendsOnThursday: AttendsOnThursday,
                             attendsOnFriday: AttendsOnFriday,
                             attendsOnSaturday: AttendsOnSaturday,
                             isAfterDark: IsAfterDark,
                             artistThumbnailImageId: ArtistThumbnailImageId,
                             artistImageId: ArtistImageId,
                             artPreviewImageId: ArtPreviewImageId,
                             categories: Categories,
                             shortDescription: ShortDescription,
                             links: Links?.map({ $0.modelValue }),
                             twitterHandle: TwitterHandle,
                             telegramHandle: TelegramHandle,
                             aboutTheArtistText: AboutTheArtistText,
                             aboutTheArtText: AboutTheArtText,
                             artPreviewCaption: ArtPreviewCaption)
        }

    }

    struct JSONMap: Decodable, ModelRepresenting {

        struct JSONMapEntry: Decodable, ModelRepresenting {

            struct JSONMapEntryLink: Decodable, ModelRepresenting {

                enum LinkFragmentType: String, Decodable, ModelRepresenting {
                    case DealerDetail
                    case EventConferenceRoom
                    case MapEntry

                    var modelValue: APIMap.Entry.Link.FragmentType {
                        switch self {
                        case .DealerDetail:
                            return .dealerDetail
                        case .EventConferenceRoom:
                            return .conferenceRoom
                        case .MapEntry:
                            return .mapEntry
                        }
                    }
                }

                var FragmentType: LinkFragmentType
                var Name: String?
                var Target: String

                var modelValue: APIMap.Entry.Link {
                    return APIMap.Entry.Link(type: FragmentType.modelValue, name: Name, target: Target)
                }
            }

            var Id: String
            var X: Int
            var Y: Int
            var TapRadius: Int
            var Links: [JSONMapEntryLink]

            var modelValue: APIMap.Entry {
                return APIMap.Entry(identifier: Id,
                                    x: X,
                                    y: Y,
                                    tapRadius: TapRadius,
                                    links: Links.map({ $0.modelValue }))
            }

        }

        var Id: String
        var ImageId: String
        var Description: String
        var Entries: [JSONMapEntry]

        var modelValue: APIMap {
            return APIMap(identifier: Id,
                          imageIdentifier: ImageId,
                          mapDescription: Description,
                          entries: Entries.map({ $0.modelValue }))
        }

    }

    struct JSONImage: Decodable, ModelRepresenting {

        var Id: String
        var InternalReference: String

        var modelValue: APIImage {
            return APIImage(identifier: Id, internalReference: InternalReference)
        }

    }

    var KnowledgeGroups: Leaf<JSONKnowledgeGroup>
    var KnowledgeEntries: Leaf<JSONKnowledgeEntry>
    var Announcements: Leaf<JSONAnnouncement>
    var EventConferenceRooms: Leaf<JSONRoom>
    var Events: Leaf<JSONEvent>
    var EventConferenceTracks: Leaf<JSONTrack>
    var EventConferenceDays: Leaf<JSONEventConferenceDay>
    var Dealers: Leaf<JSONDealer>
    var Maps: Leaf<JSONMap>
    var Images: Leaf<JSONImage>

}

private protocol ModelRepresenting {
    associatedtype ModelType: Equatable

    var modelValue: ModelType { get }
}
