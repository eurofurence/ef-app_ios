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
