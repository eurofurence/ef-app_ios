//
//  APISyncResponse+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension APISyncResponse {
    
    static var randomWithoutDeletions: APISyncResponse {
        let knowledge = APIKnowledgeGroup.makeRandomGroupsAndEntries()
        let rooms = [APIRoom].random
        let tracks = [APITrack].random
        let days = [APIConferenceDay].random
        let events = (0...Int.random(upperLimit: 10) + 5).map { (_) -> APIEvent in
            let eventStartTime: Date = .random
            return APIEvent(identifier: .random,
                            roomIdentifier: rooms.randomElement().element.roomIdentifier,
                            trackIdentifier: tracks.randomElement().element.trackIdentifier,
                            dayIdentifier: days.randomElement().element.identifier,
                            startDateTime: eventStartTime,
                            endDateTime: eventStartTime.addingTimeInterval(.random),
                            title: .random,
                            abstract: .random,
                            panelHosts: .random,
                            eventDescription: .random,
                            posterImageId: .random,
                            bannerImageId: .random)
        }
        
        let dealers: APISyncDelta<APIDealer> = APISyncDelta(changed: .random)
        let maps: APISyncDelta<APIMap> = APISyncDelta(changed: .random)
        
        var allImages: [APIImage] = events.compactMap({ $0.bannerImageId }).map({ APIImage(identifier: $0, internalReference: "") })
        allImages.append(contentsOf: events.compactMap({ $0.posterImageId }).map({ APIImage(identifier: $0, internalReference: "") }))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artistImageId }).map({ APIImage(identifier: $0, internalReference: "") }))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artistThumbnailImageId }).map({ APIImage(identifier: $0, internalReference: "") }))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artPreviewImageId }).map({ APIImage(identifier: $0, internalReference: "") }))
        allImages.append(contentsOf: maps.changed.map({ APIImage(identifier: $0.imageIdentifier, internalReference: "") }))
        
        return APISyncResponse(knowledgeGroups: APISyncDelta(changed: knowledge.groups),
                               knowledgeEntries: APISyncDelta(changed: knowledge.entries),
                               announcements: APISyncDelta(changed: .random),
                               events: APISyncDelta(changed: events),
                               rooms: APISyncDelta(changed: rooms),
                               tracks: APISyncDelta(changed: tracks),
                               conferenceDays: APISyncDelta(changed: days),
                               dealers: dealers,
                               maps: maps,
                               images: APISyncDelta(changed: allImages))
    }
    
}

extension APIKnowledgeGroup: RandomValueProviding {
    
    static var random: APIKnowledgeGroup {
        return APIKnowledgeGroup(identifier: .random,
                                 order: .random,
                                 groupName: .random,
                                 groupDescription: .random,
                                 fontAwesomeCharacterAddress: "\(Int.random(upperLimit: 100))")
    }
    
    static func makeRandomGroupsAndEntries() -> (groups: [APIKnowledgeGroup], entries: [APIKnowledgeEntry]) {
        let knowledgeGroups = [APIKnowledgeGroup].random
        var knowledgeEntries = [APIKnowledgeEntry]()
        for group in knowledgeGroups {
            let upperLimit = Int.random(upperLimit: 10) + 1
            let range = 0..<upperLimit
            let entries = range.map({ (_) -> APIKnowledgeEntry in
                var entry = APIKnowledgeEntry.random
                entry.groupIdentifier = group.identifier
                return entry
            })
            
            knowledgeEntries.append(contentsOf: entries)
        }
        
        return (groups: knowledgeGroups, entries: knowledgeEntries)
    }
    
}

extension APIKnowledgeEntry: RandomValueProviding {
    
    static var random: APIKnowledgeEntry {
        let links = [APILink].random.sorted()
        return APIKnowledgeEntry(identifier: .random,
                                 groupIdentifier: .random,
                                 title: .random,
                                 order: .random,
                                 text: .random,
                                 links: links)
    }
    
}

extension APILink: RandomValueProviding {
    
    static var random: APILink {
        return APILink(name: .random, fragmentType: .random, target: .random)
    }
    
}

extension APILink.FragmentType: RandomValueProviding {
    
    static var random: APILink.FragmentType {
        return .WebExternal
    }
    
}

extension APIAnnouncement: RandomValueProviding {
    
    static var random: APIAnnouncement {
        return APIAnnouncement(identifier: .random, title: .random, content: .random, lastChangedDateTime: .random)
    }
    
}

extension APIRoom: RandomValueProviding {
    
    static var random: APIRoom {
        return APIRoom(roomIdentifier: .random, name: .random)
    }
    
}

extension APITrack: RandomValueProviding {
    
    static var random: APITrack {
        return APITrack(trackIdentifier: .random, name: .random)
    }
    
}

extension APIEvent: RandomValueProviding {
    
    static var random: APIEvent {
        return APIEvent(identifier: .random,
                        roomIdentifier: .random,
                        trackIdentifier: .random,
                        dayIdentifier: .random,
                        startDateTime: .random,
                        endDateTime: .random,
                        title: .random,
                        abstract: .random,
                        panelHosts: .random,
                        eventDescription: .random,
                        posterImageId: .random,
                        bannerImageId: .random)
    }
    
}

extension APIConferenceDay: RandomValueProviding {
    
    static var random: APIConferenceDay {
        return APIConferenceDay(identifier: .random, date: .random)
    }
    
}

extension APIDealer: RandomValueProviding {
    
    static var random: APIDealer {
        return APIDealer(identifier: .random,
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
                         links: [APILink].random.sorted(),
                         twitterHandle: .random,
                         telegramHandle: .random,
                         aboutTheArtistText: .random,
                         aboutTheArtText: .random,
                         artPreviewCaption: .random)
    }
    
}

extension APIMap: RandomValueProviding {
    
    static var random: APIMap {
        return APIMap(identifier: .random, imageIdentifier: .random, mapDescription: .random, entries: .random)
    }
    
}

extension APIMap.Entry: RandomValueProviding {
    
    static var random: APIMap.Entry {
        return APIMap.Entry(x: .random, y: .random, tapRadius: .random, links: .random)
    }
    
}

extension APIMap.Entry.Link: RandomValueProviding {
    
    static var random: APIMap.Entry.Link {
        return APIMap.Entry.Link(type: .random, name: .random, target: .random)
    }
    
}

extension APIMap.Entry.Link.FragmentType: RandomValueProviding {
    
    static var random: APIMap.Entry.Link.FragmentType {
        let cases: [APIMap.Entry.Link.FragmentType] = [.conferenceRoom, .mapEntry, .dealerDetail]
        return cases.randomElement().element
    }
    
}

extension APIImage: RandomValueProviding {
    
    static var random: APIImage {
        return APIImage(identifier: .random, internalReference: .random)
    }
    
}
