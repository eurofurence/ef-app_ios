//
//  APISyncResponse+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation
import TestUtilities

extension ModelCharacteristics {

    static var randomWithoutDeletions: ModelCharacteristics {
        let knowledge = KnowledgeGroupCharacteristics.makeRandomGroupsAndEntries()
        let rooms = [RoomCharacteristics].random
        let tracks = [TrackCharacteristics].random
        let days = [ConferenceDayCharacteristics].random
        let events = (0...Int.random(upperLimit: 10) + 5).map { (_) -> EventCharacteristics in
            let eventStartTime: Date = .random
            return EventCharacteristics(identifier: .random,
                            roomIdentifier: rooms.randomElement().element.roomIdentifier,
                            trackIdentifier: tracks.randomElement().element.trackIdentifier,
                            dayIdentifier: days.randomElement().element.identifier,
                            startDateTime: eventStartTime,
                            endDateTime: eventStartTime.addingTimeInterval(.random),
                            title: .random,
                            subtitle: .random,
                            abstract: .random,
                            panelHosts: .random,
                            eventDescription: .random,
                            posterImageId: .random,
                            bannerImageId: .random,
                            tags: .random)
        }

        let dealers: ModelCharacteristics.Update<DealerCharacteristics> = ModelCharacteristics.Update(changed: .random)
        let maps: ModelCharacteristics.Update<MapCharacteristics> = ModelCharacteristics.Update(changed: .random)

        var allImages: [ImageCharacteristics] = events.compactMap({ $0.bannerImageId }).map({ ImageCharacteristics(identifier: $0, internalReference: "") })
        allImages.append(contentsOf: events.compactMap({ $0.posterImageId }).map({ ImageCharacteristics(identifier: $0, internalReference: "") }))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artistImageId }).map({ ImageCharacteristics(identifier: $0, internalReference: "") }))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artistThumbnailImageId }).map({ ImageCharacteristics(identifier: $0, internalReference: "") }))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artPreviewImageId }).map({ ImageCharacteristics(identifier: $0, internalReference: "") }))
        allImages.append(contentsOf: maps.changed.map({ ImageCharacteristics(identifier: $0.imageIdentifier, internalReference: "") }))

        let knowledgeEntryImages = knowledge.entries.reduce([String](), { $0 + $1.imageIdentifiers })
        let knowledgeEntryAPIImages = knowledgeEntryImages.map({ ImageCharacteristics(identifier: $0, internalReference: "") })
        allImages.append(contentsOf: knowledgeEntryAPIImages)

        let announcements = [AnnouncementCharacteristics].random
        let announcementImages = announcements.compactMap({ $0.imageIdentifier }).map({ ImageCharacteristics(identifier: $0, internalReference: "") })
        allImages.append(contentsOf: announcementImages)

        return ModelCharacteristics(knowledgeGroups: ModelCharacteristics.Update(changed: knowledge.groups),
                               knowledgeEntries: ModelCharacteristics.Update(changed: knowledge.entries),
                               announcements: ModelCharacteristics.Update(changed: announcements),
                               events: ModelCharacteristics.Update(changed: events),
                               rooms: ModelCharacteristics.Update(changed: rooms),
                               tracks: ModelCharacteristics.Update(changed: tracks),
                               conferenceDays: ModelCharacteristics.Update(changed: days),
                               dealers: dealers,
                               maps: maps,
                               images: ModelCharacteristics.Update(changed: allImages))
    }

}

extension KnowledgeGroupCharacteristics: RandomValueProviding {

    public static var random: KnowledgeGroupCharacteristics {
        return KnowledgeGroupCharacteristics(identifier: .random,
                                 order: .random,
                                 groupName: .random,
                                 groupDescription: .random,
                                 fontAwesomeCharacterAddress: "\(Int.random(upperLimit: 100))")
    }

    static func makeRandomGroupsAndEntries() -> (groups: [KnowledgeGroupCharacteristics], entries: [KnowledgeEntryCharacteristics]) {
        let knowledgeGroups = [KnowledgeGroupCharacteristics].random
        var knowledgeEntries = [KnowledgeEntryCharacteristics]()
        for group in knowledgeGroups {
            let upperLimit = Int.random(upperLimit: 10) + 1
            let range = 0..<upperLimit
            let entries = range.map({ (_) -> KnowledgeEntryCharacteristics in
                var entry = KnowledgeEntryCharacteristics.random
                entry.groupIdentifier = group.identifier
                return entry
            })

            knowledgeEntries.append(contentsOf: entries)
        }

        return (groups: knowledgeGroups, entries: knowledgeEntries)
    }

}

