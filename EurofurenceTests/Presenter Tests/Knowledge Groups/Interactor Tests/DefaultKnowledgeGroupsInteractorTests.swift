//
//  DefaultKnowledgeGroupsInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultKnowledgeGroupsInteractorTests: XCTestCase {
    
    private func expectedViewModelForGroup(_ group: KnowledgeGroup2) -> KnowledgeListGroupViewModel {
        let entriesViewModels = group.entries.map(expectedViewModelForEntry)
        return KnowledgeListGroupViewModel(title: group.title,
                                           fontAwesomeCharacter: " ",
                                           groupDescription: group.groupDescription,
                                           knowledgeEntries: entriesViewModels)
    }
    
    private func expectedViewModelForEntry(_ entry: KnowledgeEntry2) -> KnowledgeListEntryViewModel {
        return KnowledgeListEntryViewModel(title: entry.title)
    }
    
    func testKnowledgeGroupsFromServiceAreTurnedIntoExpectedViewModels() {
        let service = StubKnowledgeService()
        let interactor = DefaultKnowledgeGroupsInteractor(service: service)
        var actual: KnowledgeGroupsListViewModel?
        interactor.prepareViewModel { actual = $0 }
        
        let models: [KnowledgeGroup2] = .random
        let expected = models.map(expectedViewModelForGroup)
        service.simulateFetchSucceeded(models)
        
        XCTAssertEqual(expected, actual?.knowledgeGroups)
    }
    
    func testProvideExpectedKnowledgeGroupByIndex() {
        let service = StubKnowledgeService()
        let interactor = DefaultKnowledgeGroupsInteractor(service: service)
        var viewModel: KnowledgeGroupsListViewModel?
        interactor.prepareViewModel { viewModel = $0 }
        let models: [KnowledgeGroup2] = .random
        service.simulateFetchSucceeded(models)
        
        let randomGroup = models.randomElement()
        let expected = randomGroup.element.identifier
        var actual: KnowledgeGroup2.Identifier?
        viewModel?.fetchIdentifierForGroup(at: randomGroup.index) { actual = $0 }
        
        XCTAssertEqual(expected, actual)
    }
    
}
