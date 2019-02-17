//
//  JSONAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct JSONAPI: API, LoginAPI, PrivateMessagesAPI, SyncAPI {

    // MARK: Properties

    private let jsonSession: JSONSession
    private let apiUrl: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: Initialization

    public init(jsonSession: JSONSession, apiUrl: APIURLProviding) {
        self.jsonSession = jsonSession
        self.apiUrl = apiUrl.url

        // TODO: Investigate why system ios8601 formatter fails to parse our dates
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter())

        encoder = JSONEncoder()
    }

    // MARK: LoginAPI

    public func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        let url = apiUrl + "Tokens/RegSys"
        let request: Request.Login = Request.Login(RegNo: request.regNo, Username: request.username, Password: request.password)
        let jsonData = try! encoder.encode(request)
        let jsonRequest = JSONRequest(url: url, body: jsonData)

        jsonSession.post(jsonRequest) { (data, _) in
            if let data = data, let response = try? self.decoder.decode(Response.Login.self, from: data) {
                completionHandler(response.makeDomainLoginResponse())
            } else {
                completionHandler(nil)
            }
        }
    }

    // MARK: ImageAPI

    public func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        let url = apiUrl + "Images/\(identifier)/Content"
        let request = JSONRequest(url: url)

        jsonSession.get(request) { (data, _) in
            completionHandler(data)
        }
    }

    // MARK: PrivateMessagesAPI

    public func loadPrivateMessages(authorizationToken: String,
                                    completionHandler: @escaping ([MessageCharacteristics]?) -> Void) {
        let url = apiUrl + "Communication/PrivateMessages"
        var request = JSONRequest(url: url)
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]

        jsonSession.get(request) { (data, _) in
            var messages: [MessageCharacteristics]?
            defer { completionHandler(messages) }

            guard let data = data else { return }

            if let jsonMessages = try? self.decoder.decode([Response.Message].self, from: data) {
                messages = jsonMessages.map({ $0.makeAppDomainMessage() })
            }
        }
    }

    public func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        let url = apiUrl + "Communication/PrivateMessages/\(identifier)/Read"
        let messageContentsToSupportSwagger = "true".data(using: .utf8)!
        var request = JSONRequest(url: url, body: messageContentsToSupportSwagger)
        request.headers = ["Authorization": "Bearer \(authorizationToken)"]

        jsonSession.post(request, completionHandler: { (_, _)  in })
    }

    // MARK: SyncAPI

    public func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void) {
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
            var response: ModelCharacteristics?
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

    // MARK: Private

    private struct Request {

        struct Login: Encodable {
            var RegNo: Int
            var Username: String
            var Password: String
        }

    }

    private struct Response {

        struct Login: Decodable {
            var Uid: String
            var Username: String
            var Token: String
            var TokenValidUntil: Date

            func makeDomainLoginResponse() -> LoginResponse {
                return LoginResponse(userIdentifier: Uid,
                                     username: Username,
                                     token: Token,
                                     tokenValidUntil: TokenValidUntil)
            }
        }

        struct Message: Decodable {

            var id: String
            var authorName: String
            var subject: String
            var message: String
            var receivedDateTime: Date
            var readDateTime: Date?

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try container.decode(String.self, forKey: .id)
                authorName = try container.decode(String.self, forKey: .authorName)
                subject = try container.decode(String.self, forKey: .subject)
                message = try container.decode(String.self, forKey: .message)
                receivedDateTime = try container.decode(Date.self, forKey: .receivedDateTime)

                if let readTime = try? container.decodeIfPresent(Date.self, forKey: .readDateTime) {
                    readDateTime = readTime
                }
            }

            private enum CodingKeys: String, CodingKey {
                case id = "Id"
                case authorName = "AuthorName"
                case subject = "Subject"
                case message = "Message"
                case receivedDateTime = "ReceivedDateTimeUtc"
                case readDateTime = "ReadDateTimeUtc"
            }

            func makeAppDomainMessage() -> EurofurenceModel.MessageCharacteristics {
                return EurofurenceModel.MessageCharacteristics(identifier: id,
                                                authorName: authorName,
                                                receivedDateTime: receivedDateTime,
                                                subject: subject,
                                                contents: message,
                                                isRead: readDateTime != nil)
            }

        }

    }

}

private struct JSONSyncResponse: Decodable {

    func asAPIResponse() -> ModelCharacteristics {
        return ModelCharacteristics(knowledgeGroups: KnowledgeGroups.delta,
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

        var delta: ModelCharacteristics.Update<T.ModelType> {
            return ModelCharacteristics.Update(changed: ChangedEntities.map({ $0.modelValue }),
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

        var modelValue: KnowledgeGroupCharacteristics {
            return KnowledgeGroupCharacteristics(identifier: Id,
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

        var modelValue: KnowledgeEntryCharacteristics {
            return KnowledgeEntryCharacteristics(identifier: Id,
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

            var modelValue: LinkCharacteristics.FragmentType {
                switch self {
                case JSONLink.JSONFragmentType.WebExternal:
                    return LinkCharacteristics.FragmentType.WebExternal
                }
            }
        }

        var Name: String
        var FragmentType: JSONFragmentType
        var Target: String

        var modelValue: LinkCharacteristics {
            return LinkCharacteristics(name: Name, fragmentType: FragmentType.modelValue, target: Target)
        }
    }

    struct JSONAnnouncement: Decodable, ModelRepresenting {

        var Id: String
        var Title: String
        var Content: String
        var LastChangeDateTimeUtc: Date
        var ImageId: String?

        var modelValue: AnnouncementCharacteristics {
            return AnnouncementCharacteristics(identifier: Id,
                                   title: Title,
                                   content: Content,
                                   lastChangedDateTime: LastChangeDateTimeUtc,
                                   imageIdentifier: ImageId)
        }

    }

    struct JSONRoom: Decodable, ModelRepresenting {

        var Id: String
        var Name: String

        var modelValue: RoomCharacteristics {
            return RoomCharacteristics(roomIdentifier: Id, name: Name)
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

        var modelValue: EventCharacteristics {
            return EventCharacteristics(identifier: Id,
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

        var modelValue: TrackCharacteristics {
            return TrackCharacteristics(trackIdentifier: Id, name: Name)
        }

    }

    struct JSONEventConferenceDay: Decodable, ModelRepresenting {

        var Id: String
        var Date: Date

        var modelValue: ConferenceDayCharacteristics {
            return ConferenceDayCharacteristics(identifier: Id, date: Date)
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

        var modelValue: DealerCharacteristics {
            return DealerCharacteristics(identifier: Id,
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

                    var modelValue: MapCharacteristics.Entry.Link.FragmentType {
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

                var modelValue: MapCharacteristics.Entry.Link {
                    return MapCharacteristics.Entry.Link(type: FragmentType.modelValue, name: Name, target: Target)
                }
            }

            var Id: String
            var X: Int
            var Y: Int
            var TapRadius: Int
            var Links: [JSONMapEntryLink]

            var modelValue: MapCharacteristics.Entry {
                return MapCharacteristics.Entry(identifier: Id,
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

        var modelValue: MapCharacteristics {
            return MapCharacteristics(identifier: Id,
                          imageIdentifier: ImageId,
                          mapDescription: Description,
                          entries: Entries.map({ $0.modelValue }))
        }

    }

    struct JSONImage: Decodable, ModelRepresenting {

        var Id: String
        var InternalReference: String

        var modelValue: ImageCharacteristics {
            return ImageCharacteristics(identifier: Id, internalReference: InternalReference)
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
