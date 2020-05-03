import UIKit

struct KnowledgeContentControllerFactory: ContentControllerFactory {
    
    var knowledgeModuleProviding: KnowledgeGroupsListModuleProviding
    var knowledgeModuleDelegate: KnowledgeGroupsListModuleDelegate
    
    func makeContentController() -> UIViewController {
        knowledgeModuleProviding.makeKnowledgeListModule(knowledgeModuleDelegate)
    }
    
}
