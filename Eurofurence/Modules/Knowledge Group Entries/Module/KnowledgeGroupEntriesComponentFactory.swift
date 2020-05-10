import EurofurenceModel
import Foundation
import UIKit

public protocol KnowledgeGroupEntriesComponentFactory {

    func makeKnowledgeGroupEntriesModule(
        _ groupIdentifier: KnowledgeGroupIdentifier,
        delegate: KnowledgeGroupEntriesComponentDelegate
    ) -> UIViewController

}
