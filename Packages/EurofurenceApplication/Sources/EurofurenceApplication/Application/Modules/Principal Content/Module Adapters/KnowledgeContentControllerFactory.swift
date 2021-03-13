import UIKit

struct KnowledgeContentControllerFactory: ApplicationModuleFactory {
    
    var knowledgeModuleProviding: KnowledgeGroupsListComponentFactory
    var knowledgeModuleDelegate: KnowledgeGroupsListComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        knowledgeModuleProviding.makeKnowledgeListComponent(knowledgeModuleDelegate)
    }
    
}
