//
//  PersistentImageRepositoryTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class PersistentImageRepositoryTests: XCTestCase {
    
    func testSavingImageThenLoadingAgain() {
        let identifier = String.random
        let imageData = Data.random
        var repository = PersistentImageRepository()
        let expected = ImageEntity(identifier: identifier, pngImageData: imageData)
        repository.save(expected)
        repository = PersistentImageRepository()
        let actual = repository.loadImage(identifier: identifier)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSavingImageIndicatesRepositoryContainsImage() {
        let identifier = String.random
        let imageData = Data.random
        let repository = PersistentImageRepository()
        let expected = ImageEntity(identifier: identifier, pngImageData: imageData)
        repository.save(expected)
        
        XCTAssertTrue(repository.containsImage(identifier: identifier))
    }
    
    func testNotContainImageThatHasNotBeenSaved() {
        let repository = PersistentImageRepository()
        XCTAssertFalse(repository.containsImage(identifier: .random))
    }
    
}
