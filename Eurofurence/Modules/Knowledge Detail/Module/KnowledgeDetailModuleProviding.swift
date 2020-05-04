import EurofurenceModel
import UIKit.UIViewController

public protocol KnowledgeDetailModuleProviding {

    func makeKnowledgeListModule(
        _ identifier: KnowledgeEntryIdentifier,
        delegate: KnowledgeDetailModuleDelegate
    ) -> UIViewController

}
