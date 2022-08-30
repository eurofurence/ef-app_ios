import CoreData
@testable import EurofurenceKit
import XCTest

protocol SampleResponseFile {
    
    var jsonFileName: String { get }
    
}

extension SampleResponseFile {
    
    func loadFileContents() throws -> Data {
        let fileURL = try XCTUnwrap(Bundle.module.url(forResource: jsonFileName, withExtension: "json"))
        let fileContents = try Data(contentsOf: fileURL)
        
        return fileContents
    }
    
}
