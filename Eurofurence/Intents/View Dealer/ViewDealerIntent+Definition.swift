import DealerComponent
import EurofurenceIntentDefinitions
import EurofurenceModel

@available(iOS 12.0, *)
extension ViewDealerIntent {
    
    convenience init(intentDefinition: ViewDealerIntentDefinition) {
        self.init()
        
        dealerIdentifier = intentDefinition.identifier.rawValue
        dealerName = intentDefinition.dealerName
    }
    
}

@available(iOS 12.0, *)
extension ViewDealerIntent: DealerIntentDefinitionProviding {
    
    public var dealerIntentDefinition: ViewDealerIntentDefinition? {
        guard let identifier = dealerIdentifier, let dealerName = dealerName else { return nil }
        return ViewDealerIntentDefinition(identifier: DealerIdentifier(identifier), dealerName: dealerName)
    }
    
}
