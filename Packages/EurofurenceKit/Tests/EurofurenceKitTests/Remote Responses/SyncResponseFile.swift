import CoreData
@testable import EurofurenceKit
import XCTest

protocol SyncResponseFile: SampleResponseFile {
    
    var days: [ExpectedDay] { get }
    var tracks: [ExpectedTrack] { get }
    
}

extension SyncResponseFile {
    
    func assertAgainstEntities(in context: NSManagedObjectContext) throws {
        for day in days {
            let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", day.identifier)
            let matches = try context.fetch(fetchRequest)
            let match = try XCTUnwrap(matches.first)
            
            day.assert(against: match)
        }
        
        for track in tracks {
            let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", track.identifier)
            let matches = try context.fetch(fetchRequest)
            let match = try XCTUnwrap(matches.first)
            
            track.assert(against: match)
        }
    }
    
}
