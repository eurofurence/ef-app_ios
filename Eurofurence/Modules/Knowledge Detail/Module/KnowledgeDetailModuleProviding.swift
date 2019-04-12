import EurofurenceModel
import UIKit.UIViewController

protocol KnowledgeDetailModuleProviding {

    func makeKnowledgeListModule(_ identifier: KnowledgeEntryIdentifier, delegate: KnowledgeDetailModuleDelegate) -> UIViewController

}
