import EurofurenceKit
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
    
}
