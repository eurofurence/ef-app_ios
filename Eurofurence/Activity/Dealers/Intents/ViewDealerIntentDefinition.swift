import EurofurenceModel
import Foundation

public struct ViewDealerIntentDefinition: Hashable {
    
    public var identifier: DealerIdentifier
    public var dealerName: String
    
    public init(identifier: DealerIdentifier, dealerName: String) {
        self.identifier = identifier
        self.dealerName = dealerName
    }
    
}
