@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DefaultKnowledgeGroupsViewModelFactoryTests: XCTestCase {

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
        let viewModelFactory = DefaultKnowledgeGroupsViewModelFactory(service: service)
        var viewModel: KnowledgeGroupsListViewModel?
        viewModelFactory.prepareViewModel { viewModel = $0 }
        let delegate = CapturingKnowledgeGroupsListViewModelDelegate()
        viewModel?.setDelegate(delegate)

        let models: [FakeKnowledgeGroup] = .random
        let expected = models.map(expectedViewModelForGroup)
        service.simulateFetchSucceeded(models)

        XCTAssertEqual(expected, delegate.capturedViewModels)
    }

    func testLateBoundViewModelDelegateProvidedWithExpectedViewModels() {
        let service = StubKnowledgeService()
        let viewModelFactory = DefaultKnowledgeGroupsViewModelFactory(service: service)
        var viewModel: KnowledgeGroupsListViewModel?
        viewModelFactory.prepareViewModel { viewModel = $0 }
        let models: [FakeKnowledgeGroup] = .random
        let expected = models.map(expectedViewModelForGroup)
        service.simulateFetchSucceeded(models)

        let delegate = CapturingKnowledgeGroupsListViewModelDelegate()
        viewModel?.setDelegate(delegate)

        XCTAssertEqual(expected, delegate.capturedViewModels)
    }

    func testProvideExpectedKnowledgeGroupByIndex() {
        let service = StubKnowledgeService()
        let viewModelFactory = DefaultKnowledgeGroupsViewModelFactory(service: service)
        var viewModel: KnowledgeGroupsListViewModel?
        viewModelFactory.prepareViewModel { viewModel = $0 }
        let models: [FakeKnowledgeGroup] = .random
        service.simulateFetchSucceeded(models)

        let randomGroup = models.randomElement()
        let expected = randomGroup.element.identifier
        let visitor = CapturingKnowledgeGroupsListViewModelVisitor()
        viewModel?.describeContentsOfKnowledgeItem(at: randomGroup.index, visitor: visitor)

        XCTAssertEqual(expected, visitor.visitedKnowledgeGroup)
        XCTAssertNil(visitor.visitedKnowledgeEntry)
    }
    
    func testGroupWithSingleEntryVisitsEntryInsteadOfGroup() {
        let service = StubKnowledgeService()
        let viewModelFactory = DefaultKnowledgeGroupsViewModelFactory(service: service)
        var viewModel: KnowledgeGroupsListViewModel?
        viewModelFactory.prepareViewModel { viewModel = $0 }
        let group = FakeKnowledgeGroup.random
        let entry = FakeKnowledgeEntry.random
        group.entries = [entry]
        service.simulateFetchSucceeded([group])
        let visitor = CapturingKnowledgeGroupsListViewModelVisitor()
        viewModel?.describeContentsOfKnowledgeItem(at: 0, visitor: visitor)
        
        let expected = entry.identifier
        
        XCTAssertEqual(expected, visitor.visitedKnowledgeEntry)
        XCTAssertNil(visitor.visitedKnowledgeGroup)
    }

}
