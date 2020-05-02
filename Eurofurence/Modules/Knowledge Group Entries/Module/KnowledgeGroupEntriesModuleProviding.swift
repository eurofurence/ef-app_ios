import EurofurenceModel
import Foundation
import UIKit

public protocol KnowledgeGroupEntriesModuleProviding {

    func makeKnowledgeGroupEntriesModule(
        _ groupIdentifier: KnowledgeGroupIdentifier,
        delegate: KnowledgeGroupEntriesModuleDelegate
    ) -> UIViewController

}
