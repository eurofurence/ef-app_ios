@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

extension EurofurenceWebAPI.Image {
    
    func assert(against actual: EurofurenceKit.Image) {
        XCTAssertEqual(lastChangeDateTimeUtc, actual.lastEdited)
        XCTAssertEqual(id, actual.identifier)
        XCTAssertEqual(contentHashSha1, actual.contentHashSHA1)
        XCTAssertEqual(sizeInBytes, Int(actual.estimatedSizeInBytes))
        XCTAssertEqual(Image.Size(width: width, height: height), actual.size)
        XCTAssertEqual(internalReference, actual.internalReference)
    }
    
}
