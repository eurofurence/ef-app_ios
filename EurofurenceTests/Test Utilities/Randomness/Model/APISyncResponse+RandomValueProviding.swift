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
        let knowledgeGroups = APISyncDelta<APIKnowledgeGroup>(changed: .random)
        var knowledgeEntries = [APIKnowledgeEntry]()
        for group in knowledgeGroups.changed {
            let upperLimit = Int.random(upperLimit: 10) + 1
            let range = 0..<upperLimit
            let entries = range.map({ (_) -> APIKnowledgeEntry in
                var entry = APIKnowledgeEntry.random
                entry.groupIdentifier = group.identifier
                return entry
            })
            
            knowledgeEntries.append(contentsOf: entries)
        }
        
        let rooms = [APIRoom].random
        let events = (0...Int.random(upperLimit: 10) + 5).map { (_) -> APIEvent in
            let eventStartTime: Date = .random
            return APIEvent(roomIdentifier: rooms.randomElement().element.roomIdentifier,
                            startDateTime: eventStartTime,
                            endDateTime: eventStartTime.addingTimeInterval(.random),
                            title: .random)
        }
        
        return APISyncResponse(knowledgeGroups: knowledgeGroups,
                               knowledgeEntries: APISyncDelta(changed: knowledgeEntries),
                               announcements: APISyncDelta(changed: .random),
                               events: APISyncDelta(changed: events),
                               rooms: APISyncDelta(changed: rooms))
    }
    
}

extension APIKnowledgeGroup: RandomValueProviding {
    
    static var random: APIKnowledgeGroup {
        return APIKnowledgeGroup(identifier: .random, order: .random, groupName: .random, groupDescription: .random)
    }
    
}

extension APIKnowledgeEntry: RandomValueProviding {
    
    static var random: APIKnowledgeEntry {
        return APIKnowledgeEntry(groupIdentifier: .random, title: .random, order: .random, text: .random, links: .random)
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
