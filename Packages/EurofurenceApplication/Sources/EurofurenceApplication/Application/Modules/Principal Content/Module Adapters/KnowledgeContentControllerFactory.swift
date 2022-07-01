import KnowledgeGroupsComponent
import UIKit

struct KnowledgeContentControllerFactory: ApplicationModuleFactory {
    
    var knowledgeModuleProviding: KnowledgeGroupsListComponentFactory
    var knowledgeModuleDelegate: KnowledgeGroupsListComponentDelegate
    
    func makeApplicationModuleController() -> UIViewController {
        let knowledgeList = knowledgeModuleProviding.makeKnowledgeListComponent(knowledgeModuleDelegate)
        knowledgeList.tabBarItem.image = UIImage(systemName: "info.circle")
        knowledgeList.tabBarItem.selectedImage = UIImage(systemName: "info.circle.fill")
        
        return knowledgeList
    }
    
}
