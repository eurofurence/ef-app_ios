//
//  DefaultKnowledgeListInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultKnowledgeListInteractorTests: XCTestCase {
    
    private func expectedViewModelForGroup(_ group: KnowledgeGroup2) -> KnowledgeListGroupViewModel {
        let entriesViewModels = group.entries.map(expectedViewModelForEntry)
        return KnowledgeListGroupViewModel(title: group.title,
                                       icon: UIImage(),
                                       groupDescription: group.groupDescription,
                                       knowledgeEntries: entriesViewModels)
    }
    
    private func expectedViewModelForEntry(_ entry: KnowledgeEntry2) -> KnowledgeListEntryViewModel {
        return KnowledgeListEntryViewModel(title: entry.title)
    }
    
    func testKnowledgeGroupsFromServiceAreTurnedIntoExpectedViewModels() {
        let service = StubKnowledgeService()
        let interactor = DefaultKnowledgeListInteractor(service: service)
        var actual: KnowledgeListViewModel?
        interactor.prepareViewModel { actual = $0 }
        
        let models: [KnowledgeGroup2] = .random
        let expected = KnowledgeListViewModel(knowledgeGroups: models.map(expectedViewModelForGroup))
        service.simulateFetchSucceeded(models)
        
        XCTAssertEqual(expected, actual)
    }
    
}
