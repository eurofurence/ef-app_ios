@testable import EurofurenceKit
import Logging
import XCTest

class EurofurenceKitTests: XCTestCase {
    
    func testCanConfigureInMemoryStore() throws {
        let logger = Logger(label: "Test")
        let configuration = EurofurenceModel.Configuration(environment: .memory, logger: logger)
        let model = EurofurenceModel(configuration: configuration)
        let managedObjectContext = model.viewContext
        
        XCTAssertNotNil(managedObjectContext.persistentStoreCoordinator)
    }
    
    func testIngestingRemoteResponse_Days() async throws {
        let logger = Logger(label: "Test")
        let configuration = EurofurenceModel.Configuration(environment: .memory, logger: logger)
        let model = EurofurenceModel(configuration: configuration)
        
        let (fileName, fileExtension) = ("EF26_Full_Sync_Response", "json")
        let fileURL = try XCTUnwrap(Bundle.module.url(forResource: fileName, withExtension: fileExtension))
        let fileContents = try Data(contentsOf: fileURL)
        await model.updateLocalStore(remoteResponse: fileContents)
        
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
        
        let expectedDays: [ExpectedDay] = [
            .init(
                lastUpdated: "2022-06-23T08:18:09.424Z",
                identifier: "db6e0b07-3300-4d58-adfd-84c145e36242",
                name: "Early Arrival",
                date: "2022-08-23T00:00:00.000Z"
            )
        ]
        
        for expectedDay in expectedDays {
            let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "identifier == %@", expectedDay.identifier)
            let matches = try model.viewContext.fetch(fetchRequest)
            let match = try XCTUnwrap(matches.first)
            
            expectedDay.assert(against: match)
        }
    }
    
}
