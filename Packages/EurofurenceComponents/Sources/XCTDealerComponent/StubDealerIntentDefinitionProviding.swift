import DealerComponent

public struct StubDealerIntentDefinitionProviding: Hashable, DealerIntentDefinitionProviding {
    
    public var dealerIntentDefinition: ViewDealerIntentDefinition?
    
    public init(dealerIntentDefinition: ViewDealerIntentDefinition? = nil) {
        self.dealerIntentDefinition = dealerIntentDefinition
    }
    
}
