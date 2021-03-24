import KnowledgeGroupsComponent
import UIKit

struct KnowledgeContentControllerFactory: ApplicationModuleFactory {
    
    var knowledgeModuleProviding: KnowledgeGroupsListComponentFactory
    var knowledgeModuleDelegate: KnowledgeGroupsListComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        let knowledgeList = knowledgeModuleProviding.makeKnowledgeListComponent(knowledgeModuleDelegate)
        knowledgeList.tabBarItem.image = UIImage(named: "Info", in: .module, compatibleWith: nil)
        
        return knowledgeList
    }
    
}
