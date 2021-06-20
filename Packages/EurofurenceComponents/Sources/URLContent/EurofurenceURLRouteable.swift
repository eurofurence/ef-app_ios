import DealerComponent
import DealersComponent
import EurofurenceModel
import EventDetailComponent
import Foundation
import KnowledgeDetailComponent
import KnowledgeGroupsComponent
import RouterCore
import ScheduleComponent
import URLRouteable
import URLDecoder

public class EurofurenceURLRouteable: URLRouteable {
    
    override public func registerRouteables() {
        super.registerRouteables()
        
        registerDealerRouteable()
        registerEventRouteable()
        registerKnowledgeEntryRouteable()
        
        registerURL(ScheduleRouteable.self)
        registerURL(DealersRouteable.self)
        registerURL(KnowledgeGroupsRouteable.self)
    }
    
    private func registerDealerRouteable() {
        var decoder = URLDecoder()
        decoder.urlCriteria.path = .matches(.caseInsensitive("/Dealers/"))
        
        registerURL(DealerDeepLink.self, decoder: decoder)
    }
    
    private func registerEventRouteable() {
        var decoder = URLDecoder()
        decoder.urlCriteria.path = .matches(.caseInsensitive("/Events/"))
        
        registerURL(EventDeepLink.self, decoder: decoder)
    }
    
    private func registerKnowledgeEntryRouteable() {
        var decoder = URLDecoder()
        decoder.urlCriteria.path = .matches(.caseInsensitive("/KnowledgeEntries/"))
        
        registerURL(KnowledgeEntryDeepLink.self, decoder: decoder)
    }
    
}
