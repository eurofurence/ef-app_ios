//
//  DefaultKnowledgeGroupEntriesInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultKnowledgeGroupEntriesInteractorShould: XCTestCase {
    
    func testIndicateViewModelAsNumberOfEntriesAsInGroupFromService() {
        let service = FakeKnowledgeService()
        let identifier: KnowledgeGroup2.Identifier = .random
        let entries = [KnowledgeEntry2].random
        service.stub(entries, for: identifier)
        let interactor = DefaultKnowledgeGroupEntriesInteractor(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: identifier) { viewModel = $0 }
        
        XCTAssertEqual(entries.count, viewModel?.numberOfEntries)
    }
    
}
