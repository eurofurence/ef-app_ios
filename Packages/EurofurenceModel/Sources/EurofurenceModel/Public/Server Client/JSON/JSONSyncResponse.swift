import Foundation

// swiftlint:disable nesting
struct JSONSyncResponse: Decodable {
    
    func asAPIResponse() -> ModelCharacteristics {
        return ModelCharacteristics(
            conventionIdentifier: ConventionIdentifier,
            knowledgeGroups: KnowledgeGroups.delta,
            knowledgeEntries: KnowledgeEntries.delta,
            announcements: Announcements.delta,
            events: Events.delta,
            rooms: EventConferenceRooms.delta,
            tracks: EventConferenceTracks.delta,
            conferenceDays: EventConferenceDays.delta,
            dealers: Dealers.delta,
            maps: Maps.delta,
            images: Images.delta
        )
    }
    
    private struct Leaf<T>: Decodable where T: Decodable & ModelRepresenting {
        var ChangedEntities: [T]
        var DeletedEntities: [String]
        var RemoveAllBeforeInsert: Bool
        
        var delta: ModelCharacteristics.Update<T.ModelType> {
            return ModelCharacteristics.Update(
                changed: ChangedEntities.map(\.modelValue),
                deleted: DeletedEntities,
                removeAllBeforeInsert: RemoveAllBeforeInsert
            )
        }
    }

    struct JSONKnowledgeGroup: Decodable, ModelRepresenting {
        var Id: String
        var Order: Int
        var Name: String
        var Description: String
        var FontAwesomeIconCharacterUnicodeAddress: String

        var modelValue: KnowledgeGroupCharacteristics {
            return KnowledgeGroupCharacteristics(
                identifier: Id,
                order: Order,
                groupName: Name,
                groupDescription: Description,
                fontAwesomeCharacterAddress: FontAwesomeIconCharacterUnicodeAddress
            )
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
            return KnowledgeEntryCharacteristics(
                identifier: Id,
                groupIdentifier: KnowledgeGroupId,
                title: Title,
                order: Order,
                text: Text,
                links: Links.map(\.modelValue),
                imageIdentifiers: ImageIds
            )
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
            return AnnouncementCharacteristics(
                identifier: Id,
                title: Title,
                content: Content,
                lastChangedDateTime: LastChangeDateTimeUtc,
                imageIdentifier: ImageId
            )
        }
        
    }
    
    struct JSONRoom: Decodable, ModelRepresenting {

        var Id: String
        var Name: String

        var modelValue: RoomCharacteristics {
            return RoomCharacteristics(identifier: Id, name: Name)
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
        var IsAcceptingFeedback: Bool
        
        var modelValue: EventCharacteristics {
            return EventCharacteristics(
                identifier: Id,
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
                tags: Tags,
                isAcceptingFeedback: IsAcceptingFeedback
            )
        }
        
    }

    struct JSONTrack: Decodable, ModelRepresenting {

        var Id: String
        var Name: String

        var modelValue: TrackCharacteristics {
            return TrackCharacteristics(identifier: Id, name: Name)
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
            return DealerCharacteristics(
                identifier: Id,
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
                links: Links?.map(\.modelValue),
                twitterHandle: TwitterHandle,
                telegramHandle: TelegramHandle,
                aboutTheArtistText: AboutTheArtistText,
                aboutTheArtText: AboutTheArtText,
                artPreviewCaption: ArtPreviewCaption
            )
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
                return MapCharacteristics.Entry(
                    identifier: Id,
                    x: X,
                    y: Y,
                    tapRadius: TapRadius,
                    links: Links.map(\.modelValue)
                )
            }

        }

        var Id: String
        var ImageId: String
        var Description: String
        var Order: Int
        var Entries: [JSONMapEntry]
        
        var modelValue: MapCharacteristics {
            return MapCharacteristics(
                identifier: Id,
                imageIdentifier: ImageId,
                mapDescription: Description,
                order: Order,
                entries: Entries.map(\.modelValue)
            )
        }
        
    }
    
    struct JSONImage: Decodable, ModelRepresenting {
        
        var Id: String
        var InternalReference: String
        var ContentHashSha1: String
        
        var modelValue: ImageCharacteristics {
            return ImageCharacteristics(
                identifier: Id,
                internalReference: InternalReference,
                contentHashSha1: ContentHashSha1
            )
        }
        
    }
    
    private var ConventionIdentifier: String
    private var KnowledgeGroups: Leaf<JSONKnowledgeGroup>
    private var KnowledgeEntries: Leaf<JSONKnowledgeEntry>
    private var Announcements: Leaf<JSONAnnouncement>
    private var EventConferenceRooms: Leaf<JSONRoom>
    private var Events: Leaf<JSONEvent>
    private var EventConferenceTracks: Leaf<JSONTrack>
    private var EventConferenceDays: Leaf<JSONEventConferenceDay>
    private var Dealers: Leaf<JSONDealer>
    private var Maps: Leaf<JSONMap>
    private var Images: Leaf<JSONImage>

}

private protocol ModelRepresenting {
    associatedtype ModelType: Equatable

    var modelValue: ModelType { get }
}
