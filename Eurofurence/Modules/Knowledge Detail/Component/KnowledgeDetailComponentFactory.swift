import EurofurenceModel
import UIKit.UIViewController

public protocol KnowledgeDetailComponentFactory {

    func makeKnowledgeListModule(
        _ identifier: KnowledgeEntryIdentifier,
        delegate: KnowledgeDetailComponentDelegate
    ) -> UIViewController

}
