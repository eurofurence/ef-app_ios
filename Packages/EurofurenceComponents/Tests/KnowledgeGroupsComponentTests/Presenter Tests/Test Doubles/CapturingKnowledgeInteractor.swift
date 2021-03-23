Import KnowledgeGroupsComponent
import EurofurenceModel
import Foundation.NSIndexPath

class CapturingKnowledgeGroupsViewModelFactory: KnowledgeGroupsViewModelFactory {

    var prepareViewModelInvokedHandler: (() -> Void)?
    private(set) var toldToPrepareViewModel = false
    fileprivate var completionHandler: ((KnowledgeGroupsListViewModel) -> Void)?
    func prepareViewModel(completionHandler: @escaping (KnowledgeGroupsListViewModel) -> Void) {
        toldToPrepareViewModel = true
        self.completionHandler = completionHandler
        prepareViewModelInvokedHandler?()
    }

}

extension CapturingKnowledgeGroupsViewModelFactory {

    func simulateViewModelPrepared(_ viewModel: KnowledgeGroupsListViewModel) {
        completionHandler?(viewModel)
    }

}
