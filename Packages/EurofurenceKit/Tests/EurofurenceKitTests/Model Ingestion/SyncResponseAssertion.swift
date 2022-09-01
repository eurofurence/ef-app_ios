import CoreData
@testable import EurofurenceKit

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
        }
    }
    
    private func assertDays() throws {
        for day in response.days {
            let entity: Day = try managedObjectContext.entity(withIdentifier: day.identifier)
            day.assert(against: entity)
        }
    }
    
    private func assertTracks() throws {
        for track in response.tracks {
            let entity: Track = try managedObjectContext.entity(withIdentifier: track.identifier)
            track.assert(against: entity)
        }
    }
    
    private func assertRooms() throws {
        for room in response.rooms {
            let entity: Room = try managedObjectContext.entity(withIdentifier: room.identifier)
            room.assert(against: entity)
        }
    }
    
    private func assertEvents() throws {
        for event in response.events {
            let entity: Event = try managedObjectContext.entity(withIdentifier: event.identifier)
            try event.assert(against: entity, in: managedObjectContext, from: response)
        }
    }
    
    private func assertKnowledgeGroups() throws {
        for knowledgeGroup in response.knowledgeGroups {
            let entity: KnowledgeGroup = try managedObjectContext.entity(withIdentifier: knowledgeGroup.identifier)
            try knowledgeGroup.assert(against: entity)
        }
    }
    
}
