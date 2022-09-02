import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension SynchronizationPayload {
    
    func image(identifiedBy id: EurofurenceWebAPI.Image.ID) throws -> EurofurenceWebAPI.Image {
        try XCTUnwrap(images.changed.first(where: { $0.id == id }))
    }
    
}

struct SynchronizedStoreAssertion {
    
    var managedObjectContext: NSManagedObjectContext
    var synchronizationPayload: SynchronizationPayload
    
    func assert() throws {
        var assertionError: Error?
        managedObjectContext.performAndWait {
            do {
                try assertDays()
                try assertTracks()
                try assertRooms()
                try assertEvents()
                try assertKnowledgeGroups()
                try assertKnowledgeEntries()
                try assertDealers()
                try assertAnnouncements()
                try assertMaps()
            } catch {
                assertionError = error
            }
        }
        
        if let assertionError = assertionError {
            throw assertionError
        }
    }
    
    private func assertDays() throws {
        for day in synchronizationPayload.days.changed {
            let entity: EurofurenceKit.Day = try managedObjectContext.entity(withIdentifier: day.id)
            day.assert(against: entity)
        }
    }
    
    private func assertTracks() throws {
        for track in synchronizationPayload.tracks.changed {
            let entity: EurofurenceKit.Track = try managedObjectContext.entity(withIdentifier: track.id)
            track.assert(against: entity)
        }
    }
    
    private func assertRooms() throws {
        for room in synchronizationPayload.rooms.changed {
            let entity: EurofurenceKit.Room = try managedObjectContext.entity(withIdentifier: room.id)
            room.assert(against: entity)
        }
    }
    
    private func assertEvents() throws {
        for event in synchronizationPayload.events.changed {
            let entity: EurofurenceKit.Event = try managedObjectContext.entity(withIdentifier: event.id)
            try event.assert(against: entity, in: managedObjectContext, from: synchronizationPayload)
        }
    }

    private func assertKnowledgeGroups() throws {
        for knowledgeGroup in synchronizationPayload.knowledgeGroups.changed {
            let entity: EurofurenceKit.KnowledgeGroup = try managedObjectContext.entity(withIdentifier: knowledgeGroup.id)
            try knowledgeGroup.assert(against: entity)
        }
    }

    private func assertKnowledgeEntries() throws {
        for knowledgeEntry in synchronizationPayload.knowledgeEntries.changed {
            let entity: EurofurenceKit.KnowledgeEntry = try managedObjectContext.entity(withIdentifier: knowledgeEntry.id)
            try knowledgeEntry.assert(against: entity, in: managedObjectContext, from: synchronizationPayload)
        }
    }

    private func assertDealers() throws {
        for dealer in synchronizationPayload.dealers.changed {
            let entity: EurofurenceKit.Dealer = try managedObjectContext.entity(withIdentifier: dealer.id)
            try dealer.assert(against: entity, in: managedObjectContext, from: synchronizationPayload)
        }
    }
    
    private func assertAnnouncements() throws {
        for announcement in synchronizationPayload.announcements.changed {
            let entity: EurofurenceKit.Announcement = try managedObjectContext.entity(withIdentifier: announcement.id)
            try announcement.assert(against: entity, in: managedObjectContext, from: synchronizationPayload)
        }
    }
    
    private func assertMaps() throws {
        for map in synchronizationPayload.maps.changed {
            let entity: EurofurenceKit.Map = try managedObjectContext.entity(withIdentifier: map.id)
            try map.assert(against: entity, in: managedObjectContext, from: synchronizationPayload)
        }
    }
    
}
