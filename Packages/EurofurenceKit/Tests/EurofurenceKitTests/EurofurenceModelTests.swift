@testable import EurofurenceKit
import Logging
import XCTest

class EurofurenceKitTests: XCTestCase {
    
    func testIngestingRemoteResponse() async throws {
        let logger = Logger(label: "Test")
        let network = FakeNetwork()
        let configuration = EurofurenceModel.Configuration(environment: .memory, logger: logger)
        let model = EurofurenceModel(configuration: configuration)
        
        let (fileName, fileExtension) = ("EF26_Full_Sync_Response", "json")
        let fileURL = try XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: fileExtension))
        let fileContents = try Data(contentsOf: fileURL)
        let syncURL = try XCTUnwrap(URL(string: "https://app.eurofurence.org/EF26/api/Sync"))
        network.stub(url: syncURL, with: fileContents)
        await model.updateLocalStore()
        
        let expectedDays: [ExpectedDay] = [
            .init(
                lastUpdated: "2022-06-23T08:18:09.424Z",
                identifier: "db6e0b07-3300-4d58-adfd-84c145e36242",
                name: "Early Arrival",
                date: "2022-08-23T00:00:00.000Z"
            )
        ]
        
        let expectedTracks: [ExpectedTrack] = [
            .init(
                lastUpdated: "2022-06-23T08:18:09.205Z",
                identifier: "f23cc7f6-34c1-48d5-8acb-0ec10c353403",
                name: "Art Show"
            )
        ]
        
        for expectedDay in expectedDays {
            let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", expectedDay.identifier)
            let matches = try model.viewContext.fetch(fetchRequest)
            let match = try XCTUnwrap(matches.first)
            
            expectedDay.assert(against: match)
        }
        
        for expectedTrack in expectedTracks {
            let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", expectedTrack.identifier)
            let matches = try model.viewContext.fetch(fetchRequest)
            let match = try XCTUnwrap(matches.first)
            
            expectedTrack.assert(against: match)
        }
    }
    
}

struct ExpectedTrack {
    
    var lastUpdated: Date
    var identifier: String
    var name: String
    
    init(
        lastUpdated: String,
        identifier: String,
        name: String
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.name = name
    }
    
    func assert(against actual: Track) {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(name, actual.name)
    }
    
}

struct ExpectedDay {
    
    var lastUpdated: Date
    var identifier: String
    var name: String
    var date: Date
    
    init(
        lastUpdated: String,
        identifier: String,
        name: String,
        date: String
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.name = name
        self.date = dateFormatter.date(from: date)!
    }
    
    func assert(against actual: Day) {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(name, actual.name)
        XCTAssertEqual(date, actual.date)
    }
    
}
