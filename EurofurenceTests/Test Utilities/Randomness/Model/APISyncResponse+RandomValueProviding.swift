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
        let events = (0...Int.random(upperLimit: 10) + 5).map { (_) -> APIEvent in
            let eventStartTime: Date = .random
            return APIEvent(roomIdentifier: rooms.randomElement().element.roomIdentifier,
                            trackIdentifier: tracks.randomElement().element.trackIdentifier,
                            startDateTime: eventStartTime,
                            endDateTime: eventStartTime.addingTimeInterval(.random),
                            title: .random,
                            abstract: .random,
                            panelHosts: .random,
                            eventDescription: .random,
                            posterImageId: .random,
                            bannerImageId: .random)
        }
        
        return APISyncResponse(knowledgeGroups: APISyncDelta(changed: knowledge.groups),
                               knowledgeEntries: APISyncDelta(changed: knowledge.entries),
                               announcements: APISyncDelta(changed: .random),
                               events: APISyncDelta(changed: events),
                               rooms: APISyncDelta(changed: rooms),
                               tracks: APISyncDelta(changed: tracks))
    }
    
}

extension APIKnowledgeGroup: RandomValueProviding {
    
    static var random: APIKnowledgeGroup {
        return APIKnowledgeGroup(identifier: .random, order: .random, groupName: .random, groupDescription: .random)
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
        return APIKnowledgeEntry(groupIdentifier: .random, title: .random, order: .random, text: .random, links: links)
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
        return APIAnnouncement(title: .random, content: .random, lastChangedDateTime: .random)
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
