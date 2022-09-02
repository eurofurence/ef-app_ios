@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.KnowledgeGroup {
    
    func assert(against actual: EurofurenceKit.KnowledgeGroup) throws {
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(name, actual.name)
        XCTAssertEqual(description, actual.knowledgeGroupDescription)
        XCTAssertEqual(order, Int(actual.order))
        XCTAssertEqual(fontAwesomeIconCharacterUnicodeAddress, actual.fontAwesomeUnicodeCharacterAddress)
    }
    
}
