import EurofurenceModel
import Foundation
import UIKit

protocol KnowledgeGroupEntriesModuleProviding {

    func makeKnowledgeGroupEntriesModule(_ groupIdentifier: KnowledgeGroupIdentifier, delegate: KnowledgeGroupEntriesModuleDelegate) -> UIViewController

}
