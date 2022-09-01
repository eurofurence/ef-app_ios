import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension SynchronizationPayload {
    
    func image(identifiedBy id: EurofurenceWebAPI.Image.ID) throws -> EurofurenceWebAPI.Image {
        try XCTUnwrap(images.changed.first(where: { $0.id == id }))
    }
    
}

struct SyncResponseAssertion2 {
    
    var managedObjectContext: NSManagedObjectContext
    var synchronizationPayload: SynchronizationPayload
    
    func assert() throws {
        try managedObjectContext.performAndWait {
            try assertDays()
            try assertTracks()
            try assertRooms()
            try assertEvents()
            try assertKnowledgeGroups()
            try assertKnowledgeEntries()
            try assertDealers()
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
    
}

struct SyncResponseAssertion<Response> where Response: SyncResponseFile {
    
    var managedObjectContext: NSManagedObjectContext
    var response: Response
    
    func assert() throws {
        try managedObjectContext.performAndWait {
            try assertDays()
            try assertTracks()
            try assertRooms()
            try assertEvents()
            try assertKnowledgeGroups()
            try assertKnowledgeEntries()
            try assertDealers()
        }
    }
    
    private func assertDays() throws {
        for day in response.days {
            let entity: EurofurenceKit.Day = try managedObjectContext.entity(withIdentifier: day.identifier)
            day.assert(against: entity)
        }
    }
    
    private func assertTracks() throws {
        for track in response.tracks {
            let entity: EurofurenceKit.Track = try managedObjectContext.entity(withIdentifier: track.identifier)
            track.assert(against: entity)
        }
    }
    
    private func assertRooms() throws {
        for room in response.rooms {
            let entity: EurofurenceKit.Room = try managedObjectContext.entity(withIdentifier: room.identifier)
            room.assert(against: entity)
        }
    }
    
    private func assertEvents() throws {
        for event in response.events {
            let entity: EurofurenceKit.Event = try managedObjectContext.entity(withIdentifier: event.identifier)
            try event.assert(against: entity, in: managedObjectContext, from: response)
        }
    }
    
    private func assertKnowledgeGroups() throws {
        for knowledgeGroup in response.knowledgeGroups {
            let entity: EurofurenceKit.KnowledgeGroup = try managedObjectContext.entity(withIdentifier: knowledgeGroup.identifier)
            try knowledgeGroup.assert(against: entity)
        }
    }
    
    private func assertKnowledgeEntries() throws {
        for knowledgeEntry in response.knowledgeEntries {
            let entity: EurofurenceKit.KnowledgeEntry = try managedObjectContext.entity(withIdentifier: knowledgeEntry.identifier)
            try knowledgeEntry.assert(against: entity, in: managedObjectContext, from: response)
        }
    }
    
    private func assertDealers() throws {
        for dealer in response.dealers {
            let entity: EurofurenceKit.Dealer = try managedObjectContext.entity(withIdentifier: dealer.identifier)
            try dealer.assert(against: entity, in: managedObjectContext, from: response)
        }
    }
    
}
