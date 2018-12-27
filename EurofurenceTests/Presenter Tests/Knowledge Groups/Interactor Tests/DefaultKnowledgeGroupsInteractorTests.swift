//
//  DefaultKnowledgeGroupsInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

class CapturingKnowledgeGroupsListViewModelDelegate: KnowledgeGroupsListViewModelDelegate {

    private(set) var capturedViewModels: [KnowledgeListGroupViewModel] = []
    func knowledgeGroupsViewModelsDidUpdate(to viewModels: [KnowledgeListGroupViewModel]) {
        capturedViewModels = viewModels
    }

}

class DefaultKnowledgeGroupsInteractorTests: XCTestCase {

    private func expectedViewModelForGroup(_ group: KnowledgeGroup) -> KnowledgeListGroupViewModel {
        let entriesViewModels = group.entries.map(expectedViewModelForEntry)
        return KnowledgeListGroupViewModel(title: group.title,
                                           fontAwesomeCharacter: group.fontAwesomeCharacterAddress,
                                           groupDescription: group.groupDescription,
                                           knowledgeEntries: entriesViewModels)
    }

    private func expectedViewModelForEntry(_ entry: KnowledgeEntry) -> KnowledgeListEntryViewModel {
        return KnowledgeListEntryViewModel(title: entry.title)
    }

    func testKnowledgeGroupsFromServiceAreTurnedIntoExpectedViewModels() {
        let service = StubKnowledgeService()
        let interactor = DefaultKnowledgeGroupsInteractor(service: service)
        var viewModel: KnowledgeGroupsListViewModel?
        interactor.prepareViewModel { viewModel = $0 }
        let delegate = CapturingKnowledgeGroupsListViewModelDelegate()
        viewModel?.setDelegate(delegate)

        let models: [KnowledgeGroup] = .random
        let expected = models.map(expectedViewModelForGroup)
        service.simulateFetchSucceeded(models)

        XCTAssertEqual(expected, delegate.capturedViewModels)
    }

    func testLateBoundViewModelDelegateProvidedWithExpectedViewModels() {
        let service = StubKnowledgeService()
        let interactor = DefaultKnowledgeGroupsInteractor(service: service)
        var viewModel: KnowledgeGroupsListViewModel?
        interactor.prepareViewModel { viewModel = $0 }
        let models: [KnowledgeGroup] = .random
        let expected = models.map(expectedViewModelForGroup)
        service.simulateFetchSucceeded(models)

        let delegate = CapturingKnowledgeGroupsListViewModelDelegate()
        viewModel?.setDelegate(delegate)

        XCTAssertEqual(expected, delegate.capturedViewModels)
    }

    func testProvideExpectedKnowledgeGroupByIndex() {
        let service = StubKnowledgeService()
        let interactor = DefaultKnowledgeGroupsInteractor(service: service)
        var viewModel: KnowledgeGroupsListViewModel?
        interactor.prepareViewModel { viewModel = $0 }
        let models: [KnowledgeGroup] = .random
        service.simulateFetchSucceeded(models)

        let randomGroup = models.randomElement()
        let expected = randomGroup.element.identifier
        var actual: KnowledgeGroup.Identifier?
        viewModel?.fetchIdentifierForGroup(at: randomGroup.index) { actual = $0 }

        XCTAssertEqual(expected, actual)
    }

}
