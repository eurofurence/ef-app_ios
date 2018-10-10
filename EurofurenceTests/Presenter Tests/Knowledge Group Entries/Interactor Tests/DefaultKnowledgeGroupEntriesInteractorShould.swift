//
//  DefaultKnowledgeGroupEntriesInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class DefaultKnowledgeGroupEntriesInteractorShould: XCTestCase {
    
    func testIndicateViewModelAsNumberOfEntriesAsInGroupFromService() {
        let service = FakeKnowledgeService()
        let group = KnowledgeGroup.random
        service.stub(group)
        let interactor = DefaultKnowledgeGroupEntriesInteractor(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: group.identifier) { viewModel = $0 }
        
        XCTAssertEqual(group.entries.count, viewModel?.numberOfEntries)
    }
    
    func testAdaptEntryTitlesIntoEachViewModel() {
        let service = FakeKnowledgeService()
        let group = KnowledgeGroup.random
        service.stub(group)
        let interactor = DefaultKnowledgeGroupEntriesInteractor(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: group.identifier) { viewModel = $0 }
        let entry = group.entries.randomElement()
        let entryViewModel = viewModel?.knowledgeEntry(at: entry.index)
        
        XCTAssertEqual(entry.element.title, entryViewModel?.title)
    }
    
    func testProvideEntryIdentifiersByIndex() {
        let service = FakeKnowledgeService()
        let group = KnowledgeGroup.random
        service.stub(group)
        let interactor = DefaultKnowledgeGroupEntriesInteractor(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: group.identifier) { viewModel = $0 }
        let entry = group.entries.randomElement()
        let entryIdentifier = viewModel?.identifierForKnowledgeEntry(at: entry.index)
        
        XCTAssertEqual(entry.element.identifier, entryIdentifier)
    }
    
    func testUseGroupNameAsViewModelTitle() {
        let service = FakeKnowledgeService()
        let group = KnowledgeGroup.random
        service.stub(group)
        let interactor = DefaultKnowledgeGroupEntriesInteractor(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: group.identifier) { viewModel = $0 }
        
        XCTAssertEqual(group.title, viewModel?.title)
    }
    
}
