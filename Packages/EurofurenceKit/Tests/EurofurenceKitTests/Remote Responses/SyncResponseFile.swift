import CoreData
@testable import EurofurenceKit
import XCTest

protocol SyncResponseFile: SampleResponseFile {
    
    var currentDate: Date { get }
    
    var days: [ExpectedDay] { get }
    var tracks: [ExpectedTrack] { get }
    var rooms: [ExpectedRoom] { get }
    var events: [ExpectedEvent] { get }
    var images: [ExpectedImage] { get }
    var knowledgeGroups: [ExpectedKnowledgeGroup] { get }
    var knowledgeEntries: [ExpectedKnowledgeEntry] { get }
    var dealers: [ExpectedDealer] { get }
    
}

extension SyncResponseFile {
    
    func image(identifiedBy identifier: String) throws -> ExpectedImage {
        try XCTUnwrap(images.first(where: { $0.identifier == identifier }))
    }
    
    func assertAgainstEntities(in context: NSManagedObjectContext) throws {
        let assertion = SyncResponseAssertion(managedObjectContext: context, response: self)
        try assertion.assert()
    }
    
}
