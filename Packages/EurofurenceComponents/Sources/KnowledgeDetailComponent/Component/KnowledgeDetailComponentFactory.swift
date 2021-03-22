import EurofurenceModel
import UIKit.UIViewController

public protocol KnowledgeDetailComponentFactory {

    func makeKnowledgeListComponent(
        _ identifier: KnowledgeEntryIdentifier,
        delegate: KnowledgeDetailComponentDelegate
    ) -> UIViewController

}
