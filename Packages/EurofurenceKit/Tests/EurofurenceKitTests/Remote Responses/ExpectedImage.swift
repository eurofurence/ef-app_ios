@testable import EurofurenceKit
import Foundation
import XCTest

struct ExpectedImage {
    
    var lastUpdated: Date
    var identifier: String
    var internalReference: String
    var width: Int
    var height: Int
    var sizeInBytes: Int
    var mimeType: String
    var contentHashSha1: String
    
    init(
        lastUpdated: String,
        identifier: String,
        internalReference: String,
        width: Int,
        height: Int,
        sizeInBytes: Int,
        mimeType: String,
        contentHashSha1: String
    ) {
        let dateFormatter = EurofurenceISO8601DateFormatter.instance
        self.lastUpdated = dateFormatter.date(from: lastUpdated)!
        self.identifier = identifier
        self.internalReference = internalReference
        self.width = width
        self.height = height
        self.sizeInBytes = sizeInBytes
        self.mimeType = mimeType
        self.contentHashSha1 = contentHashSha1
    }
    
    func assert(against actual: Image) {
        XCTAssertEqual(lastUpdated, actual.lastEdited)
        XCTAssertEqual(identifier, actual.identifier)
        XCTAssertEqual(contentHashSha1, actual.contentHashSHA1)
        XCTAssertEqual(sizeInBytes, Int(actual.estimatedSizeInBytes))
        XCTAssertEqual(Image.Size(width: width, height: height), actual.size)
        XCTAssertEqual(internalReference, actual.internalReference)
    }
    
}
