@testable import EurofurenceKit
import class EurofurenceWebAPI.EurofurenceISO8601DateFormatter
import Foundation
import XCTest

struct ExpectedKnowledgeGroup {
    
    var lastUpdated: Date
    var identifier: String
    var name: String
    var description: String
    var order: Int
    var fontAwesomeCharacterAddress: String
    
    init(
        lastUpdated: String,
        identifier: String,
        name: String,
        description: String,
        order: Int,
        fontAwesomeCharacterAddress: String
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.name = name
        self.description = description
        self.order = order
        self.fontAwesomeCharacterAddress = fontAwesomeCharacterAddress
    }
    
    func assert(against actual: KnowledgeGroup) throws {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(name, actual.name)
        XCTAssertEqual(description, actual.knowledgeGroupDescription)
        XCTAssertEqual(order, Int(actual.order))
        XCTAssertEqual(fontAwesomeCharacterAddress, actual.fontAwesomeUnicodeCharacterAddress)
    }
    
}
