import UIKit

struct KnowledgeContentControllerFactory: ApplicationModuleFactory {
    
    var knowledgeModuleProviding: KnowledgeGroupsListModuleProviding
    var knowledgeModuleDelegate: KnowledgeGroupsListModuleDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        knowledgeModuleProviding.makeKnowledgeListModule(knowledgeModuleDelegate)
    }
    
}
