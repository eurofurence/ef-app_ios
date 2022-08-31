import CoreData
@testable import EurofurenceKit
import XCTest

protocol SyncResponseFile: SampleResponseFile {
    
    var days: [ExpectedDay] { get }
    var tracks: [ExpectedTrack] { get }
    var rooms: [ExpectedRoom] { get }
    var events: [ExpectedEvent] { get }
    var images: [ExpectedImage] { get }
    
}

extension SyncResponseFile {
    
    func image(identifiedBy identifier: String) throws -> ExpectedImage {
        try XCTUnwrap(images.first(where: { $0.identifier == identifier }))
    }
    
    func assertAgainstEntities(in context: NSManagedObjectContext) throws {
        for day in days {
            let entity: Day = try context.entity(withIdentifier: day.identifier)
            day.assert(against: entity)
        }
        
        for track in tracks {
            let entity: Track = try context.entity(withIdentifier: track.identifier)
            track.assert(against: entity)
        }
        
        for room in rooms {
            let entity: Room = try context.entity(withIdentifier: room.identifier)
            room.assert(against: entity)
        }
        
        for event in events {
            let entity: Event = try context.entity(withIdentifier: event.identifier)
            try event.assert(against: entity, in: context, from: self)
        }
    }
    
}
