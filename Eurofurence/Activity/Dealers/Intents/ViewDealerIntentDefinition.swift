import EurofurenceModel
import Foundation

struct ViewDealerIntentDefinition: Hashable {
    
    var identifier: DealerIdentifier
    var dealerName: String
    
    init(identifier: DealerIdentifier, dealerName: String) {
        self.identifier = identifier
        self.dealerName = dealerName
    }
    
}
