//
//  CoreDataEurofurenceDataStoreShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 06/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CoreDataEurofurenceDataStoreShould: XCTestCase {
    
    var storeIdentifier: String!
    var store: CoreDataEurofurenceDataStore!
    
    private func recreateStore() {
        store = CoreDataEurofurenceDataStore(storeName: storeIdentifier)
    }
    
    override func setUp() {
        super.setUp()
        
        storeIdentifier = .random
        recreateStore()
    }
    
    func testSaveKnowledgeGroups() {
        let expected = [APIKnowledgeGroup].random
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeGroups(expected)
        }
        
        recreateStore()
        let actual = store.getSavedKnowledgeGroups()
        
        assertThat(expected, isEqualTo: actual)
    }
    
    func testSaveKnowledgeEntries() {
        let expected = [APIKnowledgeEntry].random.sorted()
        store.performTransaction { (transaction) in
            transaction.saveKnowledgeEntries(expected)
        }
        
        recreateStore()
        let actual = store.getSavedKnowledgeEntries()
        
        assertThat(expected, isEqualTo: actual?.sorted())
    }
    
    private func assertThat<T>(_ expected: [T], isEqualTo actual: [T]?, file: StaticString = #file, line: UInt = #line) where T: Equatable {
        guard let actual = actual else {
            XCTFail("Expected actual values, but got nil", file: file, line: line)
            return
        }
        
        XCTAssertTrue(expected.contains(elementsFrom: actual),
                      "Expected \(expected), got \(actual)",
                      file: file,
                      line: line)
    }
    
}
