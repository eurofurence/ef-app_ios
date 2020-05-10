@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class DefaultKnowledgeGroupViewModelFactoryShould: XCTestCase {

    func testIndicateViewModelAsNumberOfEntriesAsInGroupFromService() {
        let service = FakeKnowledgeService()
        let group = FakeKnowledgeGroup.random
        service.stub(group)
        let interactor = DefaultKnowledgeGroupViewModelFactory(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: group.identifier) { viewModel = $0 }

        XCTAssertEqual(group.entries.count, viewModel?.numberOfEntries)
    }

    func testAdaptEntryTitlesIntoEachViewModel() {
        let service = FakeKnowledgeService()
        let group = FakeKnowledgeGroup.random
        service.stub(group)
        let interactor = DefaultKnowledgeGroupViewModelFactory(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: group.identifier) { viewModel = $0 }
        let entry = group.entries.randomElement()
        let entryViewModel = viewModel?.knowledgeEntry(at: entry.index)

        XCTAssertEqual(entry.element.title, entryViewModel?.title)
    }

    func testProvideEntryIdentifiersByIndex() {
        let service = FakeKnowledgeService()
        let group = FakeKnowledgeGroup.random
        service.stub(group)
        let interactor = DefaultKnowledgeGroupViewModelFactory(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: group.identifier) { viewModel = $0 }
        let entry = group.entries.randomElement()
        let entryIdentifier = viewModel?.identifierForKnowledgeEntry(at: entry.index)

        XCTAssertEqual(entry.element.identifier, entryIdentifier)
    }

    func testUseGroupNameAsViewModelTitle() {
        let service = FakeKnowledgeService()
        let group = FakeKnowledgeGroup.random
        service.stub(group)
        let interactor = DefaultKnowledgeGroupViewModelFactory(service: service)
        var viewModel: KnowledgeGroupEntriesViewModel?
        interactor.makeViewModelForGroup(identifier: group.identifier) { viewModel = $0 }

        XCTAssertEqual(group.title, viewModel?.title)
    }

}