extension KnowledgeEntryCharacteristics: RandomValueProviding {

    public static var random: KnowledgeEntryCharacteristics {
        let links = [LinkCharacteristics].random.sorted()
        return KnowledgeEntryCharacteristics(identifier: .random,
                                 groupIdentifier: .random,
                                 title: .random,
                                 order: .random,
                                 text: .random,
                                 links: links,
                                 imageIdentifiers: .random)
    }

}

extension LinkCharacteristics: RandomValueProviding {

    public static var random: LinkCharacteristics {
        return LinkCharacteristics(name: .random, fragmentType: .random, target: .random)
    }

}

extension LinkCharacteristics.FragmentType: RandomValueProviding {

    public static var random: LinkCharacteristics.FragmentType {
        return .WebExternal
    }

}

extension AnnouncementCharacteristics: RandomValueProviding {

    public static var random: AnnouncementCharacteristics {
        return AnnouncementCharacteristics(identifier: .random,
                               title: .random,
                               content: .random,
                               lastChangedDateTime: .random,
                               imageIdentifier: .random)
    }

}

extension RoomCharacteristics: RandomValueProviding {

    public static var random: RoomCharacteristics {
        return RoomCharacteristics(roomIdentifier: .random, name: .random)
    }

}

extension TrackCharacteristics: RandomValueProviding {

    public static var random: TrackCharacteristics {
        return TrackCharacteristics(trackIdentifier: .random, name: .random)
    }

}

extension EventCharacteristics: RandomValueProviding {

    public static var random: EventCharacteristics {
        return EventCharacteristics(identifier: .random,
                        roomIdentifier: .random,
                        trackIdentifier: .random,
                        dayIdentifier: .random,
                        startDateTime: .random,
                        endDateTime: .random,
                        title: .random,
                        subtitle: .random,
                        abstract: .random,
                        panelHosts: .random,
                        eventDescription: .random,
                        posterImageId: .random,
                        bannerImageId: .random,
                        tags: .random)
    }

}

extension ConferenceDayCharacteristics: RandomValueProviding {

    public static var random: ConferenceDayCharacteristics {
        return ConferenceDayCharacteristics(identifier: .random, date: .random)
    }

}

extension DealerCharacteristics: RandomValueProviding {

    public static var random: DealerCharacteristics {
        return DealerCharacteristics(identifier: .random,
                         displayName: .random,
                         attendeeNickname: .random,
                         attendsOnThursday: .random,
                         attendsOnFriday: .random,
                         attendsOnSaturday: .random,
                         isAfterDark: .random,
                         artistThumbnailImageId: .random,
                         artistImageId: .random,
                         artPreviewImageId: .random,
                         categories: .random,
                         shortDescription: .random,
                         links: [LinkCharacteristics].random.sorted(),
                         twitterHandle: .random,
                         telegramHandle: .random,
                         aboutTheArtistText: .random,
                         aboutTheArtText: .random,
                         artPreviewCaption: .random)
    }

}

extension MapCharacteristics: RandomValueProviding {

    public static var random: MapCharacteristics {
        return MapCharacteristics(identifier: .random, imageIdentifier: .random, mapDescription: .random, entries: .random)
    }

}

extension MapCharacteristics.Entry: RandomValueProviding {

    public static var random: MapCharacteristics.Entry {
        return MapCharacteristics.Entry(identifier: .random, x: .random, y: .random, tapRadius: .random, links: .random)
    }

}

extension MapCharacteristics.Entry.Link: RandomValueProviding {

    public static var random: MapCharacteristics.Entry.Link {
        return MapCharacteristics.Entry.Link(type: .random, name: .random, target: .random)
    }

}

extension MapCharacteristics.Entry.Link.FragmentType: RandomValueProviding {

    public static var random: MapCharacteristics.Entry.Link.FragmentType {
        let cases: [MapCharacteristics.Entry.Link.FragmentType] = [.conferenceRoom, .mapEntry, .dealerDetail]
        return cases.randomElement().element
    }

}

extension ImageCharacteristics: RandomValueProviding {

    public static var random: ImageCharacteristics {
        return ImageCharacteristics(identifier: .random, internalReference: .random)
    }

}
