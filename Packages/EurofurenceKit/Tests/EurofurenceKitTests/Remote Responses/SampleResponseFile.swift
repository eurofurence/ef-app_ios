import CoreData
@testable import EurofurenceKit
import XCTest

protocol SampleResponseFile {
    
    var jsonFileName: String { get }
    
    var days: [ExpectedDay] { get }
    var tracks: [ExpectedTrack] { get }
    
}

extension SampleResponseFile {
    
    func loadFileContents() throws -> Data {
        let fileURL = try XCTUnwrap(Bundle.module.url(forResource: jsonFileName, withExtension: "json"))
        let fileContents = try Data(contentsOf: fileURL)
        
        return fileContents
    }
    
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
