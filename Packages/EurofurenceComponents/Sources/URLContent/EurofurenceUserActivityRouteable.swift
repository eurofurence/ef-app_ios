import DealerComponent
import EventDetailComponent
import Foundation
import RouterCore
import UserActivityRouteable

public class EurofurenceUserActivityRouteable: UserActivityRouteable {
    
    override public func registerRouteables() {
        super.registerRouteables()
        
        register(EurofurenceURLRouteable.self)
        
        register { (userActivity) in
            let intent = userActivity.interaction?.intent
            
            if let provider = intent as? EventIntentDefinitionProviding, let event = provider.eventIntentDefinition {
                return EventRouteable(identifier: event.identifier).eraseToAnyRouteable()
            }
            
            if let provider = intent as? DealerIntentDefinitionProviding, let dealer = provider.dealerIntentDefinition {
                return DealerRouteable(identifier: dealer.identifier).eraseToAnyRouteable()
            }
            
            return nil
        }
    }
    
}
