import ComponentBase
import EurofurenceModel
import KnowledgeDetailComponent
import KnowledgeGroupComponent
import KnowledgeGroupsComponent
import KnowledgeJourney
import RouterCore
import UIKit

struct KnowledgeRoutes: RouteProvider {
    
    var components: ComponentRegistry
    var contentWireframe: ContentWireframe
    var modalWireframe: ModalWireframe
    var linksService: ContentLinksService
    var window: UIWindow
    
    var routes: Routes {
        Routes { (router) in
            let moveToKnowledgeTab = MoveToTabByViewController<KnowledgeListViewController>(window: window)
            let changeTabPresentation = SwapToKnowledgeTabPresentation(tabNavigator: moveToKnowledgeTab)
            
            KnowledgeRoute(presentation: changeTabPresentation)
            
            KnowledgeGroupRoute(
                knowledgeGroupModuleProviding: components.knowledgeGroupComponentFactory,
                contentWireframe: contentWireframe,
                delegate: ShowKnowledgeContentFromGroupListing(router: router)
            )
            
            KnowledgeEntryRoute(
                knowledgeDetailComponentFactory: components.knowledgeDetailComponentFactory,
                contentWireframe: contentWireframe,
                delegate: OpenLinkFromKnowledgeEntry(router: router, linksService: linksService)
            )
            
            WebPageRoute(
                webComponentFactory: components.webComponentFactory,
                modalWireframe: modalWireframe
            )
        }
    }
    
}
