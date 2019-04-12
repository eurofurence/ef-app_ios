import UIKit.UIViewController

protocol KnowledgeGroupsListModuleProviding {

    func makeKnowledgeListModule(_ delegate: KnowledgeGroupsListModuleDelegate) -> UIViewController

}
